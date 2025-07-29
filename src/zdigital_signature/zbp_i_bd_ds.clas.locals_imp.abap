CLASS lhc_zi_bd_ds DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bd_ds RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bd_ds RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_bd_ds RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_bd_ds.

    METHODS bddigitalsignature FOR MODIFY
      IMPORTING keys FOR ACTION zi_bd_ds~bddigitalsignature RESULT result.

ENDCLASS.

CLASS lhc_zi_bd_ds IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD bddigitalsignature.

**********************************************************************
**data Declaration

    DATA: lo_http_client TYPE REF TO if_web_http_client.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ',
           username  TYPE string,
           password  TYPE string.

    DATA : lv_split1 TYPE string,
           lv_split2 TYPE string,
           lv_base64 TYPE string,
           lv_split4 TYPE string,
           lv_split5 TYPE string.


    DATA ls_record LIKE LINE OF reported-zi_bd_ds.
******************************************************************************************************

    READ ENTITIES OF zi_bd_ds IN LOCAL MODE
    ENTITY zi_bd_ds
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(repoerted_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.


*    SELECT SINGLE signedqrcode,irn,ackno,ackdate,ewbno,ewbdt
*    FROM zi_j1ig_invrefnum_form
*    WHERE docno = @wa_key-billingdocument
*    INTO @DATA(wa_irn).

    SELECT SINGLE *
    FROM i_billingdocumentbasic AS bilingdocument
LEFT JOIN zi_j1ig_invrefnum_form AS einvoicetab ON einvoicetab~docno = bilingdocument~billingdocument
    WHERE billingdocument = @wa_key-billingdocument
    INTO @DATA(billingheader).

    IF ( billingheader-einvoicetab-irn IS INITIAL OR billingheader-einvoicetab-irncanceled EQ 'X' ) AND
    ( billingheader-bilingdocument-billingdocumenttype <> 'F5' AND billingheader-bilingdocument-billingdocumenttype <> 'JSN' AND billingheader-bilingdocument-billingdocumenttype <> 'JVR'
    AND billingheader-bilingdocument-billingdocumenttype <> 'F8' ).

      DATA(lv_msg) = me->new_message(
                         id       = 'ZMC_DS'
                         number   = 002
                         severity = ms-error
                       ).
*
      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zi_bd_ds.


    ELSE.

      SELECT SINGLE * FROM zdb_digiforpdf
      WHERE billingdocument = @wa_key-billingdocument
      INTO @DATA(wa_pdftab).

      CLEAR wa_pdftab.

      IF wa_pdftab IS NOT INITIAL.

        lv_msg = me->new_message(
                   id       = 'ZMC_DS'
                   number   = 001
                   severity = ms-error
*                         v1       = ''
                 ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ELSEIF wa_pdftab IS INITIAL.

        CASE sy-sysid.
          WHEN lv_dev.
            lv_tenent = 'my413043'.
            username  = 'IVP'.
            password  = 'Password@#0987654321'.
          WHEN lv_qas.
            lv_tenent = 'my412469'.
            username  =  'IVP'.
            password  = 'Password@#0987654321'.
          WHEN lv_prd.
            lv_tenent = 'my416089'.
            username  = 'IVP'.
            password  = 'Password@#0987654321'.
        ENDCASE.

        DATA(lv_url) = | https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/GetPDF?BillingDocument='{ wa_key-billingdocument }'|.
        CONDENSE lv_url NO-GAPS.



***************************************************Get Method

        TRY.
            DATA(client)  = cl_web_http_client_manager=>create_by_http_destination( i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
                                                                                                     ) .
          CATCH cx_web_http_client_error cx_http_dest_provider_error.
            "handle exception
        ENDTRY.

        DATA(req) = client->get_http_request(  ).

        req->set_authorization_basic(
          EXPORTING
            i_username = username
            i_password = password
        ).


        req->set_header_fields(  VALUE #(
    (  name = 'config_authType' value = 'Basic' )
    (  name = 'Accept' value = 'application/json' )
    ) ).

        TRY.

            DATA(lv_response) = client->execute( i_method = if_web_http_client=>get ).
            DATA(json_response) = lv_response->get_text( ).
            DATA(stat) = lv_response->get_status(  ).
          CATCH: cx_web_http_client_error.
        ENDTRY.


        CHECK stat-code = 200.

        SPLIT json_response AT '"BillingDocumentBinary":"' INTO lv_split1 lv_split2.
        SPLIT lv_split2 AT '"' INTO lv_base64 lv_split4.
        CONDENSE lv_base64 NO-GAPS.


        REPLACE ALL OCCURRENCES OF '\n' IN lv_base64 WITH ''.
        REPLACE ALL OCCURRENCES OF '\' IN lv_base64 WITH ''.


***************************************************Digital Signature Class

        DATA(createdby) = sy-uname.
        REPLACE ALL OCCURRENCES OF 'CB' IN createdby WITH space.
        CONDENSE createdby.

        SELECT SINGLE fullname FROM i_workforceperson_1
        WHERE businesspartner = @createdby
        INTO @DATA(createdbyuser).





        DATA(zclass) = NEW zcl_digital_signature( ).
        DATA(base64) = zclass->digitalsignature(
                         p_base64           = lv_base64
                         p_uuid             = ''
                         p_signloc          = '[30:15]'
                         p_signsize         = |[80:40]|
                         p_signannotation   = createdbyuser
                       ).

        DATA(decoded_binary) = cl_web_http_utility=>decode_x_base64( encoded = base64 ).

        wa_pdftab-billingdocument   = wa_key-billingdocument.
        wa_pdftab-attachment        = decoded_binary.
        wa_pdftab-mimetype          = 'application/pdf'.
        wa_pdftab-filename          = | BillingDocument.pdf |.

        MODIFY zdb_digiforpdf FROM @wa_pdftab.

        DATA(emailclass)  = NEW zcl_billingemailtrigger( ).
        DATA(emailmethod) = emailclass->emailtemplate(
                              p_billingdocument = wa_key-billingdocument
                              pdfxstring        = decoded_binary
                            ).

        lv_msg  = me->new_message(
                           id       = 'ZMC_DS'
                           number   = 003
                           severity = ms-success
                         ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_bd_ds.

      ENDIF.
    ENDIF.


  ENDMETHOD.


ENDCLASS.

CLASS lsc_zi_bd_ds DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_bd_ds IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
