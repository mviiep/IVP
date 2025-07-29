CLASS lhc_zi_ds_po DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_ds_po RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ds_po RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_ds_po RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_ds_po.

    METHODS bddigitalsignature FOR MODIFY
      IMPORTING keys FOR ACTION zi_ds_po~bddigitalsignature RESULT result.

ENDCLASS.

CLASS lhc_zi_ds_po IMPLEMENTATION.

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

    DATA ls_record LIKE LINE OF reported-zi_ds_po.

    TYPES : BEGIN OF ty_failmsg,
              code(20),
              lang(2),
              value    TYPE string,
            END OF ty_failmsg.

    TYPES : BEGIN OF ty_failresult,
              code(20),
              message      TYPE ty_failmsg,
              innererror   TYPE string,
              errordetails TYPE string,
            END OF ty_failresult.

    TYPES : BEGIN OF ty_dsfail,
              error TYPE ty_failresult,
            END OF ty_dsfail.

    DATA wa_dsfail TYPE ty_dsfail.

******************************************************************************************************

    READ ENTITIES OF zi_ds_po IN LOCAL MODE
    ENTITY zi_ds_po
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(repoerted_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.


    SELECT SINGLE * FROM zdb_dspotab
    WHERE purchaseorder = @wa_key-purchaseorder
    INTO @DATA(wa_pdftab).

    IF wa_pdftab-attachment IS NOT INITIAL.

      DATA(lv_msg) = me->new_message(
                     id       = 'ZMC_DS'
                     number   = 001
                     severity = ms-error
*                         v1       = ''
                   ).

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zi_ds_po.

    ELSEIF wa_pdftab-attachment IS INITIAL.

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

      DATA(lv_url) = | https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PURCHASEORDER_PROCESS_SRV/GetPDF?PurchaseOrder='{ wa_key-purchaseorder }'|.
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

      IF stat-code <> 200.
        /ui2/cl_json=>deserialize( EXPORTING json = json_response
                                   pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = wa_dsfail ).


        lv_msg = me->new_message(
        id       = 'ZMC_DS'
        number   = 004
        severity = ms-error
        v1       = wa_dsfail-error-message-value
        ).

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zi_ds_po.

      ENDIF.

      CHECK stat-code = 200.

      SPLIT json_response AT '"PurchaseOrderBinary":"' INTO lv_split1 lv_split2.
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
                       p_base64         = lv_base64
                       p_uuid           = ''
                       p_signloc        = '[480:22]'
                       p_signsize       = ''
                       p_signannotation = createdbyuser
                     ).

      DATA(decoded_binary) = cl_web_http_utility=>decode_x_base64( encoded = base64 ).

      DATA(emailclass)  = NEW zcl_poemailtrigger( ).
      DATA(emailmethod) = emailclass->emailtemplate(
                            p_purchaseorder   = wa_key-purchaseorder
                            pdfxstring        = decoded_binary
                          ).


      wa_pdftab-purchaseorder     = wa_key-purchaseorder.
      wa_pdftab-attachment        = decoded_binary.
      wa_pdftab-mimetype          = 'application/pdf'.
      wa_pdftab-filename          = |PurchaseOrder.pdf|.

      MODIFY zdb_dspotab FROM @wa_pdftab.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_ds_po DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_ds_po IMPLEMENTATION.

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
