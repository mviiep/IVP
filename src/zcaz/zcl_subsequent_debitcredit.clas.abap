CLASS zcl_subsequent_debitcredit DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
**data Declaration
    DATA: r_token TYPE string.
    DATA: headertext TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA:
      lv_companycode         TYPE i_journalentryitem-companycode,
      lv_accountingdocument  TYPE i_journalentryitem-accountingdocument,
      lv_fiscalyear          TYPE i_journalentryitem-fiscalyear,
      lv_digitalsignature(1) TYPE c.


    DATA wa_ds TYPE zdb_ds_ficd.
**********************************************************************
**Methods


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_obj | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_XML | <p class="shorttext synchronized" lang="en"></p>
    METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS subsequent_debitcredit
      RETURNING VALUE(r_base64) TYPE string.


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SUBSEQUENT_DEBITCREDIT IMPLEMENTATION.


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

    CASE sy-sysid.
      WHEN lv_dev.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Subsequent_debitcredit_dev' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Subsequent_debitcredit_dev' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Subsequent_debitcredit_prd' ).
    ENDCASE.



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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'accountingdocument'.
    lv_accountingdocument = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'companycode' .
    lv_companycode = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'fiscalyear' .
    lv_fiscalyear = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'digitalsignature' .
    lv_digitalsignature = ls_params-value.

    IF lv_accountingdocument IS NOT INITIAL AND lv_companycode IS NOT INITIAL AND lv_fiscalyear IS NOT INITIAL.
      TRY.
          response->set_text( subsequent_debitcredit( ) ).

          IF lv_digitalsignature = 'X' AND wa_ds-pdfstring IS NOT INITIAL.
            response->set_status(
              EXPORTING
                i_code   = 300
                i_reason = 'Digital Signature Already Exist'
            ).
          ENDIF.

        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD subsequent_debitcredit.

*****************************Digital Signature*****************************

    SELECT SINGLE *
    FROM zdb_ds_ficd
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    INTO @wa_ds.

    IF wa_ds-pdfstring IS NOT INITIAL.

      r_base64 = wa_ds-pdfstring.


    ELSEIF wa_ds-pdfstring IS INITIAL.

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




        CASE sy-sysid.
          WHEN lv_dev.
            DATA(ls_body) = VALUE struct(  xdp_template = 'Subsequent_debitcredit_dev/' && |{ objectid }|
                                                       xml_data  = xmldata ).
          WHEN lv_qas.
            ls_body = VALUE struct(  xdp_template = 'Subsequent_debitcredit_dev/' && |{ objectid }|
                                                 xml_data  = xmldata ).
          WHEN lv_prd.
            ls_body = VALUE struct(  xdp_template = 'Subsequent_debitcredit_prd/' && |{ objectid }|
                                                 xml_data  = xmldata ).
        ENDCASE.

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

        IF lv_digitalsignature = 'X'.

          DATA(zclass) = NEW zcl_digital_signature( ).
          DATA(base64) = zclass->digitalsignature(
                           p_base64     = <pdf_based64_encoded>
                           p_uuid       = ''
                           p_signloc    = ''
                           p_signsize   = ''
                         ).

          wa_ds-accountingdocument = lv_accountingdocument.
          wa_ds-companycode        = lv_companycode.
          wa_ds-fiscalyear         = lv_fiscalyear.
          wa_ds-pdfstring          = base64.
          IF headertext = 'Credit Note'.
            wa_ds-filename           = |SupplierCreditNote.pdf|.
          ELSEIF headertext = 'Debit Note'.
            wa_ds-filename           = |SupplierDebitNote.pdf|.
          ENDIF.

          MODIFY zdb_ds_ficd FROM @wa_ds.
          r_base64 = base64.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD xmldata.
**********************************************************************
*
*
*********************data Declaration
    DATA : total TYPE p LENGTH 10 DECIMALS 2. "Total of Net Amount

