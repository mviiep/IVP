CLASS zcl_hdlr_supp_quotes DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HDLR_SUPP_QUOTES IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    TYPES: BEGIN OF ty_qtnsummary,
             supplierquotation TYPE zi_dd_supqtprice-supplierquotation,
             landedcost        TYPE zi_dd_supqtprice-landedcost,
             ranking           TYPE c LENGTH 2,
           END   OF ty_qtnsummary,
           tty_qtnsummary TYPE STANDARD TABLE OF ty_qtnsummary.

    DATA: lv_rows             TYPE int8,
          lv_rec_count        TYPE int8,
          it_quotcomp         TYPE STANDARD TABLE OF zidd_quote_comparison,
          lwa_quotcomp        TYPE zidd_quote_comparison,
          lt_zcds_vspqtprice  TYPE STANDARD TABLE OF zi_dd_supqtprice,
          lwa_zcds_vspqtprice TYPE zi_dd_supqtprice,
          lv_calfldval        TYPE zi_dd_supqtprice-discount,
          lv_calfldval2       TYPE zi_dd_supqtprice-discount,
          wa_qtnsummary       TYPE ty_qtnsummary,
          lt_qtnsummary       TYPE tty_qtnsummary.

    DATA(lv_entity) = io_request->get_entity_id( ).


*    IF io_request->is_data_requested( ).        "If requested


    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
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
* SQL query
    DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).


* Set data based on called entity
    CASE lv_entity.
      WHEN 'ZIDD_QUOTE_COMPARISON'.
* Fetch RFQ Data
        IF lv_sql_filter IS NOT INITIAL.

          REPLACE 'REQUESTFORQUOTATION' IN lv_sql_filter WITH 'a~REQUESTFORQUOTATION'.

*        select from I_SupplierQuotationItem_Api01 as a
          SELECT FROM  i_supplierquotation_api01 AS a
                  LEFT OUTER JOIN i_requestforquotation_api01 AS b ON b~requestforquotation = a~requestforquotation
          FIELDS
          a~supplierquotation,
          a~requestforquotation,
          b~creationdate AS rfqdate,
          a~supplier
          WHERE (lv_sql_filter)
          INTO TABLE @DATA(lt_supquot).

        ENDIF.
        CLEAR: it_quotcomp, lwa_quotcomp.
* Prepare header
        LOOP AT lt_supquot INTO DATA(lwa_supquot).
          DATA(lv_idx) = sy-tabix.
          lwa_quotcomp-requestforquotation = lwa_supquot-requestforquotation.
          lwa_quotcomp-rfqdate             = lwa_supquot-rfqdate.

        ENDLOOP.

        IF lwa_quotcomp IS NOT INITIAL.
          APPEND lwa_quotcomp TO it_quotcomp.
          CLEAR: lwa_quotcomp.
        ENDIF.

        SELECT *
              FROM @it_quotcomp AS it     ##ITAB_DB_SELECT
              ORDER BY requestforquotation
              INTO TABLE @DATA(lt_fin_h)
              OFFSET @off UP TO @lv_max_rows ROWS.

        SELECT COUNT( * )
            FROM @lt_fin_h AS it ##ITAB_DB_SELECT
            INTO @lv_rec_count .
        io_response->set_total_number_of_records( iv_total_number_of_records = lv_rec_count ).
        io_response->set_data( lt_fin_h ).

      WHEN 'ZI_DD_SUPQTPRICE'.
        IF lv_sql_filter IS NOT INITIAL.
* Read Supplier quotations based on RFQ
          SELECT FROM i_supplierquotationitem_api01 AS a
*              left OUTER join I_SupplierQuotation_Api01 as b on b~SupplierQuotation   = a~SupplierQuotation
*              left outer join I_supplier as c on c~Supplier = a~
            FIELDS
            a~supplierquotation,
            a~supplierquotationitem,
            a~requestforquotation,
            a~requestforquotationitem,
            a~plant,
            a~\_supplierquotation-paymentterms,
            a~\_supplierquotation-incotermsclassification AS incoterms,
            a~\_supplierquotation-documentcurrency,
            a~\_supplierquotation-exchangerate,
            a~\_supplierquotation-qtnlifecyclestatus AS qtnstatus,
            a~yy1_quoteremarks_pdi,
            a~\_supplierquotation-supplier
            WHERE (lv_sql_filter)
            INTO TABLE @DATA(lt_supquotitem).

          IF lt_supquotitem IS NOT INITIAL.

