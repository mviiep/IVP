CLASS zcl_custom_comm_pack_inv DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
**data Declaration
    DATA: r_token TYPE string.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA lv_billingno TYPE i_billingdocumentbasic-billingdocument.

    DATA:lv_custom(1)     TYPE c,
         lv_commerical(1) TYPE c,
         lv_packing(1)    TYPE c.

**********************************************************************
**Methods


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_obj | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    METHODS itemtext
      IMPORTING billingdocument     TYPE i_billingdocumentitembasic-billingdocument
                billingdocumentitem TYPE i_billingdocumentitembasic-billingdocumentitem
                textid              TYPE c
      RETURNING VALUE(r_val)        TYPE string.


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_XML | <p class="shorttext synchronized" lang="en"></p>
    METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS post
      RETURNING VALUE(r_base64) TYPE string.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOM_COMM_PACK_INV IMPLEMENTATION.


  METHOD get_obj.


    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    r_token = tokenmethod->token( ).


    DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).


    IF lv_custom IS NOT INITIAL.

      CASE sy-sysid.
        WHEN lv_dev.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_custom_dev' ).
        WHEN lv_qas.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_custom_dev' ).
        WHEN lv_prd.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_custom_prd' ).
      ENDCASE.

    ELSEIF lv_commerical IS NOT INITIAL.

      CASE sy-sysid.
        WHEN lv_dev.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_commerical_dev' ).
        WHEN lv_qas.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_commerical_dev' ).
        WHEN lv_prd.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_commerical_prd' ).
      ENDCASE.

    ELSEIF lv_packing IS NOT INITIAL.

      CASE sy-sysid.
        WHEN lv_dev.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_packing_dev' ).
        WHEN lv_qas.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_packing_dev' ).
        WHEN lv_prd.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/sd_packing_prd' ).
      ENDCASE.

    ENDIF.


    lo_request->set_header_fields( VALUE #(
                (  name = 'Authorization' value =  | { r_token } | )
                ) ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error.                   "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lv_json_response) =   lv_response->get_text( ).

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.

    DATA lr_data TYPE REF TO data.
    DATA templates TYPE REF TO data.

    lr_data = /ui2/cl_json=>generate( json = lv_json_response  pretty_name  = /ui2/cl_json=>pretty_mode-user ).

    DATA: lv_test TYPE string.


    IF lr_data IS BOUND.
      ASSIGN lr_data->* TO <data>.


      ASSIGN COMPONENT 'templates' OF STRUCTURE <data> TO <templates>.
      IF <templates> IS BOUND.
        ASSIGN <templates>->* TO <templates_result>.

        ASSIGN <templates_result> TO <metadata>.

        READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield>) INDEX 1.
        ASSIGN <metafield>->* TO <metafield_result>.

        ASSIGN COMPONENT 'METADATA' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata>).
        ASSIGN <mdata>->* TO FIELD-SYMBOL(<mdata_result>).

        ASSIGN COMPONENT 'OBJECTID' OF STRUCTURE <mdata_result> TO FIELD-SYMBOL(<objectid>).
        ASSIGN <objectid>->* TO FIELD-SYMBOL(<objectid_result>).

      ENDIF.
    ENDIF.


    r_obj = <objectid_result>.
  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    DATA(lt_params) = request->get_form_fields( ).
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'custom'.
    lv_billingno = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'commercial' .
    lv_billingno = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'packing' .
    lv_billingno = ls_params-value.


    IF ls_params-name = 'custom'.
      lv_custom = 'X'.
    ELSEIF ls_params-name = 'commercial'.
      lv_commerical = 'X'.
    ELSEIF ls_params-name = 'packing'.
      lv_packing = 'X'.
    ENDIF.


    IF lv_billingno IS NOT INITIAL .
