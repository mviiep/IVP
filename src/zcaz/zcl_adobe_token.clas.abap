CLASS zcl_adobe_token DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS token RETURNING VALUE(r_token) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADOBE_TOKEN IMPLEMENTATION.


  METHOD token.

****************token****************

    DATA: token_url TYPE string VALUE 'https://ivp-development-pupk0tuh.authentication.eu10.hana.ondemand.com'.
    DATA: token_http_client TYPE REF TO if_web_http_client.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( token_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


    DATA(token_request) = token_http_client->get_http_request( ).

    token_request->set_header_fields(  VALUE #(
               (  name = 'Accept' Value = '*/*' )
                ) ).


    token_request->set_uri_path( i_uri_path = '/oauth/token' ).
    token_request->set_query( query = 'grant_type=client_credentials' ).

    token_request->set_authorization_basic(
      EXPORTING
        i_username = 'sb-ae7a7bd0-4301-4a19-8ab9-0d7941ad1ce0!b494240|ads-xsappname!b102452'
        i_password = 'd71ff480-6ab4-4067-ad0c-1ed6ab60e916$612PYWeqtX1yASBMSFrmcRFGNEDxR6rBiN-FJuT6ULs='
    ).


    TRY.
        DATA(lv_token_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>get )->get_text(  ).


      CATCH cx_web_http_client_error cx_web_message_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA lr_token TYPE REF TO data.

    FIELD-SYMBOLS:
      <tokendata>    TYPE data,
      <access_token> TYPE any.


    lr_token = /ui2/cl_json=>generate( json = lv_token_response ).

    IF lr_token IS BOUND.
      ASSIGN lr_token->* TO <tokendata>.

      ASSIGN COMPONENT `access_token` OF STRUCTURE <tokendata> TO <access_token>.
      ASSIGN <access_token>->* TO FIELD-SYMBOL(<token>).

    ENDIF.

    CONCATENATE 'Bearer' <token> INTO r_token SEPARATED BY space .


  ENDMETHOD.
ENDCLASS.
