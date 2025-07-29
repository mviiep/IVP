CLASS lsc_zkmb_inc_pay_cds DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zkmb_inc_pay_cds IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zkmb_inc_pay_cds DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zkmb_inc_pay_cds RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zkmb_inc_pay_cds RESULT result.

    METHODS createaccdoc FOR MODIFY
      IMPORTING keys FOR ACTION zkmb_inc_pay_cds~createaccdoc RESULT result.

ENDCLASS.

CLASS lhc_zkmb_inc_pay_cds IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD createaccdoc.

**********************************************************************
**Data Defination
**********************************************************************

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'ZMY',
           lv_prd(3) TYPE c VALUE 'C0A'.

    DATA: lo_url TYPE string.
    DATA username TYPE string.


    TYPES:BEGIN OF ty_soapitem,
            referencedocumentitem       TYPE i_journalentryitem-referencedocumentitem,
            companycode                 TYPE i_journalentryitem-companycode,
            glaccount                   TYPE i_journalentryitem-glaccount,
            amountintransactioncurrency TYPE string,
            debitcreditcode             TYPE i_journalentryitem-debitcreditcode,
            documentitemtext            TYPE i_journalentryitem-documentitemtext,
            assignmentreference         TYPE string,
            businessplace               TYPE i_businessplacevh-businessplace,
            housebank                   TYPE i_suplrbankdetailsbyintid-bank,
            housebankaccount            TYPE i_suplrbankdetailsbyintid-bankaccount,
          END OF ty_soapitem.


    TYPES:BEGIN OF ty_debtoritem,
            referencedocumentitem       TYPE i_journalentryitem-referencedocumentitem,
            debtor                      TYPE zcollection_dtls-e_coll_acc_no,
            debitcreditcode             TYPE i_journalentryitem-debitcreditcode,
            amountintransactioncurrency TYPE zcollection_dtls-amount,
            documentitemtext            TYPE i_journalentryitem-documentitemtext,
          END OF ty_debtoritem.


    TYPES:BEGIN OF ty_soapheader,
            originalreferencedocumenttype(4) TYPE c,
            originalrefdoclogicalsystem(7)   TYPE c,
            businesstransactiontype(4)       TYPE c,
            accountingdocumenttype           TYPE i_journalentry-accountingdocumenttype,
            documentreferenceid              TYPE i_journalentry-documentreferenceid,
            documentheadertext               TYPE i_journalentry-accountingdocumentheadertext,
            createdbyuser(12)                TYPE c,
            companycode                      TYPE i_journalentry-companycode,
            documentdate                     TYPE i_journalentry-documentdate,
            postingdate                      TYPE i_journalentry-postingdate,
            postingfiscalyear(12)            TYPE c,
            taxreportingdate                 TYPE i_journalentry-postingdate,
            taxdeterminationdate             TYPE i_journalentry-postingdate,
            reference1indocumentheader(25)   TYPE c,
            reference2indocumentheader(25)   TYPE c,
            item                             TYPE ty_soapitem,
            debtoritem                       TYPE ty_debtoritem,
          END OF ty_soapheader.

    DATA: soap_header TYPE ty_soapheader.

**********************************************************************
Data : paymentMode type string.
       paymentMode = 'Credit'.


    READ ENTITIES OF ZKMB_INC_PAY_CDS IN LOCAL MODE
     ENTITY ZKMB_INC_PAY_CDS
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(result_data)
     FAILED DATA(failed_data)
     REPORTED DATA(reported_data).


    DATA(wa_key) = VALUE #( keys[ 1 ] OPTIONAL ).

    SELECT SINGLE *
    FROM zkmb_jvpost_tab
    WHERE utrno = @wa_key-Utr_no
    INTO @DATA(wa_accdoc).

    IF wa_accdoc-acountingdocument IS NOT INITIAL.

     DATA(lv_msg) = me->new_message_with_text(
                       severity = if_abap_behv_message=>severity-error
                       text     = | Accounting Document { soap_header-accountingdocumenttype } Already Posted |
                     ).
      DATA ls_record LIKE LINE OF reported-ZKMB_INC_PAY_CDS.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-ZKMB_INC_PAY_CDS.

    ELSE.



      SELECT SINGLE *
      FROM ZKMB_INC_PAY_CDS
      WHERE Utr_no = @wa_key-Utr_no
      INTO @DATA(header).

*Item
      CONCATENATE header-Utr_no header-Remitt_info INTO soap_header-item-documentitemtext SEPARATED BY space.
      soap_header-item-amountintransactioncurrency = header-amount.

*     //header-Pay_mode. i have comment this code becouse of KMB not having fields credit debit
      CASE paymentMode .
        WHEN 'Credit'.
          soap_header-item-debitcreditcode = 'S'.
        WHEN 'Debit'.
          soap_header-item-debitcreditcode = 'H'.
          CONCATENATE '-' soap_header-item-amountintransactioncurrency INTO soap_header-item-amountintransactioncurrency.
      ENDCASE.

      soap_header-item-assignmentreference               = header-Txn_ref_no.
      SHIFT soap_header-item-assignmentreference BY ( strlen( soap_header-item-assignmentreference ) - 13 ) PLACES LEFT.
      soap_header-item-amountintransactioncurrency       = header-amount.
      soap_header-createdbyuser                          = sy-uname.