**Supplier Address
    TYPES: BEGIN OF ty_supplieraddress,
             supplier      TYPE i_supplier-supplier,
             suppliername  TYPE i_supplier-suppliername,
             supplierstate TYPE i_supplier-districtname,
             supplieradd   TYPE string,
             suppliergst   TYPE i_supplier-taxnumber3,
           END OF ty_supplieraddress.

**Consignee Address
    TYPES: BEGIN OF ty_consigneeaddress,
             consignee      TYPE i_supplier-supplier,
             consigneename  TYPE i_supplier-suppliername,
             consigneestate TYPE i_supplier-districtname,
             consigneeadd   TYPE string,
             consigneegst   TYPE i_supplier-taxnumber3,
           END OF ty_consigneeaddress.

    DATA: supplieraddress  TYPE ty_supplieraddress.
    DATA: consigneeaddress TYPE ty_consigneeaddress.


**Item Data
    TYPES: BEGIN OF ty_item,
             srno          TYPE int4,
             material      TYPE i_purchaseorderitemapi01-material,
             materialdesc  TYPE i_producttext-productname,
             qty           TYPE i_purchaseorderitemapi01-orderquantity,
             uom           TYPE i_purchaseorderitemapi01-orderpriceunit,
             rate          TYPE zi_subsequent_debitcredit-amountincompanycodecurrency,
             taxableamount TYPE zi_subsequent_debitcredit-amountincompanycodecurrency,
             cgstrate      TYPE p LENGTH 10 DECIMALS 2,
             cgstamount    TYPE p LENGTH 10 DECIMALS 2,
             sgstrate      TYPE p LENGTH 10 DECIMALS 2,
             sgstamount    TYPE p LENGTH 10 DECIMALS 2,
             igstrate      TYPE p LENGTH 10 DECIMALS 2,
             igstamount    TYPE p LENGTH 10 DECIMALS 2,
             total         TYPE p LENGTH 10 DECIMALS 2,
             var_cgstrate  TYPE string,
             var_sgstrate  TYPE string,
             var_igstrate  TYPE string,
           END OF ty_item.

    DATA: it_item TYPE STANDARD TABLE OF ty_item,
          wa_item TYPE ty_item.

    DATA: count      TYPE int4,
          grandtotal TYPE p LENGTH 10 DECIMALS 2.

**********************************************************************
    SELECT *
    FROM zi_subsequent_debitcredit
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND purchasingdocument IS NOT INITIAL
    INTO TABLE @DATA(itemtable).

    SELECT SINGLE *
    FROM zi_subsequent_debitcredit
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND purchasingdocument IS NOT INITIAL
    INTO @DATA(header).


*************Supplier Address

    SELECT SINGLE supplier,postingkey
    FROM zi_subsequent_debitcredit
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND supplier <> ' '
    INTO @DATA(accountingdocument).


    IF accountingdocument-postingkey = 31.
      headertext = 'Credit Note'.
    ELSEIF accountingdocument-postingkey = 21.
      headertext = 'Debit note'.
    ENDIF.

    IF accountingdocument-supplier IS NOT INITIAL.
      SELECT SINGLE supplier,suppliername,_addressdefaultrepresentation~streetname,streetprefixname1,streetprefixname2,
      i_regiontext~regionname,taxnumber3,_addressdefaultrepresentation~districtname,_addressdefaultrepresentation~cityname,_addressdefaultrepresentation~postalcode
      FROM i_supplier
 LEFT JOIN i_organizationaddress WITH PRIVILEGED ACCESS
                                  AS _addressdefaultrepresentation ON  _addressdefaultrepresentation~addressid  = i_supplier~addressid
 LEFT JOIN i_regiontext                                            ON   i_regiontext~region                     = _addressdefaultrepresentation~region
                                                                  AND   i_regiontext~country                    = _addressdefaultrepresentation~country
                                                                  AND   language                                = 'E'
      WHERE supplier = @accountingdocument-supplier
      INTO @DATA(supplierdata).


    ENDIF.

    supplieraddress-supplier = supplierdata-supplier.
    SHIFT supplieraddress-supplier LEFT DELETING LEADING '0'.
    supplieraddress-suppliername = supplierdata-suppliername.
    CONCATENATE supplierdata-streetname supplierdata-streetprefixname1 supplierdata-streetprefixname2 supplierdata-districtname supplierdata-cityname supplierdata-postalcode
    INTO supplieraddress-supplieradd SEPARATED BY space.
    supplieraddress-supplierstate = supplierdata-regionname.
    supplieraddress-suppliergst = supplierdata-taxnumber3.


