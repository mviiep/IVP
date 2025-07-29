CLASS zcl_petty_cash_voucher DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
**data Declaration
    DATA: r_token TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA lv_accountingdocument TYPE zi_petty_cash-accountingdocument.
    DATA lv_companycode TYPE zi_petty_cash-companycode.
    DATA lv_fiscalyear TYPE zi_petty_cash-fiscalyear.

**********************************************************************
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.

    METHODS pettycash RETURNING VALUE(r_base64) TYPE string
                      RAISING
                                cx_web_http_client_error
                                cx_http_dest_provider_error.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PETTY_CASH_VOUCHER IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PETTYCASH_Dev' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PETTYCASH_Dev' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/PETTYCASH_PRD' ).
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'documentnumber'.
    lv_accountingdocument = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'companycode' .
    lv_companycode = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'fiscalyear' .
    lv_fiscalyear = ls_params-value.

    IF lv_accountingdocument IS NOT INITIAL AND lv_companycode IS NOT INITIAL AND lv_fiscalyear IS NOT INITIAL.
      TRY.
          response->set_text( pettycash( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD pettycash.
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
          DATA(ls_body) = VALUE struct(  xdp_template = 'PETTYCASH_Dev/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'PETTYCASH_Dev/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'PETTYCASH_PRD/' && |{ objectid }|
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
  ENDMETHOD.


  METHOD xmldata.

    SELECT SINGLE accountingdocument,postingdate,plant,plantname,narration
    FROM zi_petty_cash
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND accountcode <> ' '
    INTO @DATA(header).

    SELECT SINGLE *
    FROM zi_petty_cash
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND accountingdocumenttype = 'KZ'
    AND glaccounttype = 'C'
    INTO @DATA(kzammount).

    SELECT *
    FROM zi_petty_cash
    WHERE accountingdocument = @lv_accountingdocument
    AND companycode = @lv_companycode
    AND fiscalyear = @lv_fiscalyear
    AND accountcode <> ' '
    ORDER BY ledgergllineitem
    INTO TABLE @DATA(item).

    IF kzammount-accountingdocumenttype = 'KZ' AND kzammount IS NOT INITIAL .
      IF kzammount-amountintransactioncurrency < 0.
        kzammount-amountintransactioncurrency = kzammount-amountintransactioncurrency * -1.
      ENDIF.

      MODIFY item FROM kzammount INDEX 1 TRANSPORTING amountintransactioncurrency.
    ENDIF.

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_pettycash  SOURCE header                   = header
                                              item                     = item[]
                                              RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.


  ENDMETHOD.
ENDCLASS.
