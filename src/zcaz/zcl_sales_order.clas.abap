CLASS zcl_sales_order DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA uuid TYPE c LENGTH 20.

    DATA : soheading TYPE string,
           remarks   TYPE string,
           ourref    TYPE string.

    TYPES:BEGIN OF ty_schedule,
            scheduledispatchdate TYPE datum,
            scheduleqty          TYPE zsales_order_conf1-orderquantity,
            no_of_pkgs           TYPE zsales_order_conf1-orderquantity,
            avgcontperpkg        TYPE zsales_order_conf1-orderquantity,
          END OF ty_schedule.

    DATA : it_scheduleline TYPE TABLE OF ty_schedule,
           wa_scheduleline TYPE ty_schedule.

    TYPES:BEGIN OF ty_final,
            amount             TYPE zsales_order_conf1-amount,
            productdiscription TYPE zsales_order_conf1-productdiscription,
            hsncode            TYPE zsales_order_conf1-hsncode,
            plant              TYPE zsales_order_conf1-plant,
            typeofpkgs         TYPE zsales_order_conf1-typeofpkgs,
            avgcontperpkg      TYPE zsales_order_conf1-orderquantity,
            orderquantity      TYPE zsales_order_conf1-orderquantity,
            rate               TYPE zsales_order_conf1-rate,
            unit1              TYPE zsales_order_conf1-unit1,
            dispatchdate       TYPE datum,
            nofpkgs            TYPE zsales_order_conf1-orderquantity,
            it_schedule        LIKE it_scheduleline,
          END OF ty_final.

    DATA: it_final  TYPE TABLE OF ty_final,
          wa_final  TYPE ty_final,
          wa_header TYPE  zsales_order_conf1.

    DATA amount TYPE zsales_order_conf1-amount.

    TYPES:BEGIN OF ty_customer,
            street(120),
            city         TYPE i_customer-cityname,
            postalcode   TYPE i_customer-postalcode,
            state        TYPE i_regiontext-regionname,
            statecode(2),
            acc_name(20),
            gstin        TYPE zsales_order_conf1-orderbygst,
            panno        TYPE zsales_order_conf1-orderbypan,
            street2(60),
            name         TYPE i_customer-bpcustomername,
          END OF ty_customer.

    TYPES:BEGIN OF ty_total,
            subtotal      TYPE i_salesdocitempricingelement-conditionamount,
            lessdiscount  TYPE i_salesdocitempricingelement-conditionamount,
            addfreight    TYPE i_salesdocitempricingelement-conditionamount,
            addinsurance  TYPE i_salesdocitempricingelement-conditionamount,
            taxableamount TYPE i_salesdocitempricingelement-conditionamount,
            igstr         TYPE i_salesdocitempricingelement-conditionratevalue,
            cgstr         TYPE i_salesdocitempricingelement-conditionratevalue,
            sgstr         TYPE i_salesdocitempricingelement-conditionratevalue,
            ugstr         TYPE i_salesdocitempricingelement-conditionratevalue,
            igstamount    TYPE i_salesdocitempricingelement-conditionamount,
            cgstamount    TYPE i_salesdocitempricingelement-conditionamount,
            sgstamount    TYPE i_salesdocitempricingelement-conditionamount,
            ugstamount    TYPE i_salesdocitempricingelement-conditionamount,
            tcsamount     TYPE i_salesdocitempricingelement-conditionamount,
            addduty       TYPE i_salesdocitempricingelement-conditionamount,
            totalamount   TYPE i_salesdocitempricingelement-conditionamount,
          END OF ty_total.

    DATA : wa_sp      TYPE ty_customer,
           wa_bp      TYPE ty_customer,
           wa_plant   TYPE ty_customer,
           wa_company TYPE ty_customer.

    DATA : wa_total TYPE ty_total.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.


    DATA lv_so TYPE zsales_order_conf1-salesdocument.
    DATA salesperson TYPE i_salesdocumentpartner-fullname.
    DATA salesorderorganization TYPE i_salesorder-salesorganization.
    DATA:
      mo_http_destination TYPE REF TO if_http_destination,
      mv_client           TYPE REF TO if_web_http_client.

    DATA: r_token TYPE string.

    DATA:
      username TYPE string,
      pass     TYPE string.



    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    METHODS xmldata
      IMPORTING p_import        TYPE zsales_order_conf1-salesdocument
      RETURNING VALUE(r_base64) TYPE string.

    METHODS zcomm
      IMPORTING so           TYPE i_billingdocumentitembasic-salesdocument
                textid       TYPE c
      RETURNING VALUE(r_val) TYPE string.


    METHODS mat_text
      IMPORTING so           TYPE i_billingdocumentitembasic-salesdocument
                so_item      TYPE i_billingdocumentitembasic-salesdocumentitem
      RETURNING VALUE(r_val) TYPE string.


    METHODS renderpdf RETURNING VALUE(r_json) TYPE string
                      RAISING
                                cx_web_http_client_error
                                cx_http_dest_provider_error.


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_ORDER IMPLEMENTATION.


  METHOD get_obj.
    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    r_token = tokenmethod->token( ).

    DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                          i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    IF salesorderorganization EQ '2000'.

      CASE sy-sysid.
        WHEN lv_dev.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order' ).
        WHEN lv_qas.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order' ).
        WHEN lv_prd.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order_PRD' ).
      ENDCASE.

    ELSE.

      CASE sy-sysid.
        WHEN lv_dev.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order' ).
        WHEN lv_qas.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order' ).
        WHEN lv_prd.
          lo_request->set_uri_path( i_uri_path = '/v1/forms/Sales_Order_PRD' ).
      ENDCASE.

    ENDIF.

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = 'application/json' )
                )  ).

