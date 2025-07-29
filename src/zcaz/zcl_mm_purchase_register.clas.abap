CLASS zcl_mm_purchase_register DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: lv_credit TYPE c LENGTH 10 VALUE 'H-Credit',
          lv_debit  TYPE c LENGTH 10 VALUE 'S-Debit',
          lv_bal    TYPE c LENGTH 10,
          lv_po     TYPE i_materialdocumentitem_2-purchaseorder,
          lv_poitm  TYPE i_materialdocumentitem_2-purchaseorderitem.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_PURCHASE_REGISTER IMPLEMENTATION.


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

      TYPES : BEGIN OF ty_temp,
                materialdocument         TYPE char10,
                materialdocumentitem     TYPE char4,
                reversedmaterialdocument TYPE char20,
              END  OF ty_temp.







      DATA: it_final TYPE TABLE OF zmm_purchase_register,
            wa_final TYPE          zmm_purchase_register.
      TYPES: BEGIN OF ty_main,
               purchaseorder                 TYPE i_purchaseorderitemapi01-purchaseorder,
               purchaseorderitem             TYPE i_purchaseorderitemapi01-purchaseorderitem,
               material                      TYPE i_purchaseorderitemapi01-material,
               companycode                   TYPE  i_purchaseorderitemapi01-companycode,
               plant                         TYPE i_purchaseorderitemapi01-plant,
               purchaserequisition           TYPE i_purchaseorderitemapi01-purchaserequisition,
               purchaserequisitionitem       TYPE i_purchaseorderitemapi01-purchaserequisitionitem,
               baseunit                      TYPE i_purchaseorderitemapi01-baseunit,
               orderquantity                 TYPE i_purchaseorderitemapi01-orderquantity,
               netpriceamount                TYPE i_purchaseorderitemapi01-netpriceamount,
               br_ncm                        TYPE i_purchaseorderitemapi01-br_ncm,
               iscompletelydelivered         TYPE i_purchaseorderitemapi01-iscompletelydelivered,
               purchaseorderitemtext         TYPE i_purchaseorderitemapi01-purchaseorderitemtext,
               purchaseorderquantityunit     TYPE i_purchaseorderitemapi01-purchaseorderquantityunit,
               purchaseordertype             TYPE i_purchaseorderapi01-purchaseordertype,
               purchaseorderdate             TYPE i_purchaseorderapi01-purchaseorderdate,
               purchasinggroup               TYPE i_purchaseorderapi01-purchasinggroup,
               supplier                      TYPE i_purchaseorderapi01-supplier,
               paymentterms                  TYPE i_purchaseorderapi01-paymentterms,
               incotermsclassification       TYPE i_purchaseorderapi01-incotermsclassification,
               plantname                     TYPE i_plant-plantname,
               suppliername                  TYPE i_supplier-suppliername,
               productname                   TYPE i_producttext-productname,
               supplierinvoice               TYPE i_suplrinvcitempurordrefapi01-supplierinvoice,
               supplierinvoiceitem           TYPE i_suplrinvcitempurordrefapi01-supplierinvoiceitem,
               fiscalyear                    TYPE i_suplrinvcitempurordrefapi01-fiscalyear,
               taxcode                       TYPE i_suplrinvcitempurordrefapi01-taxcode,
               qtyinpurchaseorderpriceunit   TYPE i_suplrinvcitempurordrefapi01-qtyinpurchaseorderpriceunit,
               invoicebaseamnt               TYPE i_suplrinvcitempurordrefapi01-supplierinvoiceitemamount,
               documentcurrency              TYPE i_suplrinvcitempurordrefapi01-documentcurrency,
               invccondtype                  TYPE i_suplrinvcitempurordrefapi01-suplrinvcdeliverycostcndntype,
               debitcreditcode               TYPE i_suplrinvcitempurordrefapi01-debitcreditcode,
               referencedocument             TYPE i_suplrinvcitempurordrefapi01-referencedocument,
               referencedocumentitem         TYPE i_suplrinvcitempurordrefapi01-referencedocumentitem,
               purchasinggroupname           TYPE i_purchasinggroup-purchasinggroupname,
               materialdocument              TYPE i_materialdocumentitem_2-materialdocument,
               materialdocumentitem          TYPE i_materialdocumentitem_2-materialdocumentitem,
               quantityinentryunit           TYPE i_materialdocumentitem_2-quantityinentryunit,
               postingdate                   TYPE i_materialdocumentitem_2-postingdate,
               businessplace                 TYPE i_supplierinvoiceapi01-businessplace,
               invoicingparty                TYPE i_supplierinvoiceapi01-invoicingparty,
               reversedocument               TYPE i_supplierinvoiceapi01-reversedocument,
               documentdate                  TYPE i_supplierinvoiceapi01-documentdate,
               supplierinvoiceidbyinvcgparty TYPE i_supplierinvoiceapi01-supplierinvoiceidbyinvcgparty,
               businessplacedescription      TYPE i_in_businessplacetaxdetail-businessplacedescription,
               in_gstidentificationnumber    TYPE i_in_businessplacetaxdetail-in_gstidentificationnumber,
               taxamount                     TYPE i_supplierinvoicetaxapi01-taxamount,
               taxbaseamountintranscrcy      TYPE i_supplierinvoicetaxapi01-taxbaseamountintranscrcy,
               taxcodename                   TYPE i_taxcodetext-taxcodename,
             END OF ty_main.
      DATA : it_temp TYPE TABLE OF ty_temp,
             wa_temp TYPE ty_temp.

      DATA : it_temp1 TYPE TABLE OF ty_temp,
             wa_temp1 TYPE ty_temp.

      TYPES: BEGIN OF r_plant,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE ebeln,
               high   TYPE ebeln,
             END OF r_plant.

      TYPES: BEGIN OF r_ebeln,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE ebeln,
               high   TYPE ebeln,
             END OF r_ebeln.

      TYPES: BEGIN OF r_podate,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE ebeln,
               high   TYPE ebeln,
             END OF r_podate.

      TYPES: BEGIN OF r_invoice,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE ebeln,
               high   TYPE ebeln,
             END OF r_invoice.

      TYPES: BEGIN OF r_postingdate,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE ebeln,
               high   TYPE ebeln,
             END OF r_postingdate.
      DATA: r_ebeln       TYPE TABLE OF r_ebeln,
            w_ebeln       TYPE          r_ebeln,
            r_plant       TYPE TABLE OF r_plant,
            w_plant       TYPE          r_plant,
            r_podate      TYPE TABLE OF r_podate,
            w_podate      TYPE          r_podate,
            r_invoice     TYPE TABLE OF r_invoice,
            w_invoice     TYPE          r_invoice,
            r_postingdate TYPE TABLE OF r_postingdate,
            w_postingdate TYPE          r_postingdate.

      READ TABLE lt_filter_cond INTO DATA(wa_input) WITH KEY name = 'PLANT'.
      IF sy-subrc = 0.
        DATA(lv_range) = wa_input-range.
        IF lv_range IS NOT INITIAL.
          LOOP AT lv_range INTO DATA(wa_range) .
            MOVE-CORRESPONDING wa_range TO w_plant.
            APPEND w_plant TO r_plant.
            CLEAR: w_plant.
          ENDLOOP.
        ENDIF.
      ENDIF.

      READ TABLE lt_filter_cond INTO wa_input WITH KEY name = 'PURCHASEORDER'.
      IF sy-subrc = 0.
        lv_range = wa_input-range.
        IF lv_range IS NOT INITIAL.
          LOOP AT lv_range INTO wa_range.
            MOVE-CORRESPONDING wa_range TO w_ebeln.
            APPEND w_ebeln TO r_ebeln.
            CLEAR: w_ebeln.
          ENDLOOP.
        ENDIF.
      ENDIF.

      READ TABLE lt_filter_cond INTO wa_input WITH KEY name = 'PURCHASEORDERDATE'.
      IF sy-subrc = 0.
        lv_range = wa_input-range.
        IF lv_range IS NOT INITIAL.
          LOOP AT lv_range INTO wa_range.
            MOVE-CORRESPONDING wa_range TO w_podate.
            APPEND w_podate TO r_podate.
            CLEAR: w_podate.
          ENDLOOP.
        ENDIF.
      ENDIF.

      READ TABLE lt_filter_cond INTO wa_input WITH KEY name = 'SUPPLIERINVOICE'.
      IF sy-subrc = 0.
        lv_range = wa_input-range.
        IF lv_range IS NOT INITIAL.
          LOOP AT lv_range INTO wa_range.
            MOVE-CORRESPONDING wa_range TO w_invoice.
            APPEND w_invoice TO r_ebeln.
            CLEAR: w_invoice.
          ENDLOOP.
        ENDIF.
      ENDIF.

      READ TABLE lt_filter_cond INTO wa_input WITH KEY name = 'POSTINGDATE'.
      IF sy-subrc = 0.
        lv_range = wa_input-range.
        IF lv_range IS NOT INITIAL.
          LOOP AT lv_range INTO wa_range.
            MOVE-CORRESPONDING wa_range TO w_postingdate.
            APPEND w_postingdate TO r_postingdate.
            CLEAR: w_postingdate.
          ENDLOOP.
        ENDIF.
      ENDIF.

      IF r_plant IS NOT INITIAL.
        SELECT DISTINCT  a~purchaseorder,
                a~purchaseorderitem,
                a~material,
                a~companycode,
                a~plant,
                a~purchaserequisition,
                a~purchaserequisitionitem,
                a~baseunit,
                a~orderquantity,
                a~netpricequantity AS peruom,
                a~netpriceamount,
                a~br_ncm,
                a~iscompletelydelivered,
                a~purchaseorderitemtext,
                a~purchaseorderquantityunit,
                b~purchaseordertype,
                b~purchaseorderdate,
                b~purchasinggroup,
                b~supplier,
                b~paymentterms,
                b~incotermsclassification,
                c~plantname,
                d~suppliername,
                e~productname,
                f~supplierinvoice,
                f~supplierinvoiceitem,
                f~fiscalyear,
                f~taxcode,
                f~qtyinpurchaseorderpriceunit,
                f~supplierinvoiceitemamount AS invoicebaseamnt,
                a~documentcurrency,
                f~documentcurrency AS supplierdocumentcurrency,
                f~suplrinvcdeliverycostcndntype AS invccondtype,
                f~debitcreditcode,
                f~referencedocument,
                f~referencedocumentitem,
                g~purchasinggroupname,
