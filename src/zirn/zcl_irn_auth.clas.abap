CLASS zcl_irn_auth DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************Login payload structure**********************************
    TYPES :
      BEGIN OF struct,
        username TYPE string,
        password TYPE string,
      END OF struct.
*******************LOGIN REsponse*********************************
    TYPES : BEGIN OF it_response,
              token TYPE string,
            END OF it_response.
    data: wa_response type it_response.

    DATA : lv_url       TYPE string,
           lv_url1      TYPE string,
           lv_url2      TYPE string,
           lv_tokenresp TYPE string.
****************Method for Authorization*****************
    METHODS token_gen
      IMPORTING gstin        TYPE string
      EXPORTING wa_response     like wa_response
      RETURNING VALUE(r_val) like wa_response.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IRN_AUTH IMPLEMENTATION.


  METHOD token_gen.
    DATA : lo_http_client TYPE REF TO if_web_http_client.
    lv_url1 = '/api/v1/token-auth/'.
    SELECT SINGLE link
        FROM zirn_login
        WHERE systemid = @sy-sysid
        INTO @lv_url.
    CONCATENATE lv_url lv_url1 INTO lv_url2.
    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                          i_destination = cl_http_destination_provider=>create_by_url( lv_url2 ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    DATA(lo_request) = lo_http_client->get_http_request( ).
    lo_request->set_header_fields(  VALUE #(
           (  name = 'Content-Type' value = 'application/json' )
            )  ).
    SELECT SINGLE * FROM ztab_gstin_user
        WHERE gstin = @gstin
        INTO @DATA(wa_log).
    DATA(ls_payload) = VALUE struct(  username    = wa_log-Email"'testedoc@mastersindia.co'"
                                      password = wa_log-password"'S@nd#b@x!!123'"
                                   ).
    DATA(lv_json) = /ui2/cl_json=>serialize( data = ls_payload
                                            compress = abap_true
                                            pretty_name = /ui2/cl_json=>pretty_mode-low_case
                                             ).
    lo_request->append_text(
          EXPORTING
            data   = lv_json
        ).
    TRY.
        DATA(lv_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.
    DATA(lv_json_response) = lv_response->get_text( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = wa_response ).

  ENDMETHOD.
ENDCLASS.