*    CONCATENATE 'Bearer' r_token INTO DATA(ls_token) SEPARATED BY space . " sk
    DATA(ls_token) = r_token.

    lo_request->set_header_fields(  VALUE #(
                  (  name = 'Authorization' value =  | { ls_token } | )
                  ) ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>get ).

      CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.

    DATA(lv_json_response) = lv_response->get_text( ).

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
    READ TABLE lt_params INTO DATA(wa_so) WITH KEY name = 'salesorder'.
    lv_so = wa_so-value.

    IF lv_so IS NOT INITIAL.
      TRY.
          response->set_text( renderpdf( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD mat_text.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.


    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username =  'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
    ENDCASE.

*    SELECT SINGLE * FROM zi_zuser_auth
*    WHERE sysid = @sy-sysid
*    INTO @DATA(syspass).
*
*    IF syspass IS NOT INITIAL.
*      lv_tenent = syspass-tenant.
*      username  = syspass-username.
*      pass      = syspass-password.
*    ENDIF.


    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_SALES_ORDER_SRV/A_SalesOrderItemText| &
              |(SalesOrder=' { so } ',SalesOrderItem=' { so_item } ',Language='EN',LongTextID='0001')|.

    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
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
      CATCH cx_web_http_client_error cx_web_message_error.
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


  METHOD renderpdf.

*****************************post method*****************************


    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    DATA(r_token) = tokenmethod->token( ).

    DATA(xmldata) = me->xmldata( p_import = lv_so ).

    DATA(objectid)    = me->get_obj( ).

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


    DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                      i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).

    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_uri_path( i_uri_path = '/v1/adsRender/pdf' ).
    lo_request->set_query( query =  'templateSource=storageId' ).

*    lo_request->set_header_fields(  VALUE #(
*               (  name = 'Content-Type' value = 'application/json' )
*               (  name = 'Accept' value = 'application/json' )
*                )  ).

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = 'application/json' )
                )  ).

