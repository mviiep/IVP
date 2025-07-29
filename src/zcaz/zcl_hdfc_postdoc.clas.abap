CLASS zcl_hdfc_postdoc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA:hdfctable TYPE STANDARD TABLE OF zdb_hdfctab.


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter p_hdfctable | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_val | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS postdocument
      IMPORTING p_hdfctable  LIKE hdfctable
      RETURNING VALUE(r_val) TYPE string.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HDFC_POSTDOC IMPLEMENTATION.


  METHOD postdocument.
**********************************************************************
**Data Definaton**
**********************************************************************

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    TYPES: BEGIN OF ty_soapjson,
             companycode                   TYPE zi_soapapi-companycode,
             accountingdocument            TYPE zi_soapapi-accountingdocument,
             documentreferenceid           TYPE zi_soapapi-documentreferenceid,
             documentdate                  TYPE zi_soapapi-documentdate,
             fiscalyear                    TYPE zi_soapapi-fiscalyear,
             originalreferencedocumenttype TYPE zi_soapapi-originalreferencedocumenttype,
             originalrefdoclogicalsystem   TYPE zi_soapapi-originalrefdoclogicalsystem,
             businesstransactiontype       TYPE zi_soapapi-businesstransactiontype,
             accountingdocumenttype        TYPE zi_soapapi-accountingdocumenttype,
             documentheadertext            TYPE zi_soapapi-documentheadertext,
             createdbyuser                 TYPE zi_soapapi-createdbyuser,
             postingdate                   TYPE zi_soapapi-postingdate,
             postingfiscalperiod           TYPE zi_soapapi-postingfiscalperiod,
             taxreportingdate              TYPE zi_soapapi-taxdeterminationdate,
             taxdeterminationdate          TYPE zi_soapapi-taxdeterminationdate,
             referencedocumentitem         TYPE zi_soapapi_item-referencedocumentitem,
*             Item
             glaccount                     TYPE zi_soapapi_item-glaccount,
             currency                      TYPE zi_soapapi_item-currency,
             amountintransactioncurrency   TYPE zi_soapapi_item-amountintransactioncurrency,
             debitcreditcode               TYPE zi_soapapi_item-debitcreditcode,
             documentitemtext              TYPE zi_soapapi_item-documentitemtext,
             housebank                     TYPE zi_soapapi_item-housebank,
             housebankaccount              TYPE zi_soapapi_item-housebankaccount,
             profitcenter                  TYPE zi_soapapi_item-profitcenter,
*             Item 2
             referencedocumentitem2        TYPE zi_soapapi_item-referencedocumentitem,
             debtor                        TYPE zi_soapapi_item-referencedocumentitem,
             amountintransactioncurrency2  TYPE zi_soapapi_item-referencedocumentitem,
           END OF ty_soapjson.

    DATA:header TYPE ty_soapjson.
**********************************************************************



    DATA: lo_url TYPE string .

    DATA: lo_http_client TYPE REF TO if_web_http_client.

    CASE sy-sysid.
      WHEN lv_dev.
        lo_url = 'https://my413043.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
      WHEN lv_qas.
        lo_url = 'https://my412469.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
      WHEN lv_prd.
        lo_url = 'https://my416089.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
    ENDCASE.




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



    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_soapapi  SOURCE header   = header
                                            item     = p_hdfctable
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



  ENDMETHOD.
ENDCLASS.
