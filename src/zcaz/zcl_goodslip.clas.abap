CLASS zcl_goodslip DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**data Declaration

    TYPES: BEGIN OF ty_material,
             materialdocumentyear     TYPE i_materialdocumentitem_2-materialdocumentyear,
             materialdocument         TYPE i_materialdocumentitem_2-materialdocument,
             plant                    TYPE  i_materialdocumentitem_2-plant,
             materialdocumentitem     TYPE i_materialdocumentitem_2-materialdocumentitem,
             goodsmovementtype        TYPE i_materialdocumentitem_2-goodsmovementtype,
             reservation              TYPE i_materialdocumentitem_2-reservation,
             reservationitem          TYPE  i_materialdocumentitem_2-reservationitem,
             orderid                  TYPE i_materialdocumentitem_2-orderid,
             postingdate              TYPE i_materialdocumentitem_2-postingdate,
             material                 TYPE  i_materialdocumentitem_2-material,
             storagelocationname      TYPE i_storagelocationstdvh-storagelocationname,
             quantityinbaseunit       TYPE i_materialdocumentitem_2-quantityinbaseunit,
             batch                    TYPE i_materialdocumentitem_2-batch,
             materialdocumentitemtext TYPE i_materialdocumentitem_2-materialdocumentitemtext,
             issuedby                 TYPE i_materialdocumentheader_2-createdbyuser,
             materialbaseunit         TYPE i_materialdocumentitem_2-materialbaseunit,
             plantname                TYPE  i_plant-plantname,
             product                  TYPE  i_productdescription-product,
             productdesc              TYPE  i_productdescription-productdescription,
             requiredqty              TYPE  i_reservationdocumentitem-resvnitmrequiredqtyinbaseunit,
             Automaticallycreted      TYPE  i_materialdocumentitem_2-IsAutomaticallyCreated,
             movementypedesc          TYPE  zmovetypetext,

           END OF ty_material.


    DATA: r_token TYPE string.
    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA : it_final    TYPE TABLE OF ty_material,
           wa_final    TYPE ty_material,
           wa_material TYPE ty_material,
*           ls_output   TYPE matnr,
*           lo_output   TYPE i_materialdocumentitem_2-orderid,
*           lr_output   TYPE i_materialdocumentitem_2-reservation,
           lv_year     TYPE i_materialdocumentitem_2-materialdocumentyear,
           lv_material TYPE i_materialdocumentitem_2-materialdocument.


