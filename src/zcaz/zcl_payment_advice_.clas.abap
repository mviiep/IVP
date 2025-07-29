CLASS zcl_payment_advice_ DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
*
*
*********************data Declaration
    DATA : total TYPE p LENGTH 10 DECIMALS 2. "Total of Net Amount

**Supplier Address
    TYPES: BEGIN OF ty_supplieraddress,
             supplier     TYPE i_supplier-supplier,
             suppliername TYPE i_supplier-suppliername,
             supplieradd  TYPE string,
             suppliermail TYPE i_addressemailaddress_2-emailaddress,
           END OF ty_supplieraddress.

    DATA: supplieraddress TYPE ty_supplieraddress.


**Supplier Address
    TYPES: BEGIN OF ty_item,
             documentreferenceid TYPE zi_payment_advice-documentreferenceid,
             postingdate         TYPE zi_payment_advice-postingdate,
             companycodecurrency TYPE zi_payment_advice-companycodecurrency,
             tdsdeduction        TYPE zi_payment_advice-tdsdeduction,
             netamount           TYPE zi_payment_advice-netamount,
             grossamount         TYPE zi_payment_advice-grossamount,
           END OF ty_item.

    DATA: wa_item TYPE ty_item,
          item    TYPE STANDARD TABLE OF ty_item.

    DATA:totalsum          TYPE p LENGTH 10 DECIMALS 3,
         paymenttotal      TYPE p LENGTH 10 DECIMALS 3,
         headertotal       TYPE p LENGTH 10 DECIMALS 3,
         totalnetamount    TYPE p LENGTH 10 DECIMALS 3,
         paymentdifference TYPE p LENGTH 10 DECIMALS 3.


