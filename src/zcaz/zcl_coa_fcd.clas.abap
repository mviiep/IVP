CLASS zcl_coa_fcd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
**data Declaration
    DATA: r_token TYPE string.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'JF4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.


**********************************************************************
**Methods


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_obj | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter p_inspectionlot | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter p_plant | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_XML | <p class="shorttext synchronized" lang="en"></p>
    METHODS xmldata
      IMPORTING p_inspectionlot TYPE i_inspectionlot-inspectionlot
                p_plant         TYPE i_plant-plant
      RETURNING VALUE(r_xml)    TYPE string.



    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter p_inspectionlot | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter p_plant | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS coa_fcd
      IMPORTING p_inspectionlot TYPE i_inspectionlot-inspectionlot
                p_plant         TYPE i_inspectionlot-plant
      RETURNING VALUE(r_base64) TYPE string.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COA_FCD IMPLEMENTATION.


  METHOD coa_fcd.
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

    DATA(xmldata) = me->xmldata(
                      p_inspectionlot = p_inspectionlot
                      p_plant         = p_plant
                    ).

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
          DATA(ls_body) = VALUE struct(  xdp_template = 'COAFCD_Dev/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'COAFCD_Dev/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'COAFCD_Prd/' && |{ objectid }|
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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/COAFCD_Dev' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/COAFCD_Dev' ).
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


  METHOD if_oo_adt_classrun~main.


  ENDMETHOD.


  METHOD xmldata.
**********************************************************************

**Delivery Table
    TYPES : BEGIN OF ty_batch,
              batch      TYPE i_deliverydocumentitem-batch,
              quantity   TYPE i_deliverydocumentitem-actualdeliveryquantity,
              uom        TYPE i_deliverydocumentitem-itemweightunit,
              dateofmfg  TYPE i_batch-manufacturedate,
              expirydate TYPE i_batch-shelflifeexpirationdate,
            END OF ty_batch.

    DATA: it_batch TYPE TABLE OF ty_batch,
          wa_batch TYPE ty_batch.

    TYPES : BEGIN OF ty_delivery,
              product  TYPE i_deliverydocumentitem-deliverydocumentitemtext,
              it_batch LIKE it_batch,
            END OF ty_delivery.

    DATA: it_delivery TYPE TABLE OF ty_delivery,
          wa_delivery TYPE ty_delivery.


**data Declaration
    TYPES : BEGIN OF ty_inspectionresult,
              srno(3),
              testname(40),
              specifications(50),
              results(25),
              lowerlimit(20),
              upperlimit(20),
            END OF ty_inspectionresult.



    DATA:specificationno TYPE i_inspectionplanversiontp_2-replacedbillofoperations.

    DATA: it_finalinspectionresult TYPE STANDARD TABLE OF ty_inspectionresult,
          wa_finalinspectionresult TYPE ty_inspectionresult.

    DATA: my_var      TYPE decfloat34,
          rounded_var TYPE p LENGTH 8.



**********************************************************************

    SELECT inspectionlot,deliverydocument,plant,billofoperationsgroup,material,InspectionLotCreatedOn
    FROM i_inspectionlot
    WHERE inspectionlot = @p_inspectionlot
    AND plant = @p_plant
    INTO TABLE @DATA(it_inspection).

*DATA: LT_INSPECTIONSSD TYPE STANDARD TABLE OF  ztableforcoa.

    select  from i_inspectionlot as i INNER JOIN ztableforcoa as z on i~Plant = z~plant
    FIELDS DISTINCT z~plant,z~formatno,z~refsopno,z~revno,z~validfrom,z~validto,z~last_changed_at,z~local_created_at, z~local_created_by,z~local_last_changed_at,z~local_last_changed_by
     WHERE i~inspectionlot = @p_inspectionlot "and z~validfrom GE i~InspectionLotCreatedOn
     INTO TABLE @DATA(LT_INSPECTIONSSD).