*                h~materialdocument,
*                h~materialdocumentitem,
*                h~quantityinentryunit,
                i~postingdate,
                i~supplierpostinglineitemtext,
                i~businessplace,
                i~invoicingparty,
                i~reversedocument,
                i~documentdate,
                i~supplierinvoiceidbyinvcgparty,
                i~exchangerate,
                j~businessplacedescription,
                j~in_gstidentificationnumber,
                k~taxamount,
                k~taxbaseamountintranscrcy,
                l~taxcodename,
                n~conditionratevalue,
                o~schedulelinedeliverydate
             FROM i_purchaseorderitemapi01 AS a
                    LEFT OUTER JOIN i_purchaseorderapi01 AS b ON a~purchaseorder = b~purchaseorder
                    LEFT OUTER JOIN i_plant AS c ON a~plant = c~plant
                    LEFT OUTER JOIN i_supplier AS d ON d~supplier = b~supplier
                    LEFT OUTER JOIN i_producttext AS e ON a~material = e~product AND e~language = 'E'
                    LEFT OUTER JOIN i_suplrinvcitempurordrefapi01 AS f ON a~purchaseorder = f~purchaseorder AND a~purchaseorderitem = f~purchaseorderitem
                    LEFT OUTER JOIN i_purchasinggroup AS g ON b~purchasinggroup = g~purchasinggroup
