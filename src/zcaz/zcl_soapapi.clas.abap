CLASS zcl_soapapi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:BEGIN OF ty_header,
            companycode         TYPE  i_journalentry-companycode,
            documentreferenceid TYPE  i_journalentry-documentreferenceid,
          END OF ty_header.


    TYPES:BEGIN OF ty_fin,
            companycode                   TYPE i_journalentry-companycode,
            documentreferenceid           TYPE i_journalentry-documentreferenceid,
            accountingdocument            TYPE i_journalentry-accountingdocument,
            fiscalyear                    TYPE i_journalentry-fiscalyear,
            documentdate                  TYPE i_journalentry-documentdate,
            originalreferencedocumenttype TYPE i_journalentry-originalreferencedocument,
            originalrefdoclogicalsystem   TYPE i_journalentry-originalreferencedocument,
            businesstransactiontype       TYPE i_journalentry-businesstransactiontype,
            accountingdocumenttype        TYPE i_journalentry-accountingdocumenttype,
            documentheadertext            TYPE i_manufacturingorder-manufacturingorder,
            createdbyuser                 TYPE i_manufacturingorder-manufacturingorder,
            postingdate                   TYPE i_manufacturingorder-manufacturingorder,
            postingfiscalperiod           TYPE i_manufacturingorder-manufacturingorder,
            taxreportingdate              TYPE i_manufacturingorder-manufacturingorder,
            taxdeterminationdate          TYPE i_manufacturingorder-manufacturingorder,
          END OF ty_fin.

    DATA:header   TYPE ty_header,
         wa_final TYPE ty_fin,
         it_final TYPE STANDARD TABLE OF ty_fin.


    DATA: companycode                   TYPE RANGE OF i_journalentry-companycode,
          documentreferenceid           TYPE RANGE OF i_journalentry-documentreferenceid,
          documentdate                  TYPE RANGE OF i_journalentry-documentdate,
          originalreferencedocumenttype TYPE RANGE OF i_journalentry-originalreferencedocument,
          originalrefdoclogicalsystem   TYPE RANGE OF i_journalentry-originalreferencedocument,
          businesstransactiontype       TYPE RANGE OF i_journalentry-businesstransactiontype,
          accountingdocumenttype        TYPE RANGE OF i_journalentry-accountingdocumenttype,
          documentheadertext            TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          createdbyuser                 TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          postingdate                   TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          postingfiscalperiod           TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          taxreportingdate              TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          taxdeterminationdate          TYPE RANGE OF i_manufacturingorder-manufacturingorder.

    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SOAPAPI IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      DATA(off) = io_request->get_paging( )->get_offset(  ).
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

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.
    ENDIF.

    READ TABLE lt_filter_cond INTO DATA(orderfilter11) WITH KEY name = 'COMPANYCODE'.
    MOVE-CORRESPONDING orderfilter11-range TO companycode.

    READ TABLE lt_filter_cond INTO DATA(datefilter) WITH KEY name = 'DOCUMENTREFERENCEID'.
    MOVE-CORRESPONDING datefilter-range TO documentreferenceid.

    DATA: lo_url TYPE string VALUE 'https://my413043.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.


    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Accept' value = '*/*' )
                (  name = 'Content-Type'  value = 'text/xml' )
                (  name =  'SOAPAction'   value = '#POST' )
                ) ).


    lo_request->set_authorization_basic(
      EXPORTING
        i_username = 'CTPLFIORI'
        i_password = 'Ctplfiori@1234567890'
    ).




    SELECT SINGLE *
    FROM i_journalentry
    WHERE companycode IN @companycode
    AND documentreferenceid IN @documentreferenceid
    INTO @DATA(header1).


    header1-documentreferenceid = '90000414'.
    header1-companycode = '1000'.


    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_soapapi  SOURCE header = header1
                                     RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>decode_utf8( encoded = lv_output_xml ).




    lo_request->append_text(
          EXPORTING
            data   = ls_data_xml
        ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.


    DATA(status) = lv_response->get_status( ).
    DATA(lv_json_response) = lv_response->get_text( ).



    SPLIT lv_json_response AT '<JournalEntryCreateConfirmation>' INTO DATA(data1) DATA(data2).

    SPLIT data2 AT '</MessageHeader>' INTO DATA(data3) DATA(data4).

    SPLIT data4 AT '<Log>' INTO DATA(data5) DATA(data6).

    CONCATENATE '<?xml version="1.0" encoding="utf-8"?>' data5 INTO data5.

**********************************************************************
    TYPES:BEGIN OF ty_journalentry,
            accountingdocument TYPE  i_journalentry-accountingdocument,
            companycode        TYPE  i_journalentry-companycode,
            fiscalyear         TYPE  i_journalentry-fiscalyear,
          END OF ty_journalentry.

    DATA:wajournalentrycreateconf TYPE ty_journalentry.



    TRY.
        CALL TRANSFORMATION ztr_soapapi_return
        SOURCE XML data5
        RESULT     journalentrycreateconfirmation = wajournalentrycreateconf.
      CATCH cx_st_error INTO DATA(error).
*     Your error handling comes here...
    ENDTRY.


    wa_final-accountingdocument = wajournalentrycreateconf-accountingdocument.
    wa_final-fiscalyear = wajournalentrycreateconf-fiscalyear.
    wa_final-companycode = wajournalentrycreateconf-companycode.
    APPEND wa_final TO it_final.

    io_response->set_data( it_final ).
    io_response->set_total_number_of_records( 100000 ).

  ENDMETHOD.
ENDCLASS.
