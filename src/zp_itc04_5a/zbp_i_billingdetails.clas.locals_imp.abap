CLASS lhc_ZI_BILLINGDETAILS DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_header,
              table_type     TYPE string,
              invoice_action TYPE string,
              business_gstin TYPE string,
              jw_gstin       TYPE string,
              jw_state       TYPE string,
              jw_type        TYPE string,
              src_chnum      TYPE string,
              src_chdt       TYPE string,
              o_chnum        TYPE string,
              ret_period     TYPE string,
              o_chdt         TYPE string,
            END OF ty_header,

            BEGIN OF ty_item,
              goods_type    TYPE string,
              desc          TYPE string,
              uqc           TYPE string,
              qty           TYPE string,
              tax_val       TYPE string,
              igst_rate     TYPE string,
              cgst_rate     TYPE string,
              sgst_rate     TYPE string,
              cess_rate     TYPE string,
              nature_of_job TYPE string,
              LW_uqc        TYPE string,
              LW_qty        TYPE string,
            END OF ty_item.

    DATA : ls_header TYPE ty_header,
           ls_item   TYPE ty_item,
           lv_json   TYPE string,
           lv_body   TYPE string,
           uom       TYPE string.

    DATA : it_response TYPE TABLE OF ztab_itc045a_res,
           wa_response TYPE ztab_itc045a_res.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_billingdetails RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_billingdetails RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_billingdetails.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_billingdetails.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_billingdetails.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_billingdetails RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_billingdetails.

    METHODS send_to_portal FOR MODIFY
      IMPORTING keys FOR ACTION zi_billingdetails~send_to_portal RESULT result.

ENDCLASS.

CLASS lhc_ZI_BILLINGDETAILS IMPLEMENTATION.

  METHOD get_instance_features.
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

  READ TABLE keys INTO DATA(wa_key) INDEX 1.
  SELECT  * FROM zi_billingdetails
  WHERE BillingDocument = @wa_key-BillingDocument
  INTO TABLE  @DATA(wa_bill).
  result = CORRESPONDING #( wa_bill ).

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD send_to_portal.
    DATA : lo_http_client TYPE REF TO if_web_http_client.
    CONSTANTS lv_url TYPE string VALUE 'https://api-platform.mastersindia.co/api/v2/saas-apis/itc04/import/'.
    CONSTANTS lv_miplapikey TYPE string VALUE 'rLWN9u9WePRtGneWExwJvy2gwWPrCUTM'.
    CONSTANTS lv_gst_value TYPE string VALUE '0'.
    CONSTANTS lv_gst_empty TYPE string VALUE ''.
    DATA lv_qua TYPE P DECIMALS 2.
    FIELD-SYMBOLS: <num>  TYPE P.

    DATA(it_keys) = keys.
    READ TABLE keys INTO DATA(wa_keys) INDEX 1.

*    SELECT * FROM I_BillingDocumentItem AS billitem
*    INNER JOIN I_BillingDocument AS billhead
*    ON billitem~BillingDocument = billhead~BillingDocument
*    WHERE billitem~BillingDocument = @wa_keys-billingdocument
*    INTO TABLE @DATA(it_billing).

*    READ ENTITIES OF zi_billingdetails IN LOCAL MODE
*    ENTITY zi_billingdetails
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(it_billdetails).

*    SELECT * FROM zi_billingdetails FOR ALL ENTRIES IN @it_billing
*    WHERE billingdocument = @it_billing-billhead INTO TABLE @DATA(wa_billing).

    SELECT SINGLE * FROM zi_billingdetails WHERE billingdocument = @wa_keys-billingdocument
    INTO @DATA(wa_billdetails).
*    ENDSELECT.

    SELECT * FROM zi_billingdetails WHERE billingdocument = @wa_keys-billingdocument INTO TABLE @DATA(it_billdetails).


