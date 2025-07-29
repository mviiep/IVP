CLASS zcl_daily_yield DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:final    TYPE STANDARD TABLE OF zc_daily_yeild_report,
         it_final TYPE STANDARD TABLE OF zc_daily_yeild_report,
         wa_final LIKE LINE OF  final.

    DATA lv_standardinputqnty2 TYPE p LENGTH 10 DECIMALS 2.
    TYPES: BEGIN OF r_aufnr,
             sign   TYPE zsign,
             option TYPE zoption,
             low    TYPE aufnr,
             high   TYPE ebeln,
           END OF r_aufnr.

    DATA: lv_orderid   TYPE RANGE OF i_manufacturingorder-manufacturingorder,
          wa_orderid   TYPE r_aufnr,
          lv_ordertype TYPE RANGE OF i_manufacturingorder-manufacturingordertype,
          lv_date      TYPE RANGE OF i_mfgorderconfirmation-postingdate,
          lv_plant     TYPE RANGE OF i_plant-plant,
          lv_ind       TYPE i,
          lv_calc      TYPE p DECIMALS 2 LENGTH 10,
          lv_product   TYPE RANGE OF i_manufacturingorderitem-product.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_daily_yield IMPLEMENTATION.


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

    READ TABLE lt_filter_cond INTO DATA(orderfilter11) WITH KEY name = 'PROCESSORDER'.
*    MOVE-CORRESPONDING orderfilter11-range TO lv_orderid.

    IF orderfilter11-range IS NOT INITIAL.
      LOOP AT orderfilter11-range INTO DATA(wa_range).
        IF sy-subrc = 0.
          MOVE-CORRESPONDING wa_range TO wa_orderid.
          wa_orderid-low  = |{ wa_orderid-low ALPHA = IN }|.
          wa_orderid-high = |{ wa_orderid-high ALPHA = IN }|.
          APPEND wa_orderid TO lv_orderid.
          CLEAR: wa_orderid.
        ENDIF.
      ENDLOOP.
    ENDIF.


    READ TABLE lt_filter_cond INTO DATA(datefilter) WITH KEY name = 'MANUFACTUREDATE'.
    MOVE-CORRESPONDING datefilter-range TO lv_date.

    READ TABLE lt_filter_cond INTO DATA(ordertypefilter) WITH KEY name = 'ORDERTYPE'.
    MOVE-CORRESPONDING ordertypefilter-range TO lv_ordertype.

    READ TABLE lt_filter_cond INTO DATA(plantfilter) WITH KEY name = 'PLANT'.
    MOVE-CORRESPONDING plantfilter-range TO lv_plant.

    READ TABLE lt_filter_cond INTO DATA(productfilter) WITH KEY name = 'PRODUCT'.
    MOVE-CORRESPONDING productfilter-range TO lv_product.


    SELECT a~manufacturingorder AS processorder, e~billofmaterialinternalid, a~manufacturingordertype AS ordertype, a~productionplant AS plant, b~manufacturedate, a~product,
       c~sizeordimensiontext AS expectedyield, d~productname, a~batch, a~mfgorderitemplannedtotalqty
       FROM i_manufacturingorderitem AS a
       LEFT OUTER JOIN i_batch AS b ON a~material = b~material AND a~batch = b~batch AND a~productionplant = b~plant
       LEFT OUTER JOIN i_product AS c ON a~product = c~product
       LEFT OUTER JOIN i_producttext AS d ON a~product = d~product AND d~language = 'E'
       LEFT OUTER JOIN i_manufacturingorder AS e ON a~manufacturingorder = e~manufacturingorder
