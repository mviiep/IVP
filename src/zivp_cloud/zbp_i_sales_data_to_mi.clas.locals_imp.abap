CLASS lhc_ZI_SALES_DATA_TO_MI DEFINITION INHERITING FROM cl_abap_behavior_handler.

  "MICHAEL
  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
    TYPES : BEGIN OF lty_auth,
              uname    TYPE string,
              password TYPE string,
            END OF lty_auth.

    DATA : ls_config TYPE lty_auth.
    DATA : lv_post        TYPE string,
           lo_http_client TYPE REF TO if_web_http_client,
           url1           TYPE string.
    TYPES : BEGIN OF ty_final,
*              billing_doc_no TYPE char20,
*              billing_type   TYPE char4,
*              status         TYPE char80,

              billing_doc_no TYPE string,
              billing_type   TYPE string,
              status         TYPE string,
            END OF ty_final.

    DATA : wa_create TYPE zgstr1_st.
    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

    METHODS get_auth_token
      RETURNING VALUE(lv_authtoken) TYPE string.
    "MICHAEL

*    METHODS CLOSE_HTTP RETURNING VALUE(LV_CLOSE) TYPE REF TO if_web_http_client.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_sales_data_to_mi RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_sales_data_to_mi.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_sales_data_to_mi.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_sales_data_to_mi.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_sales_data_to_mi RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_sales_data_to_mi.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_sales_data_to_mi RESULT result.

    METHODS status_update FOR MODIFY
      IMPORTING keys FOR ACTION zi_sales_data_to_mi~status_update RESULT result.

*    METHODS SELECT_ALL FOR MODIFY
*      IMPORTING keys FOR ACTION zi_sales_data_to_mi~select.

    METHODS JSON_Status.



    ""MICHAEL
    TYPES : BEGIN OF ty_res,
              result TYPE string,
              error  TYPE string,
            END OF ty_res.
    " DATA wres TYPE REF TO data.
    DATA ls_res TYPE ty_res.

    TYPES: BEGIN OF ret,
*             result_id          TYPE char1,
*             result_description TYPE char20,
*             result_extra_key   TYPE char40,
             result_id          TYPE string,
             result_description TYPE string,
             result_extra_key   TYPE string,
           END OF ret.

    TYPES: BEGIN OF tres,
             status(23),
             message(120),
             response     TYPE ret,
           END OF tres.

    DATA : lv_json      TYPE string,
           lv_token     TYPE string,
           lv_res_token TYPE string,
           string1      TYPE string,
           string2      TYPE string,
*           status       TYPE char40.
           status       TYPE string.

    DATA : gv_accdoc      TYPE zi_sales_data_to_mi-Accounting_Doc_No,
           wa_post_status TYPE zgstr1_JSON.

    CONSTANTS:
      "url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/sales/',
      content_type TYPE string VALUE 'Content-Type',
      json_content TYPE string VALUE 'application/json',
      base_url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/',
      gstr2_url    TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/sales/'.
    ""MICHAEL
ENDCLASS.

CLASS lhc_ZI_SALES_DATA_TO_MI IMPLEMENTATION.
  "MICHAEL
  METHOD if_oo_adt_classrun~main.




  ENDMETHOD.
  "MICHAEL
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