*                    LEFT OUTER JOIN i_materialdocumentitem_2 AS h ON h~purchaseorder = a~purchaseorder AND h~purchaseorderitem = a~purchaseorderitem
*                                                                 AND h~reversedmaterialdocument = '' AND h~goodsmovementiscancelled = '' AND h~goodsmovementtype = '101'
                    LEFT OUTER JOIN i_supplierinvoiceapi01 AS i ON i~supplierinvoice = f~supplierinvoice
                    LEFT OUTER JOIN i_in_businessplacetaxdetail AS j ON i~businessplace = j~businessplace
                    LEFT OUTER JOIN i_supplierinvoicetaxapi01 AS k ON k~supplierinvoice = f~supplierinvoice AND k~supplierinvoicetaxcounter = f~supplierinvoiceitem
                    LEFT OUTER JOIN i_taxcodetext AS l ON f~taxcode = l~taxcode
                    LEFT OUTER JOIN i_purorditmpricingelementapi01 AS n ON a~purchaseorder = n~purchaseorder
                                                                        AND a~purchaseorderitem = n~purchaseorderitem
                                                                        AND n~conditiontype = 'ZPI0'
                    LEFT OUTER JOIN i_purordschedulelineapi01 AS o ON a~purchaseorder = o~purchaseorder
                                                                  AND a~purchaseorderitem = o~purchaseorderitem
*                    LEFT OUTER JOIN i_purorditmpricingelementapi01 AS m ON f~purchaseorder = a~purchaseorder AND f~purchaseorderitem = a~purchaseorderitem
                    WHERE  a~plant IN @r_plant AND
                           a~purchaseorder IN @r_ebeln
                       AND b~purchaseorderdate IN @r_podate
                       AND f~supplierinvoice IN @r_invoice
                       AND a~purchasingdocumentdeletioncode = ''
                      AND i~postingdate IN @r_postingdate
*                       AND m~conditiontype <>
                    INTO TABLE @DATA(it_podetails).
        IF r_postingdate IS INITIAL.
          SELECT DISTINCT a~purchaseorder,
                 a~purchaseorderitem,
                 a~material,
                 a~companycode,
                 a~plant,
                 a~purchaserequisition,
                 a~purchaserequisitionitem,
                 a~baseunit,
                 a~orderquantity,
                 a~netpricequantity AS peruom,
                 a~netpriceamount,
                 a~documentcurrency,
                 a~br_ncm,
                 a~iscompletelydelivered,
                 a~purchaseorderitemtext,
                 a~purchaseorderquantityunit,
                 b~purchaseordertype,
                 b~purchaseorderdate,
                 b~purchasinggroup,
                 b~supplier,
                 b~paymentterms,
                 b~incotermsclassification,
                 c~plantname,
                 d~suppliername,
                 e~productname,