*       LEFT OUTER JOIN i_materialdocumentitem_2 AS f ON f~orderid = a~manufacturingorder AND f~goodsmovementtype = '101'
       WHERE a~manufacturingorder IN @lv_orderid
         AND a~manufacturingordertype IN @lv_ordertype
         AND a~product IN @lv_product
         AND a~productionplant IN @lv_plant
         AND b~manufacturedate IN @lv_date
      INTO TABLE @DATA(it_main).

    IF it_main[] IS NOT INITIAL.
      SELECT orderid, product, workcenter
          FROM i_mfgorderactlplantgtldgrcost( p_fromfiscalyearperiod = '2024001',
                                              p_tofiscalyearperiod = '9999012',
                                              p_ledger = '0L',
                                              p_currencyrole = '10',
                                              p_targetcostvariant = '0' )
          FOR ALL ENTRIES IN @it_main
          WHERE orderid = @it_main-processorder
            AND product = @it_main-product
            AND orderoperation <> ''
          INTO TABLE @DATA(it_workcenter).
      DATA(lv_date) = sy-datum.
      SELECT billofmaterialvariantusage, billofmaterial, bomalternativetext
        FROM i_billofmaterialwithkeydate
        FOR ALL ENTRIES IN @it_main
        WHERE billofmaterial = @it_main-billofmaterialinternalid
          AND billofmaterialvariantusage = '1'
          AND bomalternativetext <> ''
          INTO TABLE @DATA(it_alttext).
      "code addition for performance improvement
      SELECT processorder, materialbaseunit, SUM( qnty ) AS qntyy
          FROM zi_yield_outputqty
          WHERE movementtype = '101'
          GROUP BY processorder, materialbaseunit
          INTO TABLE @DATA(it_outputqty).
      SELECT orderid, SUM( debitactlcostindspcrcy ) AS actualcost, SUM( debitplancostindspcrcy ) AS plantcost
          FROM i_mfgorderactlplantgtldgrcost( p_fromfiscalyearperiod = '2024001',
                                                  p_tofiscalyearperiod = '9999012',
                                                  p_ledger = '0L',
                                                  p_currencyrole = '10',
                                                  p_targetcostvariant = '0' )
             WHERE orderoperation <> ''
             GROUP BY orderid
              INTO TABLE @DATA(it_cost).
*      SELECT manufacturingorder, goodsmovementtype, entryunit, sum( quantityinentryunit ) as poqty
*         FROM i_materialdocumentitem_2
*         WHERE goodsmovementtype = '261'
*         GROUP BY entryunit, manufacturingorder, goodsmovementtype
*         INTO TABLE @DATA(it_poinputqty).
      SELECT m~manufacturingorder,
           m~goodsmovementtype,
           m~entryunit,
           m~materialdocumentitem,
           m~quantityinentryunit AS poqty,
           p~product,
           p~quantitynumerator ,
           p~quantitydenominator
*           'KG' as entryunit,
*           SUM(
*               CASE
*                   WHEN m~entryunit <> 'KG' THEN
*                       ( CAST( m~quantityinentryunit AS FLTP ) *  CAST(  p~quantitynumerator AS FLTP ) / CAST( p~quantitydenominator AS FLTP ) )
*                   WHEN m~entryunit = 'KG' THEN
*                        CAST( m~quantityinentryunit AS FLTP )
*               END AS poqty
*           ) AS poqty

            FROM i_materialdocumentitem_2 AS m
            LEFT OUTER JOIN i_productunitsofmeasure AS p ON m~material = p~product
            FOR ALL ENTRIES IN @it_main
            WHERE m~goodsmovementtype = '261'
              AND m~manufacturingorder = @it_main-processorder
              AND m~goodsmovementiscancelled = ''
              AND p~alternativeunit = 'KG'
*            GROUP BY  m~manufacturingorder, m~goodsmovementtype
            INTO TABLE @DATA(it_poinputqty).

*      SELECT m~manufacturingorder,
*          m~goodsmovementtype,
**           'KG' as entryunit,
*          SUM(
*              CASE
*                  WHEN m~entryunit <> 'KG' THEN
*                      ( CAST( m~quantityinentryunit AS FLTP ) *  CAST(  p~quantitynumerator AS FLTP ) / CAST( p~quantitydenominator AS FLTP ) )
*                  WHEN m~entryunit = 'KG' THEN
*                       CAST( m~quantityinentryunit AS FLTP )
*              END
*          ) AS poqty1
*           FROM i_materialdocumentitem_2 AS m
*           LEFT OUTER JOIN i_productunitsofmeasure AS p ON m~material = p~product
*           WHERE m~goodsmovementtype = '262'
*           GROUP BY  m~manufacturingorder, m~goodsmovementtype
*           INTO TABLE @DATA(it_poinputqty1).


