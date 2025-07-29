CLASS zcl_daily_breakdown DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_final,
             datep              TYPE i_manufacturingorder-creationdate,
             processorder       TYPE i_manufacturingorder-manufacturingorder,
             plant              TYPE i_plant-plant,
             ordertype          TYPE i_manufacturingorder-manufacturingordertype,
             resource(256),
             confirmedstarttime TYPE i_mfgorderconfirmation-confirmedexecutionendtime,
             confirmedendtime   TYPE i_mfgorderconfirmation-confirmedexecutionstarttime,
             confirmedstartdate TYPE i_mfgorderconfirmation-confirmedexecutionstartdate,
             confirmedenddate   TYPE i_mfgorderconfirmation-confirmedexecutionenddate,
             maintainancehours  TYPE i_mfgorderconfirmation-confirmedbreakduration,
             reason             TYPE i_mfgorderconfirmation-confirmationtext,
             processorderhrs    TYPE i_mfgorderconfirmation-confirmedexecutionendtime,
           END OF ty_final.

    DATA: lv_orderid   TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          lv_ordertype TYPE RANGE OF i_manufacturingorder-manufacturingordertype,
          lv_date      TYPE RANGE OF i_mfgorderconfirmation-postingdate,
          lv_plant     TYPE RANGE OF i_plant-plant.

    DATA: it_final TYPE TABLE OF zc_daily_breakdown,
          wa_final TYPE zc_daily_breakdown.

    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DAILY_BREAKDOWN IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entity) = io_request->get_entity_id( ).

    IF io_request->is_data_requested( ).
      DATA(off) = io_request->get_paging( )->get_offset(  ).
      DATA(pag) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE pag ).
      DATA lv_rows TYPE int8.

      lv_rows = lv_max_rows.
      DATA(lsort) = io_request->get_sort_elements( ) .

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      DATA(lv_max_rows_top) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_fields)  = io_request->get_requested_elements( ).
      DATA(lt_sort)    = io_request->get_sort_elements( ).

      DATA(set) = io_request->get_requested_elements( ).
      DATA(lvs) = io_request->get_search_expression( ).
      DATA(filter1) = io_request->get_filter(  ).
      DATA(p1) = io_request->get_parameters(  ).
      DATA(p2) = io_request->get_requested_elements(  ).

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.
    ENDIF.

    READ TABLE lt_filter_cond INTO DATA(orderfilter11) WITH KEY name = 'PROCESSORDER'.
    MOVE-CORRESPONDING orderfilter11-range TO lv_orderid.

    READ TABLE lt_filter_cond INTO DATA(datefilter) WITH KEY name = 'DATEP'.
    MOVE-CORRESPONDING datefilter-range TO lv_date.

    READ TABLE lt_filter_cond INTO DATA(ordertypefilter) WITH KEY name = 'ORDERTYPE'.
    MOVE-CORRESPONDING ordertypefilter-range TO lv_ordertype.

    READ TABLE lt_filter_cond INTO DATA(plantfilter) WITH KEY name = 'PLANT'.
    MOVE-CORRESPONDING plantfilter-range TO lv_plant.

    SELECT DISTINCT *
    FROM zi_daily_breakdown
    WHERE processorder IN @lv_orderid
    AND datep IN @lv_date
    AND ordertype IN @lv_ordertype
    AND plant IN @lv_plant
    ORDER BY processorder
    INTO TABLE @DATA(it_item)
    OFFSET @off UP TO @lv_max_rows ROWS.

    IF it_item[] IS NOT INITIAL.
      LOOP AT it_item INTO DATA(wa_item).
        wa_final-datep              = wa_item-datep.
        wa_final-processorder       = wa_item-processorder.
*        SHIFT wa_final-processorder LEFT DELETING LEADING '0'.
        wa_final-plant              = wa_item-plant.
        wa_final-ordertype          = wa_item-ordertype.
        wa_final-product            = wa_item-product.
        SHIFT wa_final-product LEFT DELETING LEADING '0'.
        wa_final-productdescription = wa_item-productname.
        wa_final-batch              = wa_item-batch.
        SELECT SINGLE workcenter FROM i_workcenter WHERE workcenterinternalid = @wa_item-workcenter INTO @DATA(lv_workcntr).
        wa_final-workcenter           = lv_workcntr.
        wa_final-confirmedstarttime = wa_item-confirmedexecutionstarttime.
        wa_final-confirmedendtime   = wa_item-confirmedexecutionendtime.
        wa_final-confirmedstartdate = wa_item-confirmedexecutionstartdate.
        wa_final-confirmedenddate   = wa_item-confirmedexecutionenddate.
        wa_final-maintainancehours  = wa_item-confirmedbreakduration.
        wa_final-reason             = wa_item-confirmationtext.
        DATA: l_stmp1 TYPE timestamp,
              l_stmp2 TYPE timestamp.

        DATA l_stmp TYPE timestamp.
        DATA date TYPE d.
        DATA time TYPE t.

        GET TIME STAMP FIELD l_stmp.

        CONCATENATE wa_item-confirmedexecutionstartdate wa_item-confirmedexecutionstarttime INTO DATA(startdateandtime).
        CONCATENATE wa_item-confirmedexecutionenddate wa_item-confirmedexecutionendtime INTO DATA(enddateandtime).

        l_stmp1 = startdateandtime.
        l_stmp2 = enddateandtime.


        DATA(difference) = cl_abap_tstmp=>subtract(
                             tstmp1 = l_stmp2
                             tstmp2 = l_stmp1
                           ).

        DATA: lv_hours   TYPE i,
              lv_minutes TYPE i,
              lv_sec     TYPE i,
              lv_seconds TYPE i.

        lv_sec = difference.
        lv_seconds = lv_sec.
        lv_hours = lv_seconds / 3600.
        lv_seconds = lv_sec - lv_hours * 3600.
        lv_minutes = lv_seconds / 60.
        lv_seconds = lv_seconds - lv_minutes * 60.

        DATA: lv_hrs(2)  TYPE n,
              lv_mins(2) TYPE n,
              lv_secs(2) TYPE n.

        lv_hrs  = lv_hours.
        lv_mins = lv_minutes.
        lv_secs = lv_seconds.


        CONCATENATE lv_hrs lv_mins lv_secs INTO DATA(differencetime) .
        wa_final-processorderhrs    = differencetime.
        APPEND wa_final TO it_final.
        CLEAR : wa_final, lv_workcntr, wa_item.
      ENDLOOP.


    ENDIF.

    SELECT COUNT( * )
    FROM @it_final AS it_final
    INTO  @DATA(lv_count).

    io_response->set_total_number_of_records( iv_total_number_of_records =  lv_count ).
    io_response->set_data( it_final ).

  ENDMETHOD.
ENDCLASS.
