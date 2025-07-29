CLASS lhc_ZI_GST_ITC_RECO DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    INTERFACES : if_oo_adt_classrun.

    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR zi_gst_itc_reco RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gst_itc_reco RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_gst_itc_reco.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_gst_itc_reco.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_gst_itc_reco.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_gst_itc_reco RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_gst_itc_reco.

    METHODS reverse_response FOR MODIFY
      IMPORTING keys FOR ACTION zi_gst_itc_reco~reverse_response RESULT result.
    METHODS delete_reco_response FOR MODIFY
      IMPORTING keys FOR ACTION zi_gst_itc_reco~delete_reco_response RESULT result.

ENDCLASS.

CLASS lhc_ZI_GST_ITC_RECO IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

  METHOD get_global_features.
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

  METHOD create_client.

    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.

  METHOD reverse_response.

    TYPES:BEGIN OF ty_message,
            message TYPE bapi_msg,
          END OF ty_message.

    TYPES : BEGIN OF ty_sapdata,
              inum                    TYPE string,
              nt_dt                   TYPE string,
              nt_num                  TYPE string,
              ntty                    TYPE string,
              pos                     TYPE string,
              rchrg                   TYPE string,
              org_inum                TYPE string,
              org_idt                 TYPE string,
              supplier_gstin          TYPE string,
              buyer_gstin             TYPE string,
              erp_document_number(10),
              erp_document_date(10),
              invoice_type(10),
              net_amount(15),
              val                     TYPE string,
              idt                     TYPE zgstr2_reco_st-idt,
              gstr2_return_period(20),
              location(6),
              total_igst              TYPE string,
              total_cgst              TYPE string,
              total_sgst              TYPE string,
              total_cess              TYPE string,
              itc_elg(2),
              supplier_name(20),
              mismatch_reason(100),
              gl_code                 TYPE zgstr2_reco_st-pr_gl_code,
              f_year(7),
              imonth(2),
              ttxval(13),
            END OF ty_sapdata.

    TYPES : BEGIN OF ty_rsdata,
              val                       TYPE string,
              inv_typ(10),
              pos(2),
              idt                       TYPE zgstr2_reco_st-idt,
              rchrg(1),
              inum(20),
              nt_num(16),
              nt_dt                     TYPE zgstr2_reco_st-idt,
              f_year(7),
              imonth(2),
              supplier_gstin(18),
              supplier_name(20),
              supplier_gstin_status(10),
              supplier_return_type(10),
              contact_name(20),
              buyer_gstin(18),
              cfs(1),
              invoice_type(10),
              gstr1_filling_date(10),
              ttxval(13),
              net_amount(15),
              auto_reco_id(40),
              match_status(10),
              location(6),
              pr_data                   TYPE ty_sapdata,
              erp_document_number(10),
              erp_document_date(10),
              itc_elg(2),
              total_igst                TYPE string,
              total_cgst                TYPE string,
              total_sgst                TYPE string,
              total_cess                TYPE string,
              transaction_number(10),
              reco_action(50),
              action_date(10),
              referred_invoice_num(20),
              referred_invoice_date(10),
              mismatch_reason(100),
              gstr2_return_period(20),
              gstr3b_filling_status(20),
              gl_code                   TYPE zgstr2_reco_st-pr_gl_code,
              org_inum                  TYPE string,
              org_idt                   TYPE string,
              ntty                      TYPE string,
              reten_post                TYPE zgstr2_reco_st-reten_post,
              reten_post_doc            TYPE zgstr2_reco_st-reten_post_doc,
            END OF ty_rsdata.

    DATA: tt_rsdata    TYPE TABLE OF ty_rsdata,
          tt_rsurl     TYPE TABLE OF string,
          lt_chunk_url TYPE TABLE OF string,
          ls_chunk_url TYPE string.

    TYPES:BEGIN OF ty_output,
            success TYPE string,
            status  TYPE string,
            message TYPE string,
          END OF ty_output,

          BEGIN OF ty_rsdata2,
            total_count   TYPE string,
            total_page    TYPE string,
            request_valid TYPE string,
            request_id    TYPE string,
            url           LIKE tt_rsurl,
          END OF ty_rsdata2,

          BEGIN OF ty_output1,
            success TYPE string,
            status  TYPE string,
            message TYPE ty_message,
            data    LIKE tt_rsdata,
          END OF ty_output1,

          BEGIN OF ty_output2,
            success TYPE string,
            status  TYPE string,
            message TYPE ty_message,
            data    TYPE ty_rsdata2,
          END OF ty_output2.

    DATA : reco_url    TYPE string,
           buyer_gstin TYPE string,
           reco_type   TYPE string,
           f_year      TYPE string,
           page_size   TYPE string,
           api_key     TYPE string,
           product_id  TYPE string,
           background  TYPE string.

    DATA(it_reco) = keys[].

    READ TABLE it_reco INTO DATA(wa_reco) INDEX 1.
    IF  sy-subrc = 0.
      DATA(ls_gstin) = wa_reco-%param-buyergstin.
      DATA(ls_fyear) = wa_reco-%param-Fiscalyear.
    ENDIF.

