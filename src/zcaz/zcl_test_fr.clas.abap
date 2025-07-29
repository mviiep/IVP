CLASS zcl_test_fr DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
      INTERFACES if_sd_bil_edi_inv_req_head .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_FR IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.


    TYPES: BEGIN  OF ly_post_res,
             departmentcode(10) TYPE c,
             departmentname(10) TYPE c,
           END OF ly_post_res.
    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string.

    lv_request_uri         = request->get_header_field( i_name = '~request_uri' ).
    lv_request_method      = request->get_header_field( i_name = '~request_method' ).
    lv_content_type        = request->get_header_field( i_name = 'content-type' ).

    lv_req_body = request->get_text( ).

    IF lv_req_body IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF PCRE '[^[:print:]]' IN lv_req_body WITH space.
      REPLACE ALL OCCURRENCES OF PCRE '#' IN lv_req_body WITH space.
      CONDENSE lv_req_body.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