*  METHOD select_all.
*
*    READ ENTITIES OF zi_sales_data_to_mi  IN LOCAL MODE
*    ENTITY zi_sales_data_to_mi  "ZI_SALES_DATA_TO_MI
*    ALL FIELDS WITH
*    CORRESPONDING #( keys )
*    RESULT DATA(lt_gstr1).
*
**    LOOP AT LT_GSTR1 ASSIGNING FIELD-SYMBOL(<ls_gstr1>).
**
**    <ls_gstr1>-
**
**    ENDLOOP.
**
*  ENDMETHOD.

  METHOD status_update.
    "MICHAEL
    DATA: netinvoiceamount TYPE string,
          tot_tax_val      TYPE string,
          txpd_tax_val     TYPE string,
          gstr2_ret        TYPE string,
          period           TYPE string,
          igst             TYPE string,
          cgst             TYPE string,
          sgst             TYPE string,
          qty              TYPE string,
          gst_rate         TYPE string,
          gst_rate1        TYPE string,
          uom              TYPE string,
          cus_gstin        TYPE string,
          rev_chr          TYPE string,
          date             TYPE string,
          inv_date         TYPE string,
          sup_type         TYPE string,
          place_supp       TYPE string,
          inv_cat          TYPE string,
          inv_sts          TYPE string,
          inv_type         TYPE string,
          isamend          TYPE string,
          lv_port          TYPE string,
          lv_space         TYPE string,
          str1             TYPE string,
          str2             TYPE string,
          str3             TYPE string,
          str4             TYPE string,
          str5             TYPE string,
          str6             TYPE string,
          str7             TYPE string,
          str8             TYPE string,
          str9             TYPE string,
          str10            TYPE string,
          str11            TYPE string,
          str12            TYPE string.
    DATA : lv_post TYPE string.


    TYPES : BEGIN OF ty_sapdata,
              inum           TYPE string,
              nt_num         TYPE string,
              supplier_gstin TYPE string,
              buyer_gstin    TYPE string,
            END OF ty_sapdata.

    TYPES : BEGIN OF ty_rsdata,
              val                       TYPE string,
              inv_type(10),
              pos(2),
              idt(10),
              rchrg(1),
              inum(16),
              nt_num(16),
              f_year(7),
              imonth(2),
              supplier_gstin(18),
              supplier_name(20),
              supplier_gstin_status(10),
              supplier_return_type(10),
              contact_name(20),
              buyer_gstin(18),
              cfs(1),
              invoice_type(10),
              ttxval(13),
              net_amount(15),
              auto_reco_id(20),
              match_status(10),
              pr_data                   TYPE ty_sapdata,
              erp_document_number(10),
              erp_document_date(10),
              itc_elg(2),
              total_igst                TYPE string,
              total_cgst                TYPE string,
              total_sgst                TYPE string,
              total_cess                TYPE string,
              transaction_number(10),
              reco_action(50),
              action_date(10),
              referred_invoice_num(20),
              referred_invoice_date(10),
              mismatch_reason(100),
            END OF ty_rsdata.

    DATA: tt_rsdata      TYPE TABLE OF ty_rsdata,
          tt_rsurl       TYPE TABLE OF string,
          wa_post_status TYPE zgstr1_JSON.



    "response store dd
    TYPES : BEGIN OF ty_itmlst,
              bukrs         TYPE bukrs,
              belnr         TYPE belnr_d,
              gjahr         TYPE gjahr,
              posnr         TYPE string,
              igst_amount   TYPE string,
              cgst_amount   TYPE string,
              sgst_amount   TYPE string,
              taxable_value TYPE string,
              hsn_sac       TYPE string,
              product_name  TYPE string,
              item_desc     TYPE string,
              quantity      TYPE string,
              cess_amount   TYPE string,
              gst_rate      TYPE string,
              gst_rate1     TYPE string,
              unit          TYPE string,
              error         TYPE zst_gst_auto_reco_error,
            END OF ty_itmlst.

    DATA : tt_itmlst TYPE TABLE OF ty_itmlst.

    TYPES : BEGIN OF ty_saledt,
              document_date(30),
              supply_type(30),
              invoice_status(30),
              invoice_category(30),
              invoice_type(30),
              total_invoice_value(30),
              total_taxable_value(30),
              txpd_taxtable_value(30),
              gstr1_return_period(30),
              gstr3b_return_period(30),
              reverse_charge(30),
              isamended(30),
              place_of_supply(30),
              supplier_gstin(30),
              buyer_gstin(30),
              customer_name(60),
              itemlist                 LIKE tt_itmlst,
              error                    TYPE zst_gst_auto_reco_error,
            END OF ty_saledt.

    DATA : lt_saledt TYPE STANDARD TABLE OF ty_saledt,
           lt_head   TYPE STANDARD TABLE OF ty_saledt.

    TYPES : BEGIN OF ty_cntdata,
              success_count   TYPE i,
              failure_count   TYPE i,
              sale_error_data LIKE lt_saledt,
            END OF ty_cntdata.

    TYPES : BEGIN OF ty_output,
              result TYPE ty_cntdata,
              status TYPE string,
            END OF ty_output.

    DATA : ls_output TYPE ty_output.

    DATA : dps TYPE string.
    dps = 'Data Posted Successfully'.

    "response store dd


    READ ENTITIES OF zi_sales_data_to_mi  IN LOCAL MODE
    ENTITY zi_sales_data_to_mi  "ZI_SALES_DATA_TO_MI
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_gstr1)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).

*    READ TABLE keys INTO DATA(wa_keys_check) INDEX 1.  "//Anurag

*//(+)Anurag
    SELECT * FROM zgstr1_JSON FOR ALL ENTRIES IN @keys WHERE Billing_Doc_No = @keys-Billing_Doc_No
    INTO TABLE @DATA(it_check_ml).

    READ TABLE it_check_ml INTO DATA(wa_check_ml) INDEX 1.

    LOOP AT keys INTO DATA(wa_keys_ml).

*      IF wa_check_ml-posting_status = 'POSTED'.
*        EXIT.
*      ENDIF.

      SELECT * FROM zi_sales_data_to_mi WHERE GST_Invoice_No = @wa_keys_ml-GST_Invoice_No
*      AND Item_No = @wa_keys_ml-Item_No
      INTO TABLE @DATA(it_purchase_ml).

*//( - ) by Anurag
*      SELECT * FROM zgstr1_st WHERE billing_doc_no = @wa_keys_ml-Billing_Doc_No
*      INTO @DATA(wa_check).
*      ENDSELECT.
*      IF wa_check-status = dps.
*        EXIT.
*      ENDIF.
*//( - ) by Anurag

      LOOP AT it_purchase_ml INTO DATA(wa_sales).

        gv_accdoc        = wa_sales-Accounting_Doc_No.
*        netinvoiceamount = netinvoiceamount + wa_sales-Gross_Value.
        netinvoiceamount = netinvoiceamount + wa_sales-Basic_Amount + wa_sales-cgst + wa_sales-sgst + wa_sales-igst.
        tot_tax_val      = tot_tax_val + wa_sales-Basic_Amount.
        gstr2_ret        = wa_sales-Billing_date.

*    igst = abs( wa_sales-igst ).
*    cgst = abs( wa_sales-cgst ).
*    sgst = abs( wa_sales-sgst ).
*    qty = wa_sales-Invoice_Qty.
*    gst_rate = ( igst + cgst + sgst ) / ( tot_tax_val ) * 100.
*    gst_rate1 = ceil( gst_rate ).