****comntd not required for popup
*    if sy-subrc = 0.
*       select single fiscalyear from zgstr2_reco_st
*                                where inum = @wa_reco-inum
*                                and idt = @wa_reco-idt
*                                and pr_inum = @wa_reco-PrInum
*                                and pr_idt = @wa_reco-PrIdt
*                                and supplier_gstin = @wa_reco-SupplierGstin
*                                and accountingdocument = @wa_reco-accountingdocument
*                                into @data(ls_fyear).
*    endif.
*
*    select gstin from zdb_org_gstin
*                 into table @data(lt_gstin).
*    if sy-subrc = 0.
*        sort lt_gstin by gstin.
*        delete adjacent duplicates from lt_gstin comparing gstin.
*    endif.

*    loop at lt_gstin into data(ls_gstin).
*comntd not required for popup

*start error handling**
    DATA : lv_error  TYPE ty_output,
           lv_text   TYPE string,
           ls_fail   LIKE LINE OF failed-zi_gst_itc_reco,
           ls_record LIKE LINE OF reported-zi_gst_itc_reco.

    DATA(lv_len) = strlen( ls_fyear ).

    IF ls_fyear IS INITIAL.
      DATA(lv_msg) = me->new_message_with_text(
                     severity = if_abap_behv_message=>severity-error
                     text     =  'Please Input Fiscal year' ).
      APPEND ls_fail TO failed-zi_gst_itc_reco.
      ls_record-%msg = lv_msg.
      APPEND ls_record TO reported-zi_gst_itc_reco.
      EXIT.

    ELSEIF ls_fyear+4(1) NE '-' OR lv_len > 7 .
      DATA(lv_msg1) = me->new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     =  'Fiscal year should be in format Example : 2024-25' ).
      APPEND ls_fail TO failed-zi_gst_itc_reco.
      ls_record-%msg = lv_msg1.
      APPEND ls_record TO reported-zi_gst_itc_reco.
      EXIT.
    ENDIF.
*End error handling**

    reco_url    = 'https://api-platform.mastersindia.co/api/v1/saas-apis/recoapi/?'.
    buyer_gstin =  ls_gstin.
    reco_type   = '2A-PR'.
    f_year      =  ls_fyear.
    api_key     = 'rLWN9u9WePRtGneWExwJvy2gwWPrCUTM'.
    product_id  = 'enterprises'.
    background  = '1'.
    DATA(sleep_time) = 5. " Time in seconds

    CONCATENATE reco_url  'buyer_gstin=' buyer_gstin '&' 'reco_type=' reco_type '&' 'f_year=' f_year
                          '&' 'background=' background INTO reco_url.
    CONDENSE reco_url NO-GAPS.

    TRY.
        DATA(client) = create_client( reco_url ).
      CATCH cx_static_check.
    ENDTRY.
    DATA(req) = client->get_http_request(  ).

    req->set_header_fields(  VALUE #(
   ( name = 'Productid'  value = product_id  )
   ( name = 'Gstin'      value = buyer_gstin )
   ( name = 'MiplApiKey' value = api_key     ) ) ).

    TRY.
        DATA(lv_response) = client->execute(
                        i_method  = if_web_http_client=>get ).
        DATA(json_response) = lv_response->get_text( ).
        DATA(stat) = lv_response->get_status(  ).
        client->close( ).
      CATCH: cx_web_http_client_error.
    ENDTRY.

    DATA:ls_output  TYPE ty_output,
         ls_output1 TYPE ty_output1,
         ls_output2 TYPE ty_output2.
