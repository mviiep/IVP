CLASS lhc_ZVendor_EInvoice_Get DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.

    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

    METHODS get_auth_token
      RETURNING VALUE(lv_authtoken) TYPE string.

    TYPES : BEGIN OF lty_auth,
              uname    TYPE string,
              password TYPE string,
            END OF lty_auth.

    DATA : ls_config    TYPE lty_auth,
           base_url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v2/',
           lv_token     TYPE string,
           content_type TYPE string VALUE 'Content-Type',
           json_content TYPE string VALUE 'application/json'.

  PRIVATE      SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZVendor_EInvoice_Get RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZVendor_EInvoice_Get.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZVendor_EInvoice_Get.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZVendor_EInvoice_Get.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZVendor_EInvoice_Get RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZVendor_EInvoice_Get.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR ZVendor_EInvoice_Get RESULT result.

    METHODS Get_Einvoice FOR MODIFY
      IMPORTING keys FOR ACTION ZVendor_EInvoice_Get~Get_Einvoice RESULT result.


ENDCLASS.

CLASS lhc_ZVendor_EInvoice_Get IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
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
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD get_global_features.
  ENDMETHOD.

  METHOD create_client.

    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.

  METHOD get_auth_token.

    DATA : lv_res_token1 TYPE string,
           string1       TYPE string,
           string2       TYPE string,
           string3       TYPE string,
           string4       TYPE string.

    ls_config-uname = 'ryshejwal@ivpindia.com'.
    DATA url TYPE string.
    CONCATENATE base_url 'token-auth/' INTO url.
    CONDENSE url NO-GAPS.


    lv_token = '{"password":"Masters@1234567","username":"ryshejwal@ivpindia.com"}'.

    TRY.
        DATA(client) = create_client( url ).
      CATCH cx_static_check.
    ENDTRY.
    DATA(req) = client->get_http_request(  ).
    req->set_text( lv_token ).
    req->set_header_field( i_name = content_type i_value = json_content ).
    TRY.
        lv_authtoken = client->execute( if_web_http_client=>post )->get_text(  ).
        client->close(  ).
      CATCH cx_static_check.
    ENDTRY.

    lv_res_token1 = lv_authtoken.
    SPLIT lv_authtoken AT ':' INTO string1 string2.
    lv_res_token1 = string2.
    REPLACE ALL OCCURRENCES OF '"' IN lv_res_token1 WITH ' '.
    REPLACE ALL OCCURRENCES OF '}' IN lv_res_token1 WITH ' '.
    CONDENSE lv_res_token1 NO-GAPS.
    SPLIT string2 AT ',' INTO string3 string4.
    CLEAR lv_authtoken.
    lv_authtoken = string3.
    REPLACE ALL OCCURRENCES OF '"' IN lv_authtoken WITH ' '.
    CONDENSE lv_authtoken NO-GAPS.

  ENDMETHOD.

  METHOD Get_Einvoice.

    TYPES: BEGIN OF ty_message,
             message TYPE bapi_msg,
           END OF ty_message,

           BEGIN OF ty_TranDtls,
             TaxSch      TYPE string,
             SupTyp      TYPE string,
             RegRev      TYPE string,
             IgstOnIntra TYPE string,
           END OF ty_TranDtls,

           BEGIN OF ty_DocDtls,
             Typ TYPE string,
             No  TYPE string,
             Dt  TYPE string,
           END OF ty_DocDtls,

           BEGIN OF ty_SellerDtls,
             Gstin TYPE string,
             LglNm TYPE string,
             Addr1 TYPE string,
             Loc   TYPE string,
             Pin   TYPE string,
             Stcd  TYPE string,
           END OF ty_SellerDtls,

           BEGIN OF ty_BuyerDtls,
             Gstin TYPE string,
             LglNm TYPE string,
             Pos   TYPE string,
             Addr1 TYPE string,
             Loc   TYPE string,
             Pin   TYPE string,
             Stcd  TYPE string,
           END OF ty_BuyerDtls.

    TYPES : BEGIN OF TY_ItemList,
              ItemNo        TYPE string,
              SlNo          TYPE string,
              IsServc       TYPE string,
              PrdDesc       TYPE string,
              HsnCd         TYPE string,
              Unit          TYPE string,
              Qty           TYPE string,
              FreeQty       TYPE string,
              currency      TYPE string,
              UnitPrice     TYPE string,
              TotAmt        TYPE string,
              Discount      TYPE string,
              AssAmt        TYPE string,
              GstRt         TYPE string,
              IgstAmt       TYPE string,
              CgstAmt       TYPE string,
              SgstAmt       TYPE string,
              CesRt         TYPE string,
              CesAmt        TYPE string,
              CesNonAdvlAmt TYPE string,
              TotItemVal    TYPE string,
            END OF ty_itemlist.

    DATA : tt_item_list TYPE TABLE OF ty_itemlist.

    TYPES : BEGIN OF ty_ValDtls,
              AssVal    TYPE string,
              CgstVal   TYPE string,
              SgstVal   TYPE string,
              IgstVal   TYPE string,
              CesVal    TYPE string,
              Discount  TYPE string,
              OthChrg   TYPE string,
              RndOffAmt TYPE string,
              TotInvVal TYPE string,
            END OF ty_ValDtls,

            BEGIN OF ty_data,
              Ackno      TYPE string,
              Ackdt      TYPE string,
              irn        TYPE string,
              TranDtls   TYPE ty_TranDtls,
              DocDtls    TYPE ty_docdtls,
              SellerDtls TYPE ty_SellerDtls,
              BuyerDtls  TYPE ty_BuyerDtls,
              ItemList   LIKE tt_Item_List,
              ValDtls    TYPE ty_ValDtls,
            END OF ty_data,

            BEGIN OF ty_data1,
              _id(50),"  TYPE string,
              data    TYPE ty_data,