*      TRY.
*          response->set_text( post( ) ).
*        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
*          "handle exception
*      ENDTRY.

      DATA(base64_data) =  post( ).
      DATA(decoded_binary) = cl_web_http_utility=>decode_x_base64( encoded = base64_data ).
      response->set_header_field( i_name = 'Content-Type' i_value = 'application/pdf' ).
      response->set_binary( decoded_binary ).


    ENDIF.



  ENDMETHOD.


  METHOD itemtext.

    DATA:
      username TYPE string,
      pass     TYPE string.

    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username  = 'IVP'.
        pass      = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username  =  'IVP'.
        pass      = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username  = 'IVP'.
        pass      = 'Password@#0987654321'.
    ENDCASE.


    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/A_BillingDocumentItemText| &
              |(BillingDocument=' { billingdocument }',BillingDocumentItem=' { billingdocumentitem }  ',Language='EN',LongTextID=' { textid } ')|.

    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


    DATA(token_request) = token_http_client->get_http_request( ).

    token_request->set_header_fields(  VALUE #(
               (  name = 'Accept' value = '*/*' )
                ) ).



    token_request->set_authorization_basic(
      EXPORTING
           i_username = username
           i_password = pass
    ).


    TRY.
        DATA(lv_token_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>get )->get_text(  ).


      CATCH cx_web_http_client_error cx_web_message_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA:lv_string1 TYPE string,
         lv_string2 TYPE string,
         lv_string3 TYPE string,
         lv_mat     TYPE string,
         lv_rest    TYPE string.

    SPLIT lv_token_response AT '<d:LongText>' INTO lv_string2 lv_string3.

    SPLIT lv_string3 AT '</d:LongText>' INTO lv_mat lv_rest.

    r_val = lv_mat.

  ENDMETHOD.


  METHOD post.
