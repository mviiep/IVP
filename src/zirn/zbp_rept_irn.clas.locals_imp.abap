CLASS lhc_zrept_irn DEFINITION INHERITING FROM cl_abap_behavior_handler.
**************************** SUccess IRN Generation Response*******************************
  TYPES: BEGIN OF ty_msg,
           ackno(20),
           ackdt(20),
           irn(64),
           signedinvoice    TYPE string,
           signedqrcode     TYPE string,
           ewbno(20),
           ewbdt(20),
           ewbvalidtill(30),
           status(3),
           remarks          TYPE string,
           alert            TYPE string,
           error            TYPE string,
         END OF ty_msg.
  TYPES: BEGIN OF ty_result,
           message      TYPE ty_msg,
           errormessage TYPE string,
           infodtls     TYPE string,
           status(10),
           code(3),
           requestid    TYPE string,
         END OF ty_result.
  TYPES: BEGIN OF ty_irnsuccess,
           results TYPE ty_result,
         END OF ty_irnsuccess.
  DATA wa_irnsuccess TYPE ty_irnsuccess.
*******************************************************************************************
************************IRN Failure Response**************************************
  TYPES : BEGIN OF ty_failresult,
            message      TYPE string,
            errormessage TYPE string,
            infodtls     TYPE string,
            status       TYPE string,
            code(3),
            requestid    TYPE string,
          END OF ty_failresult.
  TYPES : BEGIN OF ty_irnfail,
            results TYPE ty_failresult,
          END OF ty_irnfail.
  DATA wa_irnfail TYPE ty_irnfail.
*********************************************************************************
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zrept_irn RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zrept_irn RESULT result.

    METHODS irn_gen FOR MODIFY
      IMPORTING keys FOR ACTION zrept_irn~irn_gen RESULT result.

ENDCLASS.

CLASS lhc_zrept_irn IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD irn_gen.
    DATA: zj1ig_invrefnum TYPE TABLE OF ztab_j1ig_invref.
    TYPES: BEGIN OF ty_keys,
             billingdocument TYPE c LENGTH 10,
             companycode     TYPE c LENGTH 4,
             fiscalyear      TYPE c LENGTH 4,
*             postingdate     TYPE datn,
*             irn(64),
           END OF ty_keys.
    DATA it_keys TYPE TABLE OF ty_keys.
    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    MOVE-CORRESPONDING keys TO it_keys.
    wa_key-billingdocument = |{ wa_key-billingdocument ALPHA = IN }|.
    DATA(irnmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = irnmethod->irngen( it_keys ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnsuccess ).
      DATA(lv_msg) = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 001
                       severity = ms-success
                       v1       =  'test' "wa_irnsuccess-results-message-irn "'test'
                     ).
*      DATA ls_record LIKE LINE OF reported-zce_irn_status.
*      APPEND ls_record TO reported-zce_irn_status.
*      ls_record-%msg = lv_msg.
*      APPEND ls_record TO reported-zce_irn_status.

      APPEND VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_with_text(
                             severity = if_abap_behv_message=>severity-success
                             text     = |IRN Generated { wa_irnsuccess-results-message-irn }Successfull|
                           )
                         ) TO reported-zrept_irn.

    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnfail ).
*      lv_msg = me->new_message(
*                       id       = 'ZCL_MSG_EINV'
*                       number   = 002
*                       severity = ms-success
*                       v1       = wa_irnfail-results-errormessage
*                     ).
**      DATA ls_record LIKE LINE OF reported-zce_irn_status.
*
*      ls_record-%msg = lv_msg.
*      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