* select  from i_inspectionlot as i INNER JOIN @LT_INSPECTIONSSD as z on i~Plant = z~plant
*    FIELDS DISTINCT z~plant,z~formatno,z~refsopno,z~revno,z~validfrom,z~validto  INTO TABLE @DATA(LT_INSPECTIONSSD1). " WHERE i~inspectionlot = @p_inspectionlot and z~validto le i~InspectionLotCreatedOn  INTO TABLE @DATA(LT_INSPECTIONSSD1).

select * from  ztableforcoa where plant = @p_plant into table @data(it_sr).
"data lv

data: lv_formatno type c LENGTH 30 ,
lv_refsopno  type c LENGTH 10   ,
 lv_revno     type c LENGTH 10  .


loop at it_sr into data(wa_rad) .

"read table LT_INSPECTIONSSD into  data(wa_ssd) WITH KEY plant = wa_rad-Plant.
data(lv_createdon) = value #( it_inspection[ InspectionLot = p_inspectionlot Plant = p_plant  ]-InspectionLotCreatedOn OPTIONAL ).
"if lv_createdon BETWEEN wa_ssd-validfrom and wa_ssd-validto.
if lv_createdon BETWEEN wa_rad-validfrom and wa_rad-validto.
LT_INSPECTIONSSD[ validto = wa_rad-validto validfrom = wa_rad-validfrom plant = wa_rad-plant  ]-formatno =  wa_rad-formatno.
LT_INSPECTIONSSD[ validto = wa_rad-validto validfrom = wa_rad-validfrom plant = wa_rad-plant  ]-revno =  wa_rad-revno.
LT_INSPECTIONSSD[ validto = wa_rad-validto validfrom = wa_rad-validfrom plant = wa_rad-plant  ]-refsopno =  wa_rad-refsopno.
lv_formatno = wa_rad-formatno.
lv_refsopno =  wa_rad-refsopno.
lv_revno  =  wa_rad-revno.
endif.
endloop.

"data : it_inspection1 type table of  ztableforcoa .
       data(it_inspection1) = LT_INSPECTIONSSD.
loop at LT_INSPECTIONSSD ASSIGNING FIELD-SYMBOL(<ls_inspection>) WHERE ( plant = p_plant AND formatno = lv_formatno and revno = lv_revno and refsopno = lv_refsopno  ) .
if <ls_inspection> IS ASSIGNED.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-plant =  <ls_inspection>-plant.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-formatno =  <ls_inspection>-formatno.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-refsopno =  <ls_inspection>-refsopno.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-revno =  <ls_inspection>-revno.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-validfrom =  <ls_inspection>-validfrom.
it_inspection1[  plant = <ls_inspection>-plant  formatno = <ls_inspection>-formatno  revno = <ls_inspection>-revno  refsopno = <ls_inspection>-refsopno ]-validto =  <ls_inspection>-validto.

"it_inspection1 = CORRESPONDING #( <ls_inspection> ).

endif.



endloop.

*delete   it_inspection1 WHERE   plant NE p_plant  AND refsopno NE lv_refsopno AND revno NE lv_revno AND formatno NE lv_formatno .

*DELETE it_inspection1 WHERE  plant NE p_plant  AND refsopno NE lv_refsopno AND revno NE lv_revno AND formatno NE lv_formatno .