*        IF wa_sales-Bussiness_area = '1001' OR wa_sales-Bussiness_area = '1002' OR wa_sales-Bussiness_area = '1003' OR
*           wa_sales-Bussiness_area = '1004' OR wa_sales-Bussiness_area = '1009' OR wa_sales-Bussiness_area = '1010' OR wa_sales-Bussiness_area = '1011'.
*
*          cus_gstin  = '27AABCR0897A1ZJ'."'27AACCV4229P1ZT'."'27AIAPV4653Q1ZH'.
*
*        ELSEIF wa_sales-Bussiness_area = '1007'.
*          cus_gstin  = '23AABCR0897A3ZP'.
*
*        ENDIF.

        SELECT SINGLE gstin FROM zdb_org_gstin
               WHERE business_place = @wa_sales-business_place
               INTO @DATA(lv_gstin).
          IF lv_gstin IS NOT INITIAL.
            cus_gstin = lv_gstin.
          ELSEIF lv_gstin IS INITIAL AND wa_sales-Bussiness_area = '2000'.
            cus_gstin = '27AAACI0992A1ZX'.
          ENDIF.
*          IF wa_sales-business_place = 'WB19'.
*            cus_gstin = '19AAACI0992A1ZU'.
*          ELSEIF wa_sales-business_place = 'GJ24'.
*            cus_gstin = '24AAACI0992A1Z3'.
*          ELSEIF wa_sales-business_place = 'MH27' OR wa_sales-business_place = 'MHTP' OR wa_sales-business_place = 'MHBD'.
*            cus_gstin = '27AAACI0992A1ZX'.
*          ELSEIF wa_sales-business_place = 'ISD1'.
*            cus_gstin = '27AAACI0992A2ZW'.
*          ELSEIF wa_sales-business_place = 'KA29'.
*            cus_gstin = '29AAACI0992A1ZT'.
*          ELSEIF wa_sales-business_place = 'KE32'.
*            cus_gstin = '32AAACI0992A1Z6'.
*          ELSEIF wa_sales-business_place = 'TN33'.
*            cus_gstin = '33AAACI0992A1Z4'.
*          ENDIF.

          rev_chr    = 'N'.
          isamend    = 'N'.

          IF wa_sales-Totaltax = 0.
            sup_type   = 'NRT'.
          ELSE.
            sup_type   = 'NOR'.
          ENDIF.

          place_supp =  wa_sales-Customer_GSTIN_No+0(2).  "//'27'.

