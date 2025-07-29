CLASS zcl_freight_order DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FREIGHT_ORDER IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
    DATA lv_rows TYPE int8.
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

    DATA(lv_where_clause) = io_request->get_filter( )->get_as_sql_string( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
    ENDTRY.

    DATA: it_final TYPE TABLE OF zce_freight_order,
          wa_final TYPE zce_freight_order.


    SELECT DISTINCT billingdocument, billingdocumentitem, freightorderno1, freightorderno, documentreferenceid, plant,
        billingdocumentdate, deliveryno, salesdocument, po_no, frtcostallocdoccurrency, soldtoparty, frtcostallocdocumentitem,
        customername, destination, profitcenter, product, productname, billingquantityunit, netqty, grossqty, grossweght,
        incotermsclassification, supplier, itemweightunit,billingdocumentdate1
        FROM zi_freight_cds
        WHERE (lv_where_clause)
        INTO TABLE @DATA(it_tab).

       SELECT DISTINCT *
        FROM zi_freight_cds
        WHERE (lv_where_clause)
        INTO TABLE @DATA(it_tab_test).

    DELETE it_tab WHERE netqty EQ '0.00' AND netqty = ''.
    DELETE ADJACENT DUPLICATES FROM it_tab.
    IF it_tab IS NOT INITIAL.
      SELECT deliverydocument, deliverydate, deliverydocument AS test
          FROM i_deliverydocument
          FOR ALL ENTRIES IN @it_tab
          WHERE deliverydocument = @it_tab-deliveryno
          INTO TABLE @DATA(it_deldate).
      DATA lv_date(10) TYPE c.
      LOOP AT it_deldate INTO DATA(wa_deldat).
        lv_date = |{ wa_deldat-deliverydate+6(2) }.{ wa_deldat-deliverydate+4(2) }.{ wa_deldat-deliverydate+0(4) }|.
        wa_deldat-test = lv_date.
        MODIFY it_deldate FROM wa_deldat.
      ENDLOOP.

      SELECT supplier, suppliername
           FROM i_supplier
           FOR ALL ENTRIES IN @it_tab
           WHERE supplier = @it_tab-supplier
           INTO TABLE @DATA(it_supp).

      SELECT purchaseorder, serviceentrysheet
        FROM c_serviceentrysheetdex
        FOR ALL ENTRIES IN @it_tab
        WHERE purchaseorder = @it_tab-po_no
        INTO TABLE @DATA(it_serviceentry).

      SELECT a~purchaseorder, a~supplierinvoice, a~supplierinvoiceitemamount
         FROM i_suplrinvcitempurordrefapi01 AS a
         LEFT OUTER JOIN i_supplierinvoiceapi01 AS b ON a~supplierinvoice = b~supplierinvoice
         FOR ALL ENTRIES IN @it_tab
         WHERE a~purchaseorder = @it_tab-po_no
*           AND b~isinvoice = ''
         INTO TABLE @DATA(it_miro).

      SELECT a~transportationorder, a~transportationorderexecsts, b~transportationorderexecstsdesc FROM i_freightordertp AS a
        INNER JOIN i_transpordexecstatustext_2 AS b ON b~transportationorderexecsts = a~transportationorderexecsts
        FOR ALL ENTRIES IN @it_tab
        WHERE a~transportationorder = @it_tab-freightorderno1
          AND b~language = 'E'
        INTO TABLE @DATA(it_fos).

      SELECT * FROM i_profitcentertext
      FOR ALL ENTRIES IN @it_tab
        WHERE profitcenter = @it_tab-profitcenter
          AND language = 'E'
        INTO TABLE @DATA(it_profittext).

    ENDIF.
    LOOP AT it_tab INTO DATA(wa_tab).
      wa_final-plant = wa_tab-plant.
      wa_final-gstinvoiceno = wa_tab-documentreferenceid.
      wa_final-billingdocument = wa_tab-billingdocument.
      wa_final-billingdocumentitem = wa_tab-billingdocumentitem.
      wa_final-billingdocumentdate = wa_tab-billingdocumentdate.
      wa_final-deliveryno = wa_tab-deliveryno.
      wa_final-deliverydate = VALUE #( it_deldate[ deliverydocument = wa_tab-deliveryno ]-test OPTIONAL ).
      wa_final-salesorderno = wa_tab-salesdocument.
      wa_final-freightorderno = wa_tab-freightorderno.

      SHIFT wa_final-freightorderno LEFT DELETING LEADING '0'.
      wa_final-pono = wa_tab-po_no.
*      wa_final-freighcostdocno = wa_tab-freightcostallocationdocument.
      wa_final-customercode = wa_tab-soldtoparty.
      wa_final-customername = wa_tab-customername.
      wa_final-profitcentrename = VALUE #( it_profittext[ profitcenter = wa_tab-profitcenter ]-profitcentername OPTIONAL ).
      wa_final-destination = wa_tab-destination.
      wa_final-materialcode = wa_tab-product.
      wa_final-productname = wa_tab-productname.
      wa_final-netqty = wa_tab-netqty.
      wa_final-grossqty = wa_tab-grossqty.
      wa_final-billingquantityunit = wa_tab-billingquantityunit.
      wa_final-incoterm = wa_tab-incotermsclassification.
      wa_final-transporter = wa_tab-supplier.
      wa_final-itemweightunit = wa_tab-itemweightunit.
      wa_final-weight = wa_tab-grossweght.

      wa_final-nameoftransporter = VALUE #( it_supp[ supplier = wa_tab-supplier ]-suppliername OPTIONAL ).
      wa_final-freightunitstatus = VALUE #( it_fos[ transportationorder = wa_tab-freightorderno ]-transportationorderexecstsdesc OPTIONAL ).
*      wa_final-freightamount = wa_tab-frtamt. pending to display amount

      SELECT DISTINCT freightcostallocationdocument FROM i_frtcostallocitm
        WHERE freightorder = @wa_tab-freightorderno1
        ORDER BY freightcostallocationdocument
        INTO TABLE @DATA(it_frtcstdoc).

      wa_final-freighcostdocno = VALUE #( it_frtcstdoc[ 1 ]-freightcostallocationdocument OPTIONAL ).
      DATA(wa_frtdoc1) = VALUE #( it_frtcstdoc[ 1 ]-freightcostallocationdocument OPTIONAL ).

      SELECT * FROM i_frtcostallocitm
        WHERE freightcostallocationdocument = @wa_frtdoc1
        INTO TABLE @DATA(it_all1).

      DATA(wa_all1) = VALUE #( it_all1[ freightcostallocationdocument = wa_frtdoc1 frtcostallocdocumentitem = wa_tab-frtcostallocdocumentitem ] OPTIONAL ).

      wa_final-plancost = wa_all1-frtcostallocitemgrossamount.
      wa_final-freightamount = wa_all1-frtcostallocitemgrossamount.

      DATA(wa_frtdoc2) = VALUE #( it_frtcstdoc[ 2 ]-freightcostallocationdocument OPTIONAL ).

      SELECT * FROM i_frtcostallocitm
        WHERE freightcostallocationdocument = @wa_frtdoc2
        INTO TABLE @DATA(it_all2).

      DATA(wa_all2) = VALUE #( it_all2[ freightcostallocationdocument = wa_frtdoc2 frtcostallocdocumentitem = wa_tab-frtcostallocdocumentitem ] OPTIONAL ).

      wa_final-unplancost = wa_all2-frtcostallocitemgrossamount.
      wa_final-serviceentrysheet = VALUE #( it_serviceentry[ purchaseorder = wa_tab-po_no ]-serviceentrysheet OPTIONAL ).
      wa_final-mirono = VALUE #( it_miro[ purchaseorder = wa_tab-po_no ]-supplierinvoice OPTIONAL ).
      wa_final-variance = wa_final-freightamount - wa_final-plancost - wa_final-unplancost.
      wa_final-creationdate = wa_all2-CreationDate.
      APPEND wa_final TO it_final.
      CLEAR wa_final.
    ENDLOOP.

    SELECT * FROM @it_final AS it_final                 "#EC CI_NOWHERE
       ORDER BY billingdocument
       INTO TABLE @DATA(it_fin)
       OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
    SELECT COUNT( * )
        FROM @it_final AS it_final                      "#EC CI_NOWHERE
        INTO @DATA(lv_totcount).

    io_response->set_total_number_of_records( lv_totcount ).
    io_response->set_data( it_fin ).
  ENDMETHOD.
ENDCLASS.