*        lt_reco_data1 TYPE ty_rsdata.

*** Start Error Handling *****
    /ui2/cl_json=>deserialize(
      EXPORTING
      json  = json_response
     CHANGING
      data = lv_error ).

    IF lv_error-success = '' AND ( lv_error-status = '' OR lv_error-status = '0' )
      AND  lv_error-message IS NOT INITIAL.

      CONCATENATE : 'Reco Data :' lv_error-message INTO lv_text.
      DATA(lv_message) = me->new_message_with_text(
                        severity = if_abap_behv_message=>severity-error
                        text     =  lv_text ).
      APPEND ls_fail TO failed-zi_gst_itc_reco.
      ls_record-%msg = lv_message.
      APPEND ls_record TO reported-zi_gst_itc_reco.
      EXIT.
    ENDIF.
*** End Error Handling *****

    DATA : ls_bseg TYPE i_operationalacctgdocitem.

    /ui2/cl_json=>deserialize(
    EXPORTING
    json = json_response
    CHANGING
    data = ls_output ).

    IF ls_output-success = 'X' AND ls_output-status = '1'
    AND ( ls_output-message = 'Data found' OR ls_output-message = 'data found' ).
      /ui2/cl_json=>deserialize(
  EXPORTING
  json = json_response
  CHANGING
  data = ls_output1 ).

      DATA : it_gstr2 TYPE TABLE OF zgstr2_reco_st,
             ls_gstr2 TYPE zgstr2_reco_st.
*      data reco_data1 TYPE TABLE of ty_output1."-data..
      DATA(reco_data1) = ls_output1-data.

      SELECT

      inum, idt, pr_inum, pr_idt, supplier_gstin, accountingdocument
      FROM zgstr2_reco_st
      FOR ALL ENTRIES IN @reco_data1
      WHERE inum = @reco_data1-inum  INTO TABLE @DATA(lt_gstr2).


      LOOP AT reco_data1 INTO DATA(ls_reco).

**Only 2A Data
        IF ls_reco-erp_document_number IS INITIAL AND ls_reco-pr_data IS INITIAL.
          READ TABLE lt_gstr2 INTO DATA(ls_gstr2_2a) WITH KEY inum = ls_reco-inum.
          IF sy-subrc = 0.
            ls_gstr2-inum  = ls_gstr2_2a-inum.
          ELSE.
            ls_gstr2-inum  = ls_reco-inum.
          ENDIF.
          ls_gstr2-idt                   = ls_reco-idt.
          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
          ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
          ls_gstr2-val                   = ls_reco-val.
          ls_gstr2-nt_num                = ls_reco-nt_num.
          ls_gstr2-nt_dt                 = ls_reco-nt_dt.
          ls_gstr2-inv_typ               = ls_reco-inv_typ.
          ls_gstr2-pos                   = ls_reco-pos.
          ls_gstr2-rchrg                 = ls_reco-rchrg.
          ls_gstr2-imonth                = ls_reco-imonth.
          ls_gstr2-supplier_name         = ls_reco-supplier_name.
          ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
          ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
          ls_gstr2-contact_name          = ls_reco-contact_name.
          ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
          ls_gstr2-cfs                   = ls_reco-cfs.
          ls_gstr2-invoice_type          = ls_reco-invoice_type.
          ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
          ls_gstr2-ttxval                = ls_reco-ttxval.
          ls_gstr2-net_amount            = ls_reco-net_amount.
          ls_gstr2-itc_alg               = ls_reco-itc_elg.
          ls_gstr2-transaction_number    = ls_reco-transaction_number.
          ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
          ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
          ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
          ls_gstr2-total_igst            = ls_reco-total_igst.
          ls_gstr2-total_cgst            = ls_reco-total_cgst.
          ls_gstr2-total_sgst            = ls_reco-total_sgst.
          ls_gstr2-total_cess            = ls_reco-total_cess.
          ls_gstr2-fiscalyear            = ls_reco-f_year.
          ls_gstr2-status                = ls_reco-match_status.
          ls_gstr2-reco_action           = ls_reco-reco_action.
          ls_gstr2-action_date           = ls_reco-action_date.
          ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
          ls_gstr2-reason                = ls_reco-mismatch_reason.