* Supplier Name
            SELECT supplier, suppliername
            FROM i_supplier
            FOR ALL ENTRIES IN @lt_supquotitem
            WHERE supplier  = @lt_supquotitem-supplier
            INTO TABLE @DATA(lt_supplier).



* Payment terms text
            SELECT * FROM i_paymenttermstext
                        FOR ALL ENTRIES IN @lt_supquotitem
                        WHERE language = @sy-langu
                          AND paymentterms  = @lt_supquotitem-paymentterms
                          INTO TABLE @DATA(lt_paymenttext).
            SORT lt_paymenttext BY paymentterms.
* Incoterms text
            SELECT * FROM i_incotermsclassificationtext
                        FOR ALL ENTRIES IN @lt_supquotitem
                        WHERE language = @sy-langu
                          AND incotermsclassification  = @lt_supquotitem-incoterms
                          INTO TABLE @DATA(lt_incotermstext).
            SORT lt_incotermstext BY incotermsclassificationname.
* Quotation Qutantity and Awarded Quantity

            SELECT * FROM zdd_i_suplrqtnschedline AS a
             FOR ALL ENTRIES IN @lt_supquotitem
             WHERE a~supplierquotation       = @lt_supquotitem-supplierquotation
               AND a~supplierquotationitem   = @lt_supquotitem-supplierquotationitem
             INTO TABLE @DATA(lt_supquotqty).

            SORT lt_supquotqty BY supplierquotation supplierquotationitem.
*     for pricing

            SELECT * FROM i_supplierquotationprcelmnttp AS a
"case when ( b.ConditionType = 'PMP0' or b.ConditionType = 'PPR0' ) then  b.ConditionBaseValue
"        else 0 end   as BAmount
                FOR ALL ENTRIES IN @lt_supquotitem
                WHERE a~supplierquotation       = @lt_supquotitem-supplierquotation
                  AND a~supplierquotationitem   = @lt_supquotitem-supplierquotationitem
                INTO TABLE @DATA(lt_supquotpr).

          ENDIF.
        ENDIF.

        SORT lt_supquotpr BY supplierquotation supplierquotationitem.

        CLEAR: lt_qtnsummary, wa_qtnsummary.

        LOOP AT lt_supquotitem INTO DATA(lwa_supquotitem).
          DATA(lt_supquotpr_temp) = lt_supquotpr.

          DELETE lt_supquotpr_temp WHERE supplierquotation <> lwa_supquotitem-supplierquotation.
          DELETE lt_supquotpr_temp WHERE supplierquotationitem <> lwa_supquotitem-supplierquotationitem.

          lwa_zcds_vspqtprice-supplierquotation       = lwa_supquotitem-supplierquotation.
          lwa_zcds_vspqtprice-supplierquotationitem   = lwa_supquotitem-supplierquotationitem.
          lwa_zcds_vspqtprice-requestforquotation     = lwa_supquotitem-requestforquotation.
          lwa_zcds_vspqtprice-requestforquotationitem = lwa_supquotitem-requestforquotationitem.
          lwa_zcds_vspqtprice-supplier                = lwa_supquotitem-supplier.
          lwa_zcds_vspqtprice-suppliername            = VALUE #( lt_supplier[ supplier = lwa_zcds_vspqtprice-supplier ]-suppliername OPTIONAL ).
          lwa_zcds_vspqtprice-plant                   = lwa_supquotitem-plant.
          lwa_zcds_vspqtprice-paymentterms            = lwa_supquotitem-paymentterms.
          lwa_zcds_vspqtprice-incoterms               = lwa_supquotitem-incoterms.
          lwa_zcds_vspqtprice-doccurrency             = 'INR'. "lwa_supquotitem-documentcurrency.
          lwa_zcds_vspqtprice-exchangerate            = lwa_supquotitem-exchangerate.
          lwa_zcds_vspqtprice-qtnstatus               = lwa_supquotitem-qtnstatus.
          lwa_zcds_vspqtprice-remarks                 = lwa_supquotitem-yy1_quoteremarks_pdi.

          DATA(lwa_quotqty)       = VALUE #( lt_supquotqty[ supplierquotation     = lwa_supquotitem-supplierquotation
                                                            supplierquotationitem = lwa_supquotitem-supplierquotationitem ] OPTIONAL ).
          lwa_zcds_vspqtprice-quotationquantity = lwa_quotqty-schedulelineorderquantity.
          lwa_zcds_vspqtprice-requestedquantity = lwa_quotqty-schedulelineorderquantity.
          lwa_zcds_vspqtprice-awardedquantity   = lwa_quotqty-awardedquantity.
          lwa_zcds_vspqtprice-uom               = lwa_quotqty-orderquantityunit.
          lwa_zcds_vspqtprice-deliverydate      = lwa_quotqty-schedulelinedeliverydate.