*    CONCATENATE 'Bearer' r_token INTO DATA(ls_token) SEPARATED BY space . " sk

    DATA(ls_token) = r_token.

    lo_request->set_header_fields(  VALUE #(
                  (  name = 'Authorization' value =  | { ls_token } | )
                  ) ).
    IF salesorderorganization EQ '2000'.

      CASE sy-sysid.
        WHEN lv_dev.
          DATA(ls_body) = VALUE struct(  xdp_template = 'Sales_Order/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'Sales_Order/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'Sales_Order_PRD/' && |{ objectid }|
                                               xml_data  = xmldata ).
      ENDCASE.
    ELSE.

      CASE sy-sysid.
        WHEN lv_dev.
          ls_body = VALUE struct(  xdp_template = 'Sales_Order/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'Sales_Order/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'Sales_Order_PRD/' && |{ objectid }|
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
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
    ENDTRY.

    DATA(lv_json_response) = lv_response->get_text( ).
    DATA(lv_json_status) = lv_response->get_status( ).

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

        CONCATENATE 'salesorder' lv_so INTO uuid.

*        DATA(zcl_digital_sign) = NEW zcl_digital_signature( ).
*        DATA(signedbase64) = zcl_digital_sign->digitalsignature(
*                               base64       = <pdf_based64_encoded>
*                               lv_uuid      = uuid
*                               signloc      = '[10:20]'
*                               signsize     = ''
*                             ).


        r_json = <pdf_based64_encoded>.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD xmldata.


    SELECT SINGLE * FROM zsales_order_conf1
    WHERE salesdocument = @p_import
    INTO @wa_header.

    SELECT SINGLE fullname FROM i_salesdocumentpartner
    WHERE salesdocument = @p_import
    AND partnerfunction = 'VE'
    INTO @salesperson.

    SELECT SINGLE fullname FROM i_workforceperson_1
    WHERE businesspartner = @wa_header-createdbyuser
    INTO @DATA(createdbyuser).

    SELECT SINGLE salesorganization FROM i_salesorder
    WHERE salesorder = @p_import
    INTO @salesorderorganization.

    SELECT SINGLE distributionchannel FROM i_salesorder
    WHERE salesorder = @p_import
    INTO @DATA(distributionchannel).

    SELECT SINGLE salesdocapprovalstatusdesc FROM i_salesdocapprovalstatust
    WHERE salesdocapprovalstatus = @wa_header-salesdocapprovalstatus
    AND language EQ 'E'
    AND salesdocapprovalstatus = 'A'
    INTO @DATA(watermark).

    SELECT SINGLE incotermsclassificationname FROM i_incotermsclassificationtext
    WHERE incotermsclassification = @wa_header-incotermsclassification
    AND language = 'E'
    INTO @DATA(incotermsclassificationname).

    IF distributionchannel EQ '11' OR distributionchannel EQ '21'.
      soheading = 'EXPORT SALES ORDER'.
    ELSE.
      soheading = 'SALES ORDER'.
    ENDIF.

    CONCATENATE wa_header-incotermsclassification '-' incotermsclassificationname INTO DATA(incoterms)
    SEPARATED BY space.

    CONCATENATE wa_header-orderbystreet2 wa_header-orderbystreet3
    INTO wa_bp-street2 SEPARATED BY space.
    wa_bp-street      = wa_header-orderbysreet1.
    wa_bp-city        = wa_header-orderbycity.
    wa_bp-postalcode  = wa_header-orderbypostalcode.
    wa_bp-state       = wa_header-orderbyregionname.
    wa_bp-name        = wa_header-orderbyname.
    SELECT SINGLE statecode FROM zi_state_code
    WHERE region = @wa_header-orderbystate
    INTO @wa_bp-statecode.
    wa_bp-gstin       = wa_header-orderbygst.
    wa_bp-panno       = wa_header-orderbypan.

    CONCATENATE  wa_header-shiptostreet2 wa_header-shiptostreet3
    INTO wa_sp-street2 SEPARATED BY space.
    wa_sp-street     = wa_header-shiptosreet1.
    wa_sp-city       = wa_header-shiptocity.
    wa_sp-postalcode = wa_header-shiptopostalcode.
    wa_sp-state      = wa_header-shiptoregionname.
    wa_sp-name       = wa_header-shiptoname.
    SELECT SINGLE statecode FROM zi_state_code
    WHERE region = @wa_header-shiptostate
    INTO @wa_sp-statecode.
    wa_sp-gstin      = wa_header-shiptogst.
    wa_sp-panno      = wa_header-shiptopan.


    SELECT SINGLE plant FROM i_salesdocumentitem
    WHERE salesdocument = @p_import
    INTO @DATA(plant_add).

    SELECT SINGLE i_plant~addressid,_bptaxdetail~in_gstidentificationnumber FROM i_plant
    LEFT OUTER JOIN i_in_plantbusinessplacedetail AS _bpplacedetail ON i_plant~plant                = _bpplacedetail~plant
    LEFT OUTER JOIN i_in_businessplacetaxdetail   AS _bptaxdetail   ON _bpplacedetail~businessplace = _bptaxdetail~businessplace
                                                                   AND _bptaxdetail~companycode     = _bpplacedetail~companycode
    WHERE i_plant~plant EQ @plant_add
    INTO @DATA(plantaddid).

    SELECT i_customer~addressid, i_organizationaddress~streetname
        FROM i_customer
        LEFT OUTER JOIN i_organizationaddress ON i_customer~addressid = i_organizationaddress~addressid
        INTO TABLE @DATA(it_customer).


    IF plantaddid IS NOT INITIAL.
      SELECT SINGLE *
      FROM i_address_2 WITH PRIVILEGED ACCESS "CI_ALL_FIELDS_NEEDED
      LEFT OUTER JOIN i_regiontext AS _text ON i_address_2~region  = _text~region
                                           AND i_address_2~country = _text~country
                                           AND _text~language      = 'E'

      LEFT OUTER JOIN zi_state_code AS _statecode ON i_address_2~region  = _statecode~region
      WHERE addressid  = @plantaddid-addressid
      INTO @DATA(plant).

      CONCATENATE  plant-i_address_2-streetsuffixname1 plant-i_address_2-streetsuffixname2
      INTO wa_plant-street2 SEPARATED BY space.
      wa_plant-street     = plant-i_address_2-streetname.
      wa_plant-state      = plant-_text-regionname.
      wa_plant-statecode  = plant-_statecode-statecode.
      wa_plant-city       = plant-i_address_2-cityname.
      wa_plant-postalcode = plant-i_address_2-postalcode.
      wa_plant-gstin      = plantaddid-in_gstidentificationnumber.
    ENDIF.


    IF salesorderorganization EQ '1000'.

      wa_company-street     = '501, STANFORD'.
      wa_company-street2    = 'PLOT NO.554 JUNCTION OF SV ROAD  & JUHU LANE'.
      wa_company-city       = 'ANDHERI (W) MUMBAI'.
      wa_company-postalcode = '400058'.

    ELSEIF salesorderorganization EQ '2000'.
      wa_company-street     = wa_plant-street.
      wa_company-street2    = wa_plant-street2.
      wa_company-city       = wa_plant-city.
      wa_company-postalcode = wa_plant-postalcode.
    ENDIF.

    me->zcomm(
      EXPORTING
        so     = p_import
        textid = 'TX02'
      RECEIVING
        r_val  = remarks
    ).


    me->zcomm(
      EXPORTING
        so     = p_import
        textid = 'TX01'
      RECEIVING
        r_val  = ourref
    ).

    SELECT SINGLE addressid FROM i_salesdocumentpartner
    WHERE salesdocument = @p_import AND
    partnerfunction = 'U3'
    INTO @DATA(wa_transportername).

    IF wa_transportername IS NOT INITIAL.
      SELECT SINGLE addresseefullname
      FROM i_address_2  WITH PRIVILEGED ACCESS
      WHERE addressid EQ @wa_transportername
      INTO @DATA(transportername).
    ENDIF.


    SELECT  * FROM zsales_order_conf1
    WHERE salesdocument = @p_import
    ORDER BY salesdocumentitem
    INTO TABLE @DATA(it_item).

    IF it_item[] IS NOT INITIAL.
      SELECT salesorder,confirmedrqmtqtyinbaseunit,salesorderitem,requesteddeliverydate,schedulelineorderquantity FROM i_salesorderscheduleline
      FOR ALL ENTRIES IN @it_item
      WHERE salesorder = @it_item-salesdocument
      AND requesteddeliverydate <> 0
      INTO TABLE @DATA(it_salesorderscheduleline).
*************************************************************
  if it_salesorderscheduleline is initial.
        select from i_salesorderwithoutcharge as a inner join I_SalesOrderWithoutChargeItem as b
        on a~salesorderwithoutcharge = b~salesorderwithoutcharge
        fields  a~salesorderwithoutchargetype, a~RequestedDeliveryDate,
        b~salesorderwithoutcharge, b~salesorderwithoutchargeitem, b~orderquantity
         FOR ALL ENTRIES IN @it_item
      WHERE a~salesorderwithoutcharge = @it_item-salesdocument
       INTO TABLE @DATA(it_salesorderscheduleorder).
endif.

*************************************************************
      SORT it_salesorderscheduleline BY requesteddeliverydate ASCENDING.
    ENDIF.


    LOOP AT it_item INTO DATA(waitem).
      DATA(materialtext) = me->mat_text(
                             so      = waitem-salesdocument
                             so_item = waitem-salesdocumentitem
                           ).
      IF materialtext IS NOT INITIAL.
        wa_final-productdiscription  = materialtext.
      ELSE.
        wa_final-productdiscription  = waitem-productdiscription.
      ENDIF.
      wa_final-hsncode               = waitem-hsncode.
      wa_final-plant                 = waitem-plant.
      wa_final-typeofpkgs            = waitem-typeofpkgs.
      READ TABLE it_salesorderscheduleline INTO DATA(wa_salesorderscheduleline) WITH KEY
      salesorder = waitem-salesdocument salesorderitem = waitem-salesdocumentitem.
      wa_final-orderquantity         = wa_salesorderscheduleline-schedulelineorderquantity.
      wa_final-rate                  = waitem-zdevr.
      IF wa_final-rate IS INITIAL.
        wa_final-rate                = waitem-ppr0r.
      ELSEIF wa_final-rate IS INITIAL.
        wa_final-rate                = waitem-pmp0r.
      ENDIF.
*****************************************************************************************************************
      READ table it_salesorderscheduleorder into data(wa_salesorderscheduleorder) with key
      salesorderwithoutcharge = waitem-salesdocument salesorderwithoutchargeitem = waitem-salesdocumentitem.
      if  wa_final-orderquantity is initial.
      wa_final-orderquantity         = wa_salesorderscheduleorder-OrderQuantity.
      ENDIF.
**********************************************************************************************************************

      wa_final-unit1                 = waitem-unit1.
      wa_final-dispatchdate          = wa_salesorderscheduleline-requesteddeliverydate.
      wa_final-avgcontperpkg         = waitem-deliveryqty.
      IF wa_final-avgcontperpkg IS NOT INITIAL.
        wa_final-nofpkgs             = wa_final-orderquantity / wa_final-avgcontperpkg.
      ENDIF.
      wa_final-amount                  = waitem-zdevamt.
      IF wa_final-amount IS INITIAL.
        wa_final-amount                = waitem-ppr0amt.
      ELSEIF wa_final-amount IS INITIAL.
        wa_final-amount                = waitem-pmp0amt.
      ENDIF.
      amount = wa_final-amount + amount.

      if it_salesorderscheduleline is not initial.

      LOOP AT it_salesorderscheduleline INTO DATA(wa_soscheduleline) WHERE
       salesorder = waitem-salesdocument AND salesorderitem = waitem-salesdocumentitem.
        wa_scheduleline-scheduledispatchdate =  wa_soscheduleline-requesteddeliverydate.
        wa_scheduleline-scheduleqty          = wa_soscheduleline-schedulelineorderquantity.
*         wa_scheduleline-scheduleqty          = wa_soscheduleline-orderquantity.
        wa_scheduleline-avgcontperpkg        = waitem-deliveryqty.
        IF wa_scheduleline-avgcontperpkg IS NOT INITIAL.

          DATA(scheduleqty) = wa_scheduleline-scheduleqty.

          IF wa_final-unit1 EQ 'TO'.
            scheduleqty = scheduleqty * 1000.
          ENDIF.

          wa_scheduleline-no_of_pkgs         = scheduleqty / wa_scheduleline-avgcontperpkg.
        ENDIF.

        DATA noofpkgsstring TYPE string.
        noofpkgsstring = wa_final-nofpkgs.
        SPLIT noofpkgsstring AT '.' INTO DATA(num1) DATA(dec).

        IF dec <> 0.
          DATA(watermark1) = 'Error !!! No. of Packages can not be in Decimal'.
        ENDIF.

        APPEND wa_scheduleline TO it_scheduleline.
        CLEAR wa_scheduleline.
*        endif.
      ENDLOOP.

      endif.


************************************************************************************************************
if it_salesorderscheduleorder is not initial.
       LOOP AT it_salesorderscheduleorder INTO DATA(wa_salescharge) WHERE
       salesorderwithoutcharge = waitem-salesdocument AND salesorderwithoutchargeitem = waitem-salesdocumentitem.

            wa_scheduleline-scheduledispatchdate =  wa_salescharge-requesteddeliverydate.
         wa_scheduleline-scheduleqty          = wa_salescharge-orderquantity.
        wa_scheduleline-avgcontperpkg        = waitem-deliveryqty.
        IF wa_scheduleline-avgcontperpkg IS NOT INITIAL.

          DATA(scheduleqty1) = wa_scheduleline-scheduleqty.

          IF wa_final-unit1 EQ 'TO'.
            scheduleqty1 = scheduleqty1 * 1000.
          ENDIF.

          wa_scheduleline-no_of_pkgs         = scheduleqty1 / wa_scheduleline-avgcontperpkg.
        ENDIF.

        DATA noofpkgsstring1 TYPE string.
        noofpkgsstring = wa_final-nofpkgs.
        SPLIT noofpkgsstring AT '.' INTO num1 dec.

        IF dec <> 0.
          watermark1 = 'Error !!! No. of Packages can not be in Decimal'.
        ENDIF.

        APPEND wa_scheduleline TO it_scheduleline.
        CLEAR wa_scheduleline.
*        endif.
      ENDLOOP.

      endif.

****************************************************************************************************************
      wa_final-it_schedule[] = it_scheduleline[].



      APPEND wa_final TO it_final.
      CLEAR wa_final.
      CLEAR it_scheduleline[].
    ENDLOOP.


    LOOP AT it_item INTO DATA(wa_item).
      wa_total-lessdiscount  = wa_item-discount + wa_total-lessdiscount.
      wa_total-addfreight    = wa_item-freight + wa_total-addfreight.
      wa_total-addinsurance  = wa_item-insuarance + wa_total-addinsurance.
      wa_total-igstr         = wa_item-igstvalue.
      wa_total-cgstr         = wa_item-cgstvalue.
      wa_total-sgstr         = wa_item-sgstvalue.
      wa_total-ugstr         = wa_item-utgstvalue.
      wa_total-igstamount    = wa_item-igstrate + wa_total-igstamount.
      wa_total-cgstamount    = wa_item-cgstrate + wa_total-cgstamount.
      wa_total-sgstamount    = wa_item-sgstrate + wa_total-sgstamount.
      wa_total-ugstamount    = wa_item-utgstrate + wa_total-ugstamount.
      wa_total-tcsamount     = wa_item-tcsamount + wa_total-tcsamount.
      wa_total-addduty       = wa_total-addduty + wa_item-adddutyvalue.
    ENDLOOP.
    wa_total-subtotal      = amount .
    wa_total-taxableamount = ( wa_total-subtotal + wa_total-addinsurance + wa_total-addfreight + wa_total-addduty ) - wa_total-lessdiscount.

    IF wa_total-sgstr IS INITIAL.
      wa_total-sgstr = wa_total-ugstr.
      wa_total-sgstamount = wa_total-ugstamount.
    ENDIF.

    wa_total-totalamount   = wa_total-taxableamount + wa_total-igstamount + wa_total-cgstamount +  wa_total-sgstamount + wa_total-tcsamount.


    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION zso_transformation SOURCE header      = wa_header
                                              shipto          = wa_sp
                                              billto          = wa_bp
                                              incoterms       = incoterms
                                              plant           = wa_plant
                                              soheading       = soheading
                                              transportername = transportername
                                              company         = wa_company
                                              item            = it_final[]
                                              watermark       = watermark
                                              watermark1      = watermark1
                                              remarks         = remarks
                                              ourref          = ourref
                                              createdbyuser   = createdbyuser
                                              salesperson     = salesperson
                                              total           = wa_total RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).
    r_base64 = ls_data_xml.

  ENDMETHOD.


  METHOD zcomm.

    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username =  'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
    ENDCASE.

*    SELECT SINGLE * FROM zi_zuser_auth
*    WHERE sysid = @sy-sysid
*    INTO @DATA(syspass).
*
*    IF syspass IS NOT INITIAL.
*      lv_tenent = syspass-tenant.
*      username = syspass-username.
*      pass = syspass-password.
*    ENDIF.

    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_SALES_ORDER_SRV/A_SalesOrderText| &
              |(SalesOrder=' { so } ',Language='EN',LongTextID=' { textid } ')|.

    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
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


      CATCH cx_web_http_client_error cx_web_message_error.
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
ENDCLASS.
