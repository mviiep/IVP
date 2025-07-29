CLASS lhc_zce_irn_status DEFINITION INHERITING FROM cl_abap_behavior_handler.
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
**********************************************************************************
******************************IRN Cancel Success response**************************
  TYPES : BEGIN OF ty_irncncmsg,
            irn(64),
            canceldate(20),
          END OF ty_irncncmsg.
  TYPES : BEGIN OF ty_irncncresults,
            message      TYPE ty_irncncmsg,
            errormessage TYPE string,
            infodtls     TYPE string,
            status(10),
            code(3),
          END OF ty_irncncresults.
  TYPES : BEGIN OF ty_irncncsuccess,
            results TYPE ty_irncncresults,
          END OF ty_irncncsuccess.
  DATA wa_finirncncsuccess TYPE  ty_irncncsuccess.
***********************************************************************************
*************************EWAY Success Response JSON*******************
  TYPES : BEGIN OF ty_ewayirnsucmsg,
            ewbno(20),
            ewbdt(22),
            ewbvalidtill(22),
            remarks(25),
            qrcodeurl(500),
            einvoicepdf(500),
            ewaybillpdf(500),
          END OF ty_ewayirnsucmsg.
  TYPES : BEGIN OF ty_ewayirnsuccess,
            results          TYPE ty_ewayirnsucmsg,
            errormessage(20),
            infodtls(50),
            status(20),
            code(3),
          END OF ty_ewayirnsuccess.
  DATA wa_ewayirnsuccess TYPE ty_ewayirnsuccess.
***********************************************************************
******************************Eway IRN Cancel Success response**************************
  TYPES : BEGIN OF ty_ewayirncncmsg,
            ewaybillno(12),
            canceldate(20),
          END OF ty_ewayirncncmsg.
  TYPES : BEGIN OF ty_ewayirncncresults,
            message    TYPE ty_ewayirncncmsg,
            status(10),
            code(3),
          END OF ty_ewayirncncresults.
  TYPES : BEGIN OF ty_ewayirncncsuccess,
            results TYPE ty_ewayirncncresults,
          END OF ty_ewayirncncsuccess.
  DATA wa_finewayirncncsuccess TYPE  ty_ewayirncncsuccess.
***********************************************************************
****************************EWB Success Response*********************************
  TYPES : BEGIN OF ty_resultewbsuccessresp,
            ewaybillno(20),
            ewaybilldate(25),
            validupto(25),
            alert(10),
            error(10),
            url(100),
          END OF ty_resultewbsuccessresp.
  TYPES: BEGIN OF ty_msgewbsucc,
           message       TYPE ty_resultewbsuccessresp,
           status(10),
           code(3),
           requestid(20),
         END OF ty_msgewbsucc.
  TYPES : BEGIN OF ty_ewbsuccessresp,
            results TYPE ty_msgewbsucc,

          END OF ty_ewbsuccessresp.
  DATA wa_ewbsuccessresp TYPE ty_ewbsuccessresp.
************************EWay Failure Response**************************************
  TYPES : BEGIN OF ty_ewbfailresult,
            message      TYPE string,
            status       TYPE string,
            code(3),
            nic_code    TYPE string,
          END OF ty_ewbfailresult.
  TYPES : BEGIN OF ty_ewbfailresult1,
            results TYPE ty_ewbfailresult,
          END OF ty_ewbfailresult1.
  DATA wa_ewbfail TYPE ty_ewbfailresult1.
*********************************************************************************
  CLASS-DATA: lt_irn_result TYPE TABLE OF zi_irn_alv,
              wa_maintab    TYPE ztab_j1ig_invref.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zce_irn_status RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zce_irn_status RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zce_irn_status.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zce_irn_status.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zce_irn_status.

    METHODS read FOR READ
      IMPORTING keys FOR READ zce_irn_status RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zce_irn_status.

    METHODS irn_gen FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~irn_gen RESULT result.

    METHODS irn_cnc FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~irn_cnc RESULT result.

    METHODS eway_gen FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~eway_gen RESULT result.
    METHODS ewb_gen FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~ewb_gen RESULT result.
    METHODS eway_cnc FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~eway_cnc RESULT result.
    METHODS update_eway FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~update_eway RESULT result.
    METHODS display_json FOR MODIFY
      IMPORTING keys FOR ACTION zce_irn_status~display_json RESULT result.

ENDCLASS.

CLASS lhc_zce_irn_status IMPLEMENTATION.
  METHOD get_instance_features.
