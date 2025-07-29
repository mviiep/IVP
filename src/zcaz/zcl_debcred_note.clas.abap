CLASS zcl_debcred_note DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: r_token TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY',
          lv_qas(3) TYPE c VALUE 'JF4',
          lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA lv_md TYPE z_debitcredit_note-accountingdocument.
    DATA lv_year TYPE z_debitcredit_note-fiscalyear.
    DATA lv_com TYPE z_debitcredit_note-companycode.

    DATA:
      mo_http_destination TYPE REF TO if_http_destination,
      mv_client           TYPE REF TO if_web_http_client.

    METHODS post_base64 RETURNING VALUE(r_base64) TYPE string.
    METHODS get_data IMPORTING documentnumber TYPE z_debitcredit_note-accountingdocument
                               fiscalyear     TYPE z_debitcredit_note-fiscalyear
                               companycode    TYPE z_debitcredit_note-companycode
                     RETURNING VALUE(r_data)  TYPE string.
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEBCRED_NOTE IMPLEMENTATION.


  METHOD get_data.

**********************************************************************
**Data Declaration
**********************************************************************

    TYPES:BEGIN OF ty_final,
            accountingdocument     TYPE z_debitcredit_note-accountingdocument,
            hsncode                TYPE z_debitcredit_note-hsncode,
            documentitemtext       TYPE z_debitcredit_note-documentitemtext,
            cgstrate(10)           TYPE c,
            igstrate(10)           TYPE c,
            cgst                   TYPE z_debitcredit_note-cgst,
            igst                   TYPE z_debitcredit_note-igst,
            tds                    TYPE z_debitcredit_note-tds,
            taxcode                TYPE z_debitcredit_note-taxcode,
            taxable                TYPE z_debitcredit_note-taxable,
            total                  TYPE z_debitcredit_note-taxable,
            accountingdocumenttype TYPE z_debitcredit_note-accountingdocumenttype,
          END OF ty_final.

    DATA:it_final TYPE STANDARD TABLE OF ty_final,
         wa_final TYPE ty_final.

    DATA code(1) TYPE c.
