CLASS zcl_irn_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: r_token         TYPE string,
          billingdocument TYPE i_billingdocument-billingdocument,
          textid          TYPE c.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.
    DATA:
      username TYPE string,
      pass     TYPE string.
    DATA: lv_id1 TYPE string,
          lv_id2 TYPE string.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS header_text IMPORTING billingdocument TYPE i_billingdocument-billingdocument
                                  textid          TYPE c
                        RETURNING VALUE(r_val)    TYPE string..
ENDCLASS.



CLASS ZCL_IRN_REPORT IMPLEMENTATION.


  METHOD header_text.
    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username =  'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
    ENDCASE.
    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/A_BillingDocumentText| &
             |(BillingDocument=' { billingdocument }',Language='EN',LongTextID=' { textid } ')|.
    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.

    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    DATA(token_request) = token_http_client->get_http_request( ).
    token_request->set_header_fields(  VALUE #(
               (  name = 'Accept' value = '*/*' )
                ) ).

    token_request->set_authorization_basic(
      EXPORTING
           i_username = username
           i_password = pass
    ).

    TRY.
        DATA(lv_token_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>get )->get_text(  ).

      CATCH cx_web_http_client_error cx_web_message_error.
        "handle exception
    ENDTRY.
    DATA:lv_string1 TYPE string,
         lv_string2 TYPE string,
         lv_string3 TYPE string,
         lv_mat     TYPE string,
         lv_rest    TYPE string.

    SPLIT lv_token_response AT '<d:LongText>' INTO lv_string2 lv_string3.

    SPLIT lv_string3 AT '</d:LongText>' INTO lv_mat lv_rest.
    FIND FIRST OCCURRENCE OF 'JGTD' IN lv_token_response.
    IF sy-subrc EQ 0.
      CONCATENATE lv_mat+6(4)  lv_mat+3(2)  lv_mat+0(2)  INTO lv_mat.
    ENDIF.
    r_val = lv_mat.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

*    DATA(lv_entity) = io_request->get_entity_id( ).
*    CASE lv_entity.
*      WHEN 'ZCE_IRN_STATUS'.

    DATA:final      TYPE STANDARD TABLE OF zce_irn_status,
         final1     TYPE STANDARD TABLE OF zce_irn_status,
         wa_final   LIKE LINE OF  final,
         bill_doc   TYPE RANGE OF i_billingdocument-billingdocument,
         it_billdoc TYPE STANDARD TABLE OF i_billingdocument.

    DATA(top) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN top = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE top ).
    DATA(skip) = io_request->get_paging( )->get_offset(  ).
    DATA(lt_clause) = io_request->get_filter( )->get_as_sql_string( ).
*    DATA(requested_fields) = io_request->get_requested_elements( ).
    DATA(sort_order) = io_request->get_sort_elements( ).
    DATA(lt_sort_criteria) = VALUE string_table( FOR sort_element IN sort_order
                    ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true THEN `descending`
                                                                                                    ELSE `ascending` ) ) ).
    DATA(lt_grouped_element) = io_request->get_aggregation(  )->get_grouped_elements(  ).
    DATA(lv_grouping) = concat_lines_of( table = lt_grouped_element sep = `, ` ).
    DATA(lv_sort_string) = COND #( WHEN lt_sort_criteria IS INITIAL THEN `primary key`
                                                     ELSE concat_lines_of( table = lt_sort_criteria sep = `, ` ) ).
    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    SELECT * FROM zi_irn_alv WHERE (lt_clause)
                             ORDER BY (lv_sort_string)
                            INTO CORRESPONDING FIELDS OF TABLE @final1.
    DELETE ADJACENT DUPLICATES FROM final1.
    LOOP AT final1 INTO DATA(wa_fin).
      DATA(lv_index) = sy-tabix.
      wa_fin-billingdocument = |{ wa_fin-billingdocument ALPHA = IN }|.

      if wa_fin-EwayPdf+0(8) ne 'https://'.
      wa_fin-EwayPdf = |https://{ wa_fin-EwayPdf }|.
      endif.
      MODIFY final1 FROM wa_fin INDEX lv_index.
    ENDLOOP.
    SELECT  a~billingdocument, a~supplier, b~suppliername, b~taxnumber3
          FROM i_billingdocumentpartner AS a
          LEFT OUTER JOIN i_supplier AS b ON a~supplier = b~supplier
          FOR ALL ENTRIES IN @final1
          WHERE a~billingdocument = @final1-billingdocument
            AND a~partnerfunction = 'U3'
          INTO TABLE @DATA(it_suppl).
*      SELECT SINGLE supplier, suppliername ,taxnumber3
*            FROM i_supplier
*            WHERE supplier = @lv_suppl
*            INTO @DATA(wa_transporterdet).
    SELECT a~billingdocument, a~referencesddocument, b~shippingtype
      FROM i_billingdocumentitembasic AS a
      LEFT OUTER JOIN i_deliverydocument AS b ON a~referencesddocument = b~deliverydocument
      FOR ALL ENTRIES IN @final1
      WHERE billingdocument = @final1-billingdocument
      INTO TABLE @DATA(it_shiptype).