*    LOOP AT it_billdetails INTO DATA(wa_billdetails).
"""""""""""""""""""""""""""""""""4
      ls_header-table_type = '4'.
      ls_header-invoice_action = 'Add'.
      DATA(lv_busi_gstin_code) = wa_billdetails-gstinnumber+0(2).
      ls_header-business_gstin = wa_billdetails-gstinnumber.
      ls_header-jw_gstin = wa_billdetails-customergstin.
      DATA(lv_jw_state) = wa_billdetails-customergstin+0(2).
      ls_header-jw_state = lv_jw_state.
      ls_header-jw_type = 'Non SEZ'.
      ls_header-src_chnum = wa_billdetails-chellannumber.
      CONCATENATE wa_billdetails-billindocumentdate+6(2) '-'
                  wa_billdetails-billindocumentdate+4(2) '-'
                  wa_billdetails-billindocumentdate+0(4)
                  INTO ls_header-src_chdt.

      DATA(lv_date) = ls_header-src_chdt+3(2).
      if ( lv_date eq '04' or lv_date eq '05' or lv_date eq '06' or lv_date eq '07' or lv_date eq '08' or lv_date eq '09' ).
      DATA(lv_year) = ls_header-src_chdt+6(4).
      CONCATENATE '17' lv_year INTO DATA(lv_ret_period).
      ELSEIF ( lv_date eq '10' or lv_date eq '11' or lv_date eq '12' or lv_date eq '01' or lv_date eq '02' or lv_date eq '03' ).
      lv_year = ls_header-src_chdt+6(4).
      CONCATENATE '18' lv_year INTO lv_ret_period.
      ENDIF.

      ls_header-o_chnum = ''.
      ls_header-ret_period = lv_ret_period.
      ls_header-o_chdt = ''.

      CLEAR lv_json.
      lv_json = /ui2/cl_json=>serialize( data = ls_header
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
      CONCATENATE '{ "ChallansData":' ' [ ' lv_json INTO lv_body.
      REPLACE '}' IN lv_body WITH ','.

      ls_item-goods_type = 'Inputs'.
      REPLACE ALL OCCURRENCES OF REGEX `[^a-zA-Z0-9 ]` IN wa_billdetails-billingdocumentitemtext WITH SPACE.
      ls_item-desc = wa_billdetails-billingdocumentitemtext.

      CASE wa_billdetails-billingquantityunit.
          WHEN 'KG'.
            uom = 'KGS'.
          WHEN 'NO'.
            uom = 'NOS'.
          WHEN 'MT'.
            uom = 'MTS'.
          WHEN 'L'.
            uom = 'LTR'.
          WHEN 'TO'.
            uom = 'TON'.
          WHEN 'EA'.
            uom = 'NOS'.
          WHEN 'KM'.
            uom = 'KME'.
          WHEN 'DR'.
            uom = 'DRM'.
          WHEN 'ML'.
            uom = 'MLT'.
          WHEN 'M3'.
            uom = 'CBM'.
          WHEN 'M2'.
            uom = 'SQM'.
          WHEN 'G'.
            uom = 'GMS'.
          WHEN 'FT2'.
            uom = 'SQF'.
          WHEN 'DZ'.
            uom = 'DOZ'.
          WHEN 'BOX'.
            uom = 'BOX'.
          WHEN 'BT'.
            uom = 'BTL'.
          WHEN 'BAG'.
            uom = 'BAG'.
          WHEN 'PAA'.
            uom = 'PRS'.
          WHEN 'PAC'.
            uom = 'PAC'.
          WHEN 'ROL'.
            uom = 'ROL'.
          WHEN 'SET'.
            uom = 'SET'.
          WHEN OTHERS.
            uom = 'OTH'.
        ENDCASE.

      ls_item-uqc = uom."unit of meassure
      ls_item-qty = lv_qua = wa_billdetails-billingitemquantity."quantity
      ls_item-tax_val = wa_billdetails-billingitemnetamount."net amount

      if lv_busi_gstin_code = lv_jw_state.
      ls_item-cgst_rate = lv_gst_value.
      ls_item-sgst_rate = lv_gst_value.
      ls_item-igst_rate = lv_gst_empty.
      ELSE.
      ls_item-cgst_rate = lv_gst_empty.
      ls_item-sgst_rate = lv_gst_empty.
      ls_item-igst_rate = lv_gst_value.
      endif.

      ls_item-cess_rate = '0'.
      ls_item-nature_of_job = wa_billdetails-billingdocumentitemtext..
      ls_item-lw_uqc = ''.
      ls_item-lw_qty = ''.

      CLEAR lv_json.
      lv_json = /ui2/cl_json=>serialize( data = ls_item
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
      CONCATENATE lv_body '"itemList":' ' [' lv_json '] },' INTO lv_body.
*      if lv_busi_gstin_code = lv_jw_state.
*      REPLACE '"cgst_rate":"0"' in lv_body WITH '"cgst_rate":0'.
*      REPLACE '"sgst_rate":"0"' in lv_body WITH '"sgst_rate":0'.
*      REPLACE '"igst_rate":""' in lv_body WITH '"igst_rate":""'.
*      else.
*      REPLACE '"cgst_rate":""' in lv_body WITH '"cgst_rate":""'.
*      REPLACE '"sgst_rate":""' in lv_body WITH '"sgst_rate":""'.
*      REPLACE '"igst_rate":"0"' in lv_body WITH '"igst_rate":0'.
*      endif.
*      FIND '"lw_qty":"",},' IN lv_body.
*      DATA(lv_text) = '"lw_qty":"",},'.
*      REPLACE FIRST OCCURRENCE OF '"lw_qty":"",},' IN lv_body WITH '"lw_qty":""},'.

      " '] } ] } ' INTO lv_body.

""""""""""""""""""""""""""5A
      ls_header-table_type = '5a'.
      ls_header-invoice_action = 'Add'.
      ls_header-business_gstin = wa_billdetails-gstinnumber.
      ls_header-jw_gstin = wa_billdetails-customergstin.
      ls_header-jw_state = lv_jw_state.
      ls_header-jw_type = 'Non SEZ'.
      ls_header-src_chnum = wa_billdetails-chellannumber.
      ls_header-src_chdt = ls_header-src_chdt.
      ls_header-o_chnum = ''.
      ls_header-ret_period = lv_ret_period.
      ls_header-o_chdt = ''.

      CLEAR lv_json.
      lv_json = /ui2/cl_json=>serialize( data = ls_header
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
      CONCATENATE lv_body lv_json INTO lv_body.
      REPLACE '"o_chdt":""}' in lv_body WITH '"o_chdt":"",'.
*      REPLACE '}' IN lv_body WITH ','.

      ls_item-goods_type = 'Inputs'.
      ls_item-desc = wa_billdetails-billingdocumentitemtext.
      ls_item-uqc = uom."unit of meassure
      ls_item-qty = lv_qua = wa_billdetails-billingitemquantity."quantity
      ls_item-tax_val = wa_billdetails-billingitemnetamount."net amount
      if lv_busi_gstin_code = lv_jw_state.
      ls_item-cgst_rate = lv_gst_value.
      ls_item-sgst_rate = lv_gst_value.
      ls_item-igst_rate = lv_gst_empty.
      ELSE.
      ls_item-cgst_rate = lv_gst_empty.
      ls_item-sgst_rate = lv_gst_empty.
      ls_item-igst_rate = lv_gst_value.
      endif.
      ls_item-cess_rate = '0'.
      ls_item-nature_of_job = wa_billdetails-billingdocumentitemtext..
      ls_item-lw_uqc = ''.
      ls_item-lw_qty = ''.

      CLEAR lv_json.
      lv_json = /ui2/cl_json=>serialize( data = ls_item
                                         pretty_name = /ui2/cl_json=>pretty_mode-low_case ).
      CONCATENATE lv_body '"itemList":' ' [' lv_json '] } ] } ' INTO lv_body.
      if lv_busi_gstin_code = lv_jw_state.
      REPLACE ALL OCCURRENCES OF '"cgst_rate":"0"' in lv_body WITH '"cgst_rate":0'.
      REPLACE ALL OCCURRENCES OF '"sgst_rate":"0"' in lv_body WITH '"sgst_rate":0'.
      REPLACE ALL OCCURRENCES OF '"igst_rate":""' in lv_body WITH '"igst_rate":""'.
      else.
      REPLACE ALL OCCURRENCES OF '"cgst_rate":""' in lv_body WITH '"cgst_rate":""'.
      REPLACE ALL OCCURRENCES OF '"sgst_rate":""' in lv_body WITH '"sgst_rate":""'.
      REPLACE ALL OCCURRENCES OF '"igst_rate":"0"' in lv_body WITH '"igst_rate":0'.
      endif.

      REPLACE FIRST OCCURRENCE OF '"lw_qty":"",},' IN lv_body WITH '"lw_qty":""},'.
      REPLACE ALL OCCURRENCES OF '"lw_qty":""' IN lv_body WITH '"LW_qty":""'.
      REPLACE ALL OCCURRENCES OF '"lw_uqc":""' IN lv_body WITH '"LW_uqc":""'.
      REPLACE FIRST OCCURRENCE OF '"o_chdt":""}' IN lv_body WITH '"o_chdt":"",'.
      " '] } ] } ' INTO lv_body.


      TRY.
          lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                           i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error.
          "handle exception
      ENDTRY.

      DATA(lo_request) = lo_http_client->get_http_request( ).
      lo_request->set_header_fields( VALUE #(
                ( name = 'gstin' value = '33GSPTN0591G1Z7' )
*              ( name = 'productid' value = '' )
                ( name = 'year' value = '2024-25' )
                ( name = 'subid' value = '7757' )
                ( name = 'month' value = '3' )
                ( name = 'Content-Type' value = 'application/json' )
                ( name = 'productId' value = 'enterprises' )
                ( name = 'MiplApiKey' value = 'rLWN9u9WePRtGneWExwJvy2gwWPrCUTM' )
                ) ).

      lo_request->append_text(
        data   = lv_body
*       offset = 0
*       length = -1
      ).

      TRY.
          DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>post
*                           i_timeout = 0
                              ).
        CATCH cx_web_http_client_error.
          "handle exception
      ENDTRY.

      DATA(lv_json_response) = lv_response->get_text( ).

      wa_response-billingdocument = wa_billdetails-billingdocument.
      wa_response-itc04_5arespons = lv_json_response.
      MODIFY ztab_itc045a_res FROM @wa_response.

*    ENDLOOP.

     READ ENTITIES OF zi_billingdetails IN LOCAL MODE
     ENTITY zi_billingdetails
     ALL FIELDS WITH CORRESPONDING #( it_keys )
     RESULT DATA(result_data).

     result = VALUE #( FOR wa_resultdata IN result_data
                      ( %tky = wa_resultdata-%tky %param = wa_resultdata ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_BILLINGDETAILS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_BILLINGDETAILS IMPLEMENTATION.

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