**********************************************************************
*************PO

    IF header-purchasingdocument IS NOT INITIAL.

      SELECT SINGLE supplier
      FROM i_purchaseorderapi01
      WHERE purchaseorder = @header-purchasingdocument
      INTO @DATA(purchaseorder_header).

*************Consignee Address



      IF purchaseorder_header IS NOT INITIAL.

        SELECT SINGLE supplier,suppliername,_addressdefaultrepresentation~streetname,streetprefixname1,streetprefixname2,
        i_regiontext~regionname,taxnumber3,_addressdefaultrepresentation~districtname,_addressdefaultrepresentation~cityname,_addressdefaultrepresentation~postalcode
        FROM i_supplier
LEFT JOIN i_organizationaddress WITH PRIVILEGED ACCESS
                                    AS _addressdefaultrepresentation ON  _addressdefaultrepresentation~addressid  = i_supplier~addressid
   LEFT JOIN i_regiontext                                            ON   i_regiontext~region                     = _addressdefaultrepresentation~region
                                                                    AND   i_regiontext~country                    = _addressdefaultrepresentation~country
                                                                    AND   language                                = 'E'
        WHERE supplier = @purchaseorder_header
        INTO @DATA(consigneedata).

      ENDIF.

      consigneeaddress-consignee = consigneedata-supplier.
      SHIFT consigneeaddress-consignee LEFT DELETING LEADING '0'.
      consigneeaddress-consigneename = consigneedata-suppliername.
      CONCATENATE consigneedata-streetname consigneedata-streetprefixname1 consigneedata-streetprefixname2
      consigneedata-districtname consigneedata-cityname consigneedata-postalcode
      INTO consigneeaddress-consigneeadd SEPARATED BY space.
      consigneeaddress-consigneestate = consigneedata-regionname.
      consigneeaddress-consigneegst   = consigneedata-taxnumber3.