*        IF wa_sales-Customer_GSTIN_No IS INITIAL.
*
*          IF wa_sales-BillToPartyRegion = 'AN'.
*            place_supp = '35'.
*          ELSEIF wa_sales-BillToPartyRegion = 'AP'.
*            place_supp = '37'.
*          ELSEIF wa_sales-BillToPartyRegion = 'AR'.
*            place_supp = '12'.
*          ELSEIF wa_sales-BillToPartyRegion = 'AS'.
*            place_supp = '18'.
*          ELSEIF wa_sales-BillToPartyRegion = 'BR'.
*            place_supp = '10'.
*          ELSEIF wa_sales-BillToPartyRegion = 'CG'.
*            place_supp = '22'.
*          ELSEIF wa_sales-BillToPartyRegion = 'CH'.
*            place_supp = '04'.
*          ELSEIF wa_sales-BillToPartyRegion = 'DH'.
*            place_supp = '26'.
*          ELSEIF wa_sales-BillToPartyRegion = 'DL'.
*            place_supp = '07'.
*          ELSEIF wa_sales-BillToPartyRegion = 'GA'.
*            place_supp = '30'.
*          ELSEIF wa_sales-BillToPartyRegion = 'GJ'.
*            place_supp = '24'.
*          ELSEIF wa_sales-BillToPartyRegion = 'HP'.
*            place_supp = '02'.
*          ELSEIF wa_sales-BillToPartyRegion = 'HR'.
*            place_supp = '06'.
*          ELSEIF wa_sales-BillToPartyRegion = 'JH'.
*            place_supp = '20'.
*          ELSEIF wa_sales-BillToPartyRegion = 'JK'.
*            place_supp = '01'.
*          ELSEIF wa_sales-BillToPartyRegion = 'KA'.
*            place_supp = '29'.
*          ELSEIF wa_sales-BillToPartyRegion = 'KL'.
*            place_supp = '32'.
*          ELSEIF wa_sales-BillToPartyRegion = 'LD'.
*            place_supp = '31'.
*          ELSEIF wa_sales-BillToPartyRegion = 'MH'.
*            place_supp = '27'.
*          ELSEIF wa_sales-BillToPartyRegion = 'ML'.
*            place_supp = '17'.
*          ELSEIF wa_sales-BillToPartyRegion = 'MN'.
*            place_supp = '14'.
*          ELSEIF wa_sales-BillToPartyRegion = 'MP'.
*            place_supp = '23'.
*          ELSEIF wa_sales-BillToPartyRegion = 'MZ'.
*            place_supp = '15'.
*          ELSEIF wa_sales-BillToPartyRegion = 'NL'.
*            place_supp = '13'.
*          ELSEIF wa_sales-BillToPartyRegion = 'OD'.
*            place_supp = '21'.
*          ELSEIF wa_sales-BillToPartyRegion = 'PB'.
*            place_supp = '03'.
*          ELSEIF wa_sales-BillToPartyRegion = 'PY'.
*            place_supp = '34'.
*          ELSEIF wa_sales-BillToPartyRegion = 'RJ'.
*            place_supp = '08'.
*          ELSEIF wa_sales-BillToPartyRegion = 'SK'.
*            place_supp = '11'.
*          ELSEIF wa_sales-BillToPartyRegion = 'DN'.
*            place_supp = '33'.
*          ELSEIF wa_sales-BillToPartyRegion = 'TR'.
*            place_supp = '16'.
*          ELSEIF wa_sales-BillToPartyRegion = 'TS'.
*            place_supp = '36'.
*          ELSEIF wa_sales-BillToPartyRegion = 'UK'.
*            place_supp = '05'.
*          ELSEIF wa_sales-BillToPartyRegion = 'UP'.
*            place_supp = '09'.
*          ELSEIF wa_sales-BillToPartyRegion = 'WB'.
*            place_supp = '19'.
*          ENDIF.
*        ENDIF.

          IF wa_sales-Doc_type = 'DG'.
            inv_cat = 'CDN'.
          ELSEIF wa_sales-Doc_type = 'DR'.
            inv_cat = 'DDN'.
          ELSEIF wa_sales-Doc_type = 'RV' OR wa_Sales-Doc_type = 'Z1' OR wa_Sales-Doc_type = 'Z2'.
            inv_cat = 'TXN'.
          ENDIF.

          IF ( wa_sales-Billing_Type = 'F2' )  AND wa_sales-transactioncurrency = 'INR'.
            inv_cat    = 'TXN'.
          ELSEIF   wa_sales-Billing_Type = 'JSTO'.
            inv_cat    = 'TXN'.
          ELSEIF wa_sales-Billing_Type = 'G2' OR wa_sales-Billing_Type = 'CBRE'.
            inv_cat    = 'CDN'.
          ELSEIF wa_sales-Billing_Type = 'L2'.
            inv_cat    = 'DDN'.
          ELSEIF wa_sales-Billing_Type = 'F2' AND wa_sales-transactioncurrency <> 'INR'.
            inv_cat    = 'EXP'.
          ENDIF.

          IF inv_cat = 'EXP'.
            sup_type   = 'NOR'.
          ENDIF.

          IF wa_sales-Is_Reversal = 'X'.
            inv_sts    = 'C'.
          ELSE.
            inv_sts    = 'ADD'.
          ENDIF.


          IF wa_sales-Billing_Type = 'F2' AND wa_sales-transactioncurrency <> 'INR' AND wa_sales-Totaltax = 0.
            inv_type   = 'WOPAY'.
            place_supp = '97'.
          ELSEIF wa_sales-Billing_Type = 'F2' AND wa_sales-transactioncurrency <> 'INR' AND wa_sales-Totaltax <> 0.
            inv_type   = 'WPAY'.
            place_supp = '97'.
          ELSEIF ( wa_sales-Billing_Type = 'G2' OR wa_sales-Billing_Type = 'L2' )  AND wa_sales-transactioncurrency = 'INR'
                 AND wa_sales-Customer_GSTIN_No IS NOT INITIAL.
            inv_type   = 'B2B'.
          ELSEIF ( wa_sales-Billing_Type = 'G2' OR wa_sales-Billing_Type = 'L2' )  AND wa_sales-transactioncurrency = 'INR'
                 AND wa_sales-Customer_GSTIN_No IS INITIAL.
            inv_type   = 'B2CS'.
            ELSEIF wa_sales-customergroup = 'Z4' AND wa_sales-Totaltax = 0.
            inv_type   = 'SEWOP'.
            ELSEIF wa_sales-customergroup = 'Z4' AND wa_sales-Totaltax <> 0.
            inv_type   = 'SEWP'.
          ELSE.
            inv_type   = 'R'.
          ENDIF.

*        IF ( wa_sales-Billing_Type = 'F2' AND wa_sales-transactioncurrency <> 'INR' AND inv_cat = 'EXP' ) OR wa_sales-Customer_GSTIN_No = ' '.
*          wa_sales-Customer_GSTIN_No = 'URP'.
*        ENDIF.

          lv_port    = ''.
          lv_space   = ''.

*    CASE wa_sales-uom.
*      WHEN 'KG'.
*        uom = 'KGS'.
*      WHEN 'NO'.
*        uom = 'NOS'.
*      WHEN 'MT'.
*        uom = 'MTS'.
*      WHEN 'L'.
*        uom = 'LTR'.
*      WHEN 'TO'.
*        uom = 'TON'.
*      WHEN 'EA'.
*        uom = 'NOS'.
*      WHEN 'KM'.
*        uom = 'KME'.
*      WHEN 'DR'.
*        uom = 'DRM'.
*      WHEN 'ML'.
*        uom = 'MLT'.
*      WHEN 'M3'.
*        uom = 'CBM'.
*      WHEN 'M2'.
*        uom = 'SQM'.
*      WHEN 'G'.
*        uom = 'GMS'.
*      WHEN 'FT2'.
*        uom = 'SQF'.
*      WHEN 'DZ'.
*        uom = 'DOZ'.
*      WHEN 'BOX'.
*        uom = 'BOX'.
*      WHEN 'BT'.
*        uom = 'BTL'.
*      WHEN 'BAG'.
*        uom = 'BAG'.
*      WHEN 'PAA'.
*        uom = 'PRS'.
*      WHEN 'PAC'.
*        uom = 'PAC'.
*      WHEN 'ROL'.
*        uom = 'ROL'.
*      WHEN 'SET'.
*        uom = 'SET'.
*      WHEN OTHERS.
*        uom = 'OTH'.
*    ENDCASE.

          date = wa_sales-Billing_date.
          CONCATENATE date+6(2) '-' date+4(2) '-' date+0(4) INTO inv_date.
          CONDENSE inv_date NO-GAPS.
          CONCATENATE gstr2_ret+4(2) gstr2_ret+0(4) INTO period.
        ENDLOOP.