**********************************************************************
    DATA: r_token TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8,
          lv_dev(3) TYPE c VALUE 'JNY',
          lv_qas(3) TYPE c VALUE 'JF4',
          lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA:
      lv_companycode          TYPE i_journalentryitem-companycode,
      lv_clearingjournalentry TYPE i_journalentryitem-clearingjournalentry,
      lv_clearingfiscalyear   TYPE i_journalentryitem-clearingjournalentryfiscalyear,
      lv_email(1)             TYPE c.

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
    METHODS paymentadvice
      RETURNING VALUE(r_base64) TYPE string.


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAYMENT_ADVICE_ IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PaymentAdvice_Dev' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PaymentAdvice_Dev' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PaymentAdvice_Prd' ).
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'clearingjournalentry'.
    lv_clearingjournalentry = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'companycode' .
    lv_companycode = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'clearingfiscalyear' .
    lv_clearingfiscalyear = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'email'.
    IF sy-subrc EQ 0.
      lv_email = ls_params-value.
    ENDIF.

    IF lv_clearingjournalentry IS NOT INITIAL AND lv_companycode IS NOT INITIAL AND lv_clearingfiscalyear IS NOT INITIAL.
      TRY.
          response->set_text( paymentadvice( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD paymentadvice.

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
          DATA(ls_body) = VALUE struct(  xdp_template = 'PaymentAdvice_Dev/' && |{ objectid }|
                                                     xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'PaymentAdvice_Dev/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'PaymentAdvice_Prd/' && |{ objectid }|
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

    ENDIF.


**********************************************************************
**Email
**********************************************************************


    IF lv_email IS NOT INITIAL.

      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          DATA(ld_mail_content) = ``.

          DATA : addsender    TYPE cl_bcs_mail_message=>ty_address,
                 addrecipient TYPE cl_bcs_mail_message=>ty_address,
                 addcc        TYPE cl_bcs_mail_message=>ty_address,
                 sender       TYPE cl_bcs_mail_message=>ty_address.


**Sender
          addsender = 'ivpap@ivpindia.com'.
          lo_mail->set_sender( iv_address = addsender ). "IVP


**Receiver
          addrecipient = supplieraddress-suppliermail.

          IF addrecipient IS NOT INITIAL.
            lo_mail->add_recipient( iv_address = addrecipient iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
          ENDIF.



**CC Person
          addcc =  'ivpap@ivpindia.com'.


          IF addcc IS NOT INITIAL.
            lo_mail->add_recipient( iv_address = addcc iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.


**Attachment
          DATA(pdfxstring) = cl_web_http_utility=>decode_x_base64( encoded = r_base64 ).

          lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
                                     iv_content      = pdfxstring
                                     iv_content_type = 'text/plain'
                                     iv_filename     = 'PaymentAdvice.pdf'
                                   ) ).


**Subject of Email
          lo_mail->set_subject( | Payment Advice | ).


**Body of Email
          DATA:lv_content TYPE string.

          lv_content = | <p>Dear { supplieraddress-suppliername }, </p>| &&
|<p>We are writing to inform you that payment has been processed. The details of the payment are hereby annexed for your information and records.</p><p>Please confirm receipt of this payment. If yo| &&
|u have any questions or if there are discrepancies in the information, feel free to reach out to us at <a href="mailto:ivpap@ivpindia.com">ivpap@ivpindia.com</a>.</p><p>Thank you for your continued partnership.</p><p>Best regards,</br>IVP Payable| &&
|s Team</p>|.


          lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                  iv_content      = lv_content
                  iv_content_type = 'text/html'
                   ) ).

**Send Mail
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
        CATCH cx_bcs_mail INTO DATA(lx_mail).
          "handle exception

      ENDTRY.


    ENDIF.

**********************************************************************

  ENDMETHOD.


  METHOD xmldata.

    SELECT SINGLE *
    FROM zi_payment_advice
    WHERE clearingjournalentry = @lv_clearingjournalentry
      AND clearingjournalentryfiscalyear = @lv_clearingfiscalyear
      AND companycode = @lv_companycode
    INTO  @DATA(header).

    SELECT SINGLE *
       FROM i_journalentry
       WHERE accountingdocument = @lv_clearingjournalentry
         AND fiscalyear = @lv_clearingfiscalyear
         AND companycode = @lv_companycode
       INTO  @DATA(partial_header_).

    header-accountingdocumentheadertext = partial_header_-accountingdocumentheadertext.

*************Supplier Address
    IF header IS NOT INITIAL.

      supplieraddress-supplier     = header-supplier.
      SHIFT supplieraddress-supplier LEFT DELETING LEADING '0'.
      supplieraddress-suppliername = header-suppliername.
      CONCATENATE header-streetname header-streetprefixname1 header-streetprefixname2 header-districtname header-cityname header-postalcode
      INTO supplieraddress-supplieradd SEPARATED BY space.
      supplieraddress-suppliermail = header-emailaddress.

*************Supplier Bank Details

      SELECT SINGLE i_suplrbankdetailsbyintid~bankaccountholdername,i_suplrbankdetailsbyintid~bankaccount,i_bank_2~bankname,
      i_suplrbankdetailsbyintid~bank
      FROM i_suplrbankdetailsbyintid
  LEFT JOIN i_bank_2 ON i_suplrbankdetailsbyintid~bank = i_bank_2~bankinternalid
      WHERE supplier = @header-supplier
      INTO @DATA(supplierbankdetails).

    ENDIF.
*************Item Data

    SELECT documentreferenceid,postingdate,companycodecurrency,tdsdeduction,netamount,grossamount
     FROM zi_payment_advice
     WHERE clearingjournalentry = @lv_clearingjournalentry
       AND clearingjournalentryfiscalyear = @lv_clearingfiscalyear
       AND companycode = @lv_companycode
     INTO TABLE @item.

    SELECT SINGLE amountincompanycodecurrency,accountingdocument,postingdate,companycodecurrency,withholdingtaxamount
    FROM i_operationalacctgdocitem
    WHERE accountingdocument = @lv_clearingjournalentry
      AND fiscalyear = @lv_clearingfiscalyear
      AND companycode = @lv_companycode
    INTO @DATA(wa).


    SELECT SINGLE *
       FROM i_operationalacctgdocitem AS _operationalacctgdocitem
 LEFT OUTER JOIN i_journalentry       AS _journalentry ON _journalentry~accountingdocument   = _operationalacctgdocitem~accountingdocument
                                                      AND _journalentry~fiscalyear           = _operationalacctgdocitem~fiscalyear
                                                      AND _journalentry~companycode          = _operationalacctgdocitem~companycode

       WHERE _operationalacctgdocitem~accountingdocument   = @lv_clearingjournalentry
         AND _operationalacctgdocitem~fiscalyear           = @lv_clearingfiscalyear
         AND _operationalacctgdocitem~companycode          = @lv_companycode
         AND _operationalacctgdocitem~financialaccounttype = 'K'
       INTO  @DATA(partial_header).

    SELECT SINGLE *
       FROM i_journalentry
       WHERE accountingdocument = @lv_clearingjournalentry
         AND fiscalyear = @lv_clearingfiscalyear
         AND companycode = @lv_companycode
       INTO  @partial_header_.

    IF partial_header IS NOT INITIAL.
      IF header-clearingjournalentry IS INITIAL.
        wa-postingdate                       = partial_header-_operationalacctgdocitem-postingdate.
        header-clearingjournalentry          = partial_header-_operationalacctgdocitem-accountingdocument.
        header-companycodecurrency           = partial_header-_operationalacctgdocitem-companycodecurrency.
        header-accountingdocumentheadertext  = partial_header-_journalentry-accountingdocumentheadertext.
        total                                = partial_header-_operationalacctgdocitem-amountincompanycodecurrency.

        SELECT SINGLE accountingdocumentheadertext
        FROM i_journalentry
        WHERE accountingdocument = @lv_clearingjournalentry
        AND fiscalyear           = @lv_clearingfiscalyear
        AND companycode          = @lv_companycode
        INTO @header-accountingdocumentheadertext.

        SELECT SINGLE *
        FROM i_supplier
        LEFT OUTER JOIN i_organizationaddress WITH PRIVILEGED ACCESS
        AS _addressdefaultrepresentation  ON i_supplier~addressid = _addressdefaultrepresentation~addressid
        AND _addressdefaultrepresentation~addressrepresentationcode IS INITIAL
        LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS
        AS _emailaddress                  ON  _emailaddress~addressid       = _addressdefaultrepresentation~addressid
                                          AND _emailaddress~addresspersonid = _addressdefaultrepresentation~addresspersonid
    WHERE supplier = @partial_header-_operationalacctgdocitem-supplier
    INTO @DATA(partial_supplier_address).

        supplieraddress-supplier     = partial_supplier_address-i_supplier-supplier.
        SHIFT supplieraddress-supplier LEFT DELETING LEADING '0'.
        supplieraddress-suppliername = partial_supplier_address-i_supplier-suppliername.
        CONCATENATE partial_supplier_address-_addressdefaultrepresentation-streetname partial_supplier_address-_addressdefaultrepresentation-streetprefixname1
        partial_supplier_address-_addressdefaultrepresentation-streetprefixname2 partial_supplier_address-_addressdefaultrepresentation-districtname
        partial_supplier_address-_addressdefaultrepresentation-cityname partial_supplier_address-_addressdefaultrepresentation-postalcode
        INTO supplieraddress-supplieradd SEPARATED BY space.
        supplieraddress-suppliermail = partial_supplier_address-_emailaddress-emailaddress.

*************Supplier Bank Details

        SELECT SINGLE i_suplrbankdetailsbyintid~bankaccountholdername,i_suplrbankdetailsbyintid~bankaccount,i_bank_2~bankname,
        i_suplrbankdetailsbyintid~bank
        FROM i_suplrbankdetailsbyintid
    LEFT JOIN i_bank_2 ON i_suplrbankdetailsbyintid~bank = i_bank_2~bankinternalid
        WHERE supplier = @partial_header-_operationalacctgdocitem-supplier
        INTO @supplierbankdetails.

      ENDIF.
*************Item Data for partial payment

      SELECT  *
         FROM i_operationalacctgdocitem
         WHERE accountingdocument = @lv_clearingjournalentry
           AND fiscalyear = @lv_clearingfiscalyear
           AND companycode = @lv_companycode
           AND financialaccounttype = 'K'
           AND invoicereference <> ' '
         INTO TABLE @DATA(partial_item).

      IF partial_item IS NOT INITIAL.
        SELECT accountingdocument,documentreferenceid,postingdate,companycodecurrency,tdsdeduction,netamount,grossamount
        FROM zi_payment_advice_partial
        FOR ALL ENTRIES IN @partial_item
        WHERE accountingdocument = @partial_item-invoicereference
          AND FiscalYear         = @partial_item-InvoiceReferenceFiscalYear
          AND companycode        = @lv_companycode
          AND Supplier           = @partial_item-Supplier
          AND financialaccounttype = 'K'
        INTO TABLE @DATA(invoicereference_item).
      ENDIF.


      LOOP AT invoicereference_item INTO DATA(invoicereference_wa).
        wa_item-companycodecurrency = invoicereference_wa-companycodecurrency.
        wa_item-documentreferenceid = invoicereference_wa-documentreferenceid.

        SELECT SINGLE amountincompanycodecurrency
        FROM i_operationalacctgdocitem
        WHERE accountingdocument = @invoicereference_wa-accountingdocument
        AND fiscalyear         = @lv_clearingfiscalyear
        AND companycode        = @lv_companycode
        AND transactiontypedetermination = 'WIT'
        INTO @DATA(partial_tdsamt).

        wa_item-tdsdeduction        = partial_tdsamt.
        wa_item-grossamount         = invoicereference_wa-netamount + wa_item-tdsdeduction.
        wa_item-netamount           =  invoicereference_wa-netamount.
        wa_item-postingdate         = invoicereference_wa-postingdate.

        APPEND wa_item TO item.
        CLEAR wa_item.
      ENDLOOP.

    ENDIF.

*************TotalSum

    SELECT SUM( netamount ) AS totalnetamount
    FROM @item AS item
    INTO @totalnetamount.

    IF totalnetamount IS NOT INITIAL.
      totalsum = totalnetamount.
    ENDIF.


*************PaymentTotal

    SELECT SUM( netpaymentamount )
    FROM i_operationalacctgdocitem
    WHERE accountingdocument = @lv_clearingjournalentry
      AND fiscalyear = @lv_clearingfiscalyear
      AND companycode = @lv_companycode
      AND netpaymentamount <> 0
    INTO @DATA(totalamount).

    IF totalamount < 0.
      paymenttotal = totalamount * -1.
    ENDIF.


*************PaymentDifference

    IF totalnetamount < 0.
      totalnetamount = totalnetamount * -1.
    ENDIF.

    IF partial_header IS NOT INITIAL AND header-clearingjournalentry IS INITIAL.
      paymenttotal   = partial_header-_operationalacctgdocitem-amountincompanycodecurrency.
    ELSE.
      paymenttotal   = totalamount.
    ENDIF.

    IF totalsum < 0 AND paymenttotal > 0.
      paymentdifference    = totalsum + paymenttotal.
    ELSEIF totalsum > 0.
      paymentdifference    = totalsum - paymenttotal.
    ENDIF.





**********************************************************************


    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_paymentadvice  SOURCE header                   = header
                                                  wa                       = wa
                                                  supplieraddress          = supplieraddress
                                                  supplierbankdetails      = supplierbankdetails
                                                  item                     = item[]
                                                  total                    = total
                                                  paymentdifference        = paymentdifference
                                                  totalsum                 = totalsum
                                                  paymenttotal             = paymenttotal
                                           RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.


  ENDMETHOD.
ENDCLASS.