*             TranDtls   TYPE ty_TranDtls,
*             DocDtls    TYPE ty_docdtls,
*             SellerDtls TYPE ty_SellerDtls,
*             BuyerDtls  TYPE ty_BuyerDtls,
*             ItemList   TYPE ty_ItemList,
*             ValDtls    TYPE ty_ValDtls,
*             Ackno         TYPE string,
*             Ackdt         TYPE string,
*             irn           TYPE string,
*             TaxSch        TYPE string,
*             SupTyp        TYPE string,
*             RegRev        TYPE string,
*             IgstOnIntra   TYPE string,
*             Typ           TYPE string,
*             No            TYPE string,
*             Dt            TYPE string,
*             Gstin         TYPE string,
*             LglNm         TYPE string,
*             Addr1         TYPE string,
*             Loc           TYPE string,
*             Pin           TYPE string,
*             Stcd          TYPE string,
*             CGstin        TYPE string,
*             CLglNm        TYPE string,
*             CPos          TYPE string,
*             CAddr1        TYPE string,
*             CLoc          TYPE string,
*             CPin          TYPE string,
*             CStcd         TYPE string,
*             ItemNo        TYPE string,
*             SlNo          TYPE string,
*             IsServc       TYPE string,
*             PrdDesc       TYPE string,
*             HsnCd         TYPE string,
*             Unit          TYPE string,
*             Qty           TYPE string,
*             FreeQty       TYPE string,
*             currency      TYPE string,
*             UnitPrice     TYPE string,
*             TotAmt        TYPE string,
*             IDiscount     TYPE string,
*             AssAmt        TYPE string,
*             GstRt         TYPE string,
*             IgstAmt       TYPE string,
*             CgstAmt       TYPE string,
*             SgstAmt       TYPE string,
*             CesRt         TYPE string,
*             CesAmt        TYPE string,
*             CesNonAdvlAmt TYPE string,
*             TotItemVal    TYPE string,
*             AssVal        TYPE string,
*             CgstVal       TYPE string,
*             SgstVal       TYPE string,
*             IgstVal       TYPE string,
*             CesVal        TYPE string,
*             Discount      TYPE string,
*             OthChrg       TYPE string,
*             RndOffAmt     TYPE string,
*             TotInvVal     TYPE string,
            END OF ty_data1,

            BEGIN OF ty_output,
              success TYPE string,
              status  TYPE string,
              message TYPE string,
            END OF ty_output.

    DATA : tt_Suppl_Einv TYPE TABLE OF ty_data1.

    TYPES : BEGIN OF ty_output1,
              success TYPE string,
              status  TYPE string,
              message TYPE ty_message,
              data    LIKE tt_suppl_einv,
            END OF ty_output1.

    DATA : einv_url      TYPE string,
           irn_type      TYPE string,
           ack_date_from TYPE string,
           ack_date_TO   TYPE string,
           Gstin         TYPE string,
           lv_res_token  TYPE string,
           ls_output     TYPE ty_output,
           ls_output1    TYPE ty_output1.

    DATA(it_veinv) = keys[].

    READ TABLE it_veinv INTO DATA(wa_einv) INDEX 1.
    IF  sy-subrc = 0.
      DATA(ls_ack_date_from) = wa_einv-%param-Ack_date_from.
      DATA(ls_ack_date_to)   = wa_einv-%param-Ack_date_to.
      DATA(ls_gstin)         = wa_einv-%param-gstin.
    ENDIF.