*        DATA : lv_tax TYPE string.
*        clear : lv_tax.
*        LOOP AT it_purchase_ml INTO DATA(lv_gsttax) WHERE Billing_Doc_No = wa_sales-Billing_Doc_No.
**                                                                  Item_No = wa_sales-Item_No.
*          IF sy-subrc IS INITIAL.
*            lv_tax = lv_tax + lv_gsttax-igst + lv_gsttax-sgst + lv_gsttax-cgst.
*          ENDIF.
*          CLEAR : lv_gsttax.
*        ENDLOOP.
*
*     netinvoiceamount = netinvoiceamount + lv_tax.

*      IF wa_sales IS NOT INITIAL.
*        CLEAR lv_post.
        CONCATENATE : lv_post '{'
                                 INTO lv_post SEPARATED BY ' '.

        CONCATENATE : lv_post  '"saleData":' '['
                                 INTO lv_post SEPARATED BY ' '.

        CONCATENATE : lv_post    '{'
                                       '"document_number":' '"' wa_sales-GST_Invoice_No '"' ',' "INV_NUM
                                       '"document_date":' '"' inv_date '"' ',' "INV_DATE
                                       '"supply_type":' '"' sup_type '"' ','"SUPP_TYPE
                                       '"invoice_status":' '"' inv_sts '"' ','"INV_STATUS
                                       '"invoice_category":' '"' inv_cat '"' ',' "
                                       '"invoice_type":' '"' inv_type '"' ','"INV_TYPE
                                       '"total_invoice_value":'  netinvoiceamount  ','  "INVOICE_VALUE
                                       '"total_taxable_value":'  tot_tax_val  ','  "TAXABLE_VALUE
                                       '"txpd_taxtable_value":' '"''"' ','
*                                     '"txpd_taxtable_value":'  txpd_tax_val  ','
                                       '"gstr1_return_period":' '"' period '"' ','  "GSTR2_RETIRN_PERIOD
                                       '"gstr3b_return_period":' '"' period '"' ',' "3B_AUTO_FILL_PERIOD
                                       '"reverse_charge":' '"' rev_chr '"' ','   "REVERSE_CHARGE
                                       '"isamended":' '"' isamend '"' ','       "ISAMENDED
                                      '"place_of_supply":' '"' place_supp '"' ','  "PLACE_OF_SUPPLY
                                      '"supplier_gstin":' '"' cus_gstin '"' ','  "SUPP_GSTIN
                                       '"buyer_gstin":' '"' wa_sales-Customer_GSTIN_No '"' ','   "CUST_GSTIN
                                       '"customer_name":' '"' wa_sales-Customer_Name '"' ','  "CUST_NAME
                                       INTO lv_post SEPARATED BY ' '.

        CONCATENATE : lv_post '"itemList":' '['
                                 INTO lv_post SEPARATED BY ' '.

*//Anurag
        DATA:lv_tabix TYPE sy-tabix.
        CLEAR lv_tabix.

        LOOP AT it_purchase_ml INTO DATA(wa_sales_item) WHERE GST_Invoice_No = wa_sales-GST_Invoice_No.
*                                                        AND Item_No  = wa_sales-Item_No.

          lv_tabix = lv_tabix + 1.
          IF lv_tabix NE 1.
            CONCATENATE lv_post ',' INTO lv_post.
          ENDIF.

          DATA : item_total_tax TYPE string.

          igst = abs( wa_sales_item-igst ).
          cgst = abs( wa_sales_item-cgst ).
          sgst = abs( wa_sales_item-sgst ).
          qty  = wa_sales_item-Invoice_Qty.
*         item_total_tax = wa_sales_item-Taxable_Value_In_RS.   "//igst + cgst + sgst.
          item_total_tax = wa_sales_item-Basic_Amount.   "//igst + cgst + sgst.

          IF wa_sales_item-cgst_rate IS NOT INITIAL AND wa_sales_item-SGST_Rate IS NOT INITIAL.
            gst_rate = wa_sales_item-cgst_rate + wa_sales_item-sgst_rate.
            gst_rate1 = gst_rate.
          ELSEIF wa_sales_item-igst_rate IS NOT INITIAL.
            gst_rate = wa_sales_item-igst_rate.
            gst_rate1 = gst_rate.
          ENDIF.

          IF gst_rate1 = ' '.
            gst_rate1 = '0'.
          ENDIF.

          CASE wa_sales-uom.
            WHEN 'KG'.
              uom = 'KGS'.
            WHEN 'NO'.
              uom = 'NOS'.
            WHEN 'MT'.
              uom = 'MTS'.
            WHEN 'L'.
              uom = 'LTR'.
            WHEN 'TO'.
              uom = 'TON'.
            WHEN 'EA'.
              uom = 'NOS'.
            WHEN 'KM'.
              uom = 'KME'.
            WHEN 'DR'.
              uom = 'DRM'.
            WHEN 'ML'.
              uom = 'MLT'.
            WHEN 'M3'.
              uom = 'CBM'.
            WHEN 'M2'.
              uom = 'SQM'.
            WHEN 'G'.
              uom = 'GMS'.
            WHEN 'FT2'.
              uom = 'SQF'.
            WHEN 'DZ'.
              uom = 'DOZ'.
            WHEN 'BOX'.
              uom = 'BOX'.
            WHEN 'BT'.
              uom = 'BTL'.
            WHEN 'BAG'.
              uom = 'BAG'.
            WHEN 'PAA'.
              uom = 'PRS'.
            WHEN 'PAC'.
              uom = 'PAC'.
            WHEN 'ROL'.
              uom = 'ROL'.
            WHEN 'SET'.
              uom = 'SET'.
            WHEN OTHERS.
              uom = 'OTH'.
          ENDCASE.
