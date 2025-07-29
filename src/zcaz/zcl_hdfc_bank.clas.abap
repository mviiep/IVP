CLASS zcl_hdfc_bank DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.



    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HDFC_BANK IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

**********************************************************************
** Data Defination
**********************************************************************
    TYPES:BEGIN OF ty_wa,
            status(25)      TYPE c,
            alertsequenceno TYPE zi_hdfcjson_cds-alertsequenceno,
          END OF ty_wa.

    DATA:wa_status TYPE ty_wa.

    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string,
      wa                TYPE zstruc_hdfcjson_main,
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

    READ TABLE wa-genericcorporatealertrequest INTO DATA(workarea) INDEX 1.

    SELECT SINGLE *
    FROM zi_hdfcjson_cds
    where alertsequenceno = @workarea-alertsequenceno
    INTO @DATA(wa_zi_hdfcjson_cds).


*    wa_zi_hdfcjson_cds-alertsequenceno

    IF wa_zi_hdfcjson_cds IS NOT INITIAL.

      wa_status-status = 'Duplicate'.
      wa_status-alertsequenceno = wa_zi_hdfcjson_cds-alertsequenceno.

      /ui2/cl_json=>serialize( EXPORTING data   = wa_status
                               pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING r_json = lv_json
      ).

      response->set_text( lv_json ).
    ELSE.

      wa_status-status = 'Success'.
      wa_status-alertsequenceno = workarea-alertsequenceno.


      MODIFY zdb_hdfctab FROM TABLE @wa-genericcorporatealertrequest.

      /ui2/cl_json=>serialize( EXPORTING data   = wa_status
                               pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING r_json = lv_json
      ).

      response->set_text( lv_json ).
    ENDIF.



  ENDMETHOD.
ENDCLASS.