*start error handling**
    DATA : lv_error  TYPE ty_output,
           lv_text   TYPE string,
           ls_fail   LIKE LINE OF failed-zvendor_einvoice_get,
           ls_record LIKE LINE OF reported-zvendor_einvoice_get.

    IF ls_gstin IS INITIAL.
      DATA(lv_msg) = me->new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     =  'Please Input GSTIN' ).
      APPEND ls_fail TO failed-zvendor_einvoice_get.
      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zvendor_einvoice_get.
      EXIT.

    ELSEIF ls_ack_date_from IS INITIAL.
      DATA(lv_msg1) = me->new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     =  'Please Input Ack Date from' ).
      APPEND ls_fail TO failed-zvendor_einvoice_get.
      ls_record-%msg = lv_msg1.
      APPEND ls_record TO reported-zvendor_einvoice_get.
      EXIT.

    ELSEIF ls_ack_date_to IS INITIAL.
      DATA(lv_msg2) = me->new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     =  'Please Input Ack Date to' ).
      APPEND ls_fail TO failed-zvendor_einvoice_get.
      ls_record-%msg = lv_msg2.
      APPEND ls_record TO reported-zvendor_einvoice_get.
      EXIT.
    ENDIF.
*End error handling**

    einv_url      = 'https://api-platform.mastersindia.co/api/v2/saas-apis/irn/?'.
    irn_type      = 'purchase'.
    ack_date_from = ls_ack_date_from.  "'1.11.2024'. "sy-datum - 2.
    ack_date_to   = ls_ack_date_to.    "'7.12.2024'. "sy-datum.
    gstin         = ls_gstin.          "'27AAACI0992A1ZX'.

    CONCATENATE einv_url 'irn_type=' irn_type '&' 'ack_date_from=' ack_date_from '&' 'ack_date_to=' ack_date_to INTO einv_url.

    CONDENSE einv_url NO-GAPS.

    lv_res_token = get_auth_token( ).

    TRY.
        DATA(client) = create_client( einv_url ).
      CATCH cx_static_check.
    ENDTRY.

    DATA(req) = client->get_http_request(  ).
    req->set_header_fields(  VALUE #(
   ( name = 'Gstin'      value = gstin )
   ( name = 'Authorization' value = |JWT { lv_res_token }| ) ) ).

    TRY.
        DATA(lv_response) = client->execute(
                        i_method  = if_web_http_client=>get ).
        DATA(json_response) = lv_response->get_text( ).
        DATA(stat) = lv_response->get_status(  ).
        client->close( ).
      CATCH: cx_web_http_client_error.
    ENDTRY.

    /ui2/cl_json=>deserialize(
    EXPORTING
    json = json_response
    CHANGING
    data = ls_output ).

    IF ls_output-success = 'X' AND ls_output-status = ' '
    AND ( ls_output-message = 'Data Found' OR ls_output-message = 'data found' ).

      /ui2/cl_json=>deserialize(
      EXPORTING
      json = json_response
      CHANGING
      data = ls_output1 ).

      DATA : it_Suppl_einv TYPE TABLE OF zvendor_einv_tab,
             ls_suppl_einv TYPE zvendor_einv_tab.

      DATA(IT_Einv_data) = ls_output1-data.

      LOOP AT IT_einv_data INTO DATA(wa_einv_data).

      IF wa_einv_data-data-docdtls-dt IS NOT INITIAL.
      CONCATENATE wa_einv_data-data-docdtls-dt+6(4)
                  wa_einv_data-data-docdtls-dt+3(2)
                  wa_einv_data-data-docdtls-dt+0(2)
                  INTO wa_einv_data-data-docdtls-dt.
      ENDIF.

        LOOP AT wa_einv_data-data-itemlist ASSIGNING FIELD-SYMBOL(<wa_einv_item>).

          if <wa_einv_item>-slno is not initial.
          SELECT id, item_slno FROM zvendor_einv_tab
          FOR ALL ENTRIES IN @IT_einv_data
          WHERE id = @IT_einv_data-_id
          AND item_itemno = @<wa_einv_item>-slno
          INTO TABLE @DATA(IT_Einv_data1).
          if IT_Einv_data1 is not initial.
          READ TABLE it_einv_data1 INTO DATA(wa_einv_data1) WITH KEY iD = wa_einv_data-_id
                                                                     item_slno = <wa_einv_item>-slno.
          endif.
          endif.

          IF sy-subrc = 0.
            ls_suppl_einv-id  = wa_einv_data1-id.
            ls_suppl_einv-item_slno  = wa_einv_data1-item_slno.
          ELSE.
            ls_suppl_einv-id  = wa_einv_data-_id.
            ls_suppl_einv-item_slno  = <wa_einv_ITEM>-slno.
          ENDIF.

