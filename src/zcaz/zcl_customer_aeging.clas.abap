CLASS zcl_customer_aeging DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_final,
              supplier_code     TYPE c LENGTH 10,
              fiscal_year       TYPE c LENGTH 4,
              posting_date      TYPE dats,
              supplier_name     TYPE c LENGTH 100,
              currency_code     TYPE c LENGTH 5,
              days_0_to_30      TYPE  p DECIMALS 2 LENGTH 16,
              days_31_to_60     TYPE  p DECIMALS 2 LENGTH 16,
              days_61_to_90     TYPE p DECIMALS 2 LENGTH 16,
              days_91_to_120    TYPE p DECIMALS 2 LENGTH 16,
              days_121_to_150   TYPE p DECIMALS 2 LENGTH 16,
              days_151_to_180   TYPE p DECIMALS 2 LENGTH 16,
*SOC Added by sanjay 22.11.2024
              days_181_to_210   TYPE p DECIMALS 2 LENGTH 16,
              days_211_to_240   TYPE p DECIMALS 2 LENGTH 16,
              days_241_to_270   TYPE p DECIMALS 2 LENGTH 16,
              days_271_to_365   TYPE p DECIMALS 2 LENGTH 16,
              days_366          TYPE p DECIMALS 2 LENGTH 16,
*EOC Added by sanjay 22.11.2024
*              days_181_to_365   TYPE p DECIMALS 2 LENGTH 10,
*              days_366_to_999   TYPE p DECIMALS 2 LENGTH 10,
*              days_999          TYPE p DECIMALS 2 LENGTH 10,
*              days_181_to_365   TYPE p DECIMALS 2 LENGTH 16,
*              days_366_to_999   TYPE p DECIMALS 2 LENGTH 16,
*              days_999          TYPE p DECIMALS 2 LENGTH 16,
              unadjusted_debits TYPE p DECIMALS 2 LENGTH 16,
              msme              TYPE c LENGTH 10,
              totalamount       TYPE p DECIMALS 2 LENGTH 16,
              not_due           TYPE p DECIMALS 2 LENGTH 16,
              over_due          TYPE p DECIMALS 2 LENGTH 16,
                            Net_over_due          TYPE p DECIMALS 2 LENGTH 16,
*                            fis_year type c length 4,
            END OF ty_final.


    TYPES : BEGIN OF ty_final1,
              supplier_code     TYPE c LENGTH 10,
              fiscal_year       TYPE c LENGTH 4,
              currency_code     TYPE c LENGTH 5,
              document_no       TYPE c LENGTH 10,
              posting_date      TYPE dats,
              days_0_to_30      TYPE  p DECIMALS 2 LENGTH 16,
              days_31_to_60     TYPE  p DECIMALS 2 LENGTH 16,
              days_61_to_90     TYPE p DECIMALS 2 LENGTH 16,
              days_91_to_120    TYPE p DECIMALS 2 LENGTH 16,
              days_121_to_150   TYPE p DECIMALS 2 LENGTH 16,
              days_151_to_180   TYPE p DECIMALS 2 LENGTH 16,

*SOC Added by sanjay 22.11.2024
              days_181_to_210   TYPE p DECIMALS 2 LENGTH 16,
              days_211_to_240   TYPE p DECIMALS 2 LENGTH 16,
              days_241_to_270   TYPE p DECIMALS 2 LENGTH 16,
              days_271_to_365   TYPE p DECIMALS 2 LENGTH 16,
              days_366          TYPE p DECIMALS 2 LENGTH 16,
*EOC Added by sanjay 22.11.2024
*              days_181_to_365   TYPE p DECIMALS 2 LENGTH 10,
*              days_366_to_999   TYPE p DECIMALS 2 LENGTH 10,
*              days_999          TYPE p DECIMALS 2 LENGTH 10,
*              days_181_to_365   TYPE p DECIMALS 2 LENGTH 16,
*              days_366_to_999   TYPE p DECIMALS 2 LENGTH 16,
*              days_999          TYPE p DECIMALS 2 LENGTH 16,
              unadjusted_debits TYPE p DECIMALS 2 LENGTH 16,