*                f~supplierinvoice,
*                f~supplierinvoiceitem,
*                f~fiscalyear,
*                f~taxcode,
*                f~qtyinpurchaseorderpriceunit,
*                f~supplierinvoiceitemamount AS invoicebaseamnt,
*                f~documentcurrency,
*                f~suplrinvcdeliverycostcndntype AS invccondtype,
*                f~debitcreditcode,
*                f~referencedocument,
*                f~referencedocumentitem,
                 g~purchasinggroupname,
                 h~materialdocument,
                 h~materialdocumentitem,
                 h~quantityinentryunit,
                 h~postingdate AS migodate,
                 n~conditionratevalue,
                 o~schedulelinedeliverydate
*                i~postingdate,
*                i~businessplace,
*                i~invoicingparty,
*                i~reversedocument,
*                i~documentdate,
*                i~supplierinvoiceidbyinvcgparty,
*                j~businessplacedescription,
*                j~in_gstidentificationnumber,
*                k~taxamount,
*                l~taxcodename
              FROM i_purchaseorderitemapi01 AS a
                     LEFT OUTER JOIN i_purchaseorderapi01 AS b ON a~purchaseorder = b~purchaseorder
                     LEFT OUTER JOIN i_plant AS c ON a~plant = c~plant
                     LEFT OUTER JOIN i_supplier AS d ON d~supplier = b~supplier
                     LEFT OUTER JOIN i_producttext AS e ON a~material = e~product AND e~language = 'E'
*                    LEFT OUTER JOIN i_suplrinvcitempurordrefapi01 AS f ON a~purchaseorder = f~purchaseorder AND a~purchaseorderitem = f~purchaseorderitem
                     LEFT OUTER JOIN i_purchasinggroup AS g ON b~purchasinggroup = g~purchasinggroup
                     LEFT OUTER JOIN i_materialdocumentitem_2 AS h ON h~purchaseorder = a~purchaseorder AND h~purchaseorderitem = a~purchaseorderitem
                                                                      AND h~reversedmaterialdocument = '' AND h~goodsmovementiscancelled = ''
                                                                      AND ( h~goodsmovementtype = '101' OR h~goodsmovementtype = '161' )
                     LEFT OUTER JOIN i_purorditmpricingelementapi01 AS n ON a~purchaseorder = n~purchaseorder
                                                                        AND a~purchaseorderitem = n~purchaseorderitem
                                                                        AND n~conditiontype = 'ZPI0'
                     LEFT OUTER JOIN i_purordschedulelineapi01 AS o ON a~purchaseorder = o~purchaseorder
                                                                    AND a~purchaseorderitem = o~purchaseorderitem
*                    LEFT OUTER JOIN i_supplierinvoiceapi01 AS i ON i~supplierinvoice = f~supplierinvoice
*                    LEFT OUTER JOIN i_in_businessplacetaxdetail AS j ON i~businessplace = j~businessplace
*                    LEFT OUTER JOIN i_supplierinvoicetaxapi01 AS k ON k~supplierinvoice = f~supplierinvoice AND k~supplierinvoicetaxcounter = f~supplierinvoiceitem
*                    LEFT OUTER JOIN i_taxcodetext AS l ON f~taxcode = l~taxcode
*                    LEFT OUTER JOIN i_purorditmpricingelementapi01 AS m ON f~purchaseorder = a~purchaseorder AND f~purchaseorderitem = a~purchaseorderitem
                     WHERE  a~plant IN @r_plant AND
                            a~purchaseorder IN @r_ebeln
                        AND b~purchaseorderdate IN @r_podate
*                       AND f~supplierinvoice IN @r_invoice
                        AND a~purchasingdocumentdeletioncode = ''