*          IF ls_gstr2_2a-
*          ls_gstr2-reten_post            = ls_reco-reten_post.
*          ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.

**Only PR Data
        ELSEIF ls_reco-erp_document_number IS NOT INITIAL AND ls_reco-pr_data IS INITIAL.
          READ TABLE lt_gstr2 INTO DATA(ls_gstr2_pr) WITH KEY pr_inum = ls_reco-pr_data-inum.
          IF sy-subrc = 0.
            ls_gstr2-inum  = ls_gstr2_pr-pr_inum.
          ELSE.
            ls_gstr2-inum  = ls_reco-inum.
          ENDIF.
          ls_gstr2-idt                   = ls_reco-idt.
          ls_gstr2-pr_inum               = ls_reco-inum.
          ls_gstr2-pr_idt                = ls_reco-idt.
          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
          ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
          ls_gstr2-pr_supplier_name      = ls_reco-supplier_name.
          ls_gstr2-pr_buyer_gstin        = ls_reco-buyer_gstin.
          ls_gstr2-pr_gl_code            = ls_reco-gl_code.
          ls_gstr2-pr_supplier_gstin     = ls_reco-supplier_gstin.
          ls_gstr2-pr_invoice_type       = ls_reco-invoice_type.
          ls_gstr2-pr_net_amount         = ls_reco-net_amount.
          ls_gstr2-pr_val                = ls_reco-val.
          ls_gstr2-pr_nt_num             = ls_reco-nt_num.
          ls_gstr2-pr_nt_dt              = ls_reco-nt_dt.
          ls_gstr2-pr_ntty               = ls_reco-ntty.
          ls_gstr2-pr_location           = ls_reco-location.
          ls_gstr2-pr_total_igst         = ls_reco-total_igst.
          ls_gstr2-pr_total_cgst         = ls_reco-total_cgst.
          ls_gstr2-pr_total_sgst         = ls_reco-total_sgst.
          ls_gstr2-pr_total_cess         = ls_reco-total_cess.
          ls_gstr2-fiscalyear            = ls_reco-f_year.
          ls_gstr2-status                = ls_reco-match_status.
          ls_gstr2-reco_action           = ls_reco-reco_action.
          ls_gstr2-action_date           = ls_reco-action_date.
          ls_gstr2-reason                = ls_reco-mismatch_reason.
          ls_gstr2-pr_org_inum           = ls_reco-org_inum.
          ls_gstr2-pr_org_idt            = ls_reco-org_idt.
          ls_gstr2-pr_itc_alg            = ls_reco-itc_elg.
          ls_gstr2-pr_gstr2_return_period  = ls_reco-gstr2_return_period.
          ls_gstr2-pr_erp_document_number  = ls_reco-erp_document_number.
          ls_gstr2-pr_erp_document_date  = ls_reco-erp_document_date.
          ls_gstr2-pr_fiscalyear         = ls_reco-f_year.
          ls_gstr2-pr_imonth             = ls_reco-imonth.
          ls_gstr2-pr_pos                = ls_reco-pos.
          ls_gstr2-pr_rchrg              = ls_reco-rchrg.
          ls_gstr2-pr_ttxval             = ls_reco-ttxval.