*              msme              TYPE p DECIMALS 2 LENGTH 10,
*              totalamount       TYPE p DECIMALS 2 LENGTH 10,
              not_due           TYPE p DECIMALS 2 LENGTH 16,
              over_due          TYPE p DECIMALS 2 LENGTH 16,
            END OF ty_final1.




    DATA: ed_years         TYPE i,
          ed_months        TYPE i,
          days_diff        TYPE i,
          day_off          TYPE i,
          ed_calendar_days TYPE i.

    DATA: lv_from_date TYPE sy-datum.

    DATA: lv_date  TYPE string,
          iv_year  TYPE if_xco_cp_tm_date=>tv_year,
          iv_month TYPE if_xco_cp_tm_date=>tv_month,
          iv_day   TYPE if_xco_cp_tm_date=>tv_day,
          ls_day   TYPE i,
          lt_diff  TYPE i,
          ls_day1  TYPE i,
          lt_diff1 TYPE i,
          day_off1 TYPE i.

    DATA : it_final TYPE TABLE OF ty_final,
           wa_final TYPE ty_final.
    DATA:final    TYPE TABLE OF ty_final .

    DATA: it_final1 TYPE TABLE OF ty_final1,
          wa_final1 TYPE ty_final1.

    DATA: it_final3 TYPE TABLE OF ty_final1,
          wa_final3 TYPE ty_final1.




    DATA: lv_fiscal   TYPE RANGE OF i_journalentry-fiscalyear,
          lv_supplier TYPE RANGE OF i_supplier-supplier,
          lv_posting  TYPE RANGE OF i_operationalacctgdocitem-postingdate.
    DATA: lv_due TYPE i_operationalacctgdocitem-duecalculationbasedate.





    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMER_AEGING IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entity) = io_request->get_entity_id( ).

    CASE lv_entity.


      WHEN 'ZC_CUSTOMER_AGEING'.

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

        DATA : sup(10) TYPE n.

        READ TABLE lt_filter_cond INTO DATA(supfilter) WITH KEY name = 'SUPPLIER_CODE'.
        MOVE-CORRESPONDING supfilter-range TO lv_supplier.
        IF lv_supplier IS NOT INITIAL.
          DATA(lv_cust) = lv_supplier.
          CLEAR : lv_supplier.
          READ TABLE lv_cust INTO DATA(supp) INDEX '1'.
          IF  supp IS NOT INITIAL.
            sup =     supp-low .
            supp-low = sup.
            APPEND supp TO lv_supplier.
          ENDIF.
        ENDIF.

*        READ TABLE lt_filter_cond INTO DATA(supfilter) WITH KEY name = 'SUPPLIER_CODE'.
*        MOVE-CORRESPONDING supfilter-range TO lv_supplier.


        READ TABLE lt_filter_cond INTO DATA(fiscalfil) WITH KEY name = 'FISCAL_YEAR'.
        MOVE-CORRESPONDING fiscalfil-range TO lv_fiscal.


        READ TABLE lt_filter_cond INTO DATA(posting) WITH KEY name = 'POSTING_DATE'.
        MOVE-CORRESPONDING posting-range TO lv_posting.
        DATA : lv_pdate TYPE sy-datum.
        READ TABLE lv_posting INTO DATA(wa_post) INDEX 1.
        IF wa_post IS NOT INITIAL.
          lv_pdate = wa_post-low.
          IF  lv_pdate = 0.
            lv_pdate = sy-datum.
          ENDIF.
        ENDIF.
        IF  lv_pdate = 0.
          lv_pdate = sy-datum.
        ENDIF.
*data : p_dat type sy-datum.
*
*if  lv_posting is not INITIAL.
*read TABLE lv_posting into data(wa) index '1'.
*if wa is not initial.
*p_dat = wa-low.
*endif.
*endif.

        lv_due = '0000-00-00'.



        SELECT * FROM  i_operationalacctgdocitem
            WHERE supplier IN @lv_supplier
              AND fiscalyear IN @lv_fiscal
              AND financialaccounttype = 'K'
               AND postingdate LE @lv_pdate
*              AND PostingDate IN @LV_POSTING
              AND supplier <> ''
              AND clearingjournalentry = ''
              AND duecalculationbasedate NE @lv_due
              and SpecialGLCode <> 'F'
                            and SpecialGLCode <> 'H'
        INTO TABLE @DATA(it_supplier_main) .

SELECT * FROM  i_operationalacctgdocitem
            WHERE supplier IN @lv_supplier
              AND fiscalyear IN @lv_fiscal
              AND financialaccounttype = 'K'
               AND postingdate LE @lv_pdate
