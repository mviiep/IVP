CLASS zcl_dpr_month DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_final,
              datedpr                  TYPE dats,
              forecastqty              TYPE c LENGTH 20,
              mrpcontroller            TYPE c LENGTH 20,
              confirmedorder           TYPE c LENGTH 20,
              salesdelivered           TYPE c LENGTH 20,
              productiondesign         TYPE c LENGTH 20,
              productionachieved       TYPE c LENGTH 20,
              productionachievedprcntg TYPE p LENGTH 10 DECIMALS 2,
            END OF ty_final.
    DATA : it_final TYPE TABLE OF ty_final,
           wa_final TYPE ty_final.
    TYPES: BEGIN OF r_dat,
             sign   TYPE zsign,
             option TYPE zoption,
             low    TYPE datn,
             high   TYPE datn,
           END OF r_dat.
    DATA : wa_dat           TYPE r_dat,
           lv_dat           TYPE RANGE OF i_mfgorderconfirmation-postingdate,
           lv_plant         TYPE RANGE OF i_plant-plant,
           lv_mrpcontroller TYPE RANGE OF i_productplantbasic-mrpresponsible.
    DATA: l_stmp1 TYPE timestamp,
          l_stmp2 TYPE timestamp.

    DATA : l_stmp    TYPE timestamp,
           date      TYPE d,
           time      TYPE t,
           prddesign TYPE p DECIMALS 2 LENGTH 10.
    DATA : lv_hours   TYPE i,
           lv_minutes TYPE i,
           lv_sec     TYPE i,
           lv_seconds TYPE i.
    DATA: lv_hrs(5)  TYPE c,
          lv_mins(2) TYPE n,
          lv_secs(2) TYPE n.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DPR_MONTH IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
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
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.
    ENDIF.

    READ TABLE lt_filter_cond INTO DATA(datefilter) WITH KEY name = 'DATERANGE'.
    MOVE-CORRESPONDING datefilter-range TO lv_dat.

    READ TABLE lt_filter_cond INTO DATA(plantfilter) WITH KEY name = 'PLANT'.
    MOVE-CORRESPONDING plantfilter-range TO lv_plant.

    READ TABLE lt_filter_cond INTO DATA(mrpcontrollerfilter) WITH KEY name = 'MRPCONTROLLER'.
    MOVE-CORRESPONDING mrpcontrollerfilter-range TO lv_mrpcontroller.

    SELECT a~plndindeprqmtinternalid, b~mrpresponsible, b~product, a~product AS prd
        FROM i_activeplndindeprqmt AS a
        INNER JOIN i_productplantbasic AS b ON a~product =  b~product
        WHERE b~plant IN @lv_plant
          AND b~mrpresponsible IN @lv_mrpcontroller
        INTO TABLE @DATA(it_pirpointer).
    SELECT plannedquantity
        FROM i_activeplndindeprqmtitem
        FOR ALL ENTRIES IN @it_pirpointer
        WHERE workingdaydate IN @lv_dat
          AND plndindeprqmtinternalid = @it_pirpointer-plndindeprqmtinternalid
*        group by WorkingDayDate
        INTO TABLE @DATA(it_forcast).

    SELECT SUM( plannedquantity )
        FROM @it_forcast AS it_forcast                  "#EC CI_NOWHERE
        INTO @DATA(lv_forecast)."forecast

    SELECT a~orderquantity, a~salesorder, b~product
       FROM i_salesorderitem AS a
       INNER JOIN i_productplantbasic AS b ON a~product = b~product