*                lwa_zcds_vspqtprice-PaymentTermsName  = lwa_supquotitem-PaymentTermsName.
          lwa_zcds_vspqtprice-paymenttermsname  =  VALUE #( lt_paymenttext[ paymentterms = lwa_supquotitem-paymentterms ]-paymenttermsname OPTIONAL ).

          LOOP AT lt_supquotpr_temp INTO DATA(lwa_supquotpr_temp).
            CLEAR: lv_calfldval, lv_calfldval2.

            IF lwa_supquotpr_temp-conditioncalculationtype     = 'A'.   "%
              IF lwa_zcds_vspqtprice-quotationquantity <> 0.
                lv_calfldval = lwa_supquotpr_temp-conditionamount / lwa_zcds_vspqtprice-quotationquantity.
              ELSE.
                lv_calfldval = 0.
              ENDIF.

            ELSEIF lwa_supquotpr_temp-conditioncalculationtype = 'B'   "Fixed Value
                   AND lwa_supquotpr_temp-conditionratevalue <> 0.
              lv_calfldval2 =    lwa_supquotpr_temp-conditionratevalue * lwa_supquotpr_temp-absoluteexchangerate.
              lv_calfldval  = ( lwa_supquotpr_temp-conditionratevalue * lwa_supquotpr_temp-absoluteexchangerate ) / lwa_zcds_vspqtprice-quotationquantity.

            ELSEIF lwa_supquotpr_temp-conditioncalculationtype = 'C'.   "Discount rate on Unit
              lv_calfldval = lwa_supquotpr_temp-conditionratevalue * lwa_supquotpr_temp-absoluteexchangerate.

            ENDIF.

            CASE lwa_supquotpr_temp-conditiontype.
              WHEN 'PMP0' OR 'PPR0'.  "Quotated Rate
                lwa_zcds_vspqtprice-quotedrate      = ( lwa_zcds_vspqtprice-quotedrate + ( lwa_supquotpr_temp-conditionratevalue * lwa_supquotpr_temp-absoluteexchangerate ) ) / lwa_supquotpr_temp-conditionquantity.
                lwa_zcds_vspqtprice-foreigncurr     = lwa_supquotpr_temp-conditioncurrency.
                IF lwa_zcds_vspqtprice-foreigncurr <> 'INR'.
                  lwa_zcds_vspqtprice-foreignrate     = ( lwa_zcds_vspqtprice-foreignrate + lwa_supquotpr_temp-conditionratevalue ).
                ENDIF.
                lwa_zcds_vspqtprice-conditionquantity = lwa_supquotpr_temp-conditionquantity.