*          ls_gstr2-reten_post            = ls_reco-reten_post.
*          ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.
**Both 2A & PR Data
        ELSEIF ls_reco-pr_data IS NOT INITIAL.
          READ TABLE lt_gstr2 INTO DATA(ls_gstr2_b) WITH KEY pr_inum = ls_reco-inum.
          IF sy-subrc = 0.
            ls_gstr2-inum  = ls_gstr2_b-inum.
          ELSE.
            ls_gstr2-inum  = ls_reco-inum.
          ENDIF.
          ls_gstr2-idt                   = ls_reco-idt.
          ls_gstr2-pr_inum               = ls_reco-pr_data-inum.
          ls_gstr2-pr_idt                = ls_reco-pr_data-idt.
          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
          ls_gstr2-val                   = ls_reco-val.
          ls_gstr2-nt_num                = ls_reco-nt_num.
          ls_gstr2-nt_dt                 = ls_reco-nt_dt.
          ls_gstr2-inv_typ               = ls_reco-inv_typ.
          ls_gstr2-pos                   = ls_reco-pos.
          ls_gstr2-rchrg                 = ls_reco-rchrg.
          ls_gstr2-imonth                = ls_reco-imonth.
          ls_gstr2-supplier_name         = ls_reco-supplier_name.
          ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
          ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
          ls_gstr2-contact_name          = ls_reco-contact_name.
          ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
          ls_gstr2-cfs                   = ls_reco-cfs.
          ls_gstr2-invoice_type          = ls_reco-invoice_type.
          ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
          ls_gstr2-ttxval                = ls_reco-ttxval.
          ls_gstr2-net_amount            = ls_reco-net_amount.
          ls_gstr2-itc_alg               = ls_reco-itc_elg.
          ls_gstr2-transaction_number    = ls_reco-transaction_number.
          ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
          ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
          ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
          ls_gstr2-total_igst            = ls_reco-total_igst.
          ls_gstr2-total_cgst            = ls_reco-total_cgst.
          ls_gstr2-total_sgst            = ls_reco-total_sgst.
          ls_gstr2-total_cess            = ls_reco-total_cess.
          ls_gstr2-fiscalyear            = ls_reco-f_year.
          ls_gstr2-status                = ls_reco-match_status.
          ls_gstr2-reco_action           = ls_reco-reco_action.
          ls_gstr2-action_date           = ls_reco-action_date.
          ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
          ls_gstr2-reason                = ls_reco-mismatch_reason.
          ls_gstr2-pr_buyer_gstin        = ls_reco-pr_data-buyer_gstin.
          ls_gstr2-pr_supplier_gstin     = ls_reco-pr_data-supplier_gstin.
          ls_gstr2-pr_invoice_type       = ls_reco-pr_data-invoice_type.
          ls_gstr2-pr_net_amount         = ls_reco-pr_data-net_amount.
          ls_gstr2-pr_val                = ls_reco-pr_data-val.
          ls_gstr2-pr_nt_num             = ls_reco-pr_data-nt_num.
          ls_gstr2-pr_nt_dt              = ls_reco-pr_data-nt_dt.
          ls_gstr2-pr_ntty               = ls_reco-pr_data-ntty.
          ls_gstr2-pr_location           = ls_reco-pr_data-location.
          ls_gstr2-pr_total_igst         = ls_reco-pr_data-total_igst.
          ls_gstr2-pr_total_cgst         = ls_reco-pr_data-total_cgst.
          ls_gstr2-pr_total_sgst         = ls_reco-pr_data-total_sgst.
          ls_gstr2-pr_total_cess         = ls_reco-pr_data-total_cess.
          ls_gstr2-pr_rchrg              = ls_reco-pr_data-rchrg.
          ls_gstr2-pr_org_inum           = ls_reco-pr_data-org_inum.
          ls_gstr2-pr_org_idt            = ls_reco-pr_data-org_idt.
          ls_gstr2-pr_itc_alg            = ls_reco-pr_data-itc_elg.
          ls_gstr2-pr_gstr2_return_period  = ls_reco-pr_data-gstr2_return_period.
          ls_gstr2-pr_erp_document_number  = ls_reco-pr_data-erp_document_number.
          ls_gstr2-pr_erp_document_date  = ls_reco-pr_data-erp_document_date.
          ls_gstr2-pr_pos                = ls_reco-pr_data-pos.
*          ls_gstr2-reten_post            = ls_reco-reten_post.
*          ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.

        ENDIF.

        MODIFY zgstr2_reco_st FROM @ls_gstr2.

        CLEAR : ls_gstr2,ls_reco.
      ENDLOOP.


    ELSEIF ls_output-status = '2' AND ( ls_output-message = 'Data found' OR ls_output-message = 'data found' ).
      CLEAR : client,req,lv_response,stat,ls_output,ls_output1,reco_data1,ls_reco,ls_gstr2, ls_gstr2_2a, ls_gstr2_pr, ls_gstr2_b.
      CLEAR : lt_gstr2, it_gstr2.

      /ui2/cl_json=>deserialize(
 EXPORTING
 json = json_response
 CHANGING
 data = ls_output2 ).
      " ENDIF.

      lt_chunk_url = ls_output2-data-url.

      LOOP AT lt_chunk_url INTO ls_chunk_url.

        TRY.
            client = create_client( ls_chunk_url ).
            client->close( ).
          CATCH cx_static_check.
        ENDTRY.
        req = client->get_http_request(  ).

        req->set_header_fields(  VALUE #(
       ( name = 'GSTIN'      value = buyer_gstin )
       ( name = 'MiplApiKey' value = api_key ) ) ).

        TRY.
            DATA(lv_response1)   = client->execute( i_method  = if_web_http_client=>get ).
            DATA(json_response1) = lv_response1->get_text( ).
            DATA(stat1)          = lv_response1->get_status(  ).
            client->close(  ).
          CATCH: cx_web_http_client_error.
        ENDTRY.

        /ui2/cl_json=>deserialize(
    EXPORTING
    json = json_response1
    CHANGING
    data = ls_output1 ).