*    READ ENTITIES OF ZI_RAP_sTRAV_01 IN LOCAL MODE
*    ENTITY travel
*       FIELDS (  travelID status )
*       WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_travel_result)
*     FAILED failed.
    DATA(it_ky) = keys.
    DATA(wa_key) = VALUE #( it_ky[ 1 ]  OPTIONAL ).

*    READ ENTITIES OF ZI_IRN_ALV IN LOCAL MODE
*    ENTITY ZI_IRN_ALV
*       FIELDS (  billingdocument irn irncreated )
*       WITH CORRESPONDING #( keys )
*     RESULT lt_irn_result
*     FAILED failed.
**    SELECT SINGLE irn FROM zi_irn_alv WHERE billingdocument = @wa_key-billingdocument INTO @DATA(wa_irncheck) .
**    result =
**      VALUE #( FOR ls_inv IN lt_irn_result
**        ( %key = ls_inv-%key
**          %features-%action-irn_gen = COND #( WHEN ls_inv-irncreated = 'Yes'
**                                                        THEN if_abap_behv=>fc-o-enabled                                                        ELSE if_abap_behv=>fc-o-disabled )
**         ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    SELECT *
        FROM ztab_j1ig_invref
        FOR ALL ENTRIES IN @keys
        WHERE docno = @keys-billingdocument
         AND doc_year = @keys-fiscalyear
        INTO CORRESPONDING FIELDS OF TABLE @lt_irn_result.
  ENDMETHOD.

  METHOD lock.
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
    SELECT SINGLE billingdocumentiscancelled
        FROM i_billingdocumentbasic
        WHERE billingdocument = @wa_key-billingdocument
        INTO @DATA(lv_bd).
    IF lv_bd IS NOT INITIAL.
      DATA(lv_msg) = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 010
                         severity = ms-error
                         v1       = wa_irnfail-results-errormessage
                       ).
      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    DATA(irnmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = irnmethod->irngen( it_keys ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnsuccess ).
*      READ ENTITIES OF zce_irn_status IN LOCAL MODE
*        ENTITY zce_irn_status
*        FIELDS (  billingdocument irn irncreated )
*        WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_irn_result)
*         FAILED failed.
      SELECT *
        FROM zrept_irn
        FOR ALL ENTRIES IN @keys
        WHERE billingdocument = @keys-billingdocument
*          AND fiscalyear = @keys-fiscalyear
        INTO CORRESPONDING FIELDS OF TABLE @result.
      APPEND VALUE #(
                %element-irncreated = if_abap_behv=>mk-on
                %element-billingdocument = if_abap_behv=>mk-on
                %element-companycode = if_abap_behv=>mk-on
                %element-fiscalyear = if_abap_behv=>mk-on
               %tky = keys[ 1 ]-%tky
               %msg = new_message(
                        id       = 'ZCL_MSG_EINV'
                        number   = 001
                        severity = if_abap_behv_message=>severity-none
                        v1       = wa_irnsuccess-results-message-irn
*                        v2       =
*                        v3       =
*                        v4       =
                      )
       )   TO reported-zce_irn_status.
      result = VALUE #( FOR zce_irn_status IN result
                ( %tky = zce_irn_status-%key
                  %param = zce_irn_status-%param
                )
      ).

    ENDIF.

    FIND FIRST OCCURRENCE OF '502 Bad Gateway' IN lv_json_response.
    IF sy-subrc EQ 0.
      lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 009
                         severity = ms-error
                         v1       = wa_irnfail-results-errormessage
                       ).
*      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnfail ).
      lv_msg = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 002
                       severity = ms-error
                       v1       = wa_irnfail-results-errormessage
                     ).
*      DATA ls_record LIKE LINE OF reported-zce_irn_status.
      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.

      SELECT * FROM ztab_j1ig_invref WHERE docno = @wa_key-billingdocument INTO TABLE @DATA(it_check).
      IF it_check IS INITIAL.
        wa_maintab-docno = wa_key-billingdocument.
        wa_maintab-bukrs = wa_key-companycode.
        wa_maintab-doc_year = wa_key-fiscalyear.
        wa_maintab-msg_irn = 'Error While Generating IRN'.
        MODIFY ztab_j1ig_invref FROM @wa_maintab.
*        commit WORK.
      ELSE.
        UPDATE ztab_j1ig_invref SET msg_irn = 'Error While Generating IRN'
           WHERE docno = @wa_key-billingdocument.

      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD irn_cnc.
    TYPES: BEGIN OF ty_keys,
             billingdocument TYPE c LENGTH 10,
             companycode     TYPE c LENGTH 4,
             fiscalyear      TYPE c LENGTH 4,