*                      AND i~postingdate IN @r_postingdate
*                       AND m~conditiontype <>
                     INTO TABLE @DATA(it_pomigo).
        ENDIF.
        SELECT materialdocument, materialdocumentitem, quantityinentryunit, purchaseorder, purchaseorderitem, postingdate AS migodt
           FROM i_materialdocumentitem_2
           FOR ALL ENTRIES IN @it_podetails
           WHERE purchaseorder = @it_podetails-purchaseorder
             AND purchaseorderitem = @it_podetails-purchaseorderitem
             AND reversedmaterialdocument = ''
             AND goodsmovementiscancelled = ''
             AND ( goodsmovementtype = '101' OR goodsmovementtype = '161' )
            INTO TABLE @DATA(it_migo).

        SELECT referencedocument, accountingdocument,fiscalyear
             FROM i_journalentryitem
             FOR ALL ENTRIES IN @it_podetails
             WHERE referencedocument = @it_podetails-supplierinvoice
               AND fiscalyear = @it_podetails-fiscalyear
             INTO TABLE @DATA(it_journal).



        SELECT in_gstpartner, accountingdocument
             FROM i_operationalacctgdocitem
             FOR ALL ENTRIES IN @it_journal
             WHERE accountingdocument = @it_journal-accountingdocument
             and FiscalYear = @it_journal-FiscalYear
             AND in_gstpartner <> ''
             INTO TABLE @DATA(it_gst).

        SELECT * FROM i_supplier
                 FOR ALL ENTRIES IN @it_gst
                 WHERE supplier = @it_gst-in_gstpartner
                       INTO TABLE @DATA(it_supgstpartner).

        SELECT *
            FROM i_purorditmpricingelementapi01
            FOR ALL ENTRIES IN @it_podetails
            WHERE purchaseorder = @it_podetails-purchaseorder
              AND purchaseorderitem = @it_podetails-purchaseorderitem
            INTO TABLE @DATA(it_povalue).
      ENDIF.

      IF it_podetails IS NOT INITIAL.
        SELECT * FROM i_purchaserequisitionitemapi01
                 FOR ALL ENTRIES IN @it_podetails
                 WHERE plant IN @r_plant AND
                       purchaserequisition = @it_podetails-purchaserequisition
                       INTO TABLE @DATA(it_prdetails).

        SELECT * FROM i_purchasinggroup
                 FOR ALL ENTRIES IN @it_podetails
                 WHERE  purchasinggroup = @it_podetails-purchasinggroup
                 INTO TABLE  @DATA(it_purchasing).


        SELECT * FROM i_supplier
                 FOR ALL ENTRIES IN @it_podetails
                 WHERE supplier = @it_podetails-supplier
                       INTO TABLE @DATA(it_supplierdetails).
        SELECT * FROM i_supplier
                FOR ALL ENTRIES IN @it_podetails
                WHERE supplier = @it_podetails-invoicingparty
                APPENDING TABLE @it_supplierdetails.

        SELECT *
            FROM i_regiontext                           "#EC CI_NOWHERE
            INTO TABLE @DATA(it_region).

        SELECT * FROM i_materialdocumentitem_2
                 FOR ALL ENTRIES IN @it_podetails
                 WHERE purchaseorder = @it_podetails-purchaseorder
         AND  purchaseorderitem = @it_podetails-purchaseorderitem
         AND goodsmovementtype NE '321'
         INTO TABLE @DATA(it_matdocument).

        SELECT *
             FROM i_supplierinvoicetaxapi01
             FOR ALL ENTRIES IN @it_podetails
             WHERE supplierinvoice = @it_podetails-supplierinvoice
             AND  taxcode = @it_podetails-taxcode
             INTO TABLE @DATA(it_taxamount).

        SELECT * FROM i_taxcodetext
           FOR ALL ENTRIES IN @it_podetails
           WHERE taxcode = @it_podetails-taxcode
           INTO TABLE @DATA(it_taxctext).

        SELECT * FROM i_journalentryitem
            FOR ALL ENTRIES IN @it_podetails
            WHERE referencedocument = @it_podetails-supplierinvoice
            AND   referencedocumentitem = @it_podetails-supplierinvoiceitem
            AND   fiscalyear =            @it_podetails-fiscalyear
            INTO TABLE @DATA(it_journalentry).
      ENDIF.

      LOOP AT it_podetails INTO DATA(wa_podetails).
        IF wa_podetails-purchaseorder NE lv_po OR wa_podetails-purchaseorderitem NE lv_poitm.
          CLEAR lv_bal.
        ENDIF.
        lv_po = wa_podetails-purchaseorder.
        lv_poitm = wa_podetails-purchaseorderitem.
        wa_final-plant = wa_podetails-plant.
        wa_final-plantname = wa_podetails-plantname.
        wa_final-purchaseorder = wa_podetails-purchaseorder.
        wa_final-purchaseorderitem = wa_podetails-purchaseorderitem.
        wa_final-purchaseorderdate = wa_podetails-purchaseorderdate.
        wa_final-supplierinvoiceitem = wa_podetails-supplierinvoiceitem.
        wa_final-purchaserequisition = wa_podetails-purchaserequisition.
        wa_final-purchaserequisitionitem = wa_podetails-purchaserequisitionitem.
        wa_final-purchaseordertype = wa_podetails-purchaseordertype.

        wa_final-material = wa_podetails-material.
        wa_final-materialname = wa_podetails-purchaseorderitemtext.
        wa_final-baseunit = wa_podetails-purchaseorderquantityunit.
        wa_final-hsn_code =  wa_podetails-br_ncm.
        wa_final-supplier = wa_podetails-supplier.
        wa_final-suppliername = wa_podetails-suppliername.
        wa_final-purchasinggroup = wa_podetails-purchasinggroup.
        wa_final-purchasinggroupname = wa_podetails-purchasinggroupname.
        wa_final-incotermsclassification = wa_podetails-incotermsclassification.
        wa_final-paymentterms = wa_podetails-paymentterms.
        wa_final-orderquantity = wa_podetails-orderquantity.
        wa_final-exchangerate = wa_podetails-exchangerate.
        wa_final-peruom = wa_podetails-peruom.
        CASE wa_podetails-iscompletelydelivered.
          WHEN 'X'.
            wa_final-deliverycompleted = 'Yes'.
          WHEN ''.
            wa_final-deliverycompleted = 'No'.
        ENDCASE.
        CASE wa_podetails-purchaseordertype.
          WHEN 'ZSTO' OR 'ZEXB'.
            wa_final-netpriceamount = wa_podetails-conditionratevalue.
          WHEN OTHERS.
            wa_final-netpriceamount = wa_podetails-netpriceamount.
        ENDCASE.
        wa_final-materialdocument = wa_podetails-referencedocument.
        wa_final-materialdocumentitem = wa_podetails-referencedocumentitem.
        DATA(wa_mig) = VALUE #( it_migo[ materialdocument = wa_podetails-referencedocument materialdocumentitem = wa_podetails-referencedocumentitem ] OPTIONAL ).
        wa_final-migodate = wa_mig-migodt.
        wa_final-grnquantity = wa_mig-quantityinentryunit.
        IF lv_bal IS INITIAL OR lv_bal = 0.
          wa_final-balance_qty = wa_final-orderquantity - wa_final-grnquantity.
          lv_bal = wa_final-balance_qty.
        ELSE.
          wa_final-balance_qty = lv_bal - wa_final-grnquantity.
          lv_bal = wa_final-balance_qty.
        ENDIF.
        wa_final-deliverydate = wa_podetails-schedulelinedeliverydate.
        wa_final-supplierinvoice = wa_podetails-supplierinvoice.
        wa_final-invoicedate = wa_podetails-documentdate.
        wa_final-postingdate = wa_podetails-postingdate.
        wa_final-invoicelineitemtext = wa_podetails-supplierpostinglineitemtext.
        wa_final-supplierinvoiceidbyinvcgparty = wa_podetails-supplierinvoiceidbyinvcgparty.
        wa_final-businessplace =  wa_podetails-businessplace.
        wa_final-businessplacedescription =  wa_podetails-businessplacedescription.
        wa_final-taxnumber3 = wa_podetails-in_gstidentificationnumber.
        wa_final-quantity = wa_podetails-qtyinpurchaseorderpriceunit.
        wa_final-conditiontype = wa_podetails-invccondtype.
        wa_final-supplierinvoiceitemamount =  wa_podetails-invoicebaseamnt.
        wa_final-baseamountexchangerate = wa_podetails-invoicebaseamnt * wa_podetails-exchangerate.
        wa_final-documentcurrency = wa_podetails-documentcurrency.
        wa_final-supplierdocumentcurrency = wa_podetails-supplierdocumentcurrency.
        wa_final-taxcode = wa_podetails-taxcode.
        wa_final-taxcodename = wa_podetails-taxcodename.
        CASE wa_podetails-taxcode.
          WHEN 'A1' OR 'A2' OR 'A3' OR 'A4' OR  'I1' OR 'I2' OR 'I3' OR 'I4' OR 'B1' OR 'B2' OR 'B3' OR 'B4' OR 'AA' OR 'BB' OR 'CC' OR 'II'.
            wa_final-cgst = wa_podetails-taxamount / 2.
            wa_final-sgst = wa_podetails-taxamount / 2.
          WHEN 'A5' OR 'A6' OR 'A7' OR 'A8' OR  'I5' OR 'I6' OR 'I7' OR 'I8' OR 'B5' OR 'B6' OR 'B7' OR 'B8' OR 'A0' OR 'B0' OR 'C0' OR 'I0' OR 'K1' OR 'K5'.
            wa_final-igst = wa_podetails-taxamount.
          WHEN 'R1' OR 'S1'. "OR 'R2' OR 'R3' OR 'R4' OR 'S1' OR 'S2' OR 'S3' OR 'S4'.
            CONSTANTS: r1_tax_rate TYPE decfloat16 VALUE '0.025'.
            wa_final-rcgst =  wa_podetails-taxbaseamountintranscrcy  * r1_tax_rate.
            wa_final-rsgst = wa_podetails-taxbaseamountintranscrcy  * r1_tax_rate.

          WHEN 'R2' OR 'S2'. "OR 'R2' OR 'R3' OR 'R4' OR 'S1' OR 'S2' OR 'S3' OR 'S4'.
            CONSTANTS: r2_tax_rate TYPE decfloat16 VALUE '0.06'.
            wa_final-rcgst =  wa_podetails-taxbaseamountintranscrcy  * r2_tax_rate.
            wa_final-rsgst = wa_podetails-taxbaseamountintranscrcy  * r2_tax_rate.

          WHEN 'R3' OR 'S3'. "OR 'R2' OR 'R3' OR 'R4' OR 'S1' OR 'S2' OR 'S3' OR 'S4'.
            CONSTANTS: r3_tax_rate TYPE decfloat16 VALUE '0.09'.
            wa_final-rcgst =  wa_podetails-taxbaseamountintranscrcy  * r3_tax_rate.
            wa_final-rsgst = wa_podetails-taxbaseamountintranscrcy  * r3_tax_rate.

          WHEN 'R4' OR 'S4'. "OR 'R2' OR 'R3' OR 'R4' OR 'S1' OR 'S2' OR 'S3' OR 'S4'.
            CONSTANTS: r4_tax_rate TYPE decfloat16 VALUE '0.14'.
            wa_final-rcgst =  wa_podetails-taxbaseamountintranscrcy  * r4_tax_rate.
            wa_final-rsgst = wa_podetails-taxbaseamountintranscrcy  * r4_tax_rate.


          WHEN 'R5' OR 'S5'. ""OR 'R7' OR 'R8' OR 'S5' OR 'S6' OR 'S7' OR 'S8'.
            CONSTANTS: r5_tax_rate TYPE decfloat16 VALUE '0.05'.
            wa_final-rigst =  wa_podetails-taxbaseamountintranscrcy  * r5_tax_rate.