*** Start Error Handling *****
        CLEAR : lv_error.
        /ui2/cl_json=>deserialize(
        EXPORTING
        json = json_response1
        CHANGING
        data = lv_error ).

        IF lv_error-success = '' AND ( lv_error-status = '' OR lv_error-status = '0' OR
                                       lv_error-status = '2' ) AND  lv_error-message IS NOT INITIAL.

          CONCATENATE : 'Chunk Data :' lv_error-message INTO lv_text.
          DATA(lv_message1) = me->new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     =  lv_text ).
          APPEND ls_fail TO failed-zi_gst_itc_reco.
          ls_record-%msg = lv_message1.
          APPEND ls_record TO reported-zi_gst_itc_reco.
          EXIT.
        ENDIF.
*** End Error Handling *****

        CLEAR reco_data1.
        reco_data1 = ls_output1-data.
        SORT reco_data1 BY inum ASCENDING.

        SELECT * from zgstr2_reco_st "FOR ALL ENTRIES IN @reco_data1
        WHERE reten_post_doc is not initial "pr_erp_document_number = @reco_data1-erp_document_number
        INTO TABLE @DATA(it_overriding).

        LOOP AT reco_data1 INTO ls_reco.
**Only 2A Data
          IF ls_reco-erp_document_number IS INITIAL AND ls_reco-pr_data IS INITIAL.
          READ TABLE it_overriding INTO DATA(wa_overriding) WITH KEY pr_erp_document_number = ls_reco-erp_document_number.
            ls_gstr2-inum                  = ls_reco-inum.
            ls_gstr2-idt                   = ls_reco-idt.
            ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
            ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
            ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
            ls_gstr2-val                   = ls_reco-val.
            ls_gstr2-nt_num                = ls_reco-nt_num.
            ls_gstr2-nt_dt                 = ls_reco-nt_dt.
            ls_gstr2-inv_typ               = ls_reco-inv_typ.
            ls_gstr2-pos                   = ls_reco-pos.
            ls_gstr2-rchrg                 = ls_reco-rchrg.
            ls_gstr2-imonth                = ls_reco-imonth.
            ls_gstr2-supplier_name         = ls_reco-supplier_name.
            ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
            ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
            ls_gstr2-contact_name          = ls_reco-contact_name.
            ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
            ls_gstr2-cfs                   = ls_reco-cfs.
            ls_gstr2-invoice_type          = ls_reco-invoice_type.
            ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
            ls_gstr2-ttxval                = ls_reco-ttxval.
            ls_gstr2-net_amount            = ls_reco-net_amount.
            ls_gstr2-itc_alg               = ls_reco-itc_elg.
            ls_gstr2-transaction_number    = ls_reco-transaction_number.
            ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
            ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
            ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
            ls_gstr2-total_igst            = ls_reco-total_igst.
            ls_gstr2-total_cgst            = ls_reco-total_cgst.
            ls_gstr2-total_sgst            = ls_reco-total_sgst.
            ls_gstr2-total_cess            = ls_reco-total_cess.
            ls_gstr2-fiscalyear            = ls_reco-f_year.
            ls_gstr2-status                = ls_reco-match_status.
            ls_gstr2-reco_action           = ls_reco-reco_action.
            ls_gstr2-action_date           = ls_reco-action_date.
            ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
            ls_gstr2-reason                = ls_reco-mismatch_reason.
*            ls_gstr2-reten_post            = ls_reco-reten_post.
*            ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.
            ls_gstr2-reten_post = wa_overriding-reten_post.
            ls_gstr2-reten_post_doc = wa_overriding-reten_post_doc.
            ls_gstr2-ret_flag = wa_overriding-ret_flag.