*              AND PostingDate IN @LV_POSTING
              AND supplier <> ''
              and ( ClearingDate is not INITIAL and ClearingDate > @lv_pdate )
*              AND ( clearingjournalentry NE '' and ClearingJournalEntry GE @lv_pdate )
              AND duecalculationbasedate NE @lv_due
              and SpecialGLCode <> 'F'
                            and SpecialGLCode <> 'H'
APPENDING TABLE @it_supplier_main .
*        INTO  TABLE @DATA(it_supplier_main) .


        SELECT a~supplier, b~suppliername,b~taxnumber5 FROM i_operationalacctgdocitem AS a LEFT OUTER JOIN i_supplier AS b
        ON a~supplier = b~supplier WHERE a~supplier IN @lv_supplier
        AND a~supplier <>''
         INTO TABLE @DATA(lt_supplier).

        SORT lt_supplier BY supplier.
        DELETE ADJACENT DUPLICATES FROM lt_supplier COMPARING supplier.

        SELECT * FROM i_paymenttermsconditions FOR ALL ENTRIES IN @it_supplier_main
         WHERE paymentterms = @it_supplier_main-paymentterms INTO TABLE @DATA(lt_paymenterms).



        LOOP AT lt_supplier INTO DATA(wa_supplier).

*      SHIFT wa_supplier-supplier LEFT DELETING LEADING '0'.
          wa_final-supplier_code = wa_supplier-supplier.
          wa_final-supplier_name = wa_supplier-suppliername.
          wa_final-msme = wa_supplier-taxnumber5.
SHIFT wa_final-supplier_code LEFT DELETING LEADING '0'.
          LOOP AT it_supplier_main INTO DATA(wa_main) WHERE supplier = wa_supplier-supplier .

            wa_final-fiscal_year = wa_main-fiscalyear.
            wa_final-currency_code = wa_main-companycodecurrency.
            wa_final-posting_date = lv_pdate ."p_dat ."wa_main-PostingDate.



            lv_from_date = wa_main-netduedate.
            REPLACE ALL OCCURRENCES OF '-' IN  lv_from_date WITH ''.

            DATA(lv_sydate) =  lv_pdate ."sy-datum ."wa_main-duecalculationbasedate.
            REPLACE ALL OCCURRENCES OF '-' IN  lv_sydate WITH ''.

*            days_diff =   lv_from_date - lv_sydate.
            days_diff =    lv_sydate - lv_from_date.

            DATA(duedate) = lv_pdate ."sy-datum.
            REPLACE ALL OCCURRENCES OF '-' IN  duedate WITH ''.

*            DATA(lv_date) =  wa_main-duecalculationbasedate.
DATA(lv_date) =  wa_main-NetDueDate.
            REPLACE ALL OCCURRENCES OF '-' IN  lv_date WITH ''.

            day_off =   duedate - lv_date.


            IF wa_main-isusedinpaymenttransaction IS INITIAL AND wa_main-specialglcode NE 'A'.

              IF days_diff BETWEEN 0 AND 30.

                wa_final-days_0_to_30 = wa_final-days_0_to_30 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 31 AND 60.
                wa_final-days_31_to_60 =  wa_final-days_31_to_60 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 61 AND 90.
                wa_final-days_61_to_90 =  wa_final-days_61_to_90 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 91 AND 120.
                wa_final-days_91_to_120 =  wa_final-days_91_to_120 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 121 AND 150.
                wa_final-days_121_to_150 =    wa_final-days_121_to_150 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 151 AND 180.
                wa_final-days_151_to_180 =  wa_final-days_151_to_180 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 181 AND 210.
                wa_final-days_181_to_210 =  wa_final-days_181_to_210 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 211 AND 240.
                wa_final-days_211_to_240 =  wa_final-days_211_to_240 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 241 AND 270.
                wa_final-days_241_to_270 =  wa_final-days_241_to_270 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff BETWEEN 271 AND 365.
                wa_final-days_271_to_365 =  wa_final-days_271_to_365 + wa_main-amountincompanycodecurrency.

              ELSEIF days_diff > 365.
                wa_final-days_366 =   wa_final-days_366 + wa_main-amountincompanycodecurrency.