*****************************POST METHOD*****************************
    TYPES :
      BEGIN OF struct,
        xdp_template     TYPE string,
        xml_data         TYPE string,
        form_type        TYPE string,
        form_locale      TYPE string,
        tagged_pdf       TYPE string,
        embed_font       TYPE string,
        changenotallowed TYPE string,
      END OF struct.

    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    DATA(r_token) = tokenmethod->token( ).

    DATA(xmldata) = me->xmldata( ).

    DATA(objectid)    = me->get_obj( ).


    IF objectid IS NOT INITIAL AND xmldata IS NOT INITIAL AND r_token IS NOT INITIAL.

      DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
      DATA: lo_http_client TYPE REF TO if_web_http_client.

      TRY.
          lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination =
          cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.

      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_uri_path( i_uri_path = '/v1/adsRender/pdf' ).
      lo_request->set_query( query =  'templateSource=storageId' ).

      lo_request->set_header_fields(  VALUE #(
                 (  name = 'Content-Type' value = 'application/json' )
                 (  name = 'Accept' value = 'application/json' )
                  )  ).

      lo_request->set_header_fields(  VALUE #(
                      (  name = 'Authorization' value =  | { r_token } | )
                      ) ).




      IF lv_custom IS NOT INITIAL.

        CASE sy-sysid.
          WHEN lv_dev.
            DATA(ls_body) = VALUE struct(  xdp_template = 'sd_custom_dev/' && |{ objectid }|
                                                             xml_data  = xmldata ).
          WHEN lv_qas.
            ls_body = VALUE struct(  xdp_template = 'sd_custom_dev/' && |{ objectid }|
                                                 xml_data  = xmldata ).
          WHEN lv_prd.
            ls_body = VALUE struct(  xdp_template = 'sd_custom_prd/' && |{ objectid }|
                                                 xml_data  = xmldata ).
        ENDCASE.


      ELSEIF lv_commerical IS NOT INITIAL.

        CASE sy-sysid.
          WHEN lv_dev.
            ls_body = VALUE struct(  xdp_template = 'sd_commerical_dev/' && |{ objectid }|
                                                        xml_data  = xmldata ).
          WHEN lv_qas.
            ls_body = VALUE struct(  xdp_template = 'sd_commerical_dev/' && |{ objectid }|
                                                 xml_data  = xmldata ).
          WHEN lv_prd.
            ls_body = VALUE struct(  xdp_template = 'sd_commerical_prd/' && |{ objectid }|
                                                 xml_data  = xmldata ).
        ENDCASE.


      ELSEIF lv_packing IS NOT INITIAL.

        CASE sy-sysid.
          WHEN lv_dev.
            ls_body = VALUE struct(  xdp_template = 'sd_packing_dev/' && |{ objectid }|
                                                         xml_data  = xmldata ).
          WHEN lv_qas.
            ls_body = VALUE struct(  xdp_template = 'sd_packing_dev/' && |{ objectid }|
                                                 xml_data  = xmldata ).
          WHEN lv_prd.
            ls_body = VALUE struct(  xdp_template = 'sd_packing_prd/' && |{ objectid }|
                                                 xml_data  = xmldata ).
        ENDCASE.


      ENDIF.







      DATA(lv_json) = /ui2/cl_json=>serialize( data = ls_body compress = abap_true
                                               pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

      lo_request->append_text(
            EXPORTING
              data   = lv_json
          ).

      TRY.
          DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>post ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

      DATA(lv_json_response) = lv_response->get_text( ).

      FIELD-SYMBOLS:
        <data>                TYPE data,
        <field>               TYPE any,
        <pdf_based64_encoded> TYPE any.

      DATA lr_data TYPE REF TO data.

      lr_data = /ui2/cl_json=>generate( json = lv_json_response ).

      IF lr_data IS BOUND.
        ASSIGN lr_data->* TO <data>.
        ASSIGN COMPONENT `fileContent` OF STRUCTURE <data> TO <field>.
        IF sy-subrc EQ 0.
          ASSIGN <field>->* TO <pdf_based64_encoded>.
          r_base64 = <pdf_based64_encoded>.
        ENDIF.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD xmldata.
**********************************************************************
*
*
*********************data Declaration
**Supplier Address
    TYPES: BEGIN OF ty_address,
             name            TYPE i_customer-customername,
             street1(70)     TYPE c,
             street2(45)     TYPE c,
             city            TYPE i_customer-cityname,
             state           TYPE zi_sd_address-statename,
             postalcode      TYPE zi_sd_address-postalcode,
             statecode       TYPE zi_sd_address-statecode,
             gstin           TYPE zi_sd_address-taxnumber3,
             telephonenumber TYPE zi_sd_address-telephonenumber1,
             faxno           TYPE zi_sd_address-faxnumber,
             vatno           TYPE zi_sd_address-vatno,
             country         TYPE zi_sd_address-country,
           END OF ty_address.

    DATA: plantaddress  TYPE ty_address,
          billtoaddress TYPE ty_address,
          shiptoaddress TYPE ty_address,
          soldtoaddress TYPE ty_address,
          notifyaddress TYPE ty_address.

    TYPES: BEGIN OF ty_item,
             markandnos     TYPE string,
             noofkindofpkgs TYPE string,
             hsncode        TYPE i_producttext-productname,
             hsntext        TYPE i_producttext-productname,
             matdesc        TYPE i_producttext-productname,
             qty            TYPE i_purchaseorderitemapi01-orderquantity,
             uom            TYPE i_purchaseorderitemapi01-orderpriceunit,
             rate           TYPE zi_subsequent_debitcredit-amountincompanycodecurrency,
             amount         TYPE zi_subsequent_debitcredit-amountincompanycodecurrency,
           END OF ty_item.

    DATA: item    TYPE STANDARD TABLE OF ty_item,
          wa_item TYPE ty_item.


    TYPES:BEGIN OF ty_total,
            grosswt   TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            netwt     TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            tarewt    TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            pallets   TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            fob       TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            frieght   TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            insurance TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            cif       TYPE i_billingdocitemprcgelmntbasic-conditionamount,
            addduty   TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          END OF ty_total.

    DATA: itemtotal TYPE ty_total.

**********************************************************************
*****Header

*BillingDocument,
*      BillingDocumentDate,
*      PurchaseOrderByCustomer,
*      IncotermsClassification,
*      IncotermsLocation1,
*      TransactionCurrency,
*      CustomerPaymentTerms,
*      SoldToParty,
*      AccountingExchangeRate


    SELECT SINGLE i_billingdocumentbasic~billingdocument,i_billingdocumentbasic~billingdocumentdate,i_salesorder~purchaseorderbycustomer,
    i_billingdocumentbasic~incotermsclassification,i_billingdocumentbasic~incotermslocation1,i_billingdocumentbasic~transactioncurrency,i_billingdocumentbasic~customerpaymentterms,
    i_billingdocumentbasic~soldtoparty,i_billingdocumentbasic~accountingexchangerate,i_billingdocumentbasic~documentreferenceid
    FROM i_billingdocumentbasic
    LEFT OUTER JOIN i_billingdocumentitembasic ON i_billingdocumentbasic~billingdocument = i_billingdocumentitembasic~billingdocument
    LEFT OUTER JOIN i_salesorder ON i_salesorder~salesorder = i_billingdocumentitembasic~salesdocument
    WHERE i_billingdocumentbasic~billingdocument = @lv_billingno
    INTO @DATA(header).

    DATA(lv_billingno1) = lv_billingno.

    SHIFT lv_billingno1 LEFT DELETING LEADING '0'.

    SELECT SINGLE *
    FROM zexi_export_ship_dt AS ship_dt
    LEFT JOIN zexi_export_doc_dt AS export_doc_dt ON export_doc_dt~id = ship_dt~id
    LEFT JOIN zexi_export_gen_dt AS export_gen_dt ON export_gen_dt~id = ship_dt~id
    WHERE ship_dt~id = @lv_billingno1
    INTO @DATA(shippingexim).

    SELECT SINGLE customerpaymenttermsname
    FROM i_customerpaymenttermstext
    WHERE customerpaymentterms = @header-customerpaymentterms
    AND language  = 'E'
    INTO @DATA(paymentterms).

**********************************************************************

    SELECT SINGLE billingdocument,plant
    FROM i_billingdocumentitembasic
    WHERE billingdocument EQ @header-billingdocument
    INTO @DATA(billingdocumentitem).

*****Notify Party
    CONCATENATE shippingexim-export_gen_dt-cnstreet1 shippingexim-export_gen_dt-cnstreet2 INTO DATA(np_street).
    notifyaddress-name          = shippingexim-export_gen_dt-cnname.
    notifyaddress-street1       = shippingexim-export_gen_dt-cnstreet.
    notifyaddress-street2       = np_street.
    notifyaddress-city          = shippingexim-export_gen_dt-cncity.
    notifyaddress-postalcode    = shippingexim-export_gen_dt-cnpostalcode.
    notifyaddress-state         = shippingexim-export_gen_dt-cnregion.
    notifyaddress-country       = shippingexim-export_gen_dt-cncountry.
*    notifyaddress-gstin         = shippingexim-export_gen_dt-cn.


*****Bill to Party
    SELECT SINGLE customer
    FROM i_billingdocumentpartnerbasic
    WHERE billingdocument = @header-billingdocument
    AND partnerfunction = 'RE'
    INTO @DATA(billto).

    SELECT SINGLE streetprefixname1,streetprefixname2,streetname,cityname,postalcode,telephonenumber1,
    sap_description,statecode,faxnumber,vatno,zins,vanno,taxnumber3,country
    FROM zi_sd_address
    WHERE customer  = @billto
    INTO @DATA(wa_bp).
    CONCATENATE  wa_bp-streetprefixname1 wa_bp-streetprefixname2 INTO DATA(bp_street).
    billtoaddress-street1       = wa_bp-streetname.
    billtoaddress-street2       = bp_street.
    billtoaddress-city          = wa_bp-cityname.
    billtoaddress-postalcode    = wa_bp-postalcode.
    billtoaddress-state         = wa_bp-sap_description.
    billtoaddress-statecode     = wa_bp-statecode.
    billtoaddress-gstin         = wa_bp-taxnumber3.
    billtoaddress-country       = wa_bp-country.


*****Sold to Party
    IF header-soldtoparty IS NOT INITIAL.
      SELECT SINGLE streetprefixname1,streetprefixname2,streetname,cityname,postalcode,telephonenumber1,
      sap_description,statecode,taxnumber3,vatno,customerfullname,country
      FROM zi_sd_address
      WHERE customer  = @header-soldtoparty
      INTO @DATA(wa_sh).
      CONCATENATE  wa_sh-streetprefixname1 wa_sh-streetprefixname2 INTO DATA(sh_street).
      soldtoaddress-name          = wa_sh-customerfullname.
      soldtoaddress-street1       = wa_sh-streetname.
      soldtoaddress-street2       = sh_street.
      soldtoaddress-city          = wa_sh-cityname.
      soldtoaddress-postalcode    = wa_sh-postalcode.
      soldtoaddress-state         = wa_sh-sap_description.
      soldtoaddress-statecode     = wa_sh-statecode.
      soldtoaddress-gstin         = wa_sh-taxnumber3.
      soldtoaddress-country       = wa_sh-country.
    ENDIF.

*****Ship to Party
    SELECT SINGLE customer
    FROM i_billingdocumentpartnerbasic
    WHERE billingdocument = @header-billingdocument
    AND partnerfunction = 'WE'
    INTO @DATA(shipto).

    IF shipto IS NOT INITIAL.
      SELECT SINGLE streetprefixname1,streetprefixname2,streetname,cityname,postalcode,telephonenumber1,
      sap_description,statecode,faxnumber,vatno,taxnumber3,customerfullname,country
      FROM zi_sd_address
      WHERE customer  = @shipto
      INTO @DATA(wa_sp).
      CONCATENATE  wa_sp-streetprefixname1 wa_sp-streetprefixname2 INTO DATA(sp_street).
      shiptoaddress-name            = wa_sp-customerfullname.
      shiptoaddress-street1         = wa_sp-streetname.
      shiptoaddress-street2         = bp_street.
      shiptoaddress-city            = wa_sp-cityname.
      shiptoaddress-postalcode      = wa_sp-postalcode.
      shiptoaddress-state           = wa_sp-sap_description.
      shiptoaddress-statecode       = wa_sp-statecode.
      shiptoaddress-gstin           = wa_sp-taxnumber3.
      shiptoaddress-faxno           = wa_sp-faxnumber.
      shiptoaddress-vatno           = wa_sp-vatno.
      shiptoaddress-telephonenumber = wa_sp-telephonenumber1.
      shiptoaddress-country         = wa_sp-country.
    ENDIF.



*****Plant
    SELECT SINGLE addressid FROM i_plant
    WHERE plant EQ @billingdocumentitem-plant
    INTO @DATA(plantaddid).

    IF plantaddid IS NOT INITIAL.

      SELECT SINGLE i_address_2~streetsuffixname1,i_address_2~streetsuffixname2,i_address_2~addresseefullname,
      i_address_2~streetname,i_address_2~cityname,i_address_2~postalcode,i_regiontext~regionname,
      zi_state_code~statecode
      FROM i_address_2 WITH PRIVILEGED ACCESS
            JOIN i_regiontext     ON i_regiontext~region      = i_address_2~region
                                  AND i_regiontext~country    = i_address_2~country
                                  AND language                = 'E'
            JOIN zi_state_code ON zi_state_code~region  = i_address_2~region
            WHERE addressid  = @plantaddid
            INTO @DATA(wa_plantaddress).

      SELECT SINGLE businessplace
      FROM i_in_plantbusinessplacedetail
      WHERE plant = @billingdocumentitem-plant
      INTO @DATA(plantbusinessplacedetail).

      SELECT SINGLE in_gstidentificationnumber
      FROM i_in_businessplacetaxdetail
      WHERE businessplace = @plantbusinessplacedetail
      INTO @plantaddress-gstin. "Plant GSTIN

      CONCATENATE  wa_plantaddress-streetsuffixname1 wa_plantaddress-streetsuffixname2 INTO DATA(plant_street).
      plantaddress-name        = wa_plantaddress-addresseefullname.
      plantaddress-street1     = wa_plantaddress-streetname.
      plantaddress-street2     = plant_street.
      plantaddress-city        = wa_plantaddress-cityname.
      plantaddress-postalcode  = wa_plantaddress-postalcode.
      plantaddress-state       = wa_plantaddress-regionname.
      plantaddress-statecode   = wa_plantaddress-statecode.
    ENDIF.

    SELECT SINGLE *
    FROM zi_lutarncds
    WHERE plant  = @billingdocumentitem-plant
    AND fromdate <= @header-billingdocumentdate
    AND todate   >= @header-billingdocumentdate
    INTO @DATA(lutno).


**********************************************************************
*****Item

    SELECT *
    FROM i_billingdocumentitembasic
    WHERE billingdocument = @header-billingdocument
    INTO TABLE @DATA(billdocitem).

    IF billdocitem[] IS NOT INITIAL.
      SELECT consumptiontaxctrlcode,product,plant
      FROM  i_productplantbasic
      FOR ALL ENTRIES IN @billdocitem
       WHERE product = @billdocitem-product
       AND plant   = @billdocitem-plant
       AND consumptiontaxctrlcode <> ' '
       INTO TABLE @DATA(hsntable).
    ENDIF.


********PRCD ELEMENTS********
    DATA exchangerate TYPE p LENGTH 5 DECIMALS 2.
    DATA rate TYPE p LENGTH 7 DECIMALS 3.
    exchangerate = header-accountingexchangerate.

    IF billdocitem[] IS NOT INITIAL.
      SELECT conditiontype, conditionratevalue, conditionamount,conditionrateamount,conditionbasevalue,conditionbasequantity
      FROM i_billingdocitemprcgelmntbasic
      FOR ALL ENTRIES IN @billdocitem
      WHERE billingdocument = @billdocitem-billingdocument
                         AND billingdocumentitem = @billdocitem-billingdocumentitem
                         AND conditioninactivereason <> 'M'
      INTO TABLE @DATA(it_prcd).
    ENDIF.


**********************************************************************

    LOOP AT billdocitem INTO DATA(billingdocitem).


      wa_item-markandnos     = me->itemtext(
                             billingdocument     = billingdocitem-billingdocument
                             billingdocumentitem = billingdocitem-billingdocumentitem
                             textid              = 'TX15'
                           ).

      wa_item-noofkindofpkgs = me->itemtext(
                             billingdocument     = billingdocitem-billingdocument
                             billingdocumentitem = billingdocitem-billingdocumentitem
                             textid              = 'TX06'
                           ).

      READ TABLE hsntable INTO DATA(wa_hsn) WITH KEY product = billingdocitem-product
                                                     plant   = billingdocitem-plant.

      wa_item-hsncode = wa_hsn-consumptiontaxctrlcode.
      wa_item-matdesc = billingdocitem-billingdocumentitemtext.
      wa_item-qty     = billingdocitem-billingquantity.
      wa_item-uom     = billingdocitem-billingquantityunit.

********ZDEV********

      READ TABLE it_prcd INTO DATA(wa_devrate) WITH KEY conditiontype = 'ZDEV'.
      IF sy-subrc EQ 0.
        rate = wa_devrate-conditionratevalue.
      ENDIF.


********PMP0********

      READ TABLE it_prcd INTO DATA(wa_pmp0) WITH KEY conditiontype = 'PMP0'.
      IF rate IS INITIAL.
        rate = wa_pmp0-conditionratevalue.
      ENDIF.


********PCIP********

      READ TABLE it_prcd INTO DATA(wa_pcip) WITH KEY conditiontype = 'PCIP'.
      IF rate IS INITIAL.
        rate = wa_pcip-conditionratevalue.
      ENDIF.


********Rate and Amount********
      wa_item-rate = rate.
      wa_item-amount = wa_item-rate * wa_item-qty.

      APPEND wa_item TO item.
      CLEAR wa_item.

    ENDLOOP.


**********************************************************************

    SELECT DISTINCT SUM( conditionamount ) AS conditionamount,
     conditionratevalue,
     billingdocument,
     conditiontype
     FROM i_billingdocitemprcgelmntbasic
     WHERE billingdocument = @billingdocitem-billingdocument
     AND conditiontype = 'YBHD'
     GROUP BY billingdocument,conditionratevalue,conditiontype
     INTO TABLE @DATA(it_frt).

    READ TABLE it_frt INTO DATA(wa_frt) WITH KEY conditiontype = 'YBHD'.
    DATA frt TYPE p LENGTH 10 DECIMALS 3.

    IF wa_frt-conditionamount IS NOT INITIAL.
      IF lv_commerical IS INITIAL.
        frt = wa_frt-conditionamount * exchangerate.
      ELSEIF lv_commerical = 'X'.
        frt = wa_frt-conditionamount.
      ENDIF.

*      frt = wa_frt-conditionamount * exchangerate.
      itemtotal-frieght = frt .
    ENDIF.


********insuarance********
    SELECT DISTINCT SUM( conditionamount ) AS conditionamount,
     conditionratevalue,
     billingdocument,
     conditiontype
     FROM i_billingdocitemprcgelmntbasic
     WHERE billingdocument = @billingdocitem-billingdocument
     AND conditiontype = 'FIN1'
     GROUP BY billingdocument,conditionratevalue,conditiontype
     INTO TABLE @DATA(it_ins).

    READ TABLE it_ins INTO DATA(wa_ins) WITH KEY conditiontype = 'FIN1'.
    IF sy-subrc EQ 0.
      DATA ins TYPE p LENGTH 10 DECIMALS 3.
      IF lv_commerical IS INITIAL.
        ins = wa_ins-conditionamount * exchangerate.
      ELSEIF lv_commerical = 'X'.
        ins = wa_ins-conditionamount.
      ENDIF.


*      ins = wa_ins-conditionamount * exchangerate.
      itemtotal-insurance = ins .
    ENDIF.

********add duty********
    SELECT DISTINCT SUM( conditionamount ) AS conditionamount,
     conditionratevalue,
     billingdocument,
     conditiontype
     FROM i_billingdocitemprcgelmntbasic
     WHERE billingdocument = @billingdocitem-billingdocument
     AND conditiontype = 'ZDTY'
     GROUP BY billingdocument,conditionratevalue,conditiontype
     INTO TABLE @DATA(it_addduty).

    READ TABLE it_addduty INTO DATA(wa_addduty) WITH KEY conditiontype = 'ZDTY'.
    IF sy-subrc EQ 0.
      itemtotal-addduty = wa_addduty-conditionamount .
    ENDIF.


**********************************************************************


    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_custom_comm_pack  SOURCE header                    = header
                                                     lv_billingno              = lv_billingno1
                                                     lutno                     = lutno
                                                     shippingexim              = shippingexim
                                                     paymenttermstext          = paymentterms
                                                     plantaddress              = plantaddress
                                                     billtoaddress             = billtoaddress
                                                     shiptoaddress             = shiptoaddress
                                                     soldtoaddress             = soldtoaddress
                                                     notifyaddress             = notifyaddress
                                                     item                      = item[]
                                                     itemtotal                 = itemtotal

                                           RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.

  ENDMETHOD.
ENDCLASS.