**Only PR Data
          ELSEIF ls_reco-erp_document_number IS NOT INITIAL AND ls_reco-pr_data IS INITIAL.
          READ TABLE it_overriding INTO wa_overriding WITH KEY pr_erp_document_number = ls_reco-erp_document_number.
*          ls_gstr2-inum                  = ls_reco-inum.
*          ls_gstr2-idt                   = ls_reco-idt.
            ls_gstr2-pr_inum               = ls_reco-inum.
            ls_gstr2-pr_idt                = ls_reco-idt.
            ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
            ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
            ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
            ls_gstr2-pr_supplier_name      = ls_reco-supplier_name.
            ls_gstr2-pr_buyer_gstin        = ls_reco-buyer_gstin.
            ls_gstr2-pr_gl_code            = ls_reco-gl_code.
            ls_gstr2-pr_supplier_gstin     = ls_reco-supplier_gstin.
            ls_gstr2-pr_invoice_type       = ls_reco-invoice_type.
            ls_gstr2-pr_net_amount         = ls_reco-net_amount.
            ls_gstr2-pr_val                = ls_reco-val.
            ls_gstr2-pr_nt_num             = ls_reco-nt_num.
            ls_gstr2-pr_nt_dt              = ls_reco-nt_dt.
            ls_gstr2-pr_ntty               = ls_reco-ntty.
            ls_gstr2-pr_location           = ls_reco-location.
            ls_gstr2-pr_total_igst         = ls_reco-total_igst.
            ls_gstr2-pr_total_cgst         = ls_reco-total_cgst.
            ls_gstr2-pr_total_sgst         = ls_reco-total_sgst.
            ls_gstr2-pr_total_cess         = ls_reco-total_cess.
            ls_gstr2-fiscalyear            = ls_reco-f_year.
            ls_gstr2-status                = ls_reco-match_status.
            ls_gstr2-reco_action           = ls_reco-reco_action.
            ls_gstr2-action_date           = ls_reco-action_date.
            ls_gstr2-reason                = ls_reco-mismatch_reason.
            ls_gstr2-pr_org_inum           = ls_reco-org_inum.
            ls_gstr2-pr_org_idt            = ls_reco-org_idt.
            ls_gstr2-pr_itc_alg            = ls_reco-itc_elg.
            ls_gstr2-pr_gstr2_return_period  = ls_reco-gstr2_return_period.
            ls_gstr2-pr_erp_document_number  = ls_reco-erp_document_number.
            ls_gstr2-pr_erp_document_date  = ls_reco-erp_document_date.
            ls_gstr2-pr_fiscalyear         = ls_reco-f_year.
            ls_gstr2-pr_imonth             = ls_reco-imonth.
            ls_gstr2-pr_pos                = ls_reco-pos.
            ls_gstr2-pr_rchrg              = ls_reco-rchrg.
            ls_gstr2-pr_ttxval             = ls_reco-ttxval.
*            ls_gstr2-reten_post            = ls_reco-reten_post.
*            ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.
            ls_gstr2-reten_post = wa_overriding-reten_post.
            ls_gstr2-reten_post_doc = wa_overriding-reten_post_doc.
            ls_gstr2-ret_flag = wa_overriding-ret_flag.