*             postingdate     TYPE datn,
*             irn(64),
           END OF ty_keys.
    DATA: lv_date     TYPE datn,
          lv_time(10).
    DATA it_keys TYPE TABLE OF ty_keys.
    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    MOVE-CORRESPONDING keys TO it_keys.
    wa_key-billingdocument = |{ wa_key-billingdocument ALPHA = IN }|.
    SELECT SINGLE irn, ewbno, ewb_canceled
        FROM ztab_j1ig_invref
        WHERE docno = @wa_key-billingdocument
        INTO @DATA(wa_check).
    IF wa_check-ewbno IS NOT INITIAL AND wa_check-ewb_canceled IS INITIAL.
      DATA(lv_msg) = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 011
                       severity = ms-error
                       v1       = wa_irnfail-results-errormessage
                     ).
      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    DATA(irnmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = irnmethod->irncnc( it_keys ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_finirncncsuccess ).
      REPLACE ALL OCCURRENCES OF '-' IN wa_finirncncsuccess-results-message-canceldate WITH ''.
      IF sy-subrc EQ 0.
        /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = wa_irnfail ).
        lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 003
                         severity = ms-success
                         v1       = wa_irnfail-results-errormessage
                       ).
*        DATA ls_record LIKE LINE OF reported-zce_irn_status.

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zce_irn_status.
      ENDIF.
    ENDIF.
    FIND FIRST OCCURRENCE OF '502 Bad Gateway' IN lv_json_response.
    IF sy-subrc EQ 0.
      lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 009
                         severity = ms-error
                         v1       = wa_irnfail-results-errormessage
                       ).

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnfail ).
      lv_msg = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 004
                       severity = ms-error
                       v1       = wa_irnfail-results-errormessage
                     ).
*        DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.

  ENDMETHOD.

  METHOD eway_gen.
    TYPES : BEGIN OF ty_eway,
              billingdocument    TYPE ztab_eway_trans-billingdocument,
              fiscalyear         TYPE ztab_eway_trans-fiscalyear,
              postingdate        TYPE ztab_eway_trans-postingdate,
              companycode        TYPE ztab_eway_trans-companycode,
              trans_id           TYPE ztab_eway_trans-transporterid,
              trans_doc_no       TYPE ztab_eway_trans-transporterdocno,
              trans_dist         TYPE ztab_eway_trans-transdistance,
              supply_typ         TYPE ztab_eway_trans-subsplytyp,
              trans_name         TYPE ztab_eway_trans-transportername,
              trans_doc_date(10),
              vehicle_no         TYPE ztab_eway_trans-vehicleno,
              transmode          TYPE ztab_eway_trans-transportmode,
              vehicletype        TYPE ztab_eway_trans-vehicletype,
            END OF ty_eway.
    DATA : it_eway TYPE TABLE OF ty_eway,
           wa_eway TYPE ty_eway.
    DATA(it_keys) = keys.
    wa_eway-billingdocument = it_keys[ 1 ]-billingdocument.
    wa_eway-fiscalyear = it_keys[ 1 ]-fiscalyear.
    wa_eway-companycode = it_keys[ 1 ]-companycode.
*    wa_eway-postingdate = it_keys[ 1 ]-%param-
    wa_eway-trans_id  = it_keys[ 1 ]-%param-trans_id.
    wa_eway-trans_doc_no  = it_keys[ 1 ]-%param-trans_doc_no.
    wa_eway-trans_dist  = it_keys[ 1 ]-%param-trans_dist.
*    wa_eway-supply_typ  = it_keys[ 1 ]-%param-supply_typ.
    wa_eway-trans_name  = it_keys[ 1 ]-%param-trans_name.
    wa_eway-trans_doc_date  = it_keys[ 1 ]-%param-trans_doc_date.
    wa_eway-vehicle_no  = it_keys[ 1 ]-%param-vehicle_no.
    wa_eway-transmode  = it_keys[ 1 ]-%param-modeoftransport.
    wa_eway-vehicletype  = 'R'.
    wa_eway-billingdocument = |{ wa_eway-billingdocument ALPHA = IN }|.
    SELECT * FROM ztab_eway_trans WHERE billingdocument = @wa_eway-billingdocument INTO TABLE @DATA(it_trnsprt).
    IF it_trnsprt[] IS INITIAL.
      MODIFY  ztab_eway_trans FROM @wa_eway.
    ENDIF.
    CONCATENATE wa_eway-trans_doc_date+6(2) '/' wa_eway-trans_doc_date+4(2) '/' wa_eway-trans_doc_date+0(4)  INTO wa_eway-trans_doc_date.
    wa_eway-vehicle_no = it_keys[ 1 ]-%param-vehicle_no.
    APPEND wa_eway TO it_eway.
    DATA(callmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = callmethod->gen_ewayirn( it_eway ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_ewayirnsuccess ).
      DATA(lv_msg) = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 005
                       severity = ms-success
                       v1       = wa_ewayirnsuccess-results-ewbno
                     ).
      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnfail ).
      lv_msg = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 006
                       severity = ms-error
                       v1       = wa_irnfail-results-errormessage
                     ).