*//Anurag

          CONCATENATE : lv_post '{'
                                        '"igst_amount":' '"' igst '"' ','  "IGST_AMOUNT
                                        '"cgst_amount":' '"' cgst '"' ','  "CGST_AMOUNT
                                        '"sgst_amount":' '"' sgst '"' ','   "SGST_AMOUNT
                                        '"taxable_value":' '"' item_total_tax '"' ','  "TAXABLE_VALUE  "tot_tax_val >> item_total_tax
                                        '"hsn_code":' '"' wa_sales_item-HSN_Code '"' ','     "HSN_SAC
*                                      '"product_name":' '"' wa_sales_item-Broker_Name '"' ','  "
*                                      '"item_description":' '"' wa_sales_item-Material_Description '"' ',' "ITEM_DESC
                                        '"quantity":' '' qty '' ','  "QUANTITY
                                        '"cess_amount":' '"' '0' '"' ','  "CESS_AMOUNT
                                        '"gst_rate":'  gst_rate1  ','      "GST_RATE  " club c/s gst
                                        '"unit_of_product":' '"' uom '"'  "UNIT
                                        '}' INTO lv_post SEPARATED BY ' '.

          CLEAR : wa_sales_item,igst,cgst,sgst,qty,gst_rate1,item_total_tax, cus_gstin.
        ENDLOOP.

        CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
        CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.

        CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
        CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.
        " CONDENSE lv_post NO-GAPS.
        lv_json = lv_post.
*      ENDIF.

        wa_create-billing_doc_no = wa_sales-Billing_Doc_No.
        wa_create-billing_type   = wa_sales-Billing_Type.
        wa_create-accounting_doc = wa_sales-Accounting_Doc_No.
        wa_create-status         = wa_sales-status.
        MODIFY zgstr1_st FROM @wa_create.


        CLEAR : wa_post_status.
        IF lv_json IS NOT INITIAL.
          wa_post_status-accounting_doc = wa_create-accounting_doc.
          wa_post_status-billing_doc_no = wa_create-billing_doc_no.
          wa_post_status-billing_type   = wa_create-billing_type.
          wa_post_status-company_code   = wa_create-company_code.
          wa_post_status-posting_status = 'POSTED'.
          MODIFY zgstr1_JSON FROM @wa_post_status.
        ENDIF.

        IF wa_sales IS NOT INITIAL.
          TRY.
              DATA lv_url TYPE string.
              "  CONCATENATE base_url 'saas-apis/sales/' INTO lv_url.
              " CONCATENATE base_url 'saas-apis/purchase/' INTO lv_url.
              lv_url = 'https://api-platform.mastersindia.co/api/v1/saas-apis/sales/'.
*Cmntd by Krishna
*            lv_res_token = get_auth_token( ).
*            SPLIT lv_res_token AT ':' INTO string1 string2.
*            CLEAR lv_res_token.
*            lv_res_token = string2.
*            REPLACE ALL OCCURRENCES OF '"' IN lv_res_token WITH ' '.
*            REPLACE ALL OCCURRENCES OF '}' IN lv_res_token WITH ' '.
*            CONDENSE lv_res_token NO-GAPS.
*Cmntd by Krishna
              "CONCATENATE 'JWT' '' lv_res_token INTO lv_res_token.
              TRY.
                  DATA(client) = create_client( lv_url ).
                CATCH cx_static_check.
              ENDTRY.
              DATA(req) = client->get_http_request(  ).
              " req->set_header_field( i_name = content_type i_value = json_content ).
              req->set_header_fields(  VALUE #(
              ( name = 'Content-Type' value = 'application/json' )
              ( name = 'productid' value = 'enterprises' )
              ( name = 'MiplApiKey' value = 'rLWN9u9WePRtGneWExwJvy2gwWPrCUTM' ) ) ).
*            ( name = 'Authorization' value = |JWT { lv_res_token }| ) ) ). "cmntd by krishna
              " req->set_text( lv_json ).
              req->append_text(
              EXPORTING
              data = lv_json ).
              " req->set_header_field( i_name = 'Authorization' i_value = |JWT { lv_res_token }| ).
              TRY.
                  " DATA(lv_response) = client->execute( if_web_http_client=>post )."->get_text(  ).
                  DATA(lv_response) = client->execute(
                                  i_method  = if_web_http_client=>post ).
                  DATA(json_response) = lv_response->get_text( ).
                  DATA(stat) = lv_response->get_status(  ).
                  client->close( ).
                CATCH: cx_web_http_client_error.
              ENDTRY.
            CATCH cx_static_check.
          ENDTRY.
        ENDIF.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*    TYPES:BEGIN OF ty_message,