DELETE it_inspection1 WHERE plant NE p_plant.
DELETE it_inspection1 where refsopno NE lv_refsopno.
DELETE it_inspection1 WHERE revno NE lv_revno .
DELETE it_inspection1 WHERE formatno NE lv_formatno .


 "   select from @lt_inspectionssd as it FIELDS * where validto LE i~InspectionLotCreatedOn INTO @data(lt_inspection1).


    SELECT SINGLE inspectionlotlongtext
    FROM i_inspectionlotlongtext
    WHERE inspectionlot = @p_inspectionlot
    AND language = 'E'
    INTO @DATA(text).

    IF it_inspection[] IS NOT INITIAL.
      READ TABLE it_inspection INTO DATA(deliverynumber) INDEX 1.

      SELECT a~inspectioncharacteristic, a~inspectionlot, a~inspectionspecification,
      b~inspectionresultmaximumvalue, b~inspectionresultminimumvalue, b~inspresulthasvariance
      FROM i_inspectioncharacteristic AS a
      LEFT OUTER JOIN i_inspectionresult AS b ON a~inspectionlot            = b~inspectionlot
                                             AND a~inspectioncharacteristic = b~inspectioncharacteristic
                                             AND b~inspresulthasvariance = 'X'
      WHERE a~inspectionlot = @deliverynumber-inspectionlot
        AND a~inspectionspecification = 'REFERENC'
        INTO TABLE @DATA(referencetab).

      TYPES:BEGIN OF ty_delieryref,
              deliverydocumentitem TYPE i_deliverydocumentitem-deliverydocumentitem,
            END OF ty_delieryref.

      DATA :it_delreftab TYPE TABLE OF ty_delieryref,
            wamin        TYPE  ty_delieryref,
            wamax        TYPE  ty_delieryref,
            delmin       TYPE i_deliverydocumentitem-deliverydocumentitem,
            delmax       TYPE i_deliverydocumentitem-deliverydocumentitem.

      LOOP AT referencetab INTO DATA(wa_referencetab).
        wamin-deliverydocumentitem = wa_referencetab-inspectionresultminimumvalue.
        wamax-deliverydocumentitem = wa_referencetab-inspectionresultmaximumvalue.
        APPEND wamin TO it_delreftab.
        APPEND wamax TO it_delreftab.
        CLEAR : wamin,wamax.
      ENDLOOP.

      IF deliverynumber-deliverydocument IS NOT INITIAL.

        SELECT deliverydocument,deliverydocumentitemtext,i_deliverydocumentitem~product
        , i_deliverydocumentitem~referencesddocument,deliverydocumentitem,i_deliverydocumentitem~batch,
        i_deliverydocumentitem~inspectionlot,i_deliverydocumentitem~actualdeliveryquantity,
        i_deliverydocumentitem~itemweightunit,i_batch~manufacturedate,i_batch~shelflifeexpirationdate
        FROM i_deliverydocumentitem
         LEFT JOIN i_batch           ON i_batch~material                    = i_deliverydocumentitem~material
                                    AND i_batch~batch                       = i_deliverydocumentitem~batch
                                    AND i_batch~plant                       = i_deliverydocumentitem~plant
        WHERE deliverydocument              = @deliverynumber-deliverydocument
        AND i_deliverydocumentitem~material =  @deliverynumber-material
        ORDER BY deliverydocumentitem
        INTO TABLE @DATA(itdeliverymainmat_2).


        DATA(wadeliverymainmat) = VALUE #( itdeliverymainmat_2[ 1 ] OPTIONAL ).