**Both 2A & PR Data
          ELSEIF ls_reco-pr_data IS NOT INITIAL.
          READ TABLE it_overriding INTO wa_overriding WITH KEY pr_erp_document_number = ls_reco-erp_document_number.
            ls_gstr2-inum                  = ls_reco-inum.
            ls_gstr2-idt                   = ls_reco-idt.
            ls_gstr2-pr_inum               = ls_reco-pr_data-inum.
            ls_gstr2-pr_idt                = ls_reco-pr_data-idt.
            ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
            ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
            ls_gstr2-val                   = ls_reco-val.
            ls_gstr2-nt_num                = ls_reco-nt_num.
            ls_gstr2-nt_dt                 = ls_reco-nt_dt.
            ls_gstr2-inv_typ               = ls_reco-inv_typ.
            ls_gstr2-pos                   = ls_reco-pos.
            ls_gstr2-rchrg                 = ls_reco-rchrg.
            ls_gstr2-imonth                = ls_reco-imonth.
            ls_gstr2-supplier_name         = ls_reco-supplier_name.
            ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
            ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
            ls_gstr2-contact_name          = ls_reco-contact_name.
            ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
            ls_gstr2-cfs                   = ls_reco-cfs.
            ls_gstr2-invoice_type          = ls_reco-invoice_type.
            ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
            ls_gstr2-ttxval                = ls_reco-ttxval.
            ls_gstr2-net_amount            = ls_reco-net_amount.
            ls_gstr2-itc_alg               = ls_reco-itc_elg.
            ls_gstr2-transaction_number    = ls_reco-transaction_number.
            ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
            ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
            ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
            ls_gstr2-total_igst            = ls_reco-total_igst.
            ls_gstr2-total_cgst            = ls_reco-total_cgst.
            ls_gstr2-total_sgst            = ls_reco-total_sgst.
            ls_gstr2-total_cess            = ls_reco-total_cess.
            ls_gstr2-fiscalyear            = ls_reco-f_year.
            ls_gstr2-status                = ls_reco-match_status.
            ls_gstr2-reco_action           = ls_reco-reco_action.
            ls_gstr2-action_date           = ls_reco-action_date.
            ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
            ls_gstr2-reason                = ls_reco-mismatch_reason.
            ls_gstr2-pr_buyer_gstin        = ls_reco-pr_data-buyer_gstin.
            ls_gstr2-pr_supplier_gstin     = ls_reco-pr_data-supplier_gstin.
            ls_gstr2-pr_invoice_type       = ls_reco-pr_data-invoice_type.
            ls_gstr2-pr_net_amount         = ls_reco-pr_data-net_amount.
            ls_gstr2-pr_val                = ls_reco-pr_data-val.
            ls_gstr2-pr_nt_num             = ls_reco-pr_data-nt_num.
            ls_gstr2-pr_nt_dt              = ls_reco-pr_data-nt_dt.
            ls_gstr2-pr_ntty               = ls_reco-pr_data-ntty.
            ls_gstr2-pr_location           = ls_reco-pr_data-location.
            ls_gstr2-pr_total_igst         = ls_reco-pr_data-total_igst.
            ls_gstr2-pr_total_cgst         = ls_reco-pr_data-total_cgst.
            ls_gstr2-pr_total_sgst         = ls_reco-pr_data-total_sgst.
            ls_gstr2-pr_total_cess         = ls_reco-pr_data-total_cess.
            ls_gstr2-pr_rchrg              = ls_reco-pr_data-rchrg.
            ls_gstr2-pr_org_inum           = ls_reco-pr_data-org_inum.
            ls_gstr2-pr_org_idt            = ls_reco-pr_data-org_idt.
            ls_gstr2-pr_gstr2_return_period  = ls_reco-pr_data-gstr2_return_period.
            ls_gstr2-pr_erp_document_number  = ls_reco-pr_data-erp_document_number.
            ls_gstr2-pr_erp_document_date  = ls_reco-pr_data-erp_document_date.
            ls_gstr2-pr_pos                = ls_reco-pr_data-pos.
*            ls_gstr2-reten_post            = ls_reco-reten_post.
*            ls_gstr2-reten_post_doc        = ls_reco-reten_post_doc.
            ls_gstr2-reten_post = wa_overriding-reten_post.
            ls_gstr2-reten_post_doc = wa_overriding-reten_post_doc.
            ls_gstr2-ret_flag = wa_overriding-ret_flag.

          ENDIF.
          APPEND ls_gstr2 TO it_gstr2.
          CLEAR : ls_reco, lt_gstr2, ls_gstr2.
        ENDLOOP.

        MODIFY zgstr2_reco_st FROM TABLE @it_gstr2.
        CLEAR : it_gstr2.

        CLEAR : client, req, lv_response, lv_response1, stat, stat1, ls_output,ls_output1,ls_reco,ls_gstr2, ls_chunk_url.
        WAIT UP TO '5' SECONDS.
      ENDLOOP.
    ENDIF.

*    ENDLOOP. "comntd not required for popup

  ENDMETHOD.

  METHOD delete_reco_response.

  SELECT *
FROM ZGSTR2_RECO_ST
into table @DATA(it_delete).

LOOP AT it_delete INTO DATA(wa_delete).
DELETE ZGSTR2_RECO_ST FROM @WA_DELETE.
clear WA_DELETE.

ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_GST_ITC_RECO DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_GST_ITC_RECO IMPLEMENTATION.

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