****Methods


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
    METHODS goodslip
      RETURNING VALUE(r_base64) TYPE string.




    INTERFACES if_http_service_extension .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GOODSLIP IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/GOODSLIP_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/GOODSLIP_QAS' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/GOODSLIP_PRD' ).
    ENDCASE.



    lo_request->set_header_fields( VALUE #(
                (  name = 'Authorization' value =  | { r_token } | )
                ) ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error. "#EC NO_HANDLER
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


  METHOD goodslip.

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
          DATA(ls_body) = VALUE struct(  xdp_template = 'GOODSLIP_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'GOODSLIP_QAS/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'GOODSLIP_PRD/' && |{ objectid }|
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


  METHOD if_http_service_extension~handle_request.

    DATA(lt_params) = request->get_form_fields( ).
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'materialdocument'.
    lv_material = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'materialdocumentyear'.
    lv_year = ls_params-value.

    IF lv_material IS NOT INITIAL AND lv_year IS NOT INITIAL.

      TRY.
          response->set_text( goodslip( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD xmldata.
    SELECT i_materialdocumentitem_2~materialdocumentyear, i_materialdocumentitem_2~materialdocument, i_materialdocumentitem_2~materialdocumentitem,  i_materialdocumentitem_2~plant,
              i_materialdocumentheader_2~createdbyuser,i_materialdocumentitem_2~goodsmovementtype, i_materialdocumentitem_2~reservation,
    i_materialdocumentitem_2~orderid, i_materialdocumentitem_2~postingdate, i_materialdocumentitem_2~material, i_reservationdocumentitem~resvnitmrequiredqtyinbaseunit,
            i_productdescription~productdescription,i_materialdocumentitem_2~materialbaseunit, i_materialdocumentitem_2~quantityinbaseunit,
             i_materialdocumentitem_2~batch, i_materialdocumentitem_2~IsAutomaticallyCreated,
             i_storagelocationstdvh~storagelocationname,
            zgoods_slip~goodsmovementtypename
        FROM i_materialdocumentitem_2
        LEFT OUTER JOIN i_materialdocumentheader_2 ON i_materialdocumentheader_2~materialdocument = i_materialdocumentitem_2~materialdocument
        LEFT OUTER JOIN i_productdescription       ON i_productdescription~product = i_materialdocumentitem_2~material
                                          AND i_productdescription~language = 'E'
        LEFT OUTER JOIN i_reservationdocumentitem  ON i_reservationdocumentitem~reservation = i_materialdocumentitem_2~reservation
                                         AND i_reservationdocumentitem~reservationitem = i_materialdocumentitem_2~reservationitem
        LEFT OUTER JOIN zgoods_slip    ON zgoods_slip~materialdocument =     i_materialdocumentitem_2~materialdocument
                            AND zgoods_slip~materialdocumentitem = i_materialdocumentitem_2~materialdocumentitem
       LEFT OUTER JOIN i_storagelocationstdvh ON i_storagelocationstdvh~plant = i_materialdocumentitem_2~plant
                            AND i_storagelocationstdvh~storagelocation = i_materialdocumentitem_2~storagelocation
        WHERE   i_materialdocumentitem_2~materialdocument = @lv_material
         AND   i_materialdocumentitem_2~materialdocumentyear = @lv_year
        INTO TABLE @DATA(it_material).

    IF it_material IS NOT INITIAL.

      SELECT * FROM i_plant
      FOR ALL ENTRIES IN @it_material
      WHERE plant EQ @it_material-plant
      INTO TABLE @DATA(plantable).
    ENDIF.




    LOOP AT it_material INTO DATA(wa_material)." where goodsmovementtype = '311'
                                             " and IsAutomaticallyCreated = 'X'.
      READ TABLE plantable INTO DATA(wa_plantable) WITH KEY plant = wa_material-plant.
      IF wa_plantable IS NOT INITIAL.
        wa_final-plantname = wa_plantable-plantname.
      ENDIF.
      wa_final-materialdocument = wa_material-materialdocument.
      wa_final-materialdocumentitem = wa_material-materialdocumentitem.
      wa_final-goodsmovementtype = wa_material-goodsmovementtype.
      wa_final-movementypedesc = wa_material-goodsmovementtypename.
      wa_final-materialdocumentyear = wa_material-materialdocumentyear.
      wa_final-batch = wa_material-batch.
*      IF wa_material-material IS NOT INITIAL.
*        ls_output = wa_material-material.
*        SHIFT ls_output LEFT DELETING LEADING '0'.
*      ENDIF.
      wa_final-material = wa_material-material.
      SHIFT wa_final-material LEFT DELETING LEADING '0'.
*      wa_final-material = ls_output.
      wa_final-postingdate = wa_material-postingdate.
      wa_final-quantityinbaseunit = wa_material-quantityinbaseunit.
*      IF wa_material-orderid IS NOT INITIAL.
*        lo_output = wa_material-orderid.
*        SHIFT lo_output LEFT DELETING LEADING '0'.
*      ENDIF.
      wa_final-orderid = wa_material-orderid.
      SHIFT wa_final-orderid LEFT DELETING LEADING '0'.
*      wa_final-orderid = lo_output.
      wa_final-storagelocationname = wa_material-storagelocationname.
*      IF wa_material-reservation IS NOT INITIAL.
*        lr_output = wa_material-reservation.
*        SHIFT lr_output LEFT DELETING LEADING '0'.
*      ENDIF.
      wa_final-reservation = wa_material-reservation.
*      SHIFT wa_final-reservation LEFT DELETING LEADING '0'.
      wa_final-requiredqty = wa_material-resvnitmrequiredqtyinbaseunit.
      wa_final-issuedby = wa_material-createdbyuser.
      wa_final-productdesc = wa_material-productdescription.
      wa_final-materialbaseunit = wa_material-materialbaseunit.
      wa_final-automaticallycreted = wa_material-IsAutomaticallyCreated.
      if wa_final-goodsmovementtype = '311' and wa_final-automaticallycreted = 'X'.
      APPEND wa_final TO it_final.
      elseif wa_final-goodsmovementtype NE '311'.
      APPEND wa_final TO it_final.
      endif.
      CLEAR : wa_final.
    ENDLOOP.

    READ TABLE it_final INTO DATA(header) INDEX 1.

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_goodslip     SOURCE it_final           = it_final[]
                                                header              = header
                                              RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.

  ENDMETHOD.
ENDCLASS.
