CLASS zcl_sd_salestext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .



  PUBLIC SECTION .

    CLASS-METHODS salestext
      IMPORTING so           TYPE i_billingdocumentitembasic-salesdocument
                so_item      TYPE i_billingdocumentitembasic-salesdocumentitem
      RETURNING VALUE(r_val) TYPE string.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_SD_SALESTEXT IMPLEMENTATION.


  METHOD salestext.
**********************************************************************
*** Data Defination
**********************************************************************

    DATA:
      mo_http_destination TYPE REF TO if_http_destination,
      mv_client           TYPE REF TO if_web_http_client.

    DATA:
      username TYPE string,
      pass     TYPE string.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.


    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username  = 'IVP'.
        pass      = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username  =  'IVP'.
        pass      = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username  = 'IVP'.
        pass      = 'Password@#0987654321'.
    ENDCASE.

**********************************************************************


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
ENDCLASS.