*        SELECT SINGLE deliverydocument,deliverydocumentitemtext,i_deliverydocumentitem~product
*        , i_deliverydocumentitem~referencesddocument,deliverydocumentitem,i_deliverydocumentitem~batch,
*        i_deliverydocumentitem~inspectionlot,i_deliverydocumentitem~actualdeliveryquantity,
*        i_deliverydocumentitem~itemweightunit,i_batch~manufacturedate,i_batch~shelflifeexpirationdate
*        FROM i_deliverydocumentitem
*  LEFT  JOIN i_batch    ON i_batch~batch    = i_deliverydocumentitem~batch
*        WHERE deliverydocument              = @deliverynumber-deliverydocument
*        AND i_deliverydocumentitem~material =  @deliverynumber-material
*        AND i_deliverydocumentitem~batch = ' '
*        INTO @DATA(wadeliverymainmat).


        SELECT DISTINCT deliverydocument,deliverydocumentitemtext,i_deliverydocumentitem~product,
        i_deliverydocumentitem~referencesddocument,deliverydocumentitem,i_deliverydocumentitem~batch,
        i_deliverydocumentitem~inspectionlot, i_deliverydocumentitem~actualdeliveryquantity,
        i_deliverydocumentitem~itemweightunit,i_batch~manufacturedate,i_batch~shelflifeexpirationdate
        FROM i_deliverydocumentitem
        LEFT JOIN i_batch            ON i_batch~material                    = i_deliverydocumentitem~material
                                    AND i_batch~batch                       = i_deliverydocumentitem~batch
                                    AND i_batch~plant                       = i_deliverydocumentitem~plant
        FOR ALL ENTRIES IN @it_delreftab
        WHERE deliverydocument   = @deliverynumber-deliverydocument
        AND deliverydocumentitem = @it_delreftab-deliverydocumentitem
        INTO TABLE @DATA(it_deliverymaintab).


        INSERT wadeliverymainmat INTO it_deliverymaintab INDEX 1.


        SELECT DISTINCT i_deliverydocumentitem~deliverydocumentitem,i_deliverydocumentitem~batch,i_deliverydocument~deliverydocument,
        i_batch~manufacturedate,i_batch~shelflifeexpirationdate,i_deliverydocument~soldtoparty,i_deliverydocumentitem~product,
        i_customer~customerfullname,i_deliverydocument~creationdate,i_deliverydocumentitem~deliverydocumentitemtext,
        i_deliverydocumentitem~actualdeliveryquantity,i_deliverydocumentitem~itemweightunit,i_deliverydocumentitem~higherlvlitmofbatspltitm
        FROM i_deliverydocumentitem
   LEFT JOIN i_deliverydocument ON i_deliverydocument~deliverydocument = i_deliverydocumentitem~deliverydocument
   LEFT JOIN i_batch            ON i_batch~material                    = i_deliverydocumentitem~material
                               AND i_batch~batch                       = i_deliverydocumentitem~batch
                               AND i_batch~plant                       = i_deliverydocumentitem~plant
  LEFT  JOIN i_customer         ON i_customer~customer                 = i_deliverydocument~soldtoparty
        WHERE i_deliverydocument~deliverydocument = @deliverynumber-deliverydocument
        INTO TABLE @DATA(it_deliverydoc).


        SORT it_deliverymaintab BY deliverydocumentitem.

        SORT it_deliverydoc BY deliverydocumentitem.

        LOOP AT it_deliverymaintab INTO DATA(wa_deliverymaintab).

          SELECT SINGLE industrystandardname
          FROM i_product
          WHERE product = @wa_deliverymaintab-product
          INTO @wa_delivery-product.

          IF wa_delivery-product IS INITIAL.
            wa_delivery-product = wa_deliverymaintab-deliverydocumentitemtext.
          ENDIF.

          LOOP AT it_deliverydoc INTO DATA(wa_deliverydoc) WHERE higherlvlitmofbatspltitm = wa_deliverymaintab-deliverydocumentitem.
            wa_batch-batch      = wa_deliverydoc-batch.
            wa_batch-quantity   = wa_deliverydoc-actualdeliveryquantity.
            wa_batch-uom        = wa_deliverydoc-itemweightunit.
            wa_batch-dateofmfg  = wa_deliverydoc-manufacturedate.
            wa_batch-expirydate = wa_deliverydoc-shelflifeexpirationdate.

            APPEND wa_batch TO it_batch.
            CLEAR wa_batch.
          ENDLOOP.

          IF it_batch[] IS INITIAL.
            wa_batch-batch      = wa_deliverymaintab-batch.
            wa_batch-quantity   = wa_deliverymaintab-actualdeliveryquantity.
            wa_batch-uom        = wa_deliverymaintab-itemweightunit.
            wa_batch-dateofmfg  = wa_deliverymaintab-manufacturedate.
            wa_batch-expirydate = wa_deliverymaintab-shelflifeexpirationdate.
            APPEND wa_batch TO it_batch.
            CLEAR wa_batch.
          ENDIF.

          wa_delivery-it_batch[] = it_batch[].

          APPEND wa_delivery TO it_delivery.
          CLEAR wa_delivery.
          CLEAR it_batch[].

        ENDLOOP.

      ENDIF.