*                    wa_final-rigst = wa_podetails-taxamount.\
          WHEN 'R6' OR 'S6'. ""OR 'R7' OR 'R8' OR 'S5' OR 'S6' OR 'S7' OR 'S8'.
            CONSTANTS: r6_tax_rate TYPE decfloat16 VALUE '0.12'.
            wa_final-rigst =  wa_podetails-taxbaseamountintranscrcy  * r6_tax_rate.

          WHEN 'R7' OR 'S7' . ""OR 'R7' OR 'R8' OR 'S5' OR 'S6' OR 'S7' OR 'S8'.
            CONSTANTS: r7_tax_rate TYPE decfloat16 VALUE '0.18'.
            wa_final-rigst =  wa_podetails-taxbaseamountintranscrcy  * r7_tax_rate.
          WHEN 'R7' OR 'S7'. ""OR 'R7' OR 'R8' OR 'S5' OR 'S6' OR 'S7' OR 'S8'.
            CONSTANTS: r8_tax_rate TYPE decfloat16 VALUE '0.28'.
            wa_final-rigst =  wa_podetails-taxbaseamountintranscrcy  * r8_tax_rate.


        ENDCASE.



        DATA(wa_journal) = VALUE #( it_journal[ referencedocument = wa_podetails-supplierinvoice ] OPTIONAL ).
        wa_final-journalentry = wa_journal-accountingdocument.
        DATA(wa_tax) = VALUE #( it_gst[ accountingdocument = wa_journal-accountingdocument ] OPTIONAL ).
        wa_final-gstpartner = wa_tax-in_gstpartner.
        DATA(wa_supgstpartner) = VALUE #( it_supgstpartner[ supplier = wa_tax-in_gstpartner ] OPTIONAL ).
        wa_final-gstpartnername = wa_supgstpartner-suppliername.
        wa_final-gstpartnergstin = wa_supgstpartner-taxnumber3.
        wa_final-invoicegrossamount = wa_final-supplierinvoiceitemamount + wa_podetails-taxamount.

        CASE wa_podetails-debitcreditcode.
          WHEN 'H'.
            wa_final-debitcreditcode = lv_credit.
            wa_final-invoicegrossamount = wa_final-invoicegrossamount * -1.
            wa_final-invoicegrossamountexchangerate = wa_final-invoicegrossamount * wa_podetails-exchangerate .
          WHEN 'S'.
            wa_final-debitcreditcode = lv_debit.
            wa_final-invoicegrossamountexchangerate = wa_final-invoicegrossamount * wa_podetails-exchangerate.
        ENDCASE.
        DATA(wa_prdet) = VALUE #( it_prdetails[ purchaserequisition = wa_final-purchaserequisition purchaserequisitionitem = wa_final-purchaserequisitionitem ] OPTIONAL ).
        wa_final-purreqcreationdate = wa_prdet-purchasereqncreationdate.
        CASE wa_final-supplierinvoice.
          WHEN ''.
            DATA(wa_supplier1) = VALUE #( it_supplierdetails[ supplier = wa_final-supplier ] OPTIONAL ).
            wa_final-supplier = wa_supplier1-supplier.
            wa_final-suppliername = wa_supplier1-suppliername.
            wa_final-suppliergstin   = wa_supplier1-taxnumber3.
            wa_final-region       = wa_supplier1-region.
            DATA(wa_supregiontext) = VALUE #( it_region[ region =  wa_final-region country = wa_supplier1-country ] OPTIONAL ).
            wa_final-regionname = wa_supregiontext-regionname.
          WHEN OTHERS.
            DATA(wa_supplier) = VALUE #( it_supplierdetails[ supplier = wa_podetails-invoicingparty ] OPTIONAL ).
            wa_final-supplier = wa_supplier-supplier.
            wa_final-suppliername = wa_supplier-suppliername.
            wa_final-suppliergstin   = wa_supplier-taxnumber3.
            wa_final-region       = wa_supplier-region.

            wa_supregiontext = VALUE #( it_region[ region =  wa_final-region country = wa_supplier-country ] OPTIONAL ).
            wa_final-regionname = wa_supregiontext-regionname.
        ENDCASE.
        CASE wa_podetails-reversedocument.
          WHEN  ''.
            APPEND wa_final TO it_final.
            CLEAR : wa_final, wa_podetails,wa_mig,wa_journal, wa_supplier1, wa_supregiontext, wa_supplier, wa_prdet.
          WHEN OTHERS.
            CLEAR : wa_final, wa_podetails,wa_mig,wa_journal, wa_supplier1, wa_supregiontext, wa_supplier, wa_prdet.
            CONTINUE.
        ENDCASE.
      ENDLOOP.
      LOOP AT it_pomigo INTO DATA(wa_pomigo).
        READ TABLE it_final INTO wa_final WITH KEY materialdocument = wa_pomigo-materialdocument materialdocumentitem = wa_pomigo-materialdocumentitem.
        IF sy-subrc NE 0.
          IF wa_pomigo-purchaseorder NE lv_po OR wa_pomigo-purchaseorderitem NE lv_poitm.
            CLEAR lv_bal.
          ENDIF.
          lv_po = wa_pomigo-purchaseorder.
          lv_poitm = wa_pomigo-purchaseorderitem.
          wa_final-plant = wa_pomigo-plant.
          wa_final-plantname = wa_pomigo-plantname.
          wa_final-purchaseorder = wa_pomigo-purchaseorder.
          wa_final-purchaseorderitem = wa_pomigo-purchaseorderitem.
          wa_final-purchaseorderdate = wa_pomigo-purchaseorderdate.
          wa_final-purchaserequisition = wa_pomigo-purchaserequisition.
          wa_final-purchaserequisitionitem = wa_pomigo-purchaserequisitionitem.
          wa_final-purchaseordertype = wa_pomigo-purchaseordertype.
          wa_final-material = wa_pomigo-material.
          wa_final-materialname = wa_pomigo-purchaseorderitemtext.
          wa_final-baseunit = wa_pomigo-purchaseorderquantityunit.
          wa_final-hsn_code =  wa_pomigo-br_ncm.
          wa_final-purchasinggroup = wa_pomigo-purchasinggroup.
          wa_final-purchasinggroupname = wa_pomigo-purchasinggroupname.
          wa_final-incotermsclassification = wa_pomigo-incotermsclassification.
          wa_final-paymentterms = wa_pomigo-paymentterms.
          wa_final-orderquantity = wa_pomigo-orderquantity.
          wa_final-migodate = wa_pomigo-migodate.
          wa_final-deliverydate = wa_pomigo-schedulelinedeliverydate.
          wa_final-peruom = wa_pomigo-peruom.
          CASE wa_pomigo-iscompletelydelivered.
            WHEN 'X'.
              wa_final-deliverycompleted = 'Yes'.
            WHEN ''.
              wa_final-deliverycompleted = 'No'.
          ENDCASE.
          CASE wa_pomigo-purchaseordertype.
            WHEN 'ZSTO' OR 'ZEXB'.
              wa_final-netpriceamount = wa_pomigo-conditionratevalue.
            WHEN OTHERS.
              wa_final-netpriceamount = wa_pomigo-netpriceamount.
          ENDCASE.
          wa_final-documentcurrency = wa_pomigo-documentcurrency.
          wa_final-materialdocument = wa_pomigo-materialdocument.
          wa_final-materialdocumentitem = wa_pomigo-materialdocumentitem.
          wa_final-grnquantity = wa_pomigo-quantityinentryunit.
          IF lv_bal IS INITIAL OR lv_bal = 0.
            wa_final-balance_qty = wa_final-orderquantity - wa_final-grnquantity.
            lv_bal = wa_final-balance_qty.
          ELSE.
            wa_final-balance_qty = lv_bal - wa_final-grnquantity.
            lv_bal = wa_final-balance_qty.
          ENDIF.
          DATA(wa_prdet1) = VALUE #( it_prdetails[ purchaserequisition = wa_final-purchaserequisition purchaserequisitionitem = wa_final-purchaserequisitionitem ] OPTIONAL ).
          wa_final-purreqcreationdate = wa_prdet1-purchasereqncreationdate.

          wa_supplier1 = VALUE #( it_supplierdetails[ supplier = wa_pomigo-supplier ] OPTIONAL ).
          wa_final-supplier = wa_supplier1-supplier.
          wa_final-suppliername = wa_supplier1-suppliername.
          wa_final-suppliergstin   = wa_supplier1-taxnumber3.
          wa_final-region       = wa_supplier1-region.

          wa_supregiontext = VALUE #( it_region[ region =  wa_final-region country = wa_supplier1-country ] OPTIONAL ).
          wa_final-regionname = wa_supregiontext-regionname.
          APPEND wa_final TO it_final.
          CLEAR : wa_final,wa_pomigo, wa_podetails, wa_supplier1, wa_supregiontext, wa_supplier, wa_prdet, wa_prdet1.
        ENDIF.
      ENDLOOP.
      SELECT * FROM @it_final AS it_final               "#EC CI_NOWHERE
       ORDER BY purchaseorder
       INTO TABLE @DATA(it_fin)
       OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
      SELECT COUNT( * )
          FROM @it_final AS it_final                    "#EC CI_NOWHERE
          INTO @DATA(lv_totcount).

*      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( lv_totcount ).
        io_response->set_data( it_fin ).
*      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