*      DATA ls_record LIKE LINE OF reported-zce_irn_status.
      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '502 Bad Gateway' IN lv_json_response.
    IF sy-subrc EQ 0.
      lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 009
                         severity = ms-error
                         v1       = wa_irnfail-results-errormessage
                       ).

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
  ENDMETHOD.

  METHOD ewb_gen.
    TYPES : BEGIN OF ty_eway,
              billingdocument    TYPE ztab_eway_trans-billingdocument,
              fiscalyear         TYPE ztab_eway_trans-fiscalyear,
              postingdate        TYPE ztab_eway_trans-postingdate,
              companycode        TYPE ztab_eway_trans-companycode,
              trans_id           TYPE ztab_eway_trans-transporterid,
              trans_doc_no       TYPE ztab_eway_trans-transporterdocno,
              trans_dist         TYPE ztab_eway_trans-transdistance,
              supply_typ         TYPE ztab_eway_trans-subsplytyp,
              trans_name         TYPE ztab_eway_trans-transportername,
              trans_doc_date(10),
              vehicle_no         TYPE ztab_eway_trans-vehicleno,
              transmode          TYPE ztab_eway_trans-transportmode,
              vehicletype        TYPE ztab_eway_trans-vehicletype,
            END OF ty_eway.
    DATA : it_eway TYPE TABLE OF ty_eway,
           wa_eway TYPE ty_eway.
    DATA(it_keys) = keys.
    wa_eway-billingdocument = it_keys[ 1 ]-billingdocument.
    wa_eway-fiscalyear = it_keys[ 1 ]-fiscalyear.
    wa_eway-companycode = it_keys[ 1 ]-companycode.
*    wa_eway-postingdate = it_keys[ 1 ]-%param-
    wa_eway-trans_id  = it_keys[ 1 ]-%param-trans_id.
    wa_eway-trans_doc_no  = it_keys[ 1 ]-%param-trans_doc_no.
    wa_eway-trans_dist  = it_keys[ 1 ]-%param-trans_dist.
*    wa_eway-supply_typ  = it_keys[ 1 ]-%param-supply_typ.
    wa_eway-trans_name  = it_keys[ 1 ]-%param-trans_name.
    wa_eway-trans_doc_date  = it_keys[ 1 ]-%param-trans_doc_date.
    wa_eway-vehicle_no  = it_keys[ 1 ]-%param-vehicle_no.
    wa_eway-transmode  = it_keys[ 1 ]-%param-modeoftransport.
    wa_eway-vehicletype  = 'R'.
    wa_eway-billingdocument = |{ wa_eway-billingdocument ALPHA = IN }|.
    SELECT * FROM ztab_eway_trans WHERE billingdocument = @wa_eway-billingdocument INTO TABLE @DATA(it_trnsprt).
    IF it_trnsprt[] IS INITIAL.
      MODIFY  ztab_eway_trans FROM @wa_eway.
    ENDIF.
    CONCATENATE wa_eway-trans_doc_date+6(2) '/' wa_eway-trans_doc_date+4(2) '/' wa_eway-trans_doc_date+0(4)  INTO wa_eway-trans_doc_date.
    wa_eway-vehicle_no = it_keys[ 1 ]-%param-vehicle_no.
    APPEND wa_eway TO it_eway.
    DATA(callmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = callmethod->gen_eway( it_eway ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc = 0.
      DATA(lv_msg) = me->new_message(
                     id       = 'ZCL_MSG_EINV'
                     number   = 005
                     severity = ms-success
                     v1       = wa_ewbsuccessresp-results-message-ewaybillno
                   ).
      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_irnfail ).
      lv_msg = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 006
                       severity = ms-error
                       v1       = wa_irnfail-results-errormessage
                     ).