*          ls_suppl_einv-id                    =  wa_einv_data-_id                .
          ls_suppl_einv-ack_no                =  wa_einv_data-data-ackno                .
          ls_suppl_einv-ack_dt                =  wa_einv_data-data-ackdt                .
          ls_suppl_einv-irn                   =  wa_einv_data-data-irn                   .
          ls_suppl_einv-tax_sch               =  wa_einv_data-data-trandtls-taxsch               .
          ls_suppl_einv-sup_typ               =  wa_einv_data-data-trandtls-suptyp               .
          ls_suppl_einv-reg_rev               =  wa_einv_data-data-trandtls-regrev               .
          ls_suppl_einv-igst_on_intra         =  wa_einv_data-data-trandtls-igstonintra         .
          ls_suppl_einv-doc_type              =  wa_einv_data-data-docdtls-typ              .
          ls_suppl_einv-doc_no                =  wa_einv_data-data-docdtls-no                .
*          CONCATENATE wa_einv_data-data-docdtls-dt+0(2) wa_einv_data-data-docdtls-dt+3(2)
*                      wa_einv_data-data-docdtls-dt+6(4) INTO wa_einv_data-data-docdtls-dt.
          ls_suppl_einv-doc_date              =  wa_einv_data-data-docdtls-dt              .
          ls_suppl_einv-suppl_gstin           =  wa_einv_data-data-sellerdtls-gstin           .
          ls_suppl_einv-suppl_legal_name      =  wa_einv_data-data-sellerdtls-lglnm      .
          ls_suppl_einv-suppl_addr            =  wa_einv_data-data-sellerdtls-addr1            .
          ls_suppl_einv-suppl_loc             =  wa_einv_data-data-sellerdtls-loc             .
          ls_suppl_einv-suppl_pincode         =  wa_einv_data-data-sellerdtls-pin         .
          ls_suppl_einv-suppl_stcd            =  wa_einv_data-data-sellerdtls-stcd            .
          ls_suppl_einv-cust_gstin            =  wa_einv_data-data-buyerdtls-gstin            .
          ls_suppl_einv-cust_legal_name       =  wa_einv_data-data-buyerdtls-lglnm       .
          ls_suppl_einv-cust_pos              =  wa_einv_data-data-buyerdtls-pos              .
          ls_suppl_einv-cust_addr             =  wa_einv_data-data-buyerdtls-addr1             .
          ls_suppl_einv-cust_loc              =  wa_einv_data-data-buyerdtls-loc              .
          ls_suppl_einv-cust_pincode          =  wa_einv_data-data-buyerdtls-pin          .
          ls_suppl_einv-cust_stcd             =  wa_einv_data-data-buyerdtls-stcd             .
          ls_suppl_einv-assval                =  wa_einv_data-data-valdtls-assval                .
          ls_suppl_einv-cgstval               =  wa_einv_data-data-valdtls-cgstval               .
          ls_suppl_einv-sgstval               =  wa_einv_data-data-valdtls-sgstval               .
          ls_suppl_einv-igstval               =  wa_einv_data-data-valdtls-igstval               .
          ls_suppl_einv-cessval               =  wa_einv_data-data-valdtls-cesval               .
          ls_suppl_einv-discount              =  wa_einv_data-data-valdtls-discount              .
          ls_suppl_einv-other_chrg            =  wa_einv_data-data-valdtls-othchrg            .
          ls_suppl_einv-roundoff_val          =  wa_einv_data-data-valdtls-rndoffamt          .
          ls_suppl_einv-totinv_val            =  wa_einv_data-data-valdtls-totinvval            .

          ls_suppl_einv-item_itemno           =  <wa_einv_ITEM>-itemno           .
          ls_suppl_einv-item_isservc          =  <wa_einv_ITEM>-isservc          .
          ls_suppl_einv-item_proddesc         =  <wa_einv_ITEM>-prddesc         .
          ls_suppl_einv-item_hsn_code         =  <wa_einv_ITEM>-hsncd         .
          ls_suppl_einv-item_unit             =  <wa_einv_ITEM>-unit             .
          ls_suppl_einv-item_qty              =  <wa_einv_ITEM>-qty              .
          ls_suppl_einv-item_free_qty         =  <wa_einv_ITEM>-freeqty         .
          ls_suppl_einv-item_unitprice        =  <wa_einv_ITEM>-unitprice        .
          ls_suppl_einv-item_tot_amt          =  <wa_einv_ITEM>-totamt          .
          ls_suppl_einv-item_discount         =  <wa_einv_ITEM>-discount         .
          ls_suppl_einv-item_assamt           =  <wa_einv_ITEM>-assamt           .
          ls_suppl_einv-item_gst_rate         =  <wa_einv_ITEM>-gstrt         .
          ls_suppl_einv-item_igst_amt         =  <wa_einv_ITEM>-igstamt         .
          ls_suppl_einv-item_cgst_amt         =  <wa_einv_ITEM>-cgstamt         .
          ls_suppl_einv-item_sgst_amt         =  <wa_einv_ITEM>-sgstamt         .
          ls_suppl_einv-item_cess_rate        =  <wa_einv_ITEM>-cesrt        .
          ls_suppl_einv-item_cess_amt         =  <wa_einv_ITEM>-cesamt         .
          ls_suppl_einv-item_cess_non_advl_amt = <wa_einv_ITEM>-cesnonadvlamt.
          ls_suppl_einv-item_tot_item_val     =  <wa_einv_ITEM>-totitemval     .

*          APPEND ls_suppl_einv TO it_suppl_einv.

          MODIFY zvendor_einv_tab FROM @ls_suppl_einv.
*          TABLE @it_suppl_einv.
      IF sy-subrc IS INITIAL.
      ELSE.
        MODIFY zvendor_einv_tab FROM TABLE @it_suppl_einv.
      ENDIF.

      CLEAR : it_suppl_einv.
      CLEAR : client, req, lv_response, stat, ls_output,ls_output1.

        ENDLOOP.

        CLEAR : ls_suppl_einv, <wa_einv_ITEM>.
      ENDLOOP.

*      MODIFY zvendor_einv_tab FROM TABLE @it_suppl_einv.
*      IF sy-subrc IS INITIAL.
*      ELSE.
*        MODIFY zvendor_einv_tab FROM TABLE @it_suppl_einv.
*      ENDIF.
*
*      CLEAR : it_suppl_einv.
*      CLEAR : client, req, lv_response, stat, ls_output,ls_output1.

    ENDIF.

  ENDMETHOD.


ENDCLASS.

CLASS lsc_ZVENDOR_EINVOICE_GET DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZVENDOR_EINVOICE_GET IMPLEMENTATION.

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
