CLASS zcl_batchdatechanges DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA it_set_cookie TYPE if_web_http_request=>cookies.

    DATA:
      lv_access_token TYPE string,
      lv_tag          TYPE if_web_http_request=>name_value_pairs,
      lv_dev(3)       TYPE c VALUE 'JNY',
      lv_qas(3)       TYPE c VALUE 'JF4',
      lv_prd(3)       TYPE c VALUE 'KSZ',
      lv_csrf_token   TYPE string,
      lv_set_cookie   TYPE string.

    TYPES:BEGIN OF ty_token,
            token  TYPE string,
            cookie TYPE string,
          END OF ty_token.

    TYPES:BEGIN OF ty_import,
            product               TYPE i_manufacturingorder-product,
            batch                 TYPE i_manufacturingorder-batch,
            batchidentifyingplant TYPE i_manufacturingorder-planningplant,
          END OF ty_import.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_token | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_token RETURNING VALUE(r_token) TYPE ty_token.

    METHODS patch_method
      IMPORTING
                api_para        TYPE ty_import
                manufacturedate TYPE i_manufacturingorder-mfgorderscheduledstartdate
                shelflifedate   TYPE i_productstorage_2-totalshelflife
      RETURNING VALUE(r_return) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_BATCHDATECHANGES IMPLEMENTATION.


  METHOD get_token.

    CASE sy-sysid.
      WHEN lv_dev.
        DATA(lo_url) = |https://my413043-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch|.
      WHEN lv_qas.
        lo_url = |https://my412469-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch|.
      WHEN lv_prd.
        lo_url = |https://my416089-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch|.
    ENDCASE.


* Read credentials
*    SELECT SINGLE *
*    FROM zi_cs_id
*    WHERE systemid = @sy-mandt
*    INTO @DATA(wa_idpass).

    TRY.
        DATA(lo_http_token) = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    " To fetch x-csrf-token
    DATA(lo_request_token) = lo_http_token->get_http_request( ).
    lo_request_token->set_header_fields(  VALUE #(
                                             ( name = 'x-csrf-token'  value = 'fetch' )
                                             ( name = 'Accept' value = '*/*' )
                                             ( name = 'If-Match' value = '*' )
                                            )
                                 ).

    lo_request_token->set_authorization_basic(
                       EXPORTING
                         i_username = 'IVP'
                         i_password = 'Password@#0987654321'
                     ).

    TRY.
        DATA(lo_response) = lo_http_token->execute(
                            i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

    lv_csrf_token = lo_response->get_header_field( EXPORTING i_name = 'x-csrf-token' ).
*    DATA(lv_csrf_tag) = lo_response->get_header_field( EXPORTING i_name = 'etag' ).
*    DATA(lv_csrf_tag1) = lo_response->get_header_field( EXPORTING i_name = 'dataserviceversion' ).
**    lv_tag = lo_response->get_header_field( EXPORTING i_name = 'etag' )."( EXPORTING i_name = 'etag' ).
*    lv_tag = lo_response->get_header_fields( ).


    TRY.
        lo_response->get_cookies(
          RECEIVING
            r_value = it_set_cookie
        ).
      CATCH cx_web_message_error.                       "#EC NO_HANDLER
    ENDTRY.


**********************************************************************

  ENDMETHOD.


  METHOD patch_method.

**********************************************************************
    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string.

    TYPES: BEGIN OF ty_d,
             _manufacture_date           TYPE string,
             _shelf_life_expiration_date TYPE string,
           END OF ty_d.
    DATA wa_d TYPE ty_d.
    TYPES : BEGIN OF ty_fin,
              d TYPE  ty_d,
            END OF ty_fin.
    DATA wa_fin TYPE ty_fin.

**********************************************************************


    CASE sy-sysid.
      WHEN lv_dev.
        DATA(lo_url)   = |https://my413043-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch(Material='{ api_para-product }',BatchIdentifyingPlant='',Batch='{ api_para-batch }')|.
      WHEN lv_qas.
        lo_url      = |https://my412469-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch(Material='{ api_para-product }',BatchIdentifyingPlant='',Batch='{ api_para-batch }')|.
      WHEN lv_prd.
        lo_url      = |https://my416089-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BATCH_SRV/Batch(Material='{ api_para-product }',BatchIdentifyingPlant='',Batch='{ api_para-batch }')|.
    ENDCASE.


* Read credentials

    TRY.
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.


    DATA(csrf_token) = me->get_token( ).

    DATA(lo_request) = lo_http_client->get_http_request( ).
    lo_request->set_header_fields(  VALUE #(
                                             ( name = 'Content-Type'  value = 'application/json' )
                                             ( name = 'x-csrf-token'  value = lv_csrf_token )
                                             ( name = 'Accept'        value = '*/*' )
                                             ( name = 'If-Match'      value = '*' )
                                            ) ).


    LOOP AT it_set_cookie INTO DATA(wa_set_cookie).
      TRY.
          lo_request->set_cookie(
            EXPORTING
              i_name    = wa_set_cookie-name
              i_value   = wa_set_cookie-value
          ).
        CATCH cx_web_message_error.                     "#EC NO_HANDLER
      ENDTRY.
    ENDLOOP.

    lo_request->set_authorization_basic(
                       EXPORTING
                         i_username = 'IVP'
                         i_password = 'Password@#0987654321'
                     ).
    DATA lv_shelfdate TYPE d.
    lv_shelfdate =  manufacturedate + shelflifedate.
    wa_fin-d-_shelf_life_expiration_date = |{ lv_shelfdate+0(4) }-{ lv_shelfdate+4(2) }-{ lv_shelfdate+6(2) }T00:00:00|.
    wa_fin-d-_manufacture_date = |{ manufacturedate+0(4) }-{ manufacturedate+4(2) }-{ manufacturedate+6(2) }T00:00:00|.
    DATA:mfdate_json TYPE string.
    /ui2/cl_json=>serialize( EXPORTING  data        = wa_fin
                                        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                             RECEIVING  r_json      = mfdate_json ).


*    item_json = '{"ManufactureDate": "2024-07-01T00:00:00"}'.

    lo_request->append_text(
          EXPORTING
            data   = mfdate_json
        ).

    TRY.
        DATA(lo_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>patch ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

  ENDMETHOD.
ENDCLASS.