*       FOR ALL ENTRIES IN @it_pirpointer
       WHERE a~creationdate IN @lv_dat
         AND a~plant IN @lv_plant
         AND b~mrpresponsible IN @lv_mrpcontroller
         AND a~division IN ( '10', '20', '30' )
       INTO TABLE @DATA(it_confirmorder).

    SELECT SUM( orderquantity )
        FROM @it_confirmorder AS it_confirmorder        "#EC CI_NOWHERE
        INTO @DATA(lv_confirmorder).   "confirmedorder

    SELECT  deliveredqtyinorderqtyunit, salesorder, salesorderitem
       FROM i_salesorderscheduleline
       FOR ALL ENTRIES IN @it_confirmorder
       WHERE salesorder = @it_confirmorder-salesorder
       INTO TABLE @DATA(it_sales_delivered).

    SELECT SINGLE SUM( deliveredqtyinorderqtyunit )
        FROM @it_sales_delivered AS it_forcast          "#EC CI_NOWHERE
        INTO @DATA(lv_salesdelivered)."sales delivered

    "Production Achieved
    SELECT DISTINCT e~manufacturingorder
        FROM i_mfgorderconfirmation AS a
        LEFT OUTER JOIN i_mfgorderforextraction AS b ON a~manufacturingorder = b~manufacturingorder
        LEFT OUTER JOIN i_productplantbasic AS c ON b~material = c~product
        LEFT OUTER JOIN i_mfgorderforextraction AS d  ON d~product = c~product
        LEFT OUTER JOIN i_mfgorderconfirmation AS e ON d~manufacturingorder = e~manufacturingorder
        WHERE a~postingdate IN @lv_dat
          AND a~plant IN @lv_plant
          AND a~manufacturingordertype IN ( 'ZF01', 'ZF02', 'ZF03', 'ZF04' )
          AND a~isreversed = ''
          AND a~isreversal = ''
          AND a~milestoneisconfirmed = ''
          AND d~manufacturingordertype IN ( 'ZF01', 'ZF02', 'ZF03', 'ZF04' )
          AND c~mrpresponsible IN @lv_mrpcontroller
          AND c~plant IN @lv_plant
          AND e~milestoneisconfirmed = ''
          AND e~postingdate IN @lv_dat
          AND e~isreversed = ''
          AND e~isreversal = ''
        INTO TABLE @DATA(it_material).

    IF it_material IS NOT INITIAL.
      SELECT confyieldqtyinproductionunit, manufacturingorder, mfgorderconfirmation
          FROM i_mfgorderconfirmation
          FOR ALL ENTRIES IN @it_material
          WHERE manufacturingorder = @it_material-manufacturingorder
            and IsReversal = ''
            and IsReversed = ''
          INTO TABLE @DATA(it_qty).


      SELECT SUM( confyieldqtyinproductionunit )
      FROM @it_qty AS it_qty
      INTO  @DATA(lv_qty).
      "Production Achieved

      SELECT a~workcenterinternalid, b~workcenter, c~designcap, a~manufacturingorder
          FROM i_mfgorderconfirmation AS a LEFT OUTER JOIN i_workcenter AS b ON a~workcenterinternalid = b~workcenterinternalid
          LEFT OUTER JOIN zi_rsrc_cap AS c ON c~resrce = b~workcenter
          FOR ALL ENTRIES IN @it_material
          WHERE a~manufacturingorder =  @it_material-manufacturingorder
            AND a~postingdate IN @lv_dat
            AND a~plant IN @lv_plant
            AND a~manufacturingordertype IN ( 'ZF01', 'ZF02', 'ZF03', 'ZF04' )
            AND a~isreversed = ''
            AND a~isreversal = ''
            AND a~milestoneisconfirmed = ''
          INTO TABLE @DATA(it_workcenterinternalid).
      LOOP AT it_workcenterinternalid INTO DATA(wa_work).
        DATA(lv_index) = sy-tabix.
        SHIFT wa_work-manufacturingorder LEFT DELETING LEADING '0'.
        MODIFY it_workcenterinternalid FROM wa_work INDEX lv_index.
      ENDLOOP.
      SELECT DISTINCT *
        FROM zi_daily_breakdown
        FOR ALL ENTRIES IN @it_workcenterinternalid
        WHERE processorder = @it_workcenterinternalid-manufacturingorder
          AND milestoneisconfirmed = ''
        INTO TABLE @DATA(it_item).
      SELECT * FROM ztb_resource_cap
          FOR ALL ENTRIES IN @it_workcenterinternalid
          WHERE resrce = @it_workcenterinternalid-workcenter
          INTO TABLE @DATA(it_designcap).

      LOOP AT it_workcenterinternalid INTO DATA(wa_workcent).

        DATA(wa_itm) = VALUE #( it_item[ processorder = wa_workcent-manufacturingorder ] OPTIONAL ).
        CONCATENATE wa_itm-confirmedexecutionstartdate wa_itm-confirmedexecutionstarttime INTO DATA(startdateandtime).
        CONCATENATE wa_itm-confirmedexecutionenddate wa_itm-confirmedexecutionendtime INTO DATA(enddateandtime).

        l_stmp1 = startdateandtime.
        l_stmp2 = enddateandtime.
        TRY.
            DATA(difference) = cl_abap_tstmp=>subtract(
                                 tstmp1 = l_stmp2
                                 tstmp2 = l_stmp1
                               ).
          CATCH cx_parameter_invalid_range.
        ENDTRY.
        lv_sec = difference.
        lv_seconds = lv_sec.
        lv_hours = lv_seconds / 3600.
        lv_seconds = lv_sec - lv_hours * 3600.
        lv_minutes = lv_seconds / 60.
        lv_seconds = lv_seconds - lv_minutes * 60.

        lv_hrs  = lv_hours.
        lv_mins = lv_minutes.
        lv_secs = lv_seconds.

        DATA(wa_designcap) = VALUE #( it_designcap[ resrce = wa_workcent-workcenter ] OPTIONAL ).
        IF lv_hours < 1.
          lv_hours = 1.
        ENDIF.
        prddesign = prddesign + (  wa_designcap-design_cap * ( 24 / lv_hours ) ).

      ENDLOOP.
    ENDIF.
    DATA(lv_prddesigncap) = prddesign.
*    SELECT SINGLE SUM( designcap )
*        FROM @it_workcenterinternalid AS it_workcenterinternalid "#EC CI_NOWHERE
*        INTO @DATA(lv_prddesigncap).
*    select sum( designcap )
*        from zc_Dpr
*        where PostingDate in @lv_dat
*        into @data(lv_prddesigncap).
    "Production Design Capacity


    wa_final-forecastqty = lv_forecast.
    wa_final-confirmedorder = lv_confirmorder.
    wa_final-salesdelivered = lv_salesdelivered.
    wa_final-productiondesign = lv_prddesigncap.
    wa_final-productionachieved = lv_qty.
    wa_final-productionachievedprcntg = ( lv_qty / lv_prddesigncap ) * 100.

    APPEND wa_final TO it_final.

    SELECT COUNT( * )
    FROM @it_final AS it_final
    INTO  @DATA(lv_count).

    io_response->set_total_number_of_records( iv_total_number_of_records =  lv_count ).
    io_response->set_data( it_final ).
  ENDMETHOD.
ENDCLASS.