*              ELSEIF days_diff BETWEEN 181 AND 365.
*                wa_final-days_181_to_365 = wa_final-days_181_to_365 +  wa_main-AmountInCompanyCodeCurrency.
*
*              ELSEIF days_diff  BETWEEN 366 AND 999.
*                wa_final-days_366_to_999 =  wa_final-days_366_to_999 + wa_main-AmountInCompanyCodeCurrency.
*
*              ELSEIF days_diff > 999.
*                wa_final-days_999 =   wa_final-days_999 + wa_main-AmountInCompanyCodeCurrency.

              ENDIF.

              IF  day_off <  0 ."wa_main-cashdiscount1days.
                wa_final-not_due =  wa_final-not_due + wa_main-amountincompanycodecurrency.
              ELSE.
                wa_final-over_due =   wa_final-over_due + wa_main-amountincompanycodecurrency.
              ENDIF.

            ELSE.

              wa_final-unadjusted_debits = wa_final-unadjusted_debits + wa_main-amountincompanycodecurrency.

            ENDIF.



            CLEAR:  days_diff,lv_sydate, ls_day ,  lv_date, iv_day,iv_year,iv_month,
            days_diff,  lv_from_date,  day_off.

          ENDLOOP.
* wa_final-fis_year = lv_fiscal[ 1 ]-low .


          wa_final-totalamount = wa_final-days_0_to_30 +   wa_final-days_31_to_60 +  wa_final-days_61_to_90 +  wa_final-days_91_to_120 +
          wa_final-days_121_to_150 +  wa_final-days_151_to_180 + "wa_final-days_181_to_365 + wa_final-days_366_to_999 +  wa_final-days_999
          wa_final-days_181_to_210 + wa_final-days_211_to_240 + wa_final-days_241_to_270 + wa_final-days_271_to_365 + wa_final-days_366
          + wa_final-unadjusted_debits + wa_final-not_due.
wa_final-net_over_due = wa_final-unadjusted_debits + wa_final-over_due.
          APPEND wa_final TO final.
          DELETE final WHERE fiscal_year IS INITIAL.

          CLEAR: wa_final. "SK

        ENDLOOP.





        SELECT * FROM @final AS it_final                "#EC CI_NOWHERE
              ORDER BY supplier_code DESCENDING
              INTO TABLE @DATA(it_fin)
              OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
        SELECT COUNT( * )
            FROM @final AS it_final                     "#EC CI_NOWHERE
            INTO @DATA(lv_totcount).

        io_response->set_total_number_of_records( lv_totcount ) .
        io_response->set_data( it_fin ).

      WHEN 'ZCHILD_CUSTOMER_AGEING'.


        IF io_request->is_data_requested( ).
          DATA(off1) = io_request->get_paging( )->get_offset(  ).
          DATA(pag1) = io_request->get_paging( )->get_page_size( ).
          DATA(lv_max_rows1) = COND #( WHEN pag1 = if_rap_query_paging=>page_size_unlimited THEN 0
                                      ELSE pag1 ).
          DATA lv_rows1 TYPE int8.

          lv_rows1 = lv_max_rows1.
          DATA(lsort1) = io_request->get_sort_elements( ) .

          DATA(lv_top1)     = io_request->get_paging( )->get_page_size( ).
          IF lv_top1 < 0.
            lv_top1 = 1.
          ENDIF.
          DATA(lv_skip1)    = io_request->get_paging( )->get_offset( ).

          DATA(lv_max_rows_top1) = COND #( WHEN lv_top1 = if_rap_query_paging=>page_size_unlimited THEN 0
                                      ELSE lv_top1 ).

          DATA(lt_fields1)  = io_request->get_requested_elements( ).
          DATA(lt_sort1)    = io_request->get_sort_elements( ).

          DATA(set1) = io_request->get_requested_elements( ).
          DATA(lvs1) = io_request->get_search_expression( ).
          DATA(filter11) = io_request->get_filter(  ).
          DATA(p11) = io_request->get_parameters(  ).
          DATA(p21) = io_request->get_requested_elements(  ).

          DATA(filter_tree1) =   io_request->get_filter( )->get_as_tree(  ).


          TRY.
              DATA(lt_filter_cond1) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
            CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option1). "#EC NO_HANDLER
          ENDTRY.
        ENDIF.


        READ TABLE lt_filter_cond1 INTO DATA(supfilter1) WITH KEY name = 'SUPPLIER_CODE'.
        MOVE-CORRESPONDING supfilter1-range TO lv_supplier.


        READ TABLE lt_filter_cond1 INTO DATA(fiscalfil1) WITH KEY name = 'FISCAL_YEAR'.
        MOVE-CORRESPONDING fiscalfil1-range TO lv_fiscal.

        DATA :child_supplier TYPE  n LENGTH 10.
        child_supplier = lv_supplier[ 1 ]-low.

        DATA :child_fiyear TYPE  c LENGTH 10.
        child_fiyear = lv_fiscal[ 1 ]-low.
        CLEAR : lv_posting , lv_pdate.
        READ TABLE lt_filter_cond1 INTO DATA(posting_key1) WITH KEY name = 'POSTING_DATE'.
        MOVE-CORRESPONDING posting_key1-range TO lv_posting.

        READ TABLE lv_posting INTO DATA(wa_post1) INDEX 1.
        IF wa_post1 IS NOT INITIAL.
          lv_pdate = wa_post1-low.
          IF  lv_pdate = 0.
            lv_pdate = sy-datum.
          ENDIF.
        ENDIF.
        IF  lv_pdate = 0.
          lv_pdate = sy-datum.
        ENDIF.

        SELECT * FROM  i_operationalacctgdocitem
            WHERE supplier = @child_supplier