*      SELECT manufacturingorder, goodsmovementtype, entryunit, SUM( quantityinentryunit )  AS poqty1
*         FROM i_materialdocumentitem_2
*         WHERE goodsmovementtype = '262'
*         GROUP BY entryunit, manufacturingorder, goodsmovementtype
*         INTO TABLE @DATA(it_poinputqty1).
      SELECT a~manufacturingorder, a~inspectionlot, b~insplotusagedecisioncodegroup, b~inspectionlotusagedecisioncode,c~usagedecisioncodetext
        FROM i_inspectionlot AS a
        LEFT OUTER JOIN i_insplotusagedecision  AS b  ON a~inspectionlot = b~inspectionlot
        LEFT OUTER JOIN i_usagedecisioncodetext AS c ON b~inspectionlotusagedecisioncode = c~usagedecisioncode
                                                     AND b~insplotusagedecisioncodegroup = c~usagedecisioncodegroup
                                                     AND c~language = 'E'
        FOR ALL ENTRIES IN @it_main
        WHERE a~manufacturingorder = @it_main-processorder
        INTO TABLE @DATA(it_usagedecision).
      SELECT orderid, quantityinentryunit
        FROM i_materialdocumentitem_2
        FOR ALL ENTRIES IN @it_main
        WHERE orderid = @it_main-processorder
          AND goodsmovementtype = '101'
          INTO TABLE @DATA(it_sfgopqty).
      SELECT orderid, SUM( costvarianceindspcrcy ) AS costvarianceindspcrcy
        FROM i_mfgorderevtbsdwipvariance( p_ledger = '0L', "#EC CI_NOWHERE
                                          p_fromfiscalyearperiod = '2024001',
                                          p_tofiscalyearperiod = '9999012',
                                          p_currencyrole = '10' )
        GROUP BY orderid
        INTO TABLE @DATA(it_variance).

      SELECT orderid, batch
      FROM i_materialdocumentitem_2
       FOR ALL ENTRIES IN @it_main
        WHERE goodsmovementtype = '261'   AND
        batch = @it_main-batch AND manufacturingorder = @it_main-processorder
        INTO TABLE @DATA(it_ord).

      SELECT quantityinbaseunit, orderid, batch
      FROM i_materialdocumentitem_2
      FOR ALL ENTRIES IN @it_ord
      WHERE goodsmovementtype = '101'  AND orderid = @it_ord-orderid AND
      batch = @it_ord-batch INTO TABLE @DATA(it_ordqty).





    ENDIF.
    DATA : lv_expyield TYPE p LENGTH 10 DECIMALS 2.
    SORT it_main BY product batch.
    DELETE ADJACENT DUPLICATES FROM it_main COMPARING product batch.
    LOOP AT it_main INTO DATA(wa_main).
      wa_final-processorder = wa_main-processorder.
      wa_final-plant = wa_main-plant.
      wa_final-ordertype =  wa_main-ordertype.
      wa_final-product = wa_main-product.
      SHIFT wa_final-product LEFT DELETING LEADING '0'.
      wa_final-productname = wa_main-productname.
      wa_final-batch = wa_main-batch.
      wa_final-manufacturedate = wa_main-manufacturedate.
      DATA(wa_workcenter) = VALUE #( it_workcenter[ orderid = wa_main-processorder product = wa_main-product ] OPTIONAL ).
      wa_final-workcenter = wa_workcenter-workcenter.
*      SELECT SINGLE billofmaterialvariantusage, billofmaterial, bomalternativetext
*        FROM i_billofmaterialwithkeydate( p_keydate = '20240701' )
*        WHERE billofmaterial = @wa_main-billofmaterialinternalid
*          AND billofmaterialvariantusage = '1'
*          INTO @DATA(wa_alttext).
      DATA(wa_alttext) = VALUE #( it_alttext[ billofmaterial = wa_main-billofmaterialinternalid billofmaterialvariantusage = 1 ] OPTIONAL )   .
      lv_standardinputqnty2 = wa_alttext-bomalternativetext.
      wa_final-standardinputqnty = ( wa_main-mfgorderitemplannedtotalqty * lv_standardinputqnty2 ) / 1000 .


      "changes from here
      SELECT SINGLE processorder, materialbaseunit, SUM( qnty ) AS qntyy
        FROM zi_yield_outputqty
        WHERE processorder = @wa_main-processorder
          AND movementtype = '101'
        GROUP BY processorder, materialbaseunit
        INTO @DATA(wa_outputqty).
