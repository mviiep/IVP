class ZCL_KOTAK_INCOMING_PAY definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_KOTAK_INCOMING_PAY IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

  TYPES:BEGIN OF ty_wa,
            status(25)      TYPE c,
            requestid TYPE zstr_cmsgenericinboundresponse-cmsgenericinboundresponse-header-requestid,
          END OF ty_wa.

    DATA:wa_status TYPE ty_wa.


    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string,
      wa                TYPE zstr_cmsgenericinboundresponse,
      lv_json           TYPE string.

**********************************************************************


    lv_request_uri         = request->get_header_field( i_name = '~request_uri' ).
    lv_request_method      = request->get_header_field( i_name = '~request_method' ).
    lv_content_type        = request->get_header_field( i_name = 'content-type' ).

    lv_req_body = request->get_text( ).

    IF lv_req_body IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF PCRE '[^[:print:]]' IN lv_req_body WITH space.
      REPLACE ALL OCCURRENCES OF PCRE '#' IN lv_req_body WITH space.
      CONDENSE lv_req_body.
    ENDIF.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                CHANGING data = wa ).
*   DATA lv_reqId TYPE string.
*   DATA lv_Srcappcd TYPE string.
*   lv_reqId = wa-cmsgenericinboundresponse-header-requestid.
*   lv_Srcappcd = wa-cmsgenericinboundresponse-header-srcappcd.

    DATA: wa_zheader TYPE zheader.

    wa_zheader-requestid     = wa-cmsgenericinboundresponse-header-requestid.
    wa_zheader-srcappcd     = wa-cmsgenericinboundresponse-header-srcappcd.



*loop at wa-cmsgenericinboundresponse-cmsgenericinboundres-collectiondetails-collectiondetail into data(wa_test).
*endloop.



*    READ TABLE wa-cmsgenericinboundresponse-cmsgenericinboundres-collectiondetails-collectiondetail INTO DATA(workarea) index 1.

 SELECT SINGLE *
    FROM zheader
    where requestid = @wa-cmsgenericinboundresponse-header-requestid
    INTO @DATA(it_zheader).

    IF it_zheader IS NOT INITIAL.

      wa_status-status = 'Duplicate'.
      wa_status-requestid = wa-cmsgenericinboundresponse-header-requestid.

      /ui2/cl_json=>serialize( EXPORTING data   = wa_status
                               pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING r_json = lv_json
      ).

      response->set_text( lv_json ).
    ELSE.

      wa_status-status = 'Success'.
      wa_status-requestid = wa-cmsgenericinboundresponse-header-requestid.
      INSERT zheader FROM @wa_zheader.
      MODIFY zcollection_dtls FROM TABLE @wa-cmsgenericinboundresponse-cmsgenericinboundres-collectiondetails-collectiondetail.

      /ui2/cl_json=>serialize( EXPORTING data   = wa_status
                               pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING r_json = lv_json
      ).

      response->set_text( lv_json ).
    ENDIF.


  endmethod.
ENDCLASS.
