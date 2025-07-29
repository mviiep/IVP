class ZCL_TESTFR definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_TESTFR IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

      DATA: lv_url TYPE string VALUE 'http:192.168.1.115:8080/API/getWeight02'.
      DATA: lo_http_client TYPE REF TO if_web_http_client.
          TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_header_fields(  VALUE #(
                 (  name = 'Content-Type' value = 'application/json' )
                 (  name = 'Accept' value = 'application/json' )
                  )  ).

      TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error.                   "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lv_json_response) =   lv_response->get_text( ).


  endmethod.
ENDCLASS.
