class ZCL_GET_WEIGHT definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GET_WEIGHT IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
  DATA: lv_json_response TYPE string.
        lv_json_response = 'test'.

   DATA: lv_url TYPE string VALUE 'http://192.168.147.78:8080',
          lo_http_client TYPE REF TO if_web_http_client,
          lv_http_dest TYPE REF TO if_http_destination,
          lv_response TYPE REF TO if_web_http_response.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                                                                                   comm_scenario  = 'ZCS_GETWEIGHT'
                                                                                                   comm_system_id = 'GETWEIGHT'
                                                                                                 ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    response->set_text( lv_json_response ).
  endmethod.
ENDCLASS.
