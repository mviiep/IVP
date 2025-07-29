CLASS zcl_label_rm_pm DEFINITION
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
      lv_plant         TYPE i_plant-plant,
      lv_InspectionLot TYPE i_inspectionlot-InspectionLot.



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

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LABEL_RM_PM IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/QMLABELRM_PM_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/QMLABELRM_PM_DEV' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/COAFCD_Prd' ).
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'inspectionlot'.
    lv_inspectionlot = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'plant'.
    lv_plant = ls_params-value.


   IF lv_inspectionlot IS NOT INITIAL.
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
          DATA(ls_body) = VALUE struct(  xdp_Template = 'QMLABELRM_PM_DEV/' && |{ objectid }|
                                               xml_Data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_Template = 'QMLABELRM_PM_DEV/' && |{ objectid }|
                                               xml_Data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_Template = 'QMLABELRM_PM_PRD/' && |{ objectid }|
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

    ENDIF.

  ENDMETHOD.


  METHOD xmldata.

    SELECT SINGLE i_inspectionlot~inspectionlot,i_inspectionlot~inspectionlotobjecttext,i_inspectionlot~inspectionlotcontainer,
    i_materialdocumentitem_2~Supplier,i_materialdocumentitem_2~Batch,i_materialdocumentitem_2~quantityinbaseunit,
    i_materialdocumentitem_2~postingdate,i_materialdocumentitem_2~manufacturedate,i_materialdocumentitem_2~shelflifeexpirationdate

    FROM i_inspectionlot
    JOIN i_insplotusagedecision    ON i_inspectionlot~inspectionlot    = i_insplotusagedecision~InspectionLot
    JOIN  i_materialdocumentitem_2 ON i_inspectionlot~materialdocument = i_materialdocumentitem_2~materialdocument
*Left JOIN I_CharcAttributeCodeText  ON i_insplotusagedecision~INSPLOTUSGEDCSNSELECTEDSET  = I_CharcAttributeCodeText~INSPECTIONLOTUSAGEDECISIONCODE
    WHERE i_inspectionlot~InspectionLot = @lv_inspectionlot
    AND i_inspectionlot~Plant           = @lv_plant
    INTO @DATA(wa_materialdocument).



    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_labelrm_pm     SOURCE wa_materialdocument = wa_materialdocument
                                           RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_XML = ls_data_xml.


  ENDMETHOD.
ENDCLASS.