*      DATA(wa_outputqty) = VALUE #( it_outputqty[ processorder = wa_final-processorder ] OPTIONAL ).
      IF wa_outputqty-qntyy IS NOT INITIAL.
        wa_final-outputquantity = wa_outputqty-qntyy.
      ENDIF.

*      READ TABLE it_ordqty INTO DATA(wa_ordqty) WITH KEY batch = wa_main-batch.
*      IF sy-subrc = 0.
*        wa_final-outputquantity = wa_ordqty-quantityinbaseunit.
*      ENDIF.


      wa_final-materialbaseunit = wa_outputqty-materialbaseunit.
      lv_expyield = wa_main-expectedyield.
      wa_final-expectedyeild = lv_expyield.
*      SELECT SUM( debitactlcostindspcrcy ) AS actualcost, SUM( debitplancostindspcrcy ) AS plantcost
*            FROM i_mfgorderactlplantgtldgrcost( p_fromfiscalyearperiod = '2024001',
*                                                    p_tofiscalyearperiod = '9999012',
*                                                    p_ledger = '0L',
*                                                    p_currencyrole = '10',
*                                                    p_targetcostvariant = '0' )
*               WHERE orderid = @wa_main-processorder
*                AND orderoperation <> ''
*                INTO @DATA(wa_cost).
      DATA(wa_cost) = VALUE #( it_cost[ orderid = wa_main-processorder ] OPTIONAL ).
*      SELECT  SINGLE manufacturingorder, goodsmovementtype, entryunit, SUM( quantityinentryunit )  AS poqty
*         FROM i_materialdocumentitem_2
*         WHERE manufacturingorder = @wa_main-processorder
*           AND goodsmovementtype = '261'
*         GROUP BY entryunit, manufacturingorder, goodsmovementtype
*         INTO @DATA(wa_poinputqty).
      DATA(wa_poinputqty) = VALUE #( it_poinputqty[ manufacturingorder = wa_main-processorder ] OPTIONAL ).
*      SELECT  SINGLE manufacturingorder, goodsmovementtype, entryunit, SUM( quantityinentryunit )  AS poqty1
*         FROM i_materialdocumentitem_2
*         WHERE manufacturingorder = @wa_main-processorder
*           AND goodsmovementtype = '262'
*         GROUP BY entryunit, manufacturingorder, goodsmovementtype
*         INTO @DATA(wa_poinputqty1).
*      DATA(wa_poinputqty1) = VALUE #( it_poinputqty1[ manufacturingorder = wa_main-processorder ] OPTIONAL ).
      LOOP AT it_poinputqty INTO DATA(wa_poinp) WHERE manufacturingorder = wa_final-processorder.
        lv_ind = sy-tabix.
        CASE wa_poinp-entryunit.
          WHEN 'L'.
            wa_poinp-poqty = wa_poinp-poqty * (  wa_poinp-quantitydenominator / wa_poinp-quantitynumerator ).
          WHEN 'KG'.
            wa_poinp-poqty = wa_poinp-poqty.
        ENDCASE.
        lv_calc = wa_poinp-poqty + lv_calc.
        MODIFY it_poinputqty FROM wa_poinp  INDEX lv_ind.
      ENDLOOP.
      wa_final-entryunit =  'KG'.
      wa_final-poinputqty = lv_calc.