**debtoritem
      soap_header-debtoritem-debtor           = header-E_Coll_Acc_No.
      SHIFT soap_header-debtoritem-debtor BY ( strlen( soap_header-debtoritem-debtor ) - 6 ) PLACES LEFT.
      CONCATENATE '-' header-amount INTO soap_header-debtoritem-amountintransactioncurrency.

*    header-Pay_mode
      CASE paymentMode.
        WHEN 'Credit'.
          soap_header-debtoritem-debitcreditcode = 'H'.
        WHEN 'Debit'.
          soap_header-debtoritem-debitcreditcode = 'S'.
      ENDCASE.


***************time stamp

      DATA : timestamp  TYPE timestampl,
             fraction   TYPE string,
             timestamp2 TYPE string.

      GET TIME STAMP FIELD timestamp.

      DATA(tz) = 'INDIA'.
      DATA(time_stamp) = timestamp.


      CONVERT TIME STAMP time_stamp TIME ZONE tz
              INTO DATE DATA(dat) TIME DATA(tim)
              DAYLIGHT SAVING TIME DATA(dst).

      timestamp2 = timestamp.
      fraction   = | { timestamp2+15(7) } |.
      CONDENSE fraction NO-GAPS.

      DATA(created_on) = |{ dat(4) }-{ dat+4(2) }-{ dat+6(2) }T{ tim(2) }:{ tim+2(2) }:{ tim+4(2) }.{ fraction }Z|.
      CONDENSE created_on NO-GAPS.

**********************************************************************
**SOAP API Call

      CASE sy-sysid.
        WHEN lv_dev.
          lo_url = 'https://my413043-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
        WHEN lv_qas.
          lo_url = 'https://my412469-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
        WHEN lv_prd.
          lo_url = 'https://my416089-api.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
      ENDCASE.


      TRY.
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.


      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_header_fields(  VALUE #(
                 (  name = 'Content-Type'  value = 'text/xml' ) )
                  ).


      CASE sy-sysid.
        WHEN lv_dev.
          username = 'IVP'.
        WHEN lv_qas.
          username = 'IVP'.
        WHEN lv_prd.
          username = 'IVP'.
      ENDCASE.


      lo_request->set_authorization_basic(
        EXPORTING
          i_username = username
          i_password = 'Password@#0987654321'
      ).



      DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

      CALL TRANSFORMATION ZTR_KMB_INC_PAY_SOAP  SOURCE header     = header
                                                  soapheader = soap_header
                                                  created_on = created_on
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
**Response in XML Schema

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



      IF wajournalentrycreateconf-accountingdocument <> '0000000000' AND status-code = '200'.

*        lv_msg = me->new_message(
*                           id       = 'ZMC_HDFC_SOAP'
*                           number   = 001
*                           severity = ms-success
*                           v1       = wajournalentrycreateconf-accountingdocument
*                         ).
*
*        ls_record-%msg = lv_msg.
*        APPEND ls_record TO reported-ZKMB_INC_PAY_CDS.

lv_msg = me->new_message_with_text(
                       severity = if_abap_behv_message=>severity-success
                       text     = | Accounting Document { soap_header-accountingdocumenttype } Posted Successfully |
                     ).
*      DATA ls_record LIKE LINE OF reported-ZKMB_INC_PAY_CDS.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-ZKMB_INC_PAY_CDS.

        wa_accdoc-utrno   = wa_key-Utr_no.
        wa_accdoc-acountingdocument = wajournalentrycreateconf-accountingdocument.

        MODIFY zkmb_jvpost_tab FROM @wa_accdoc.

      ELSE.


        SPLIT data4 AT '</JournalEntryCreateConfirmation>' INTO DATA(error1) DATA(error2).

        SPLIT error2 AT '</JournalEntryCreateConfirmation>' INTO DATA(error3) DATA(error4).

        TYPES:BEGIN OF ty_journalentryerror,
                typeid       TYPE  string,
                severitycode TYPE  string,
                note         TYPE  string,
              END OF ty_journalentryerror.

        DATA:iterror TYPE TABLE OF ty_journalentryerror.


        REPLACE ALL OCCURRENCES OF PCRE '<WebURI>.*?</WebURI>' IN error3 WITH '' IGNORING CASE.


        TRY.
            CALL TRANSFORMATION ztr_fi_jvposting_error
            SOURCE XML error3
            RESULT     log = iterror.
          CATCH cx_st_error INTO error.
        ENDTRY.


        LOOP AT iterror INTO DATA(wa_soaperror).
          CONCATENATE wa_soaperror-note soaperror INTO DATA(soaperror) SEPARATED BY space.
        ENDLOOP.

*        lv_msg = me->new_message(
*                           id       = 'ZMC_HDFC_SOAP'
*                           number   = 002
*                           severity = ms-none
*                           v1       = soaperror
*                         ).
*
*        ls_record-%msg = lv_msg.
*        APPEND ls_record TO reported-ZKMB_INC_PAY_CDS.

   lv_msg = me->new_message_with_text(
                       severity = if_abap_behv_message=>severity-error
                       text     = | Error in Document Posting { soap_header-accountingdocumenttype } please check error... |
                     ).
*      DATA ls_record LIKE LINE OF reported-ZKMB_INC_PAY_CDS.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-ZKMB_INC_PAY_CDS.
      ENDIF.















    ENDIF.



**********************************************************************




  ENDMETHOD.

ENDCLASS.