*            message TYPE bapi_msg,
*          END OF ty_message.

*    TYPES : BEGIN OF ty_sapdata,
*              inum           TYPE string,
*              nt_num         TYPE string,
*              supplier_gstin TYPE string,
*              buyer_gstin    TYPE string,
*            END OF ty_sapdata.
*
*    TYPES : BEGIN OF ty_rsdata,
*              val                       TYPE string,
*              inv_type(10),
*              pos(2),
*              idt(10),
*              rchrg(1),
*              inum(16),
*              nt_num(16),
*              f_year(7),
*              imonth(2),
*              supplier_gstin(18),
*              supplier_name(20),
*              supplier_gstin_status(10),
*              supplier_return_type(10),
*              contact_name(20),
*              buyer_gstin(18),
*              cfs(1),
*              invoice_type(10),
*              ttxval(13),
*              net_amount(15),
*              auto_reco_id(20),
*              match_status(10),
*              pr_data                   TYPE ty_sapdata,
*              erp_document_number(10),
*              erp_document_date(10),
*              itc_elg(2),
*              total_igst                TYPE string,
*              total_cgst                TYPE string,
*              total_sgst                TYPE string,
*              total_cess                TYPE string,
*              transaction_number(10),
*              reco_action(50),
*              action_date(10),
*              referred_invoice_num(20),
*              referred_invoice_date(10),
*              mismatch_reason(100),
*            END OF ty_rsdata.
*
*    DATA: tt_rsdata TYPE TABLE OF ty_rsdata,
*          tt_rsurl  TYPE TABLE OF string.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

*    TYPES:BEGIN OF ty_output,
*            success TYPE string,
*            status  TYPE string,
*            message TYPE string,
*          END OF ty_output,

*          TYPES : BEGIN OF ty_output1,
*            success TYPE string,
*            status  TYPE string,
*            message TYPE ty_message,
*            data    LIKE tt_rsdata,
*          END OF ty_output1.

*    DATA:ls_output  TYPE ty_output,
*         ls_output1 TYPE ty_output1.

*/ui2/cl_json=>deserialize( EXPORTING json = json_response CHANGING data = ls_output ).


*IF ls_output-success = 'X'
*      AND ls_output-status = '1'
*      AND ( ls_output-message = 'Data found' OR ls_output-message = 'data found' ).
*      /ui2/cl_json=>deserialize(
*  EXPORTING
*  json = json_response
*  CHANGING
*  data = ls_output1 ).
*      DATA(reco_data1) = ls_output1-data.
*      SELECT * FROM zgstr2_st INTO TABLE @DATA(lt_gstr2).
*      LOOP AT reco_data1 INTO DATA(ls_reco).
*        READ TABLE lt_gstr2 INTO DATA(ls_gstr2) WITH KEY referencedocumentmiro = ls_reco-inum.
*        IF sy-subrc = 0.
*          ls_gstr2-reco_action = ls_reco-reco_action.
*          ls_gstr2-reason      = ls_reco-mismatch_reason.
*          MODIFY zgstr2_st FROM @ls_gstr2.
*        ENDIF.
*        CLEAR : ls_gstr2,ls_reco.
*        ENDLOOP.
*        ENDif.


*JSON result dd

        IF stat-code = '200'.

          /ui2/cl_json=>deserialize(
       EXPORTING
       json = json_response
       CHANGING
       data = ls_output ).
          lt_head = ls_output-result-sale_error_data.

          IF ls_output-result-failure_count = '1'.
            SPLIT json_response AT 'error' INTO str1 str2.
            SPLIT str2 AT 'error' INTO str3 str4.
            REPLACE ALL OCCURRENCES OF '"' IN str4 WITH ''.
            REPLACE ALL OCCURRENCES OF '{' IN str4 WITH ''.
            REPLACE ALL OCCURRENCES OF '}' IN str4 WITH ''.
            REPLACE ALL OCCURRENCES OF '[' IN str4 WITH ''.
            REPLACE ALL OCCURRENCES OF ']' IN str4 WITH ''.
            SPLIT str4 AT ':' INTO str5 str6.
            SPLIT str6 AT ':' INTO str7 str8.
            SPLIT str8 AT 'values' INTO str9 str10.
            SPLIT str9 AT ',' INTO str11 str12.

            SELECT SINGLE * FROM zgstr1_st WHERE accounting_doc = @wa_create-accounting_doc OR billing_doc_no  = @wa_create-billing_doc_no
                INTO @DATA(wa_zgstr1_st).
              IF wa_zgstr1_st IS NOT INITIAL AND str9 IS NOT INITIAL.
                wa_zgstr1_st-accounting_doc = wa_zgstr1_st-accounting_doc.
                wa_zgstr1_st-billing_doc_no = wa_zgstr1_st-billing_doc_no.
                wa_zgstr1_st-billing_type   = wa_zgstr1_st-billing_type.
                wa_zgstr1_st-status = str11.
                MODIFY zgstr1_st FROM @wa_zgstr1_st.
