CLASS zcl_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS testmethod RETURNING VALUE(rstring) TYPE string.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    SELECT *
*    FROM i_addressemailaddress_2 WITH PRIVILEGED ACCESS
*    INTO TABLE @DATA(testtable).
*
*    SELECT *
*       FROM zdb_hdfctab
*       WHERE valuedate = 'ValueDate'
*       INTO TABLE @DATA(itab).
*
*
*    DELETE zdb_hdfctab FROM TABLE @itab.


**********************************************************************


    TRY.
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = cl_http_destination_provider=>create_by_cloud_destination(
            i_name        = 'ADOBE_FORMS'
*       i_service_instance_name = 'your_instance_name',
            i_authn_mode = if_a4c_cp_service=>user_propagation
          )
        ).

      CATCH cx_web_http_client_error INTO DATA(lx_http_error).

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest_error).

      CATCH cx_root INTO DATA(lx_root).

    ENDTRY.


    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_uri_path( i_uri_path = '/v1/adsRender/pdf' ).
    lo_request->set_query( query =  'templateSource=storageId' ).

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = 'application/json' )
                )  ).




  ENDMETHOD.


  METHOD testmethod.
*
**    SELECT SINGLE *
**    FROM zi_daily_breakdown
**    WHERE processorder = '000050000031'
**    INTO @DATA(wa).
**
**    DATA: l_stmp1 TYPE timestamp,
**          l_stmp2 TYPE timestamp.
**
**    DATA l_stmp TYPE timestamp.
**    DATA date TYPE d.
**    DATA time TYPE t.
**
**    GET TIME STAMP FIELD l_stmp.
**
**    CONCATENATE wa-confirmedexecutionstartdate wa-confirmedexecutionstarttime INTO DATA(startdateandtime).
**    CONCATENATE wa-confirmedexecutionenddate wa-confirmedexecutionendtime INTO DATA(enddateandtime).
**
**    l_stmp1 = startdateandtime.
**    l_stmp2 = enddateandtime.
**
**
**    DATA(difference) = cl_abap_tstmp=>subtract(
**                         tstmp1 = l_stmp2
**                         tstmp2 = l_stmp1
**                       ).
**
**    DATA: lv_hours   TYPE i,
**          lv_minutes TYPE i,
**          lv_sec     TYPE i,
**          lv_seconds TYPE i.
**
**    lv_sec = difference.
**    lv_seconds = lv_sec.
**    lv_hours = lv_seconds / 3600.
**    lv_seconds = lv_seconds - lv_hours * 3600.
**    lv_minutes = lv_seconds / 60.
**    lv_seconds = lv_seconds - lv_minutes * 60.
**
**    DATA: lv_hrs(2)  TYPE n,
**          lv_mins(2) TYPE n,
**          lv_secs(2) TYPE n.
**
**    lv_hrs  = lv_hours.
**    lv_mins = lv_minutes.
**    lv_secs = lv_seconds.
**
***    wa_key-billingdocument = |{ wa_key-billingdocument ALPHA = IN }|.
**
**    CONCATENATE lv_hrs lv_mins lv_secs INTO DATA(differencetime) SEPARATED BY ':'.
*
*************************************************************************************************************
*
*    DATA itab TYPE STANDARD TABLE OF zdb_hdfctab.
**    DATA itabheader TYPE STANDARD TABLE OF zletter_of_crdt.
**    DATA itabsoap TYPE STANDARD TABLE OF zdb_soapapi.
**    DATA itabsoap_item TYPE STANDARD TABLE OF zdb_soapapi_item.
**    DATA zdb_digiforpdftab TYPE STANDARD TABLE OF zdb_digiforpdf.
**    DATA zdb_dspotable TYPE STANDARD TABLE OF zdb_dspotab.
*
    SELECT *
    FROM zdb_hdfctab
    INTO TABLE @DATA(itab).
**
**    SELECT *
**    FROM zletter_of_crdt
**    INTO TABLE @itabheader.
**
**    SELECT *
**    FROM zdb_soapapi
**    INTO TABLE @itabsoap.
*
**    SELECT *
**    FROM zdb_dspotab
**    INTO TABLE @zdb_dspotable.
**
**    SELECT *
**    FROM zdb_digiforpdf
**    INTO TABLE @zdb_digiforpdftab.
*
**    SELECT *
**    FROM zdb_soapapi_item
**    INTO TABLE @itabsoap_item.
*
    DELETE zdb_hdfctab FROM TABLE @itab.
**    DELETE zletter_crdt_itm FROM TABLE @itab.
**    DELETE zdb_soapapi FROM TABLE @itabsoap.
**    DELETE zdb_soapapi_item FROM TABLE @itabsoap_item.
**    DELETE zdb_digiforpdf FROM TABLE @zdb_digiforpdftab.
**    DELETE zdb_dspotab FROM TABLE @zdb_dspotable.
*
************************************************************************************************
*
*    TYPES : BEGIN OF ty_billing,
*              billdoc     TYPE i_billingdocument-billingdocument,
*              soldtoparty TYPE i_billingdocument-soldtoparty,
*              billdocitem TYPE i_billingdocumentitem-billingdocumentitem,
*              batch       TYPE i_billingdocumentitem-batch,
*            END OF ty_billing.
*
*    DATA it_billingdoc TYPE STANDARD TABLE OF ty_billing.
*
*    SELECT * FROM i_billingdocumentbasic INTO TABLE @DATA(billingdocumentbasic) UP TO 2 ROWS.
*    IF sy-subrc EQ 0.
*      SELECT * FROM i_billingdocumentitembasic
*      FOR ALL ENTRIES IN @billingdocumentbasic
*      WHERE billingdocument = @billingdocumentbasic-billingdocument
*        INTO TABLE @DATA(billingdocumentitembasic).
*    ENDIF.
*
*    "FOR Iteration
*    it_billingdoc =
*      VALUE #(
*        FOR wa_billdocheader IN billingdocumentbasic INDEX INTO lv_index
*        LET wa_billingdocumentitem = billingdocumentitembasic[ billingdocument = wa_billdocheader-billingdocument ]
*        IN  billdoc   = wa_billdocheader-billingdocument
*        ( billdocitem = wa_billingdocumentitem-billingdocumentitem
*          soldtoparty = wa_billdocheader-soldtoparty
*          batch       = wa_billingdocumentitem-batch
*        )
*      ).
*
*    CLEAR it_billingdoc[].
*
*    "Nested FOR Iterations
*    it_billingdoc =
*      VALUE #(
*        FOR wa_billingdocumentitem IN billingdocumentitembasic
*        FOR wa_billdocheader IN billingdocumentbasic WHERE ( billingdocument = wa_billingdocumentitem-billingdocument )
*        (
*        billdoc     = wa_billdocheader-billingdocument
*        billdocitem = wa_billingdocumentitem-billingdocumentitem
*        soldtoparty = wa_billdocheader-soldtoparty
*        batch       = wa_billingdocumentitem-batch
*        )
*      ).
*
**    cl_demo_output=>display( lt_new_flights ).
*

  ENDMETHOD.
ENDCLASS.