*****Plant

      SELECT SINGLE *
      FROM zi_revisiontabforcoa
      WHERE plant EQ @deliverynumber-plant
      INTO @DATA(revisiontabforcoa).


      SELECT SINGLE addressid FROM i_plant
      WHERE plant EQ @deliverynumber-plant
      INTO @DATA(plantaddid).

      IF plantaddid IS NOT INITIAL.


        SELECT SINGLE i_address_2~streetsuffixname1,i_address_2~streetsuffixname2,i_address_2~addresseefullname,
        i_address_2~streetname,i_address_2~cityname,i_address_2~postalcode,i_regiontext~regionname,
        i_address_2~streetprefixname1,i_address_2~districtname,i_address_2~addresspersonid,i_address_2~addressid,
        i_addressemailaddress_2~emailaddress,i_addressphonenumber_2~internationalphonenumber,
        concat( concat( i_addressphonenumber_2~internationalphonenumber, '/' ), i_addrcurdfltmobilephonenumber~internationalphonenumber ) AS phone
        FROM i_address_2 WITH PRIVILEGED ACCESS
             JOIN i_regiontext             ON  i_regiontext~region                     = i_address_2~region
                                           AND i_regiontext~country                    = i_address_2~country
                                           AND language                                = 'E'
  LEFT OUTER JOIN i_addressemailaddress_2
             WITH PRIVILEGED ACCESS
                                           ON  i_addressemailaddress_2~addressid       = i_address_2~addressid
                                           AND i_addressemailaddress_2~addresspersonid = i_address_2~addresspersonid
  LEFT OUTER JOIN i_addressphonenumber_2
             WITH PRIVILEGED ACCESS
                                           ON  i_addressphonenumber_2~addressid        = i_address_2~addressid
                                           AND i_addressphonenumber_2~addresspersonid  = i_address_2~addresspersonid
  LEFT OUTER JOIN i_addrcurdfltmobilephonenumber
               WITH PRIVILEGED ACCESS
                                           ON  i_addrcurdfltmobilephonenumber~addressid        = i_address_2~addressid
                                           AND i_addrcurdfltmobilephonenumber~addresspersonid  = i_address_2~addresspersonid
             WHERE i_address_2~addressid  = @plantaddid
             INTO @DATA(wa_plantaddress).

        wa_plantaddress-phone = wa_plantaddress-internationalphonenumber.

        SELECT SINGLE replacedbillofoperations
        FROM i_inspectionplanversiontp_2
        WHERE inspectionplangroup = @deliverynumber-billofoperationsgroup
        INTO @specificationno.
      ENDIF.