*                            lwa_zcds_vspqtprice-DocCurrency     = lwa_supquotpr_temp-CONDITIONCURRENCY.
*                            lwa_zcds_vspqtprice-ExchangeRate    = lwa_supquotpr_temp-ABSOLUTEEXCHANGERATE.
              WHEN 'DRV1' OR 'DL01' OR 'DRQ1'.    "Discount Value
                lwa_zcds_vspqtprice-discount = ( lwa_zcds_vspqtprice-discount + lv_calfldval ) / lwa_supquotpr_temp-conditionquantity.

              WHEN 'ZJC1' OR 'ZSW2'.              "Customs duty Value/Amount
                lwa_zcds_vspqtprice-customsdutyamt = lwa_zcds_vspqtprice-customsdutyamt + lv_calfldval.

              WHEN 'JCDB' OR 'ZSW1'.              "Customs duty %
                IF lwa_supquotpr_temp-conditioncalculationtype     = 'A'.
                  lwa_zcds_vspqtprice-customsdutyamt = lwa_zcds_vspqtprice-customsdutyamt + lwa_supquotpr_temp-conditionamount.
                ENDIF.
                IF lwa_zcds_vspqtprice-quotationquantity <> 0.
                  lwa_zcds_vspqtprice-customsdutyqtyamt =  lwa_zcds_vspqtprice-customsdutyamt / lwa_zcds_vspqtprice-quotationquantity.
                ELSE.
                  lwa_zcds_vspqtprice-customsdutyqtyamt = 0.
                ENDIF.
              WHEN 'ZFG1' OR 'ZFQ1' OR 'ZFV1'.    "Freight
                lwa_zcds_vspqtprice-freightamt = lwa_zcds_vspqtprice-freightamt +  lv_calfldval.

              WHEN 'ZMOC' OR 'ZAGC' OR 'ZPLC'.              "Other Charges
                lwa_zcds_vspqtprice-otchargesamt = lwa_zcds_vspqtprice-otchargesamt + lv_calfldval2.
                lwa_zcds_vspqtprice-otchargesqtyamt = lwa_zcds_vspqtprice-otchargesqtyamt + lv_calfldval.
              WHEN 'ZADD'.              "anti dumping
                lwa_zcds_vspqtprice-antidumping = lwa_zcds_vspqtprice-antidumping + lv_calfldval2.
              WHEN OTHERS.
            ENDCASE.

            lwa_zcds_vspqtprice-negotiatedrate    = lwa_zcds_vspqtprice-quotedrate + lwa_zcds_vspqtprice-discount.
            lwa_zcds_vspqtprice-landedcost        = lwa_zcds_vspqtprice-negotiatedrate + lwa_zcds_vspqtprice-customsdutyamt + lwa_zcds_vspqtprice-freightamt + lwa_zcds_vspqtprice-otchargesqtyamt + lwa_zcds_vspqtprice-antidumping.
* Gross total.

          ENDLOOP.

          lwa_zcds_vspqtprice-grosstotal = lwa_zcds_vspqtprice-awardedquantity * lwa_zcds_vspqtprice-landedcost.
          APPEND lwa_zcds_vspqtprice TO lt_zcds_vspqtprice.
* Summary table
          wa_qtnsummary-supplierquotation = lwa_zcds_vspqtprice-supplierquotation.
          wa_qtnsummary-landedcost        = lwa_zcds_vspqtprice-landedcost.
          COLLECT wa_qtnsummary INTO lt_qtnsummary.
          CLEAR lwa_zcds_vspqtprice.
        ENDLOOP.

* Sorting
        SORT lt_qtnsummary BY landedcost.
        LOOP AT lt_qtnsummary ASSIGNING FIELD-SYMBOL(<f1>).
          lv_idx = sy-tabix.
          CASE lv_idx.
            WHEN 1. <f1>-ranking = 'L1'.
            WHEN 2. <f1>-ranking = 'L2'.
            WHEN 3. <f1>-ranking = 'L3'.
            WHEN 4. <f1>-ranking = 'L4'.
            WHEN 5. <f1>-ranking = 'L5'.
          ENDCASE.
        ENDLOOP.
        SORT lt_qtnsummary BY supplierquotation.

        LOOP AT lt_zcds_vspqtprice ASSIGNING FIELD-SYMBOL(<f2>).
          <f2>-ranking = VALUE #( lt_qtnsummary[ supplierquotation = <f2>-supplierquotation ]-ranking OPTIONAL ).
        ENDLOOP.
*        sort lt_zcds_vspqtprice by ranking supplierquotation supplierquotationitem.

        SELECT * FROM @lt_zcds_vspqtprice AS it ##ITAB_DB_SELECT
            ORDER BY requestforquotation, supplierquotation, supplierquotationitem
        INTO TABLE @DATA(lt_qtprfin)
            OFFSET @off UP TO @lv_max_rows ROWS.

*            lv_Rec_Count = lines(  lt_zcds_vspqtprice ).
        lv_rec_count = lines(  lt_qtprfin ).
        io_response->set_total_number_of_records( iv_total_number_of_records = lv_rec_count ).
*            io_response->set_data( lt_zcds_vspqtprice ).
        io_response->set_data( lt_qtprfin ).

      WHEN OTHERS.
    ENDCASE.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
    ENDTRY.
*    ENDIF.         "If requested
  ENDMETHOD.
ENDCLASS.
