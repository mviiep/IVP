CLASS zcl_label_fg DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
**data Declaration
    DATA: r_token TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_QAS(3) TYPE c VALUE 'CM4'.
    DATA :lv_PRD(3) TYPE c VALUE 'CU4'.

    DATA:
      lv_ProcessOrder TYPE i_manufacturingorder-ManufacturingOrder,
      lv_drumno       TYPE int4.



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
      RETURNING VALUE(r_XML) TYPE string.



    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS LabelPrint
      RETURNING VALUE(r_base64) TYPE string.


    METHODS zcomm
      IMPORTING product      TYPE i_product-Product
      RETURNING VALUE(r_val) TYPE string.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LABEL_FG IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/QMLABELFG_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/QMLABELFG_DEV' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/QMLABELFG_PRD' ).
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'processorder'.
    lv_ProcessOrder = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'drumno'.
    lv_drumno = ls_params-value.

    IF lv_ProcessOrder IS NOT INITIAL.

      TRY.
          response->set_text( labelprint( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD labelprint.

*****************************POST METHOD*****************************
    TYPES :
      BEGIN OF struct,
        xdp_Template     TYPE string,
        xml_Data         TYPE string,
        form_Type        TYPE string,
        form_Locale      TYPE string,
        tagged_Pdf       TYPE string,
        embed_Font       TYPE string,
        changeNotAllowed TYPE string,
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
        CATCH cx_web_http_client_error cx_http_dest_provider_error.
          "handle exception
      ENDTRY.

      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_uri_path( i_uri_path = '/v1/adsRender/pdf' ).
      lo_request->set_query( query =  'templateSource=storageId' ).

      lo_request->set_header_fields(  VALUE #(
                 (  name = 'Content-Type' Value = 'application/json' )
                 (  name = 'Accept' Value = 'application/json' )
                  )  ).

      lo_request->set_header_fields(  VALUE #(
                      (  name = 'Authorization' Value =  | { r_token } | )
                      ) ).




      CASE sy-sysid.
        WHEN lv_dev.
          DATA(ls_body) = VALUE struct(  xdp_Template = 'QMLABELFG_DEV/' && |{ objectid }|
                                               xml_Data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_Template = 'QMLABELFG_DEV/' && |{ objectid }|
                                               xml_Data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_Template = 'QMLABELFG_DEV/' && |{ objectid }|
                                               xml_Data  = xmldata ).
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

*      DO 99 TIMES.
*        CONCATENATE r_base64 <pdf_based64_encoded> INTO r_base64 SEPARATED BY cl_abap_char_utilities=>cr_lf.
*      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD xmldata.


*    SELECT SINGLE i_manufacturingorder~ProductionPlant, i_productdescription_2~productdescription,i_manufacturingorder~Batch,
*    i_batchdistinct~manufacturedate,i_batchdistinct~shelflifeexpirationdate,
*    i_product~Grossweight,i_product~netweight,i_product~productionorinspectionmemotxt,i_product~product,i_product~baseunit
*    FROM i_manufacturingorder
*    JOIN i_productdescription_2 ON i_productdescription_2~Product = i_manufacturingorder~Product
*    JOIN i_batchdistinct        ON i_batchdistinct~Batch          = i_manufacturingorder~Batch
*    JOIN i_product              ON i_product~Product              = i_manufacturingorder~Product
*    WHERE manufacturingOrder = @lv_processorder
*    INTO @DATA(wa_manufacturing).


SELECT SINGLE
  i_manufacturingorder~ProductionPlant,
  i_productdescription_2~ProductDescription,
  i_manufacturingorder~Batch,
  i_batchdistinct~ManufactureDate,
  i_batchdistinct~ShelfLifeExpirationDate,
  zc_zfg_table~gr_wt    AS GrossWeight,
  zc_zfg_table~net_wt   AS NetWeight,
  i_product~ProductionOrInspectionMemoTxt,
  i_product~Product,
  zc_zfg_table~uom_m    AS BaseUnit
FROM i_manufacturingorder
  JOIN i_productdescription_2 ON i_productdescription_2~Product = i_manufacturingorder~Product
  JOIN i_batchdistinct        ON i_batchdistinct~Batch          = i_manufacturingorder~Batch
  JOIN i_product              ON i_product~Product              = i_manufacturingorder~Product
  LEFT JOIN zc_zfg_table      ON zc_zfg_table~mcode             = i_manufacturingorder~Product
WHERE i_manufacturingorder~ManufacturingOrder = @lv_processorder
INTO @DATA(wa_manufacturing).



*****Plant
    SELECT SINGLE AddressID FROM I_Plant
    WHERE plant EQ @wa_manufacturing-ProductionPlant
    INTO @DATA(plantaddid).

    IF plantaddid IS NOT INITIAL.

      SELECT SINGLE *
       FROM i_address_2 WITH PRIVILEGED ACCESS
            WHERE i_address_2~addressid  = @plantaddid
            INTO @DATA(wa_Plantaddress_test).

      SELECT SINGLE i_address_2~StreetSuffixName1,i_address_2~StreetSuffixName2,i_address_2~AddresseeFullName,
      i_address_2~StreetName,i_address_2~cityname,i_address_2~postalcode,i_regiontext~RegionName,
      i_address_2~streetprefixname1,i_address_2~districtname,i_address_2~AddressPersonID,i_address_2~AddressID,
      I_AddressEmailAddress_2~emailaddress,I_AddressPhoneNumber_2~internationalphonenumber
      FROM i_address_2 WITH PRIVILEGED ACCESS
           JOIN i_regiontext             ON  i_regiontext~region                     = i_address_2~region
                                         AND i_regiontext~country                    = i_address_2~country
                                         AND Language                                = 'E'
LEFT OUTER JOIN I_AddressEmailAddress_2
           WITH PRIVILEGED ACCESS
                                         ON  I_AddressEmailAddress_2~AddressID       = i_address_2~AddressID
                                         AND I_AddressEmailAddress_2~AddressPersonID = i_address_2~AddressPersonID
LEFT OUTER JOIN I_AddressPhoneNumber_2
           WITH PRIVILEGED ACCESS
                                         ON  I_AddressPhoneNumber_2~AddressID        = i_address_2~AddressID
                                         AND I_AddressPhoneNumber_2~AddressPersonID  = i_address_2~AddressPersonID
           WHERE i_address_2~addressid  = @plantaddid
           INTO @DATA(wa_Plantaddress).

    ENDIF.

    DATA(note) = me->zcomm( product = wa_manufacturing-Product ).

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_labelfg        SOURCE wa_manufacturing = wa_manufacturing
                                                  wa_Plantaddress  = wa_Plantaddress
                                                  note             = note
                                                  drumno           = lv_drumno
                                           RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_XML = ls_data_xml.




  ENDMETHOD.


  METHOD zcomm.

    DATA:
      username TYPE string,
      pass     TYPE string.

    CASE sy-sysid.
      WHEN lv_dev.
        LV_Tenent = 'my413043'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_qas.
        LV_Tenent = 'my410646'.
        username =  'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_prd.
        LV_Tenent = 'my411244'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
    ENDCASE.


    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_PRODUCT_SRV/| &
              |A_Product(' { product } ')/to_ProductBasicText|.


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
               (  name = 'Accept' Value = '*/*' )
                ) ).



    token_request->set_authorization_basic(
      EXPORTING
           i_username = username
           i_password = pass
    ).




    TRY.
        DATA(lv_response) = token_http_client->execute(
                            i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
    ENDTRY.

    DATA(status) = lv_response->get_status( ).

    DATA(lv_token_response) = lv_response->get_text( ).

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