*****Item Data

      SELECT *
      FROM zi_qm_coa
      WHERE inspectionlot = @p_inspectionlot
      INTO TABLE @DATA(inspectionresult).

      SORT inspectionresult BY chars.

      LOOP AT inspectionresult INTO DATA(wa_inspectionresult).
        DATA count TYPE int4.
        count = count + 1.
        wa_finalinspectionresult-srno = count.
        wa_finalinspectionresult-testname = wa_inspectionresult-testname.


        CASE wa_inspectionresult-decimalplaces.

          WHEN 0.
            DATA:var_lowerlimit TYPE p LENGTH 10 DECIMALS 0,
                 var_upperlimit TYPE p LENGTH 10 DECIMALS 0.

            var_lowerlimit = wa_inspectionresult-lowerlimit.
            var_upperlimit = wa_inspectionresult-upperlimit.

            wa_finalinspectionresult-lowerlimit = var_lowerlimit.
            wa_finalinspectionresult-upperlimit = var_upperlimit.

          WHEN 1.

            DATA:var_lowerlimit1 TYPE p LENGTH 10 DECIMALS 1,
                 var_upperlimit1 TYPE p LENGTH 10 DECIMALS 1.

            var_lowerlimit1 = wa_inspectionresult-lowerlimit.
            var_upperlimit1 = wa_inspectionresult-upperlimit.

            wa_finalinspectionresult-lowerlimit = var_lowerlimit1.
            wa_finalinspectionresult-upperlimit = var_upperlimit1.
          WHEN 2.

            DATA:var_lowerlimit2 TYPE p LENGTH 10 DECIMALS 2,
                 var_upperlimit2 TYPE p LENGTH 10 DECIMALS 2.

            var_lowerlimit2 = wa_inspectionresult-lowerlimit.
            var_upperlimit2 = wa_inspectionresult-upperlimit.

            wa_finalinspectionresult-lowerlimit = var_lowerlimit2.
            wa_finalinspectionresult-upperlimit = var_upperlimit2.

          WHEN 3.

            DATA:var_lowerlimit3 TYPE p LENGTH 10 DECIMALS 3,
                 var_upperlimit3 TYPE p LENGTH 10 DECIMALS 3.

            var_lowerlimit3 = wa_inspectionresult-lowerlimit.
            var_upperlimit3 = wa_inspectionresult-upperlimit.

            wa_finalinspectionresult-lowerlimit = var_lowerlimit3.
            wa_finalinspectionresult-upperlimit = var_upperlimit3.

        ENDCASE.



        CONDENSE : wa_finalinspectionresult-lowerlimit,
                   wa_finalinspectionresult-upperlimit.

        CONCATENATE wa_finalinspectionresult-lowerlimit '-' wa_finalinspectionresult-upperlimit wa_inspectionresult-uom
        INTO wa_finalinspectionresult-specifications
        SEPARATED BY space.

        IF wa_inspectionresult-lowerlimit IS NOT INITIAL AND wa_inspectionresult-upperlimit IS INITIAL. "Lower Limit
          CONCATENATE '≥' wa_finalinspectionresult-lowerlimit wa_inspectionresult-uom
          INTO wa_finalinspectionresult-specifications
          SEPARATED BY space.

        ELSEIF wa_inspectionresult-upperlimit IS NOT INITIAL AND wa_inspectionresult-lowerlimit IS INITIAL. "Upper Limit
          CONCATENATE '≤' wa_finalinspectionresult-upperlimit wa_inspectionresult-uom
          INTO wa_finalinspectionresult-specifications
          SEPARATED BY space.

        ELSEIF wa_inspectionresult-lowerlimit IS INITIAL AND wa_inspectionresult-upperlimit IS INITIAL.
          wa_finalinspectionresult-specifications = wa_inspectionresult-characteristicattributecodetxt.
        ENDIF.

        IF wa_inspectionresult-inspresulthasvariance = 'X'.
          DATA: var_inspectionresultmaxvalue  TYPE p LENGTH 10 DECIMALS 3,
                var_inspectionresultminvalue  TYPE p LENGTH 10 DECIMALS 3,
                var_inspectionresultmaxstring TYPE string,
                var_inspectionresultminstring TYPE string.

          var_inspectionresultmaxvalue  = wa_inspectionresult-inspectionresultmaximumvalue.
          var_inspectionresultminvalue  = wa_inspectionresult-inspectionresultminimumvalue.

          var_inspectionresultmaxstring = var_inspectionresultmaxvalue.
          var_inspectionresultminstring = var_inspectionresultminvalue.


          CONCATENATE var_inspectionresultmaxstring ',' var_inspectionresultminstring
          INTO wa_finalinspectionresult-results SEPARATED BY space.
        ELSE.
          wa_finalinspectionresult-results = wa_inspectionresult-inspectionresult.
        ENDIF.


        APPEND wa_finalinspectionresult TO it_finalinspectionresult.
        CLEAR: wa_finalinspectionresult,var_lowerlimit,var_upperlimit.
      ENDLOOP.

      DELETE it_finalinspectionresult WHERE testname = 'Catalyst Reference'.

      DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

read table it_inspection1 into data(wa_inspection1) INDEX 1 .

      CALL TRANSFORMATION ztr_coafcd     SOURCE it_deliverydoc           = it_deliverydoc[]
                                                it_delivery              = it_delivery[]
                                                text                     = text
                                                wa_plantaddress          = wa_plantaddress
                                                specificationno          = specificationno
*                                                revisiontabforcoa        = revisiontabforcoa
                                            "     revisiontabforcoa        = lt_inspectionssd1[]
                                                revisiontabforcoa        =  wa_inspection1
                                                it_finalinspectionresult = it_finalinspectionresult[]
                                                RESULT XML lo_xml_conv.

      DATA(lv_output_xml) = lo_xml_conv->get_output( ).

      DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

      r_xml = ls_data_xml.

    ENDIF.

**********************************************************************

  ENDMETHOD.
ENDCLASS.