*              AND fiscalyear = @child_fiyear
              AND fiscalyear IN @lv_fiscal
               AND postingdate LE @lv_pdate
              AND financialaccounttype = 'K'
              AND supplier <> ''
              AND clearingjournalentry = ''
              AND duecalculationbasedate NE @lv_due
              and SpecialGLCode <> 'F'
              and SpecialGLCode <> 'H'
        INTO TABLE @DATA(it_supplier_child) .
        SELECT * FROM  i_operationalacctgdocitem
            WHERE supplier = @child_supplier
*              AND fiscalyear in @lv_fiscal
              AND financialaccounttype = 'K'
               AND postingdate LE @lv_pdate
              AND supplier <> ''
              and ( ClearingDate is not INITIAL and ClearingDate > @lv_pdate )
*              AND clearingjournalentry = ''
              AND duecalculationbasedate NE @lv_due
              and SpecialGLCode <> 'F'
                            and SpecialGLCode <> 'H'
        APPENDING TABLE @it_supplier_child .
*SELECT * FROM  i_operationalacctgdocitem
*            WHERE supplier IN @lv_supplier
*              AND fiscalyear IN @lv_fiscal
*              AND financialaccounttype = 'K'
*               AND postingdate LE @lv_pdate
**              AND PostingDate IN @LV_POSTING
*              AND supplier <> ''
*              and ( ClearingDate is not INITIAL and ClearingDate GE @lv_pdate )
**              AND ( clearingjournalentry NE '' and ClearingJournalEntry GE @lv_pdate )
*              AND duecalculationbasedate NE @lv_due
*              and SpecialGLCode <> 'F'
*APPENDING TABLE @it_supplier_chid .

        LOOP AT it_supplier_child INTO DATA(wa_cust) WHERE supplier = child_supplier.

          wa_final1-supplier_code = child_supplier.
          wa_final1-fiscal_year = wa_cust-fiscalyear.
          wa_final-currency_code = wa_cust-companycodecurrency.
          wa_final1-posting_date = wa_cust-postingdate.
SHIFT wa_final1-supplier_code LEFT DELETING LEADING '0'.
          wa_final1-document_no = wa_cust-accountingdocument.
          DATA(lv_from_date1) = wa_cust-netduedate.
          REPLACE ALL OCCURRENCES OF '-' IN  lv_from_date1 WITH ''.

          DATA(lv_sydate1) = lv_pdate ." sy-datum.                                "wa_cust-duecalculationbasedate.
          REPLACE ALL OCCURRENCES OF '-' IN  lv_sydate1 WITH ''.

*          lt_diff1 =   lv_from_date1 - lv_sydate1.
          lt_diff1 =    lv_sydate1 - lv_from_date1.

          DATA(duedate1) = lv_pdate ." sy-datum.
          REPLACE ALL OCCURRENCES OF '-' IN  duedate1 WITH ''.