**********************************************************************

    SELECT SINGLE accountingdocumenttype
        FROM i_operationalacctgdocitem
        WHERE accountingdocument = @documentnumber
        INTO @DATA(lv_type).

    IF lv_type = 'KR' OR  lv_type = 'KG'.

      SELECT SINGLE suppliername,pannumber,gst,accountingdocument,postingdate,supplier1,addresss1,bpaddrstreetname,documenttext
       FROM z_debitcredit_note
           WHERE accountingdocument =  @documentnumber
              AND  fiscalyear = @fiscalyear
              AND companycode = @companycode
              INTO @DATA(wa_header).

      SELECT DISTINCT accountingdocument, accountingdocumentitem, hsncode,documentitemtext,cgst,igst,tds,taxcode,taxable,accountingdocumenttype,taxcondition
          FROM z_debitcredit_note
          WHERE accountingdocument =  @documentnumber
          AND  fiscalyear = @fiscalyear
          AND companycode = @companycode
          INTO TABLE @DATA(it_item).

      LOOP AT it_item INTO DATA(wa_item).
        wa_final-accountingdocument   = wa_item-accountingdocument.
        wa_final-hsncode              = wa_item-hsncode.
        wa_final-documentitemtext     = wa_item-documentitemtext.
        case wa_item-taxcode.
            when 'R1' or 'R2' or 'R3' or 'R4' or 'R5' or 'R6' or 'R7' or 'R8' .
        when others.
        wa_final-cgst                 = wa_item-cgst.
        wa_final-igst                 = wa_item-igst.
        ENDCASE.
        wa_final-tds                  = wa_item-tds.
        wa_final-taxcode              = wa_item-taxcode.
        IF wa_item-taxable < 1.
          wa_final-taxable              = wa_item-taxable * -1.
        ELSE.
          wa_final-taxable              = wa_item-taxable.
        ENDIF.

        code = wa_final-taxcode+1(1).
        data(lv_let) = wa_final-taxcode+0(1).

        IF wa_final-taxcode <> 'F1' AND  wa_final-taxcode <> 'E1' AND  wa_final-taxcode <> 'E2'
            and lv_let <> 'B' and lv_let <> 'R'.

          CASE code.
            WHEN '0'.
              wa_final-igstrate = '0.00%'.

            WHEN 'A'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'B'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'C'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'D'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'I'.
              wa_final-cgstrate = '0.00%'.

            WHEN '1'.
              wa_final-cgstrate = '2.50%'.

            WHEN '2'.
              wa_final-cgstrate = '6%'.

            WHEN '3'.
              wa_final-cgstrate = '9%'.

            WHEN '4'.
              wa_final-cgstrate = '14%'.

            WHEN '5'.
              wa_final-igstrate = '5%'.

            WHEN '6'.
              wa_final-igstrate = '12%'.

            WHEN '7'.
              wa_final-igstrate = '18%'.

            WHEN '8'.
              wa_final-igstrate = '28%'.
            WHEN OTHERS.
          ENDCASE.

        ELSEIF wa_final-taxcode = 'F1'.
          CASE code.
            WHEN '1'.
              wa_final-cgstrate = '0.05%'.
          ENDCASE.

        ELSEIF wa_final-taxcode = 'E1' OR wa_final-taxcode = 'E2'.
          CASE code.
            WHEN '1'.
              wa_final-igstrate = '0.10%'.
            WHEN '2'.
              wa_final-igstrate = '18.00%'.
          ENDCASE.
        ENDIF.

        CASE wa_item-taxcondition.
          WHEN 'JCN' OR 'JIN'.
            wa_final-total = wa_final-taxable - ( ( wa_final-cgst * 2 ) + wa_final-igst ).
          WHEN 'JIC' OR 'JII'.
            wa_final-total = wa_final-taxable + ( ( wa_final-cgst * 2 ) + wa_final-igst ).
          WHEN ''.
            wa_final-total = wa_final-taxable.
        ENDCASE.

        IF wa_final-total < 0 .
          wa_final-total = wa_final-total * -1.
        ENDIF.

        wa_final-accountingdocumenttype = wa_item-accountingdocumenttype.

        APPEND wa_final TO it_final.
        CLEAR wa_final.

      ENDLOOP.

    ELSEIF lv_type = 'DR' OR  lv_type = 'DG'.

      SELECT SINGLE suppliername,pannumber,gst,accountingdocument,postingdate,supplier1,addresss1,bpaddrstreetname,documenttext
      FROM z_credit_note
        WHERE accountingdocument =  @documentnumber
          AND  fiscalyear = @fiscalyear
          AND companycode = @companycode
          AND customer1 <> '' INTO @wa_header.

      SELECT DISTINCT *
      FROM z_credit_note
      WHERE accountingdocument =  @documentnumber
      AND  fiscalyear = @fiscalyear
      AND companycode = @companycode
      AND customer1 = '' INTO TABLE @DATA(it_item1).

      DELETE ADJACENT DUPLICATES FROM it_item1.

      LOOP AT it_item1 INTO DATA(wa_item1).
        wa_final-accountingdocument   = wa_item1-accountingdocument.
        wa_final-hsncode              = wa_item1-hsncode.
        wa_final-documentitemtext     = wa_item1-documentitemtext.
        wa_final-cgst                 = wa_item1-cgst.
        wa_final-igst                 = wa_item1-igst.
        wa_final-tds                  = wa_item1-tds.
        wa_final-taxcode              = wa_item1-taxcode.
        wa_final-taxable              = wa_item1-taxable.

        code = wa_final-taxcode+1(1).

        IF wa_final-taxcode <> 'F1' AND  wa_final-taxcode <> 'E1' AND  wa_final-taxcode <> 'E2'.

          CASE code.
            WHEN '0'.
              wa_final-igstrate = '0.00%'.

            WHEN 'A'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'B'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'C'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'D'.
              wa_final-cgstrate = '0.00%'.

            WHEN 'I'.
              wa_final-cgstrate = '0.00%'.

            WHEN '1'.
              wa_final-cgstrate = '2.50%'.

            WHEN '2'.
              wa_final-cgstrate = '6%'.

            WHEN '3'.
              wa_final-cgstrate = '9%'.

            WHEN '4'.
              wa_final-cgstrate = '14%'.

            WHEN '5'.
              wa_final-igstrate = '5%'.

            WHEN '6'.
              wa_final-igstrate = '12%'.

            WHEN '7'.
              wa_final-igstrate = '18%'.

            WHEN '8'.
              wa_final-igstrate = '28%'.
            WHEN OTHERS.
          ENDCASE.

        ELSEIF wa_final-taxcode = 'F1'.
          CASE code.
            WHEN '1'.
              wa_final-cgstrate = '0.05%'.
          ENDCASE.

        ELSEIF wa_final-taxcode = 'E1' OR wa_final-taxcode = 'E2'.
          CASE code.
            WHEN '1'.
              wa_final-igstrate = '0.10%'.
            WHEN '2'.
              wa_final-igstrate = '18.00%'.
          ENDCASE.
        ENDIF.

        CASE wa_item1-taxcondition.
          WHEN 'JCN' OR 'JIN' OR 'JOI'.
            wa_final-total = wa_final-taxable - ( ( wa_final-cgst * 2 ) - wa_final-igst ).
          WHEN 'JIC' OR 'JII' OR 'JOC'.
            wa_final-total = wa_final-taxable + ( ( wa_final-cgst * 2 ) + wa_final-igst ) .
          WHEN ''.
            wa_final-total = wa_final-taxable.
        ENDCASE.


        IF wa_final-total < 0 .
          wa_final-total = wa_final-total * -1.
        ENDIF.

        wa_final-accountingdocumenttype = wa_item1-accountingdocumenttype.

        APPEND wa_final TO it_final.
        CLEAR wa_final.

      ENDLOOP.
    ENDIF.

    DELETE it_final[] WHERE taxable = 0.

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_debcred_note SOURCE wa_header   = wa_header
                                                it_item     = it_final[]
                                         RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).
    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).
    r_data = ls_data_xml.

  ENDMETHOD.


  METHOD get_obj.

    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    r_token = tokenmethod->token( ).


    DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    CASE sy-sysid.
      WHEN lv_dev.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/FIdebitcredit_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/FIdebitcredit_DEV' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/FIdebitcredit_PRD' ).
    ENDCASE.

    lo_request->set_header_fields( VALUE #(
                (  name = 'Authorization' value =  | { r_token } | )
                ) ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error.
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
    READ TABLE lt_params INTO DATA(wa_so) WITH KEY name = 'documentnumber'   .
    lv_md = wa_so-value.
    READ TABLE lt_params INTO wa_so WITH KEY name = 'fiscalyear' .
    lv_year = wa_so-value.
    READ TABLE lt_params INTO wa_so WITH KEY name = 'companycode' .
    lv_com = wa_so-value.

    IF lv_md IS NOT INITIAL AND lv_year IS NOT INITIAL AND lv_com IS NOT INITIAL.
      response->set_text( post_base64( ) ).
    ENDIF.
  ENDMETHOD.


  METHOD post_base64.
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

    DATA(xmldata) = me->get_data( documentnumber = lv_md  fiscalyear = lv_year  companycode = lv_com ).
    DATA(objectid)    = me->get_obj( ).

    IF objectid IS NOT INITIAL AND xmldata IS NOT INITIAL AND r_token IS NOT INITIAL.

      DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
      DATA: lo_http_client TYPE REF TO if_web_http_client.

      TRY.
          lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination =
          cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error.
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
          DATA(ls_body) = VALUE struct(  xdp_template = 'FIdebitcredit_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'FIdebitcredit_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'FIdebitcredit_PRD/' && |{ objectid }|
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
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
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
ENDCLASS.