*      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    FIND FIRST OCCURRENCE OF '502 Bad Gateway' IN lv_json_response.
    IF sy-subrc EQ 0.
      lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 009
                         severity = ms-error
                         v1       = wa_irnfail-results-errormessage
                       ).

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
  ENDMETHOD.

  METHOD eway_cnc.
    TYPES: BEGIN OF ty_keys,
             billingdocument TYPE c LENGTH 10,
             companycode     TYPE c LENGTH 4,
             fiscalyear      TYPE c LENGTH 4,
*             postingdate     TYPE datn,
*             irn(64),
           END OF ty_keys.
    DATA: lv_date     TYPE datn,
          lv_time(10).
    DATA it_keys TYPE TABLE OF ty_keys.
    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    MOVE-CORRESPONDING keys TO it_keys.
    wa_key-billingdocument = |{ wa_key-billingdocument ALPHA = IN }|.
    SELECT SINGLE ewb_canceled FROM ztab_j1ig_invref WHERE docno = @wa_key-billingdocument INTO @DATA(lv_ewbcnc).
    IF lv_ewbcnc IS NOT INITIAL.
      DATA(lv_msg) = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 012
                       severity = ms-error
                     ).
      DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
    DATA(irnmethod) = NEW zcl_einvoicing( ).
    DATA(lv_json_response) = irnmethod->ewaycnc( it_keys ).

    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_finewayirncncsuccess ).
      REPLACE ALL OCCURRENCES OF '-' IN wa_finewayirncncsuccess-results-message-canceldate WITH ''.
      SPLIT wa_finewayirncncsuccess-results-message-canceldate AT space INTO lv_date lv_time.
      CONDENSE lv_date.
*      DATA(lv) = CONV datn( lv_date ).
      DATA(lv_ewb) = wa_finewayirncncsuccess-results-message-ewaybillno.
      CONDENSE lv_ewb.
*      SELECT SINGLE docno FROM ztab_j1ig_invref WHERE ewbno = @lv_ewb INTO @DATA(lv_irnew).
      wa_maintab-ewb_canceled = 'X'.
      wa_maintab-cancel_date = lv_date.
      wa_maintab-ewbstatus = 'CNC'.

      UPDATE ztab_j1ig_invref SET cancel_date = @wa_maintab-cancel_date ,
      ewb_canceled = @wa_maintab-ewb_canceled,
      ewbstatus = @wa_maintab-ewbstatus WHERE docno = @wa_key-billingdocument.

      REPLACE ALL OCCURRENCES OF '-' IN wa_finirncncsuccess-results-message-canceldate WITH ''.
      IF sy-subrc EQ 0.
*        /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
*                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*                                   CHANGING data = wa_irnfail ).
        lv_msg = me->new_message(
                         id       = 'ZCL_MSG_EINV'
                         number   = 007
                         severity = ms-success
                         v1       = wa_irnfail-results-errormessage
                       ).
*        DATA ls_record LIKE LINE OF reported-zce_irn_status.

        ls_record-%msg = lv_msg.
        APPEND ls_record TO reported-zce_irn_status.
      ENDIF.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"No Content"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_ewbfail ).
      lv_msg = me->new_message(
                       id       = 'ZCL_MSG_EINV'
                       number   = 008
                       severity = ms-error
                       v1       = wa_ewbfail-results-message
                     ).
*        DATA ls_record LIKE LINE OF reported-zce_irn_status.

      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zce_irn_status.
    ENDIF.
  ENDMETHOD.

  METHOD update_eway.
  ENDMETHOD.

  METHOD DISPLAY_JSON.

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
         SELECT SINGLE *
        FROM i_billingdocumentbasic
        WHERE billingdocument = @wa_key-billingdocument
        INTO @DATA(lv_bd).

 DATA(lv_json) = /UI2/CL_JSON=>SERIALIZE(
        DATA             = lv_bd
        COMPRESS         = ABAP_TRUE
        ASSOC_ARRAYS     = ABAP_TRUE
        ASSOC_ARRAYS_OPT = ABAP_TRUE
 PRETTY_NAME = /UI2/CL_JSON=>PRETTY_MODE-CAMEL_CASE  ).
* CL_DEMO_OUTPUT_cloud

 FINAL(json) =
      cl_demo_output_cloud=>new( cl_demo_output_cloud=>json
        )->begin_section( 'JSON Output'
        )->get( lv_bd ).

*    cl_demo_output_cloud=>new( cl_demo_output_cloud=>json
*        )->write_data( json ) .


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zce_irn_status DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zce_irn_status IMPLEMENTATION.

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
