*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS loc DEFINITION.
    PUBLIC SECTION.
    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zi_dd_supqtprice AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

        TYPES tdata TYPE TABLE OF ty_buffer.
        CLASS-DATA mt_data TYPE tdata.

   CLASS-DATA:thead   TYPE TABLE OF zi_dd_supqtprice,
               tdel   type table of zi_dd_supqtprice,
               gv_mode type C.

ENDCLASS.

CLASS lhc_zi_dd_supqtprice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_dd_supqtprice RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_dd_supqtprice.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_dd_supqtprice.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_dd_supqtprice.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_dd_supqtprice RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_dd_supqtprice.

ENDCLASS.

CLASS lhc_zi_dd_supqtprice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.
  METHOD create.
    loc=>gv_mode = 'C'.     "Create
**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-zi_dd_supqtprice,
          tgdt    LIKE LINE OF loc=>mt_data.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_dd_supqtprice.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

   METHOD update.
        data: lv_baseurl type string,
              lv_dev(3)       TYPE c VALUE 'JNY',
              lv_qas(3)       TYPE c VALUE 'JF4',
              lv_prd(3)       TYPE c VALUE 'KSZ'.

        data: lo_http_token       TYPE REF TO if_web_http_client,
              lv_csrftoken   type string.
       types: begin of ty_supqtitem,
*                _Request_For_Quotation type ebeln,
                _Awarded_Quantity      type string,
               _Y_Y1___Quote_Remarks___P_D_I type string,      "YY1_QuoteRemarks_PDI
               end   of ty_supqtitem.

    data: wa_supqtitem  type ty_supqtitem,
          lt_string     type table of string,
          lwa_string    like line of lt_string,
          lv_msgtyp     type IF_ABAP_BEHV_MESSAGE=>T_SEVERITY,
          wa_msgrecord  like line of reported-zi_dd_supqtprice.

    loc=>gv_mode = 'B'.     "Modify/Update
**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-zi_dd_supqtprice,
          tgdt    LIKE LINE OF loc=>mt_data.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_dd_supqtprice.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

* return.     "TEMP REMOVE THIS LINE ONCE BELOW CODE IS COMPLETED
" Call API to update Award Quantity
 " Supplier Quotation: API_QTN_PROCESS_SRV
           case sy-sysid.
           when lv_dev.
                lv_baseurl = 'https://my413043.s4hana.cloud.sap/sap/opu/odata/sap/API_QTN_PROCESS_SRV/'.
           when lv_qas.
                lv_baseurl = 'https://my412469.s4hana.cloud.sap/sap/opu/odata/sap/API_QTN_PROCESS_SRV/'.
           when lv_prd.
                lv_baseurl = 'https://my416089.s4hana.cloud.sap/sap/opu/odata/sap/API_QTN_PROCESS_SRV/'.
           ENDCASE.

* Read credentials
" Table : yy1_753a4f724eca
" Entity: YY1_API_USER_CREDENTIAL
    SELECT single * from zi_apicreden
           where SystemID = @sy-mandt
            INTO @data(lwa_uidpwd).
    if sy-subrc <> 0.
        return.
    endif.

* Call Http client object
     TRY.
        lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lv_baseurl ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