*    ELSEIF str4 IS INITIAL.
*      wa_zgstr1_st-status = 'Document Posted Successfully'.
*      MODIFY zgstr1_st FROM @wa_zgstr1_st.
              ENDIF.
            ENDIF.


            IF ls_output-result-success_count = '1'.
              SELECT SINGLE * FROM zgstr1_st WHERE accounting_doc = @wa_create-accounting_doc OR billing_doc_no  = @wa_create-billing_doc_no
              INTO @DATA(wa_zgstr2_status).
                IF wa_zgstr2_status IS NOT INITIAL.
                  wa_zgstr2_status-billing_doc_no = wa_zgstr2_status-billing_doc_no.
                  wa_zgstr2_status-accounting_doc = wa_zgstr2_status-accounting_doc.
                  wa_zgstr2_status-billing_type   = wa_zgstr2_status-billing_type.
                  wa_zgstr2_status-status = 'Data Posted Successfully'.
                  MODIFY zgstr1_st FROM @wa_zgstr2_status.
                ENDIF.
              ENDIF.


              DATA(lv_message) = me->new_message(
                               id = 'ZGSTR1_MESSAGE'
                               number = '001'
                               severity = ms-success
                               v1       = str9 ).
              DATA ls_record LIKE LINE OF reported-zi_sales_data_to_mi.
              ls_record-%msg = lv_message.
              ls_record-%element-billing_doc_no = if_abap_behv=>mk-on.
              "  ls_record-%element- = if_abap_behv=>mk-on.
              APPEND ls_record TO reported-zi_sales_data_to_mi.



            ENDIF.
            "MICHAEL
            CLEAR : wa_SALES, wa_keys_ml, wa_keys_ml, wa_zgstr1_st, wa_zgstr2_status, lv_post, lv_json, wa_create,
                    lv_res_token, lv_response, json_response, stat, ls_output, lt_head, str1, str2, str3, str4, str5,
                    str6, str7, str8, str9, str10, str11, str12, ls_record, lv_message, cus_gstin, inv_cat, inv_sts, inv_type,place_supp.
*      EXIT.
          ENDLOOP.

          me->json_status(  ).

        ENDMETHOD.

*  METHOD response.
*  ENDMETHOD.

        "MICHAEL
        METHOD create_client.

          DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
          result = cl_web_http_client_manager=>create_by_http_destination( dest ).
        ENDMETHOD.
        METHOD get_auth_token.
          "DATA : string1 TYPE string,
          " string2 TYPE string,
          " string3 type string,
          " string4 TYPE string.

          ls_config-uname = 'ryshejwal@ivpindia.com'.
*    ls_config-password = 'Ivplimited@01'.
          "data(dest) = cl_http_destination_provider=>create_by_url( url ).
          "DATA(result) = cl_web_http_client_manager=>create_by_http_destination( dest ).
          DATA url TYPE string.
          CONCATENATE base_url 'token-auth/' INTO url.
          CONDENSE url NO-GAPS.

          "lv_token = '{"password":"Admin@123","username":"admin@srthoratmilk.com"}'.
          lv_token = '{"password":"Ivplimited@01","username":"ryshejwal@ivpindia.com"}'.
          "CONDENSE lv_token NO-GAPS.

          " DATA(req) = result->get_http_request( ).
          TRY.
              DATA(client) = create_client( url ).
            CATCH cx_static_check.
          ENDTRY.
          DATA(req) = client->get_http_request(  ).
          req->set_text( lv_token ).
          req->set_header_field( i_name = content_type i_value = json_content ).
          TRY.
              lv_authtoken = client->execute( if_web_http_client=>post )->get_text(  ).
              client->close(  ).
            CATCH cx_static_check.
          ENDTRY.
          "lv_res_token = lv_authtoken.
          " SPLIT lv_authtoken AT ':' INTO string1 string2.
          "lv_res_token = string2.
          "REPLACE all OCCURRENCES OF '"' in lv_res_token WITH ' '.
          "REPLACE all OCCURRENCES OF '}' in lv_res_token WITH ' '.
          "CONDENSE lv_res_token NO-GAPS.
          "split string2 at '.' INTO string3 string4.
          "clear lv_authtoken.
          "lv_authtoken = string3.
          "REPLACE ALL OCCURRENCES OF '"' IN lv_authtoken WITH ' '.
          " REPLACE all OCCURRENCES OF '}' IN lv_authtoken WITH ' '.
          "condense lv_authtoken NO-GAPS.
        ENDMETHOD.

        METHOD json_status.

          CLEAR : wa_post_status.

          SELECT * FROM zgstr1_JSON
          WHERE accounting_doc = @gv_accdoc
          INTO TABLE @DATA(it_json).

            READ TABLE it_json INTO DATA(wa_JSON) INDEX 1.
            IF sy-subrc IS INITIAL.
              wa_post_status-accounting_doc = wa_JSON-accounting_doc.
              wa_post_status-billing_doc_no = wa_JSON-billing_doc_no.
              wa_post_status-billing_type   = wa_JSON-billing_type.
              wa_post_status-company_code   = wa_JSON-company_code.
              wa_post_status-posting_status = ' '.
              MODIFY zgstr1_JSON FROM @wa_post_status.
            ENDIF.

          ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_SALES_DATA_TO_MI DEFINITION INHERITING FROM cl_abap_behavior_saver.
PROTECTED SECTION.

  METHODS finalize REDEFINITION.

  METHODS check_before_save REDEFINITION.

  METHODS save REDEFINITION.

  METHODS cleanup REDEFINITION.

  METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_SALES_DATA_TO_MI IMPLEMENTATION.

METHOD finalize.
ENDMETHOD.

METHOD check_before_save.
ENDMETHOD.

METHOD save.
ENDMETHOD.

METHOD cleanup.
ENDMETHOD.

METHOD cleanup_finalize.
ENDMETHOD.

ENDCLASS.