*          DATA(lv_date1) =  wa_cust-duecalculationbasedate.
          DATA(lv_date1) =  wa_cust-NetDueDate.
          REPLACE ALL OCCURRENCES OF '-' IN  lv_date1 WITH ''.

          day_off1 =   duedate1 - lv_date1.

          IF wa_cust-isusedinpaymenttransaction IS INITIAL AND wa_cust-specialglcode NE 'A'.

            IF  lt_diff1 BETWEEN 0 AND 30.

              wa_final1-days_0_to_30 = wa_final1-days_0_to_30 + wa_cust-amountincompanycodecurrency.

            ELSEIF  lt_diff1 BETWEEN 31 AND 60.
              wa_final1-days_31_to_60 =  wa_final1-days_31_to_60 + wa_cust-amountincompanycodecurrency.

            ELSEIF  lt_diff1 BETWEEN 61 AND 90.
              wa_final1-days_61_to_90 =  wa_final1-days_61_to_90 + wa_cust-amountincompanycodecurrency.

            ELSEIF  lt_diff1 BETWEEN 91 AND 120.
              wa_final1-days_91_to_120 =  wa_final1-days_91_to_120 + wa_cust-amountincompanycodecurrency.

            ELSEIF  lt_diff1 BETWEEN 121 AND 150.
              wa_final1-days_121_to_150 =    wa_final1-days_121_to_150 + wa_cust-amountincompanycodecurrency.

            ELSEIF  lt_diff1 BETWEEN 151 AND 180.
              wa_final1-days_151_to_180 =  wa_final1-days_151_to_180 + wa_cust-amountincompanycodecurrency.

*            ELSEIF  lt_diff1 BETWEEN 181 AND 365.
*              wa_final1-days_181_to_365 =   wa_final1-days_181_to_365 + wa_cust-AmountInCompanyCodeCurrency.
*
*            ELSEIF  lt_diff1  BETWEEN 366 AND 999.
*              wa_final1-days_366_to_999 =  wa_final1-days_366_to_999 + wa_cust-AmountInCompanyCodeCurrency.
*
*            ELSEIF lt_diff1 > 999.
*              wa_final1-days_999 =   wa_final1-days_999 + wa_cust-AmountInCompanyCodeCurrency.

            ELSEIF lt_diff1 BETWEEN 181 AND 210.
              wa_final1-days_181_to_210 = wa_final1-days_181_to_210 +  wa_cust-amountincompanycodecurrency.

            ELSEIF lt_diff1  BETWEEN 211 AND 240.
              wa_final1-days_211_to_240 =  wa_final1-days_211_to_240 + wa_cust-amountincompanycodecurrency.

            ELSEIF lt_diff1  BETWEEN 241 AND 270.
              wa_final1-days_241_to_270 =  wa_final1-days_241_to_270 + wa_cust-amountincompanycodecurrency.

            ELSEIF lt_diff1  BETWEEN 271 AND 365.
              wa_final1-days_271_to_365 =  wa_final1-days_271_to_365 + wa_cust-amountincompanycodecurrency.

            ELSEIF lt_diff1 > 365.
              wa_final1-days_366 =   wa_final1-days_366 + wa_cust-amountincompanycodecurrency.


            ENDIF.

            IF  day_off1 <  0 ." wa_cust-cashdiscount1days.
              wa_final1-not_due =  wa_final1-not_due + wa_cust-amountincompanycodecurrency.
            ELSE.
              wa_final1-over_due =   wa_final1-over_due + wa_cust-amountincompanycodecurrency.
            ENDIF.

          ELSE.

            wa_final1-unadjusted_debits = wa_final1-unadjusted_debits + wa_cust-amountincompanycodecurrency.

          ENDIF.

          APPEND wa_final1 TO it_final1.
          DELETE it_final WHERE fiscal_year IS INITIAL.
          CLEAR wa_final1.
          CLEAR: lt_diff1 ,lv_sydate1, ls_day1 ,  lv_date1,  lv_from_date1,  day_off1.

        ENDLOOP.


        SELECT * FROM @it_final1 AS it_final3           "#EC CI_NOWHERE
           ORDER BY supplier_code DESCENDING
           INTO TABLE @DATA(it_fin1)
           OFFSET @lv_skip1 UP TO  @lv_max_rows1 ROWS.
        SELECT COUNT( * )
            FROM @it_final1 AS it_final3                "#EC CI_NOWHERE
            INTO @DATA(lv_totcount1).



        io_response->set_total_number_of_records( lv_totcount1 ).
        io_response->set_data( it_fin1 ).


    ENDCASE.

  ENDMETHOD.
ENDCLASS.
