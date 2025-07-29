CLASS zcl_digital_signature DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: lv_checksum       TYPE string,
          lv_uuid           TYPE string,
          lv_timestamp      TYPE string,
          lv_uploadfile1    TYPE string,
          lv_signer         TYPE string,
          lv_signloc        TYPE string,
          lv_signsize       TYPE string,
          lv_signannotation TYPE string.

    TYPES :
      BEGIN OF struct,
        pfxid          TYPE string,
        pfxpwd         TYPE string,
        signloc        TYPE string,
        signsize       TYPE string,
        signannotation TYPE string,
        uploadfile     TYPE string,
        timestamp      TYPE string,
        cs             TYPE string,
        uuid           TYPE string,
        signer         TYPE string,
      END OF struct.

    METHODS digitalsignature
      IMPORTING p_base64         TYPE string
                p_uuid           TYPE c OPTIONAL
                p_signloc        TYPE c OPTIONAL
                p_signsize       TYPE c OPTIONAL
                p_signer         TYPE c OPTIONAL
                p_signannotation TYPE c OPTIONAL
      RETURNING VALUE(r_val)     TYPE string.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DIGITAL_SIGNATURE IMPLEMENTATION.


  METHOD digitalsignature.

***************time stamp
    DATA l_stmp TYPE timestamp.
    DATA date TYPE d.
    DATA time TYPE t.

    GET TIME STAMP FIELD l_stmp.

    DATA(tz) = 'INDIA'.
    DATA(time_stamp) = l_stmp.


    CONVERT TIME STAMP time_stamp TIME ZONE tz
            INTO DATE DATA(dat) TIME DATA(tim)
            DAYLIGHT SAVING TIME DATA(dst).


    DATA(new_date) = |{ dat+6(2) }| && |{ dat+4(2) }| && |{ dat(4) }|.

    CONCATENATE tim(2) ':' tim+2(2) ':' tim+4(2) INTO DATA(new_time).
    CONCATENATE tim(2) tim+2(2) tim+4(2) INTO DATA(new_time1).

    CONCATENATE new_date new_time INTO lv_timestamp.
    CONCATENATE new_date new_time1 INTO DATA(timestamp1).
    CONDENSE: timestamp1, lv_timestamp.

************************************************************

    SELECT DISTINCT * FROM zi_digital_sign
    WHERE systemid = @sy-sysid
    ORDER BY date_ DESCENDING
    INTO TABLE @DATA(it).

    READ TABLE it INTO DATA(wa) INDEX 1.


    CONCATENATE wa-cs lv_timestamp INTO DATA(checksum_decrypted).
    CONDENSE checksum_decrypted.

    lv_uploadfile1 = p_base64. "uploadfile

************************************************************

    TRY.
        cl_abap_message_digest=>calculate_hash_for_char(
                EXPORTING
                  if_algorithm = 'SHA256'
                  if_data      =  checksum_decrypted
                IMPORTING
                  ef_hashstring = lv_checksum "checksum
              ).
      CATCH cx_abap_message_digest.
        "handle exception
    ENDTRY.


    CONCATENATE p_uuid timestamp1 INTO lv_uuid. "uuid


*    lv_signer   = |Approved by { p_signer }|.
    lv_signannotation = |Approved by { p_signannotation }|.
    lv_signloc        = p_signloc.
    lv_signsize       = p_signsize.

******************************************************************************

    DATA: lo_http_client TYPE REF TO if_web_http_client.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                                                                                   comm_scenario  = 'YY1_DIGITAL_SIGNATURE'
                                                                                                   comm_system_id = 'CTPL_DIGITALSIGN'
                                                                                                 ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = 'application/json' )
                )  ).



    DATA(ls_body) = VALUE struct(
        pfxid          = wa-pfxid
        pfxpwd         = wa-pfxpwd
        signloc        = lv_signloc
        signsize       = lv_signsize
        signannotation = lv_signannotation
        uploadfile     = lv_uploadfile1
        timestamp      = lv_timestamp
        cs             = lv_checksum
        uuid           = lv_uuid
        signer         = wa-signer
    ).


    DATA(lv_json) = /ui2/cl_json=>serialize( data        = ls_body
                                             compress    = abap_true
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

    lo_request->append_text(
          EXPORTING
            data   = lv_json
        ).


    TRY.
        DATA(lv_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
    ENDTRY.

    DATA(lv_json_response) = lv_response->get_binary( ).
    DATA(lv_json_response_txt) = lv_response->get_text( ).



    DATA(encoded) = cl_web_http_utility=>encode_x_base64( unencoded = lv_json_response ).


    FIND FIRST OCCURRENCE OF '%PDF' IN lv_json_response_txt.
    IF sy-subrc EQ 0.
      r_val = encoded.
    ELSE.
      r_val = lv_uploadfile1.
    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    me->digitalsignature(
      EXPORTING
        p_base64     = ''
        p_uuid     = ''
        p_signloc  = ''
        p_signsize = ''
*  RECEIVING
*    r_val    =
    ).


  ENDMETHOD.
ENDCLASS.