*      SELECT SINGLE shippingtype
*        FROM i_deliverydocument
*        WHERE deliverydocument = @lv_deldoc
*        INTO @DATA(lv_shipptype).

    LOOP AT final1 INTO wa_final.
      DATA(wa_sup) = VALUE #( it_suppl[ billingdocument = wa_final-billingdocument ] OPTIONAL ).
      wa_final-trans_id = wa_sup-taxnumber3.
      wa_final-trans_name = wa_sup-suppliername.
      DATA(wa_shiptype) = VALUE #( it_shiptype[ billingdocument = wa_final-billingdocument ] OPTIONAL ).
      SHIFT wa_shiptype-shippingtype LEFT DELETING LEADING '0'.
      wa_final-modeoftransport = wa_shiptype-shippingtype.
      IF wa_final-trans_id IS NOT INITIAL.
        wa_final-vehicle_no = me->header_text(
                                       billingdocument = wa_final-billingdocument
                                       textid          = 'JGVN'
                                     ).
        wa_final-trans_doc_date = me->header_text(
                                       billingdocument = wa_final-billingdocument
                                       textid          = 'JGTD'
                                     ).
      ENDIF.
      SHIFT wa_final-billingdocument LEFT DELETING LEADING '0'.
      APPEND wa_final TO final.
      CLEAR wa_final.
    ENDLOOP.
*    SORT final  DESCENDING BY billingdocument.
    DELETE ADJACENT DUPLICATES FROM final.
    SELECT * FROM @final AS it_final
        ORDER BY billingdocument DESCENDING, postingdate DESCENDING
        INTO TABLE @DATA(it_fin)
        OFFSET @skip UP TO  @lv_max_rows ROWS.          "#EC CI_NOWHERE

    SELECT COUNT( * )
        FROM @final AS it_final
        INTO @DATA(lv_totcount).                        "#EC CI_NOWHERE
    io_response->set_data( it_fin ).
    io_response->set_total_number_of_records( lv_totcount ).

*        DATA(off) = io_request->get_paging( )->get_offset(  ).
*        DATA(pag) = io_request->get_paging( )->get_page_size( ).
*        DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
*                                    ELSE pag ).
*        DATA(lsort) = io_request->get_sort_elements( ) .
*        TRY.
*            DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
*          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
*        ENDTRY.
*
*        DATA(lt_fields)  = io_request->get_requested_elements( ).
*        DATA(lt_sort)    = io_request->get_sort_elements( ).

**        DATA(set) = io_request->get_requested_elements( )."  --> could be used for optimizations
**        DATA(lvs) = io_request->get_search_expression( ).
**        DATA(filter1) = io_request->get_filter(  ).
**        DATA(p1) = io_request->get_parameters(  ).
**        DATA(p2) = io_request->get_requested_elements(  ).
**        DATA(rng) = filter1->get_as_ranges(   ).
*
**        DATA(str) = filter1->get_as_sql_string(  ).

*        READ TABLE lt_filter_cond INTO DATA(filter) WITH KEY name = 'BILLINGDOCUMENT'.
*        MOVE-CORRESPONDING filter-range TO bill_doc.



*      WHEN 'ZCE_EWAY_TRANSPORTER'.
*        DATA: final2    TYPE STANDARD TABLE OF zce_eway_transporter,
*              bill_doc1 TYPE RANGE OF i_billingdocument-billingdocument.
*        DATA(top1) = io_request->get_paging( )->get_page_size( ).
*        DATA(lv_max_rows1) = COND #( WHEN top1 = if_rap_query_paging=>page_size_unlimited THEN 0
*                                    ELSE top1 ).
*        DATA(skip1) = io_request->get_paging( )->get_offset(  ).
*        DATA(lt_clause1) = io_request->get_filter( )->get_as_sql_string( ).
**    DATA(requested_fields) = io_request->get_requested_elements( ).
*        DATA(sort_order1) = io_request->get_sort_elements( ).
*        DATA(lt_sort_criteria1) = VALUE string_table( FOR sort_element IN sort_order1
*                        ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true THEN `descending`
*                                                                                                        ELSE `ascending` ) ) ).
*        DATA(lt_grouped_element1) = io_request->get_aggregation(  )->get_grouped_elements(  ).
*        DATA(lv_grouping1) = concat_lines_of( table = lt_grouped_element1 sep = `, ` ).
*        DATA(lv_sort_string1) = COND #( WHEN lt_sort_criteria1 IS INITIAL THEN `primary key`
*                                                         ELSE concat_lines_of( table = lt_sort_criteria1 sep = `, ` ) ).
*        TRY.
*            DATA(filter_condition1) = io_request->get_filter( )->get_as_ranges( ).
*          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option1).
*        ENDTRY.
*        READ TABLE filter_condition1 INTO DATA(filter) WITH KEY name = 'BILLINGDOCUMENT'.
*        MOVE-CORRESPONDING filter-range TO bill_doc1.
*        SELECT a~billingdocument, a~companycode, a~fiscalyear, a~postingdate, b~transporterid, b~transporterdocno, b~transdistance, b~subsplytyp,
*               b~transportername, b~transdocdate, b~vehicleno
*            FROM zi_irn_alv AS a
*            LEFT OUTER JOIN ztab_eway_trans AS b ON a~billingdocument = b~billingdocument
*            WHERE a~billingdocument IN @bill_doc1
*            INTO CORRESPONDING FIELDS OF TABLE @final2.
**            ORDER BY (lv_sort_string1)
**        INTO CORRESPONDING FIELDS OF TABLE @final2 UP TO @lv_max_rows1 ROWS.
*        SELECT COUNT( * )
*            FROM @final2 AS it_final
*            INTO @DATA(lv_totcount1).
*        io_response->set_data( final2 ).
*        io_response->set_total_number_of_records( lv_totcount1 ).
*   ENDCASE.
  ENDMETHOD.
ENDCLASS.