********************PO (Item Table)
      SELECT purchaseorder,purchaseorderitem,orderquantity,baseunit,purchaseorderitemtext,material
      FROM i_purchaseorderitemapi01
      FOR ALL ENTRIES IN @itemtable
      WHERE purchaseorder = @itemtable-purchasingdocument
      AND purchaseorderitem = @itemtable-purchasingdocumentitem
      INTO TABLE @DATA(purchaseorder_item).

      IF purchaseorder_item[] IS NOT INITIAL.
        SELECT amountincompanycodecurrency,purchasingdocument,purchasingdocumentitem,taxcode
        FROM zi_subsequent_debitcredit
        FOR ALL ENTRIES IN @purchaseorder_item
        WHERE
         purchasingdocument = @purchaseorder_item-purchaseorder
         AND purchasingdocumentitem = @purchaseorder_item-purchaseorderitem
         AND accountingdocument = @lv_accountingdocument
        INTO TABLE @DATA(po_item).
      ENDIF.

      LOOP AT purchaseorder_item INTO DATA(wa_purchaseorder).
        count = count + 1.
        wa_item-srno         = count.
        wa_item-material     = wa_purchaseorder-material.
        SHIFT wa_item-material LEFT DELETING LEADING '0'.
        wa_item-materialdesc = wa_purchaseorder-purchaseorderitemtext.
        wa_item-qty          = wa_purchaseorder-orderquantity.
        wa_item-uom          = wa_purchaseorder-baseunit.

        READ TABLE po_item INTO DATA(wa_po) WITH KEY  purchasingdocument     = wa_purchaseorder-purchaseorder
                                                      purchasingdocumentitem = wa_purchaseorder-purchaseorderitem.

        wa_item-taxableamount = wa_po-amountincompanycodecurrency.
        IF wa_item-taxableamount < 0.
          wa_item-taxableamount = wa_item-taxableamount * -1.
        ENDIF.
        wa_item-rate = wa_item-taxableamount / wa_item-qty.


        DATA(code) = wa_po-taxcode+1(1).

        CASE code.
          WHEN 0.
            wa_item-igstrate = '0.00'.
            wa_item-igstamount = ( wa_item-igstrate * wa_item-taxableamount ) / 100.
          WHEN 'A'.
            wa_item-cgstrate = '0.00'.
            wa_item-sgstrate = '0.00'.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
          WHEN 'B'.
            wa_item-cgstrate = '0.00'.
            wa_item-sgstrate = '0.00'.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
          WHEN 'C'.
            wa_item-cgstrate = '0.00'.
            wa_item-sgstrate = '0.00'.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 'I'.
            wa_item-cgstrate = '0.00'.
            wa_item-sgstrate = '0.00'.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 1.
            wa_item-cgstrate = '2.50'.
            wa_item-sgstrate = '2.50'.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 2.
            wa_item-cgstrate = 6.
            wa_item-sgstrate = 6.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 3.
            wa_item-cgstrate = 9.
            wa_item-sgstrate = 9.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 4.
            wa_item-cgstrate = 14.
            wa_item-sgstrate = 14.

            wa_item-cgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.
            wa_item-sgstamount = ( wa_item-cgstrate * wa_item-taxableamount ) / 100.

          WHEN 5.
            wa_item-igstrate = 5.
            wa_item-igstamount = ( wa_item-igstrate * wa_item-taxableamount ) / 100.
          WHEN 6.
            wa_item-igstrate = 12.
            wa_item-igstamount = ( wa_item-igstrate * wa_item-taxableamount ) / 100.
          WHEN 7.
            wa_item-igstrate = 18.
            wa_item-igstamount = ( wa_item-igstrate * wa_item-taxableamount ) / 100.
          WHEN 8.
            wa_item-igstrate = 28.
            wa_item-igstamount = ( wa_item-igstrate * wa_item-taxableamount ) / 100.
        ENDCASE.

        wa_item-var_cgstrate = wa_item-cgstrate.
        wa_item-var_igstrate = wa_item-igstrate.

        CONCATENATE wa_item-var_cgstrate '%' INTO wa_item-var_cgstrate SEPARATED BY space.
        CONCATENATE wa_item-var_igstrate '%' INTO wa_item-var_igstrate SEPARATED BY space.

        wa_item-var_sgstrate = wa_item-var_cgstrate.

        wa_item-total = wa_item-taxableamount + wa_item-cgstamount + wa_item-sgstamount + wa_item-igstamount.
        grandtotal = grandtotal + wa_item-total.

        APPEND wa_item TO it_item.
        CLEAR wa_item.
      ENDLOOP.



**********************************************************************

      DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

      CALL TRANSFORMATION ztr_subsequent_debitcredit  SOURCE header                   = header
                                                             headertext               = headertext
                                                             supplieraddress          = supplieraddress
                                                             consigneeaddress         = consigneeaddress
                                                             item                     = it_item[]
                                                             grandtotal               = grandtotal
                                             RESULT XML lo_xml_conv.

      DATA(lv_output_xml) = lo_xml_conv->get_output( ).

      DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

      r_xml = ls_data_xml.


    ENDIF.



  ENDMETHOD.
ENDCLASS.