" To fetch x-csrf-token
       DATA(lo_request) = lo_http_token->get_http_request( ).
        lo_request->set_header_fields(  VALUE #(
                                                 ( name = 'Content-Type'  value = 'application/json' )
                                                 ( name = 'x-csrf-token'  value = 'Fetch' )
                                                 ( name = 'Accept' Value = '*/*' )
                                                )  ).

       lo_request->set_authorization_basic(
                          EXPORTING
                            i_username = lwa_uidpwd-username
                            i_password = lwa_uidpwd-password  ).

     TRY.

        DATA(lo_response) = lo_http_token->execute(
                            i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
"       data(lv_msg) = lo_Response->get_text(  ).
    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

    lv_csrftoken = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
    lo_response->get_cookies(
          RECEIVING
            r_value = DATA(it_cookies)
        ).

       if lv_status-code <> 200.
" Appropriate message should go here
            lv_msgtyp = if_abap_behv_message=>severity-error.
            data(wa_msg)    = me->new_message( EXPORTING
                               id     = '8i'
                               number = 000
                               severity = lv_msgtyp
                               v1       = 'Error in generating x-csrf-token' ).

            wa_msgrecord-%msg = wa_msg.
            wa_msgrecord-%tky-%key-SupplierQuotation = value #( loc=>thead[ 1 ]-SupplierQuotation optional ).
            append wa_msgrecord to reported-zi_dd_supqtprice.
            return.     "exit in case error in receiving csrf token
        endif.

*&------------------------------------------------------------------------*&
*  To update Awarded Quantity
*&------------------------------------------------------------------------*&
    CONCATENATE lv_baseurl '$batch' into data(lv_urlnew).
 try.
    data(lo_http_supquot) = cl_web_http_client_manager=>create_by_http_destination(
                                  i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).
    clear: lwa_string.
*    lwa_string = cl_abap_string_utilities=>c2str_preserving_blanks.
    lo_request = lo_http_supquot->get_http_request(  ).
"    lo_request->append_text( 'test' ).


    lo_request->append_text( '--batch_123456' && cl_abap_char_utilities=>cr_lf ).
*    lo_request->append_text( '' && cl_abap_char_utilities=>cr_lf ).
    lo_request->append_text( 'Content-Type: multipart/mixed; boundary=changeset_67890' && cl_abap_char_utilities=>cr_lf ).

    loop at loc=>thead into data(lwa_supqtitem).
        clear: lwa_string, wa_supqtitem.
        lo_request->append_text( ' ' && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( '--changeset_67890' && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( 'Content-Type: application/http' && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( 'Content-Transfer-Encoding: binary' && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( ' ' && cl_abap_char_utilities=>cr_lf ).

        lwa_string = |PATCH A_SupplierQuotationItem(SupplierQuotation='{ lwa_supqtitem-SupplierQuotation }',SupplierQuotationItem='{ lwa_supqtitem-SupplierQuotationItem }') HTTP/1.1|.
        lo_request->append_text( LWA_STRING && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( 'Content-Type: application/json' && cl_abap_char_utilities=>cr_lf ).
        lo_request->append_text( '' && cl_abap_char_utilities=>cr_lf ).

        wa_supqtitem-_awarded_quantity =  lwa_supqtitem-AwardedQuantity.            "Awarded Quantity
        wa_supqtitem-_y_y1___quote_remarks___p_d_i    = lwa_supqtitem-Remarks.        "Remarks
* To remove space just in case
        wa_supqtitem-_awarded_quantity = condense(  wa_supqtitem-_awarded_quantity ).

          data(lv_json) = /ui2/cl_json=>serialize( exporting data = wa_supqtitem
                                                              pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
         lo_request->append_text( lv_json ).

    endloop.            "End loop of Supplier quotation

    lo_request->append_text( ' ' && cl_abap_char_utilities=>cr_lf ).
    lo_request->append_text( '--changeset_67890--' && cl_abap_char_utilities=>cr_lf ).
    lo_request->append_text( '--batch_123456--' && cl_abap_char_utilities=>cr_lf ).

    data(lv_text_temp)  = lo_request->get_text(  ).
    lo_request->set_header_fields(  VALUE #(
                                             (  name = 'Content-Type'  value = 'multipart/mixed;boundary=batch_123456' )
                                             (  name = 'x-csrf-token'  value = lv_csrftoken )
                                            )  ).
    loop at it_cookies into data(ls_cookie).
        lo_request->set_cookie( EXPORTING
                                  i_name    = ls_cookie-name
                                  i_value   = ls_cookie-value
                                  i_path    = ls_cookie-path
                                  i_secure  = ls_cookie-secure ).
    endloop.

    lo_response = lo_http_supquot->execute( i_method  = if_web_http_client=>post ).
      lv_status = lo_response->get_status(  ).
      data(lv_resptext) = lo_response->get_text(  ).

    if lv_status-code = 202.        "Accepted
    else.
           lv_msgtyp = if_abap_behv_message=>severity-error.
           wa_msg    = me->new_message( EXPORTING
                               id     = '8i'
                               number = 000
                               severity = lv_msgtyp
                               v1       = 'Error updating awarded quantity'
                               v2     = lwa_supqtitem-SupplierQuotation ).

            wa_msgrecord-%msg = wa_msg.
            wa_msgrecord-%tky-%key-SupplierQuotation = lwa_supqtitem-SupplierQuotation.
            append wa_msgrecord to reported-zi_dd_supqtprice.
            return.
    endif.

   catch cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
  endtry.

*&------------------------------------------------------------------------*&
*  To Award/Send for approval the supplier quotation
*&------------------------------------------------------------------------*&
    concatenate lv_baseurl 'SubmitForApproval?SupplierQuotation=' '''' lwa_supqtitem-SupplierQuotation '''' into lv_urlnew.
   try.
     lo_http_supquot = cl_web_http_client_manager=>create_by_http_destination(
                                  i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

    lo_request = lo_http_supquot->get_http_request( ).
    lo_request->set_header_fields(  VALUE #( (  name = 'Content-Type'  value = 'application/json' )
                                             (  name = 'x-csrf-token'  value = lv_csrftoken ) ) ).
      loop at it_cookies into ls_cookie.
        lo_request->set_cookie( EXPORTING
                                      i_name    = ls_cookie-name
                                      i_value   = ls_cookie-value
                                      i_path    = ls_cookie-path
                                      i_secure  = ls_cookie-secure ).
      endloop.
      lo_response   = lo_http_supquot->execute( i_method  = if_web_http_client=>post ).
      lv_status     = lo_response->get_status(  ).
      lv_resptext   = lo_response->get_text(  ).
      if lv_status-code = 200.

           lv_msgtyp = if_abap_behv_message=>severity-success.
           wa_msg    = me->new_message( EXPORTING
                               id     = '8i'
                               number = 000
                               severity = lv_msgtyp
                               v1       = 'Supplier Quotation ' && lwa_supqtitem-SupplierQuotation
                               v2       = ' sent for approval' ).

           wa_msgrecord-%msg = wa_msg.
           wa_msgrecord-%tky-%key-SupplierQuotation = lwa_supqtitem-SupplierQuotation.
           append wa_msgrecord to reported-zi_dd_supqtprice.
      else.
           lv_msgtyp = if_abap_behv_message=>severity-error.
           wa_msg    = me->new_message( EXPORTING
                               id     = '8i'
                               number = 000
                               severity = lv_msgtyp
                               v1       = 'Error Awarding supplier quotation'
                               v2       = lwa_supqtitem-SupplierQuotation ).

            wa_msgrecord-%msg = wa_msg.
            wa_msgrecord-%tky-%key-SupplierQuotation = lwa_supqtitem-SupplierQuotation.
            append wa_msgrecord to reported-zi_dd_supqtprice.
      endif.

   catch cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error..
   endtry.

*&--------------------------------------------------------------------*&
* Update method end
*&--------------------------------------------------------------------*&
  ENDMETHOD.

    METHOD delete.
      data: lwa_line type zi_dd_supqtprice.
        loop at keys INTO data(lwa_key).
        lwa_line-requestforquotation = lwa_key-RequestForQuotation.
    "    lwa_line-rfq_item      = lwa_key-rfq_item.
        append lwa_line to loc=>tdel.
        clear: lwa_line.
        ENDLOOP.
  ENDMETHOD.

*end of delete method

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

"**************************************************************************"
" SAVER Class definition and implementation
"**************************************************************************"
CLASS lsc_zi_dd_supqtprice DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_dd_supqtprice IMPLEMENTATION.

      METHOD finalize.
      ENDMETHOD.

      METHOD check_before_save.
      ENDMETHOD.
"***************************************************************"
" SAVE Method
"***************************************************************"
      METHOD save.
      ENDMETHOD.

      METHOD cleanup.

      ENDMETHOD.

      METHOD cleanup_finalize.
      ENDMETHOD.
  ENDCLASS.
