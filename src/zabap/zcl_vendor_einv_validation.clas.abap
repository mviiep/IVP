CLASS zcl_vendor_einv_validation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_data,
              stjcd          TYPE string,
              lgnm           TYPE string,
              stj            TYPE string,
              dty            TYPE string,
              adadr          TYPE string,
              cxdt           TYPE string,
              gstin          TYPE string,
              nba            TYPE string,
              lstupdt        TYPE string,
              rgdt           TYPE string,
              ctd            TYPE string,
              sts            TYPE string,
              einvoicestatus TYPE string,
            END OF ty_data,

            BEGIN OF ty_data1,
              zdata TYPE ty_data,
            END OF ty_data1.


    DATA : it_data TYPE TABLE OF ty_data1,
           wa_data TYPE ty_data1,
           result  TYPE REF TO if_web_http_client.

    TYPES: BEGIN OF ty_message,
             message TYPE bapi_msg,
           END OF ty_message.

    DATA : tt_Suppl_Einv TYPE TABLE OF ty_data1.

    TYPES : BEGIN OF ty_output1,
              success TYPE string,
              status  TYPE string,
              message TYPE ty_message,
              data    LIKE tt_suppl_einv,
            END OF ty_output1.

    TYPES : BEGIN OF ty_output,
              success TYPE string,
              status  TYPE string,
              message TYPE string,
            END OF ty_output.

    DATA : ls_output  TYPE ty_output,
           ls_output1 TYPE ty_output1,
           einv_url   TYPE string,
           gstin      TYPE string,
           LV_Auth    TYPE string VALUE '960e4ba76a22ca33dee074b3d755b43bc358201d',
           LV_Client  TYPE string VALUE 'eqSvGqrqaNPcgqjRBC'.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_mrm_check_invoice_cloud .

    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VENDOR_EINV_VALIDATION IMPLEMENTATION.


  METHOD create_client.

    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.


  METHOD if_ex_mrm_check_invoice_cloud~check_invoice.

*    IF action = if_ex_mrm_check_invoice_cloud=>c_action_check
*       OR action = if_ex_mrm_check_invoice_cloud=>c_action_post
*       OR action = if_ex_mrm_check_invoice_cloud=>c_action_simulate.

    DATA it_head TYPE if_ex_mrm_check_invoice_cloud=>s_invoice_header.
    DATA lv_date TYPE string.

*    DATA(it_action)               = action.
    DATA(it_assetitem)            = assetitems.
    DATA(IT_consignmentitems)     = consignmentitems.
    DATA(IT_glaccountitems)       = glaccountitems.
    DATA(IT_itemswithporeference) = itemswithporeference.
    it_head                       = headerdata.


    LOOP AT assetitems INTO DATA(wa_assetitems).
    if wa_assetitems-taxcode <> 'AA' OR wa_assetitems-taxcode <> 'A0'.

*//Supplier GSTIN details
    SELECT SINGLE taxnumber3 FROM zi_vendor_master1 WHERE Supplier = @it_head-invoicingparty
                                      INTO @DATA(lv_supplier_gstin).

    IF ( lv_supplier_gstin NE '27AAXCS0934P1ZF' OR lv_supplier_gstin NE '27AAHFR5203K1Z4'
       OR lv_supplier_gstin NE '27AABCS0582M1Z3' OR lv_supplier_gstin NE '27AAAFU1902H1ZH'
       OR lv_supplier_gstin NE '27ABUPW3304L1ZZ' ).

    SELECT SINGLE * FROM zi_org_gstin WHERE BusinessPlace = @it_head-businessplace
                                            INTO @DATA(lv_buyer_gstin).

    IF lv_buyer_gstin-e_invoice IS NOT INITIAL.
     if lv_supplier_gstin is not initial or
        lv_supplier_gstin ne 'URD' or
        lv_supplier_gstin ne 'URP'.

       IF action = if_ex_mrm_check_invoice_cloud=>c_action_check
       OR action = if_ex_mrm_check_invoice_cloud=>c_action_post
       OR action = if_ex_mrm_check_invoice_cloud=>c_action_simulate.

    einv_url      = 'https://commonapi.mastersindia.co/commonapis/searchgstin?'.
    gstin         = lv_supplier_gstin. "'37AAFCA3135N2ZI'.

    CONCATENATE einv_url 'gstin=' gstin INTO einv_url.

    CONDENSE einv_url NO-GAPS.

    TRY.
        DATA(client) = create_client( einv_url ).
      CATCH cx_static_check.
    ENDTRY.

    DATA(req) = client->get_http_request(  ).
    req->set_header_fields(  VALUE #(
   ( name = 'Authorization' value = |Bearer { lv_auth }| )
   ( name = 'client_id'     value = lv_client ) ) ).

    TRY.
        DATA(lv_response) = client->execute(
                        i_method  = if_web_http_client=>get ).
        DATA(json_response) = lv_response->get_text( ).
        DATA(stat) = lv_response->get_status(  ).
        client->close( ).
      CATCH: cx_web_http_client_error.
    ENDTRY.

      IF json_response CS '"einvoiceStatus":"Yes"'.

        SELECT SINGLE * FROM ZVendor_EInvoice_Get WHERE DocNo EQ @it_head-supplierinvoiceidbyinvcgparty
                                           AND DocDate EQ @it_head-documentdate
                                           AND SupplGstin = @lv_supplier_gstin
                                           AND CustGstin = @lv_buyer_gstin-Gstin
                                           INTO @DATA(lw_veinv).


        IF lw_veinv-DocNo IS INITIAL AND lw_veinv-DocDate IS INITIAL.
          APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
          messagenumber    = '001'
          messageid        = 'MRM_BADI_CLOUD'
          messagevariable1 = 'BADI: Doc no. & Date not match with e-invoice data' )
          TO messages.
        ENDIF.


      ELSEIF json_response CS '"error": true,'.

      APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
      messagenumber    = '001'
      messageid        = 'MRM_BADI_CLOUD'
      messagevariable1 = 'BADI: The GSTIN passed in the request is invalid')
      TO messages. "|BADI { json_response }| )

      ENDIF.
    ENDIF.
   ENDIF.
  ENDIF.
    CLEAR: wa_data, lv_buyer_gstin, lv_supplier_gstin, lw_veinv.
    ENDIF.
    ENDIF.
ENDLOOP.
  ENDMETHOD.
ENDCLASS.
