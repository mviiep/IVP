CLASS zcl_qm_fglabel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA:
      username TYPE string,
      pass     TYPE string.

    TYPES: BEGIN OF ty_final,
             " Manufacturing Order Details
             manufacturingorder            TYPE zi_qmlabel_fg-manufacturingorder,
             productionplant               TYPE zi_qmlabel_fg-productionplant,
             manufacturingorderhaslongtext TYPE zi_qmlabel_fg-manufacturingorderhaslongtext,

             " Product Details
             productdescription            TYPE zi_qmlabel_fg-productdescription,
             weightunit                    TYPE zi_qmlabel_fg-weightunit,
             grossweight                   TYPE zi_qmlabel_fg-grossweight,
             netweight                     TYPE zi_qmlabel_fg-netweight,
             baseunit                      TYPE zi_qmlabel_fg-baseunit,
             productionorinspectionmemotxt TYPE zi_qmlabel_fg-productionorinspectionmemotxt,
             product                       TYPE zi_qmlabel_fg-product,

             " Batch Details
             batch                         TYPE zi_qmlabel_fg-batch,
             manufacturedate               TYPE zi_qmlabel_fg-manufacturedate,
             shelflifeexpirationdate       TYPE zi_qmlabel_fg-shelflifeexpirationdate,

             " Plant Address Details
             plant                         TYPE zi_qmlabel_fg-plant,
             streetname                    TYPE zi_qmlabel_fg-streetname,
             addresseefullname             TYPE zi_qmlabel_fg-addresseefullname,
             streetsuffixname1             TYPE zi_qmlabel_fg-streetsuffixname1,
             streetsuffixname2             TYPE zi_qmlabel_fg-streetsuffixname2,
             cityname                      TYPE zi_qmlabel_fg-cityname,
             postalcode                    TYPE zi_qmlabel_fg-postalcode,
             regionname                    TYPE zi_qmlabel_fg-regionname,
             streetprefixname1             TYPE zi_qmlabel_fg-streetprefixname1,
             districtname                  TYPE zi_qmlabel_fg-districtname,
             addresspersonid               TYPE zi_qmlabel_fg-addresspersonid,
             emailaddress                  TYPE zi_qmlabel_fg-emailaddress,
             internationalphonenumber      TYPE zi_qmlabel_fg-internationalphonenumber,
             internationalphonenumber1     TYPE zi_qmlabel_fg-internationalphonenumber1,
             countryname                   TYPE zi_qmlabel_fg-countryname,

             "Note
             notes(200)                    TYPE c,
           END OF ty_final.


    DATA:it_final TYPE STANDARD TABLE OF ty_final,
         wa_final TYPE ty_final.

    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_QM_FGLABEL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).

      DATA(off) = io_request->get_paging( )->get_offset( ).
      DATA(pag) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE pag ).
      DATA lv_rows TYPE int8.
      lv_rows = lv_max_rows.
      DATA(lsort) = io_request->get_sort_elements( ) .

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      DATA(lv_max_rows_top) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_fields)  = io_request->get_requested_elements( ).
      DATA(lt_sort)    = io_request->get_sort_elements( ).

      DATA(set) = io_request->get_requested_elements( ).
      DATA(lvs) = io_request->get_search_expression( ).
      DATA(filter1) = io_request->get_filter(  ).
      DATA(p1) = io_request->get_parameters(  ).
      DATA(p2) = io_request->get_requested_elements(  ).

      DATA(lv_where_clause) = io_request->get_filter( )->get_as_sql_string( ).

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.
    ENDIF.

    IF lv_where_clause IS NOT INITIAL.

      SELECT DISTINCT *
      FROM zi_qmlabel_fg
      WHERE (lv_where_clause)
      ORDER BY manufacturingorder
      INTO CORRESPONDING FIELDS OF TABLE @it_final
      OFFSET @off UP TO @lv_max_rows ROWS.

    ELSE.

      SELECT DISTINCT *
      FROM zi_qmlabel_fg
      ORDER BY manufacturingorder
      INTO CORRESPONDING FIELDS OF TABLE @it_final
      OFFSET @off UP TO @lv_max_rows ROWS.

    ENDIF.

    LOOP AT it_final INTO DATA(wa_final).

    data(lv_prod) = wa_final-product .
    SHIFT lv_prod LEFT DELETING LEADING '0'.

    select SINGLE * from zc_zfg_table WHERE mcode = @lv_prod
    into @data(wa_data).
    if sy-subrc = 0.

wa_final-grossweight = wa_data-gr_wt.
wa_final-netweight = wa_data-net_wt.
wa_final-baseunit = wa_data-uom_m.

ENDIF.

      CASE sy-sysid.
        WHEN lv_dev.
          lv_tenent = 'my413043'.
          username  = 'IVP'.
          pass      = 'Password@#0987654321'.
        WHEN lv_qas.
          lv_tenent = 'my412469'.
          username  =  'IVP'.
          pass      = 'Password@#0987654321'.
        WHEN lv_prd.
          lv_tenent = 'my416089'.
          username  = 'IVP'.
          pass      = 'Password@#0987654321'.
      ENDCASE.


      DATA: lv_url TYPE string.
      lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PRODUCT_SRV//A_Product('{ wa_final-product }')/to_ProductBasicText|.

      CONDENSE: lv_url NO-GAPS.
      DATA: token_http_client TYPE REF TO if_web_http_client,
            gt_return         TYPE STANDARD TABLE OF bapiret2.


      TRY.
          token_http_client = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
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


        CATCH cx_web_http_client_error cx_web_message_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.

      DATA:lv_string1 TYPE string,
           lv_string2 TYPE string,
           lv_string3 TYPE string,
           lv_mat     TYPE string,
           lv_rest    TYPE string.

      SPLIT lv_token_response AT '<d:LongText>' INTO lv_string2 lv_string3.

      SPLIT lv_string3 AT '</d:LongText>' INTO lv_mat lv_rest.

      wa_final-notes = lv_mat.
      MODIFY it_final FROM wa_final.
    ENDLOOP.

    SORT it_final BY manufacturingorder.
    DELETE ADJACENT DUPLICATES FROM it_final COMPARING manufacturingorder.

*    SELECT DISTINCT *
*    FROM @it_final AS it ##ITAB_DB_SELECT
*     ORDER BY requestforquotation,supplier
*     INTO TABLE @DATA(it_fin)                           "#EC CI_NOWHERE
*     OFFSET @off UP TO @lv_max_rows  ROWS.

    SELECT COUNT( * )
    FROM @it_final AS it ##ITAB_DB_SELECT
    INTO  @DATA(lv_child_lines) .                       "#EC CI_NOWHERE


    io_response->set_total_number_of_records( iv_total_number_of_records = lv_child_lines ).
    io_response->set_data( it_final ).

  ENDMETHOD.
ENDCLASS.
