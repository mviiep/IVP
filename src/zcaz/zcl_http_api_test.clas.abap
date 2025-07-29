CLASS zcl_http_api_test DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA rx_root TYPE REF TO cx_root.
    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_API_TEST IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA: lv_url TYPE string VALUE 'http://192.168.1.101:8080'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.
    DATA: lv_http_dest  TYPE REF TO if_http_destination.

    TRY.
        lv_http_dest = cl_http_destination_provider=>create_by_cloud_destination(
                         i_name                  = 'gateapp'
*                         i_service_instance_name = 'GateApp'
*                         i_authn_mode            = if_a4c_cp_service=>user_propagation
                       ).
      CATCH cx_http_dest_provider_error INTO DATA(dest_provider_error).
        "handle exception
    ENDTRY.

    CONDENSE lv_url NO-GAPS.
    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_uri_path( i_uri_path = '/API/getWeight02' ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error INTO DATA(lx_http_error).
    ENDTRY.
    DATA(lv_status) =   lv_response->get_status( ).
    DATA(lv_json_response) =   lv_response->get_text( ).


    TRY.
        response->set_text( lv_json_response ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
