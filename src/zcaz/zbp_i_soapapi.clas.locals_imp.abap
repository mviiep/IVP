CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zi_soapapi AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES: BEGIN OF ty_buffer_item.
             INCLUDE TYPE   zi_soapapi_item AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer_item.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    TYPES tdata_item TYPE TABLE OF ty_buffer_item.
    CLASS-DATA mt_data_item TYPE tdata_item.

    CLASS-DATA:thead TYPE TABLE OF zi_soapapi.
    CLASS-DATA:titem TYPE TABLE OF zi_soapapi_item.

ENDCLASS.


CLASS lhc_zi_soapapi DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_soapapi RESULT result.

    METHODS create FOR MODIFY
      IMPORTING
        gdata FOR CREATE zi_soapapi
        tgen  FOR CREATE zi_soapapi\item.



*    METHODS create FOR MODIFY
*      IMPORTING gdata FOR CREATE zi_soapapi.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_soapapi.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_soapapi.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_soapapi RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_soapapi.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ zi_soapapi\item FULL result_requested RESULT result LINK association_links.

*    METHODS cba_item FOR MODIFY
*      IMPORTING tgen FOR CREATE zi_soapapi\item.

ENDCLASS.

CLASS lhc_zi_soapapi IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA: mapgen LIKE LINE OF mapped-zi_soapapi.
    DATA  tgdt   LIKE LINE OF loc=>mt_data.

    DATA:tl LIKE LINE OF mapped-zi_soapapi,
         wi LIKE LINE OF loc=>thead.

    LOOP AT gdata INTO DATA(dt).
      MOVE-CORRESPONDING dt TO mapgen.
      MOVE-CORRESPONDING dt TO tgdt.
      APPEND mapgen TO mapped-zi_soapapi.
      APPEND tgdt TO loc=>thead.
    ENDLOOP.

    DATA  tgdt_item   LIKE LINE OF loc=>mt_data_item.


    DATA: locitem     LIKE LINE OF loc=>titem,
          mapgen_item LIKE LINE OF mapped-zi_soapapi_item.

**********************************************************************

*    LOOP AT tgen INTO DATA(wgen).
    READ TABLE tgen INTO DATA(wgen) INDEX 1.

*      LOOP AT wgen-%target INTO DATA(wgen1).
    READ TABLE wgen-%target INTO DATA(wgen1) INDEX 1..

    READ TABLE loc=>thead INTO DATA(header) INDEX 1.

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

    CALL TRANSFORMATION ztr_soapapi  SOURCE header = header
                                            item   = wgen-%target[]
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
    ENDTRY.


    header-accountingdocument  = wajournalentrycreateconf-accountingdocument.
    header-fiscalyear          = wajournalentrycreateconf-fiscalyear.
    wgen1-accountingdocument   = wajournalentrycreateconf-accountingdocument.
    wgen1-companycode          = wajournalentrycreateconf-companycode.

    MODIFY loc=>thead FROM header INDEX 1.

*        MOVE-CORRESPONDING wgen1 TO mapgen_item.
*        MOVE-CORRESPONDING wgen1 TO tgdt_item.
*        APPEND mapgen_item TO mapped-zi_soapapi_item.
*        APPEND locitem TO loc=>titem.
*
*      ENDLOOP.

    MOVE-CORRESPONDING header TO mapgen.
    MOVE-CORRESPONDING header TO tgdt.
    APPEND mapgen TO mapped-zi_soapapi.
    APPEND tgdt TO loc=>thead.

*    ENDLOOP.



  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.


ENDCLASS.

CLASS lsc_zi_soapapi DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_soapapi IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA : lt_data      TYPE STANDARD TABLE OF zdb_soapapi.
    DATA : lt_data_item      TYPE STANDARD TABLE OF zdb_soapapi_item.

    MOVE-CORRESPONDING loc=>thead TO lt_data.
    MOVE-CORRESPONDING loc=>titem TO lt_data_item.

    MODIFY zdb_soapapi FROM TABLE @lt_data.
    MODIFY zdb_soapapi_item FROM TABLE @lt_data_item.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