*      SELECT SINGLE a~inspectionlot, b~insplotusagedecisioncodegroup, b~inspectionlotusagedecisioncode,c~usagedecisioncodetext
*        FROM i_inspectionlot AS a
*        LEFT OUTER JOIN i_insplotusagedecision  AS b  ON a~inspectionlot = b~inspectionlot
*        LEFT OUTER JOIN i_usagedecisioncodetext AS c ON b~inspectionlotusagedecisioncode = c~usagedecisioncode
*                                                     AND b~insplotusagedecisioncodegroup = c~usagedecisioncodegroup
*                                                     AND c~language = 'E'
*        WHERE a~manufacturingorder = @wa_final-processorder
*        INTO @DATA(wa_usagedecision).
      DATA(wa_usagedecision) =  VALUE #( it_usagedecision[ manufacturingorder = wa_main-processorder ] OPTIONAL ).
      CLEAR : lv_expyield.
      IF wa_final-poinputqty = '0'.
        wa_final-poinputqty = '1'.
      ENDIF.
      lv_expyield = ( wa_final-outputquantity / wa_final-poinputqty ) * 100.
      IF wa_final-poinputqty = '1'.
        wa_final-poinputqty = '0'.
      ENDIF.
*      SELECT SINGLE quantityinentryunit
*        FROM i_materialdocumentitem_2
*        WHERE orderid = @wa_final-processorder
*          AND goodsmovementtype = '101'
*          INTO @DATA(lv_sfgopqty).
      DATA(wa_sfgopqty) =  VALUE #( it_sfgopqty[ orderid = wa_main-processorder ] OPTIONAL ).
      wa_final-sfg_output = wa_sfgopqty-quantityinentryunit.
      IF wa_final-ordertype EQ 'ZI01'.
        CLEAR :  wa_final-outputquantity.
        wa_final-outputquantity =  wa_final-sfg_output.
      ENDIF.

      IF wa_final-poinputqty = '0'.
        wa_final-poinputqty = '1'.
      ENDIF.
      CASE wa_final-ordertype.
        WHEN 'ZI01'.
          lv_expyield = ( wa_final-sfg_output / wa_final-poinputqty ) * 100.
        WHEN 'ZS01' OR 'ZS02' OR 'ZS03' OR 'ZS04' OR 'ZR01' OR 'ZR02' OR ' ZP01'  OR 'ZP02' OR 'ZB01' OR 'ZB02'.
*          lv_expyield = ( wa_final-outputquantity / wa_final-poinputqty ) * 100.
          lv_expyield = ( wa_final-sfg_output / wa_final-poinputqty ) * 100.
      ENDCASE.
      IF wa_final-poinputqty = '1'.
        wa_final-poinputqty = '0'.
      ENDIF.
      wa_final-actualyield = lv_expyield.
      wa_final-usagedecision = wa_usagedecision-usagedecisioncodetext. "Changed
      wa_final-plantcost = wa_cost-plantcost.
      wa_final-actualcost = wa_cost-actualcost.

*      SELECT SUM( costvarianceindspcrcy )
*        FROM i_mfgorderevtbsdwipvariance( p_ledger = '0L',
*                                          p_fromfiscalyearperiod = '2024001',
*                                          p_tofiscalyearperiod = '9999012',
*                                          p_currencyrole = '10' )
*        WHERE orderid =  @wa_final-processorder
*        INTO @DATA(wa_variance).
      DATA(wa_variance) = VALUE #( it_variance[ orderid = wa_main-processorder ] OPTIONAL ).
      wa_final-variance = wa_variance-costvarianceindspcrcy.
*      SELECT SINGLE quantityinentryunit
*        FROM i_materialdocumentitem_2
*        WHERE orderid = @wa_final-processorder
*          AND goodsmovementtype = '101'
*          INTO @DATA(lv_sfgopqty).
*      wa_final-sfg_output = lv_sfgopqty.
      SHIFT wa_final-processorder LEFT DELETING LEADING '0'.
      APPEND wa_final TO final.
      CLEAR: wa_final, wa_main, wa_outputqty, wa_poinputqty, wa_usagedecision, lv_expyield, wa_workcenter, wa_alttext, wa_cost, wa_sfgopqty, wa_variance, lv_calc." it_usagedecision, wa_text .
    ENDLOOP.
    SELECT * FROM @final AS it_final                    "#EC CI_NOWHERE
       ORDER BY processorder DESCENDING
       INTO TABLE @DATA(it_fin)
       OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
    SELECT COUNT( * )
        FROM @final AS it_final                         "#EC CI_NOWHERE
        INTO @DATA(lv_totcount).
    io_response->set_data( it_fin ).
    io_response->set_total_number_of_records( lv_totcount ).
  ENDMETHOD.
ENDCLASS.
