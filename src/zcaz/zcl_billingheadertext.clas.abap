CLASS zcl_billingheadertext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter p_billingdocument | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter p_textid | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_text | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS billingtext
      IMPORTING p_billingdocument TYPE i_billingdocumentbasic-billingdocument
                p_textid          TYPE c
      RETURNING VALUE(r_text)     TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BILLINGHEADERTEXT IMPLEMENTATION.


  METHOD billingtext.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA:
      username TYPE string,
      pass     TYPE string.

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


    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/A_BillingDocumentText| &
              |(BillingDocument=' { p_billingdocument }',Language='EN',LongTextID=' { p_textid } ')|.

    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
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


      CATCH cx_web_http_client_error cx_web_message_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA:lv_string1 TYPE string,
         lv_string2 TYPE string,
         lv_string3 TYPE string,
         lv_mat     TYPE string,
         lv_rest    TYPE string.

    SPLIT lv_token_response AT '<d:LongText>' INTO lv_string2 lv_string3.

    SPLIT lv_string3 AT '</d:LongText>' INTO lv_mat lv_rest.

    r_text = lv_mat.

  ENDMETHOD.
ENDCLASS.
