CLASS lhc_zi_send_gstr1_mi DEFINITION INHERITING FROM cl_abap_behavior_handler.
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
              referencedocumentmiro TYPE string,
              referencedocumentitem TYPE string,
              accountingdocument    TYPE string,
              purchasingdocument    TYPE string,
              fiscalyear            TYPE string,
              status                TYPE string,
            END OF ty_final.

    DATA : wa_create TYPE zgstr2_st.

    METHODS
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check.

    METHODS get_auth_token
      RETURNING VALUE(lv_authtoken) TYPE string.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_send_gstr1_mi RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_send_gstr1_mi.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_send_gstr1_mi.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_send_gstr1_mi.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_send_gstr1_mi RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_send_gstr1_mi.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_send_gstr1_mi RESULT result.

    METHODS status_update FOR MODIFY
      IMPORTING keys FOR ACTION zi_send_gstr1_mi~status_update RESULT result.

**commented it is moved to ITC Reco *****
*    METHODS response FOR MODIFY
*      IMPORTING keys FOR ACTION zi_send_gstr1_mi~response RESULT result.

    TYPES : BEGIN OF ty_res,
              result TYPE string,
              error  TYPE string,
            END OF ty_res.

    DATA ls_res TYPE ty_res.
    TYPES: BEGIN OF ret,
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
    CONSTANTS:
      "url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/sales/',
      content_type TYPE string VALUE 'Content-Type',
      json_content TYPE string VALUE 'application/json',
      base_url     TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/',
      gstr2_url    TYPE string VALUE 'https://api-platform.mastersindia.co/api/v1/saas-apis/purchase/'.

*    METHODS create_client
*      IMPORTING url           TYPE string
*        RETURNING VALUE(result) TYPE REF TO if_web_http_client
*        RAISING   cx_static_check.

ENDCLASS.

CLASS lhc_zi_send_gstr1_mi IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

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

  METHOD status_update.
    DATA: netinvoiceamount TYPE string,
          tot_taxable1 TYPE string,
          tot_tax_val      TYPE string,
          txpd_tax_val     TYPE string,
          txpd_tax_val1 TYPE string,
          gstr2_ret        TYPE string,
          period           TYPE string,
          igst             TYPE string,
          cgst             TYPE string,
          sgst             TYPE string,
          qty              TYPE string,
          gst_rate         TYPE i,
          gst_rate1        TYPE string,    "gst rate round-off
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
          str11            TYPE string, str12 TYPE string,
          tot_inv          TYPE string,
          tot_inv1 type string,
          tot_taxable      TYPE string,
          tot_txpd         TYPE string,
          cess             TYPE string,
          itc_elgibity     TYPE string.


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

    TYPES : BEGIN OF ty_purchasedt,
              document_number(30),
              document_date(30),
              original_document_number(30),
              original_document_date(12),
              ref_document_number(30),
              ref_document_date(12),
              supply_type(30),
              erp_document_number(30),
              erp_document_date(12),
              transaction_number(30),
              gl_code(20),
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
              inv_itc_eleg(30),
              place_of_supply(30),
              supplier_gstin(30),
              buyer_gstin(30),
              customer_name(60),
              ftp_status                   TYPE string,
              itemlist                     LIKE tt_itmlst,
              error                        TYPE  zst_gst_auto_reco_error,
            END OF ty_purchasedt.


    DATA : itemdesc TYPE string.
    DATA : lt_purchasedt TYPE TABLE OF ty_purchasedt,
           lt_head       TYPE STANDARD TABLE OF ty_purchasedt.

    TYPES : BEGIN OF ty_cntdata,
              success_count       TYPE i,
              failure_count       TYPE i,
              purchase_error_data LIKE lt_purchasedt,
            END OF ty_cntdata.

    TYPES : BEGIN OF ty_output,
              result TYPE ty_cntdata,
              status TYPE string,
            END OF ty_output.

    DATA : ls_output TYPE ty_output.


    DATA:
      lv_lines       TYPE i,
      lv_count       TYPE i,
      lv_syindex     TYPE i,
      lv_syindex2    TYPE i,
      lv_indx        TYPE i,
      lv_divid       TYPE i,
      lv_times       TYPE i,
      lv_times1      TYPE i,
      lv_times2      TYPE i,
      lv_stop        TYPE i,
      lv_gstrate     TYPE i,
      lv_igst        TYPE string,
      lv_cgst        TYPE string,
      lv_sgst        TYPE string,
      lv_qnty        TYPE string,
      lv_taxable_amt TYPE string,
      lv_cess_amt    TYPE string,
      lv_qa          TYPE string,

      dps            TYPE string,
      validhsn       TYPE string,
      hsndesc        TYPE string,
      allexists      TYPE string.

    dps = 'Data Posted Successfully'.

******* Converting data from JSON format to table
    FIELD-SYMBOLS:
      <data>                         TYPE data,
      <data_u>                       TYPE data,
      <text>                         TYPE data,
      <text1>                        TYPE data,
      <templates>                    TYPE data,
      <templates_uti>                TYPE data,
      <templates_result>             TYPE any,
      <result_uuid>                  TYPE STANDARD TABLE,
      <result_status>                TYPE STANDARD TABLE,
      <result_status_type>           TYPE STANDARD TABLE,
      <metafield_result>             TYPE data,
      <metafield_result_uuid>        TYPE data,
      <metafield_result_status>      TYPE data,
      <metafield_result_utilization> TYPE data,
      <metadata_result>              TYPE data,
      <metafield_result_sts_type>    TYPE data,
      <metadata_result_sts_type>     TYPE data,
      <metadata>                     TYPE STANDARD TABLE,
      <textdata>                     TYPE data.


    DATA lr_data TYPE REF TO data.
    DATA templates TYPE REF TO data.

    "sending multiple data to portal
    READ ENTITIES OF zi_send_gstr1_mi  IN LOCAL MODE
    ENTITY zi_send_gstr1_mi  "ZI_SALES_DATA_TO_MI
    ALL FIELDS WITH
    CORRESPONDING #( keys )
    RESULT DATA(lt_gstr2_ml)
    FAILED DATA(failed_data_ml)
    REPORTED DATA(reported_data_ml).

    LOOP AT keys INTO DATA(wa_keys_ml).
      SELECT * FROM zi_send_gstr1_mi WHERE RefDocNo = @wa_keys_ml-DocumentReferenceID
      AND ReferenceDocumentMIRO = @wa_keys_ml-ReferenceDocumentMIRO
      INTO TABLE @DATA(it_purchase_ml).

      LOOP AT it_purchase_ml INTO DATA(wa_purchase).

        IF wa_purchase-taxcode = 'V0' OR wa_purchase-taxcode = 'G0'
         OR wa_purchase-taxcode = '' OR wa_purchase-Reverse IS NOT INITIAL.
*          CLEAR : wa_purchase.  "comntd by krishna 07/10/24
*          CONTINUE.            "comntd by krishna 07/10/24
        ENDIF.


       tot_taxable1 = COND #( WHEN wa_purchase-netinvoiceamount LT 0
                THEN wa_purchase-netinvoiceamount * -1
                ELSE wa_purchase-netinvoiceamount ).
        tot_taxable  = tot_taxable + tot_taxable1.

        tot_inv1 = COND #( WHEN wa_purchase-Tot_Inv lt 0
                           THEN wa_purchase-Tot_Inv * -1
                           ELSE wa_purchase-Tot_Inv ).
        tot_inv      = tot_inv + tot_inv1.

*        txpd_tax_val1 =
        txpd_tax_val = COND #( WHEN wa_purchase-netinvoiceamount lt 0
                               THEN wa_purchase-netinvoiceamount * -1
                               ELSE wa_purchase-netinvoiceamount ).

        gstr2_ret    = wa_purchase-PostingDate.

        IF wa_purchase-Plant IS INITIAL.
          wa_purchase-plant = wa_purchase-ProftCenter+6(4).
        ENDIF.

        IF wa_purchase-business_place IS NOT INITIAL.
          SELECT SINGLE gstin FROM zdb_org_gstin
                        WHERE business_place = @wa_purchase-business_place
                        INTO @cus_gstin.
        ELSEIF wa_purchase-plant IS NOT INITIAL.
          SELECT SINGLE gstin FROM zdb_org_gstin
                        WHERE plant = @wa_purchase-Plant
                        INTO @cus_gstin.
        ELSEIF wa_purchase-ProftCenter IS NOT INITIAL.
          SELECT SINGLE gstin FROM zdb_org_gstin
                        WHERE plant = @wa_purchase-ProftCenter
                        INTO @cus_gstin.
        ELSE.
          cus_gstin = ''.
        ENDIF.

*        IF  wa_purchase-Reverse IS NOT INITIAL.
*          rev_chr = 'Y'.
*        ELSE.
*          rev_chr = 'N'.
*        ENDIF.

        IF wa_purchase-rcgst IS NOT INITIAL OR wa_purchase-rsgst IS NOT INITIAL OR wa_purchase-rigst IS NOT INITIAL.
          rev_chr = 'Y'.
        ELSE.
          rev_chr = 'N'.
        ENDIF.

*Krishna 11/11/24
*        sup_type = 'Normal'.
*        IF wa_purchase-cgst = 0 AND wa_purchase-sgst = 0 AND wa_purchase-igst = 0.
*          sup_type = 'NRT'.
*        ELSE.
*          sup_type = 'NOR'.
*        ENDIF.

        sup_type = 'NOR'.

*Krishna 11/11/24
        " place_supp = '27'.
*

        IF cus_gstin IS NOT INITIAL.
          place_supp = cus_gstin+0(2).
        ELSE.
          CONCATENATE 'There is No GSTIN configured for plant :' wa_purchase-plant
                      '& Business Place :' wa_purchase-business_place INTO DATA(lv_text).
          DATA(lv_msg) =  me->new_message(
                         id = 'ZGSTR1_MESSAGE'
                         number = '002'
                         severity = ms-success
                         v1       = lv_text ).
          DATA ls_record1 LIKE LINE OF reported-zi_send_gstr1_mi.
          ls_record1-%msg = lv_msg.
          ls_record1-%element-referencedocumentmiro = if_abap_behv=>mk-on.
          "  ls_record-%element- = if_abap_behv=>mk-on.
          APPEND ls_record1 TO reported-zi_send_gstr1_mi.
        ENDIF.

*Krishna 11/11/24
*        inv_cat = 'TXN'. cmntd
        IF wa_purchase-Doctype = 'KG'.
          inv_cat = 'CDN'.
        ELSEIF wa_purchase-Doctype = 'KR'.
          inv_cat = 'TXN'.
        ELSEIF wa_purchase-Doctype = 'RE'.
          inv_cat = 'TXN'.
        ELSE.
          inv_cat = 'TXN'.
        ENDIF.
*Krishna 11/11/24

        inv_sts = 'ADD'.
        inv_type = 'R'.
        lv_port = ''.
        lv_space = ''.

        date = wa_purchase-InvoiceDate.
        CONCATENATE date+6(2) '-' date+4(2) '-' date+0(4) INTO inv_date.
        CONDENSE inv_date NO-GAPS.
        CONCATENATE gstr2_ret+4(2) '-' gstr2_ret+0(4) INTO period.

      ENDLOOP.

      CONCATENATE : lv_post '{'
                                 INTO lv_post SEPARATED BY ' '.


      CONCATENATE : lv_post  '"purchaseData":' '['
                              INTO lv_post SEPARATED BY ' '.

      CONCATENATE : lv_post    '{'
                                " '"document_number":' '"' wa_purchase-referencedocumentmiro '"' ','
                                  '"document_number":' '"' wa_purchase-RefDocNo '"' ','
                                  '"document_date":' '"' inv_date '"' ','
                                  '"original_document_number":' '"' lv_space '"' ','
                                  '"original_document_date":' '"' lv_space '"' ','
                                  '"ref_document_number":' '"' lv_space '"' ','
                                  '"ref_document_date":' '"' lv_port '"' ','
                                  '"supply_type":' '"' sup_type '"' ','
                                  '"erp_document_number":' '"' wa_purchase-accountingdocument '"' ','
                                  '"erp_document_date":' '"' lv_space '"' ','
                                  '"transaction_number":' '"' wa_purchase-accountingdocument '"' ','
                                  '"gl_code":' '"' lv_space '"' ','
                                  '"invoice_status":' '"' inv_sts '"' ','
                                  '"invoice_category":' '"' inv_cat '"' ','
                                  '"invoice_type":' '"' inv_type '"' ','
*                                '"total_invoice_value":' netinvoiceamount ','
*                                '"total_taxable_value":' netinvoiceamount ','
*                                '"txpd_taxable_value":' netinvoiceamount ','
                                   '"total_invoice_value":' tot_inv ','
                                  '"total_taxable_value":' tot_taxable ','
*                                '"txpd_taxable_value":' tot_txpd ','
                                  '"txpd_taxable_value":' '"' lv_space '"' ','
*                                '"total_taxable_value":' tot_tax_val ','
*                                '"txpd_taxable_value":' txpd_tax_val ','
                                  '"shipping_bill_number":' '"' lv_space '"' ','
                                  '"shipping_bill_date":' '"' lv_port '"' ','
                                  '"reason":' '"' lv_space '"' ','
                                  '"port_code":' '"' lv_port '"' ','
                                  '"inv_itc_elgibity":' '"' lv_port '"' ','
                                  '"location":' '"' lv_space '"' ','
                                  '"gstr2_return_period":' '"' period '"' ','
                                  '"gstr3b_return_period":' '"' period '"' ','
                                  '"reverse_charge":' '"' rev_chr '"' ','
                                  '"isamended":' '"' lv_port '"' ','
                                  '"amended_pos":' '"' lv_space '"' ','
                                  '"amended_period":' '"' lv_port '"' ','
                                  '"place_of_supply":' '"' place_supp '"' ','
                                  '"supplier_gstin":' '"' wa_purchase-gstin '"' ','
                                  '"buyer_gstin":' '"' cus_gstin '"' ','
                                  '"supplier_name":' '"' wa_purchase-vendorname '"' ','
                                  '"customer_name":' '"' lv_space '"' ','
                                      INTO lv_post. " SEPARATED BY ' '.


      CONCATENATE : lv_post '"itemList":' '['
                               INTO lv_post SEPARATED BY ' '.


      DATA: lv_tabix TYPE sy-tabix.
      CLEAR : lv_tabix, gstr2_ret, period.

      LOOP AT it_purchase_ml INTO DATA(wa_purchase_item) WHERE RefDocNo = wa_purchase-RefDocNo
                                                         AND ReferenceDocumentMIRO = wa_purchase-ReferenceDocumentMIRO.
*                                                         AND ReferenceDocumentItem = wa_purchase-ReferenceDocumentItem.
*   lv_lines = lines( it_purchase_ml ).

        IF wa_purchase_item-taxcode = 'V0' OR wa_purchase_item-taxcode = 'G0'
         OR wa_purchase_item-taxcode = '' OR wa_purchase_item-Reverse IS NOT INITIAL.
*          CLEAR : wa_purchase_item.  "comntd by krishna 07/10/24
*          CONTINUE.                     "comntd by krishna 07/10/24
        ENDIF.

        lv_tabix = lv_tabix + 1.
        IF lv_tabix NE 1.
          CONCATENATE lv_post ',' INTO lv_post.
        ENDIF.

        CASE wa_purchase_item-uom.
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
        tot_tax_val = COND #( WHEN wa_purchase_item-NetInvoiceAmount lt 0
                              THEN wa_purchase_item-NetInvoiceAmount * -1
                              ELSE wa_purchase_item-NetInvoiceAmount ).
*        gstr2_ret   = wa_purchase_item-invoicedate.

        IF wa_purchase_item-rigst IS INITIAL.
        igst        = COND #( WHEN wa_purchase_item-igst lt 0
                              THEN wa_purchase_item-igst * -1
                              ELSE wa_purchase_item-igst ).
        ELSE.
        igst        = COND #( WHEN wa_purchase_item-rigst lt 0
                              THEN wa_purchase_item-rigst * -1
                              ELSE wa_purchase_item-rigst ).
        ENDIF.
        IF wa_purchase_item-rcgst IS INITIAL.
        cgst        = COND #( WHEN wa_purchase_item-cgst lt 0
                              THEN wa_purchase_item-cgst * -1
                              ELSE wa_purchase_item-cgst ).
        ELSE.
        cgst        = COND #( WHEN wa_purchase_item-rcgst lt 0
                              THEN wa_purchase_item-rcgst * -1
                              ELSE wa_purchase_item-rcgst ).
        ENDIF.
        if wa_purchase_item-rsgst IS INITIAL.
        sgst        = COND #( WHEN wa_purchase_item-sgst lt 0
                              THEN wa_purchase_item-sgst * -1
                              ELSE wa_purchase_item-sgst ).
        ELSE.
        sgst        = COND #( WHEN wa_purchase_item-rsgst lt 0
                              THEN wa_purchase_item-rsgst * -1
                              ELSE wa_purchase_item-rsgst ).
        ENDIF.

        qty         = wa_purchase_item-porderquantity.

        IF wa_purchase_item-HSNCode IS NOT INITIAL.
          itemdesc = wa_purchase_item-MaterialDescription.
        ELSE.
          itemdesc = wa_purchase_item-Narration.
        ENDIF.

        if wa_purchase_item-RCGST_per is INITIAL and wa_purchase_item-RSGST_per is INITIAL.
        IF wa_purchase_item-CGST_per IS NOT INITIAL AND wa_purchase_item-SGST_per IS NOT INITIAL.
          gst_rate  = wa_purchase_item-CGST_per + wa_purchase_item-SGST_per.
          gst_rate1 = gst_rate.
        ELSE.
          gst_rate  = wa_purchase_item-RCGST_per + wa_purchase_item-RSGST_per.
          gst_rate1 = gst_rate.
          ENDIF.
          ENDIF.

        if wa_purchase_item-RIGST_per is INITIAL.
        IF wa_purchase_item-IGST_per IS NOT INITIAL.
          gst_rate  = wa_purchase_item-IGST_per.
          gst_rate1 = gst_rate.
        ENDIF.
        ELSE.
        gst_rate  = wa_purchase_item-RIGST_per.
          gst_rate1 = gst_rate.
        ENDIF.

*Start by Krishna 07/10/24
        IF gst_rate1 IS INITIAL.
          gst_rate1 = '0'.
        ENDIF.
*End by Krishna 07/10/24

        cess = '0.00'.
        itc_elgibity = 'N'.

        CASE wa_purchase_item-taxcode.
        WHEN 'A1' OR 'A2' OR 'A3' OR 'A4' OR 'A5' OR 'A6' OR 'A7' OR 'A8'.
          itc_elgibity = 'Y'.
        WHEN 'K1' OR 'K2'.
          itc_elgibity = 'Y'.
        WHEN 'B1' OR 'B2' OR 'B3' OR 'B4' OR 'B5' OR 'B6' OR 'B7' OR 'B8'.
          itc_elgibity = 'N'.
        WHEN 'R1' OR 'R2' OR 'R3' OR 'R4' OR 'R5' OR 'R6' OR 'R7' OR 'R8'.
          itc_elgibity = 'Y'.
        WHEN 'I1' OR 'I2' OR 'I3' OR 'I4' OR 'I5' OR 'I6' OR 'I7' OR 'I8'.
          itc_elgibity = 'Y'.
        WHEN 'S1' OR 'S2' OR 'S3' OR 'S4' OR 'S5' OR 'S6' OR 'S7' OR 'S8'.
          itc_elgibity = 'N'.
        ENDCASE.

        CONCATENATE : lv_post '{'
                                        ' "igst_amount":' igst  ','
                                        ' "cgst_amount":' cgst  ','
                                        ' "sgst_amount":' sgst  ','
                                        ' "taxable_value":' tot_tax_val ','
                                        ' "hsn_code":' '"' wa_purchase_item-hsncode '"' ','
                                        ' "product_name":' '"' lv_space '"' ','
*                                    ' "item_description":' '"' wa_purchase-materialdescription '"' ','
*                                     ' "item_description":' '"' itemdesc '"' ','        "07/11/24 Cmntd by Krishna
                                        ' "quantity":' qty ','
                                        ' "cess_amount":' cess ','
                                        ' "gst_rate":' gst_rate1 ','
                                        ' "unit_of_product":' '"' uom '"' ','
                                        ' "itc_elgibity":' '"' itc_elgibity '"'
                                         '}' INTO lv_post. " SEPARATED BY ' '.

        CLEAR : wa_purchase_item,igst,cgst,sgst,qty,gst_rate1, cess, itc_elgibity.

      ENDLOOP.

      CLEAR : gstr2_ret, period.
      CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
      CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.

      CONCATENATE : lv_post   ']' INTO lv_post SEPARATED BY ' '.
      CONCATENATE : lv_post   '}' INTO lv_post SEPARATED BY ' '.

      lv_json = lv_post.

      wa_create-referencedocumentmiro = wa_purchase-referencedocumentmiro.
      wa_create-referencedocumentitem = wa_purchase-AccountingDocument.
      wa_create-fiscalyear            = wa_purchase-fiscalyear.
      wa_create-purchasingdocument    = wa_purchase-PurchasingDocument."''.
      wa_create-accountingdocument    = wa_purchase-AccountingDocument."''.
      wa_create-ref_doc               = wa_purchase-RefDocNo.
*     wa_create-vendor                = wa_purchase-Vendor.
      MODIFY zgstr2_st FROM @wa_create.

      IF wa_purchase IS NOT INITIAL.
        TRY.
            DATA lv_url TYPE string.
            " CONCATENATE base_url 'saas-apis/sales/' INTO lv_url.
            " CONCATENATE base_url 'saas-apis/purchase/' INTO lv_url.
            lv_url = 'https://api-platform.mastersindia.co/api/v1/saas-apis/purchase/'.
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
            "req->set_header_field( i_name = content_type i_value = json_content ).
            req->set_header_fields(  VALUE #(
            ( name = 'Content-Type' value  = 'application/json' )
            ( name = 'productid' value     = 'enterprises' )
            ( name = 'MiplApiKey' value = 'rLWN9u9WePRtGneWExwJvy2gwWPrCUTM' ) ) ).
*            ( name = 'Authorization' value = |JWT { lv_res_token }| ) ) ).
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

*    "response store dd

      IF stat-code = '200'.

        /ui2/cl_json=>deserialize(
     EXPORTING
     json = json_response
     CHANGING
     data = ls_output ).
        lt_head = ls_output-result-purchase_error_data.

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

          SELECT SINGLE * FROM zgstr2_st WHERE referencedocumentmiro = @wa_create-referencedocumentmiro
          AND ref_doc = @wa_create-ref_doc
          INTO @DATA(wa_zgstr2_st).
          IF wa_zgstr2_st IS NOT INITIAL.
            wa_zgstr2_st-status = str11.
            MODIFY zgstr2_st FROM @wa_zgstr2_st.
          ENDIF.
        ENDIF.

        IF ls_output-result-success_count = '1'.
          SELECT SINGLE * FROM zgstr2_st WHERE referencedocumentmiro = @wa_create-referencedocumentmiro
          AND ref_doc = @wa_create-ref_doc
          INTO @DATA(wa_zgstr2_status).
          IF wa_zgstr2_status IS NOT INITIAL.
            wa_zgstr2_status-status = 'Data Posted Successfully'.
            MODIFY zgstr2_st FROM @wa_zgstr2_status.
          ENDIF.
        ENDIF.

        DATA(lv_message) = me->new_message(
                         id = 'ZGSTR1_MESSAGE'
                         number = '001'
                         severity = ms-success
                         v1       = str11 ).
        DATA ls_record LIKE LINE OF reported-zi_send_gstr1_mi.
        ls_record-%msg = lv_message.
        ls_record-%element-referencedocumentmiro = if_abap_behv=>mk-on.
        "  ls_record-%element- = if_abap_behv=>mk-on.
        APPEND ls_record TO reported-zi_send_gstr1_mi.

      ENDIF..
      CLEAR : wa_purchase, wa_keys_ml, wa_keys_ml, wa_zgstr2_st, wa_zgstr2_status, lv_post, lv_json, wa_create,
              lv_res_token, lv_response, json_response, stat, ls_output, lt_head, str1, str2, str3, str4, str5,
              str6, str7, str8, str9, str10, str11, str12, ls_record, lv_message.

    ENDLOOP.
  ENDMETHOD.

  METHOD create_client.

    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.

  METHOD get_auth_token.

    ls_config-uname = 'ryshejwal@ivpindia.com'.
*    ls_config-password = 'Reli@123456789'.
    "data(dest) = cl_http_destination_provider=>create_by_url( url ).
    "DATA(result) = cl_web_http_client_manager=>create_by_http_destination( dest ).
    DATA url TYPE string.
    CONCATENATE base_url 'token-auth/' INTO url.
    CONDENSE url NO-GAPS.
*
*
*    lv_token = '{"password":"Ivplimited@01","username":"ryshejwal@ivpindia.com"}'.  "cmntd by Krishna 25/09/24
    lv_token = '{"password":"Masters@1234567","username":"ryshejwal@ivpindia.com"}'.

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

  ENDMETHOD.

*** Start commenting as it is moved to GST ITC RECO *****
*  METHOD response.
*
*    TYPES:BEGIN OF ty_message,
*            message TYPE bapi_msg,
*          END OF ty_message.
*
*    TYPES : BEGIN OF ty_sapdata,
*              inum                    TYPE string,
*              nt_dt                   TYPE string,
*              nt_num                  TYPE string,
*              ntty                    TYPE string,
*              pos                     TYPE string,
*              portcode                TYPE string,
*              rchrg                   TYPE string,
*              org_inum                TYPE string,
*              org_idt                 TYPE string,
*              supplier_gstin          TYPE string,
*              buyer_gstin             TYPE string,
*              erp_document_number(10),
*              erp_document_date(10),
*            END OF ty_sapdata.
*
*    TYPES : BEGIN OF ty_rsdata,
*              val                       TYPE string,
*              inv_type(10),
*              pos(2),
*              idt type zgstr2_reco_st-idt,
*              rchrg(1),
*              inum(20),
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
*              gstr1_filling_date(10),
*              ttxval(13),
*              net_amount(15),
*              auto_reco_id(40),
*              match_status(10),
*              location(6),
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
*              gstr2_return_period(20),
*              gstr3b_filling_status(20),
*            END OF ty_rsdata.
*
*    DATA: tt_rsdata    TYPE TABLE OF ty_rsdata,
*          tt_rsurl     TYPE TABLE OF string,
*          lt_chunk_url TYPE TABLE OF string,
*          ls_chunk_url TYPE string.
*
*    TYPES:BEGIN OF ty_output,
*            success TYPE string,
*            status  TYPE string,
*            message TYPE string,
*          END OF ty_output,
*
*          BEGIN OF ty_rsdata2,
*            total_count   TYPE string,
*            total_page    TYPE string,
*            request_valid TYPE string,
*            request_id    TYPE string,
*            url           LIKE tt_rsurl,
*          END OF ty_rsdata2,
*
*          BEGIN OF ty_output1,
*            success TYPE string,
*            status  TYPE string,
*            message TYPE ty_message,
*            data    LIKE tt_rsdata,
*          END OF ty_output1,
*
*          BEGIN OF ty_output2,
*            success TYPE string,
*            status  TYPE string,
*            message TYPE ty_message,
*            data    TYPE ty_rsdata2,
*          END OF ty_output2.
*
*    DATA : reco_url    TYPE string,
*           buyer_gstin TYPE string,
*           reco_type   TYPE string,
*           f_year      TYPE string,
*           page_size   TYPE string,
*           api_key     TYPE string,
*           product_id  TYPE string.
*
*    READ ENTITIES OF zi_send_gstr1_mi  IN LOCAL MODE
*    ENTITY zi_send_gstr1_mi
*    ALL FIELDS WITH
*    CORRESPONDING #( keys )
*    RESULT DATA(lt_gstr2_ml)
*    FAILED DATA(failed_data_ml)
*    REPORTED DATA(reported_data_ml).
*
*    data(it_reco) = keys[].
*
*    read TABLE it_reco into data(wa_reco) index 1.
*    if sy-subrc is INITIAL.
*
*      SELECT Single business_place
*                    FROM zi_send_gstr1_mi
*                    WHERE RefDocNo            = @wa_reco-DocumentReferenceID
*                    AND ReferenceDocumentMIRO = @wa_reco-ReferenceDocumentMIRO
*                    INTO @DATA(wa_bp).
*
*      select single IN_GSTIdentificationNumber
*                    from I_IN_BusinessPlaceTaxDetail
*                    where BusinessPlace = @wa_bp
*                    into @data(lv_gstin).
*    endif.
*
*    reco_url    = 'https://api-platform.mastersindia.co/api/v1/saas-apis/recoapi/?'.
*    buyer_gstin = lv_gstin.   "'27ADDPA4822E1Z4'."Should be dynamic
*    reco_type   = '2A-PR'.
*    f_year      = '2024-25'.
*    api_key     = '1AAY5FpR7B21uLYq6YtRbogsENRBbaXe'.
*    product_id  = 'enterprises'.
*    page_size   = '800'.
*    DATA(sleep_time) = 5. " Time in seconds
*
*    CONCATENATE reco_url  'buyer_gstin=' buyer_gstin '&' 'reco_type=' reco_type '&' 'f_year=' f_year INTO reco_url.
*    '&' 'page_size=' page_size
*    CONDENSE reco_url NO-GAPS.
*
*    TRY.
*        DATA(client) = create_client( reco_url ).
*      CATCH cx_static_check.
*    ENDTRY.
*    DATA(req) = client->get_http_request(  ).
*
*    req->set_header_fields(  VALUE #(
*   ( name = 'Productid'  value = product_id  )
*   ( name = 'GSTIN'      value = buyer_gstin )
*   ( name = 'MiplApiKey' value = api_key     ) ) ).
*
*    TRY.
*        DATA(lv_response) = client->execute(
*                        i_method  = if_web_http_client=>get ).
*        DATA(json_response) = lv_response->get_text( ).
*        DATA(stat) = lv_response->get_status(  ).
*        client->close( ).
*      CATCH: cx_web_http_client_error.
*    ENDTRY.
*
*    DATA:ls_output  TYPE ty_output,
*         ls_output1 TYPE ty_output1,
*         ls_output2 TYPE ty_output2.
*        lt_reco_data1 TYPE ty_rsdata.
*
*    DATA : ls_bseg TYPE i_operationalacctgdocitem.
*
*    /ui2/cl_json=>deserialize(
*    EXPORTING
*    json = json_response
*    CHANGING
*    data = ls_output ).
*
*    IF ls_output-success = 'X' AND ls_output-status = '1'
*    AND ( ls_output-message = 'Data found' OR ls_output-message = 'data found' ).
*      /ui2/cl_json=>deserialize(
*  EXPORTING
*  json = json_response
*  CHANGING
*  data = ls_output1 ).
*
*      data : it_gstr2 type table of zgstr2_reco_st,
*             ls_gstr2 type zgstr2_reco_st.
*
*      DATA(reco_data1) = ls_output1-data.
*
*      SELECT inum FROM zgstr2_reco_st
*      FOR ALL ENTRIES IN @reco_data1
*      WHERE inum = @reco_data1-inum  INTO TABLE @DATA(lt_gstr2).
*
*      LOOP AT reco_data1 INTO DATA(ls_reco).
*
*        READ TABLE lt_gstr2 INTO data(ls_gstr2_n) WITH KEY inum = ls_reco-inum.
*        IF sy-subrc = 0.
*          ls_gstr2-inum                  = ls_gstr2_n-inum.
*          ls_gstr2-idt                   = ls_reco-idt.
*          ls_gstr2-val                   = ls_reco-val.
*          ls_gstr2-inv_typ               = ls_reco-inv_type.
*          ls_gstr2-pos                   = ls_reco-pos.
*          ls_gstr2-rchrg                 = ls_reco-rchrg.
*          ls_gstr2-imonth                = ls_reco-imonth.
*          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
*          ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
*          ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
*          ls_gstr2-contact_name          = ls_reco-contact_name.
*          ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
*          ls_gstr2-cfs                   = ls_reco-cfs.
*          ls_gstr2-invoice_type          = ls_reco-invoice_type.
*          ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
*          ls_gstr2-ttxval                = ls_reco-ttxval.
*          ls_gstr2-net_amount            = ls_reco-net_amount.
*          ls_gstr2-nt_dt                 = ls_reco-pr_data-nt_dt.
*          ls_gstr2-nt_num                = ls_reco-pr_data-nt_num.
*          ls_gstr2-ntty                  = ls_reco-pr_data-ntty.
*          ls_gstr2-location              = ls_reco-location.
*          ls_gstr2-total_cgst            = ls_reco-total_cgst.
*          ls_gstr2-total_sgst            = ls_reco-total_sgst.
*          ls_gstr2-total_igst            = ls_reco-total_igst.
*          ls_gstr2-total_cess            = ls_reco-total_cess.
*          ls_gstr2-portcode              = ls_reco-pr_data-portcode.
*          ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
*          ls_gstr2-org_inum              = ls_reco-pr_data-org_inum.
*          ls_gstr2-org_idt               = ls_reco-pr_data-org_idt.
*          ls_gstr2-itc_alg               = ls_reco-itc_elg.
*          ls_gstr2-transaction_number    = ls_reco-transaction_number.
*          ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
*          ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
*          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
*          ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
*          ls_gstr2-fiscalyear            = ls_reco-f_year.
*          ls_gstr2-status                = ls_reco-match_status.
*          ls_gstr2-reco_action           = ls_reco-reco_action.
*          ls_gstr2-action_date           = ls_reco-action_date.
*          ls_gstr2-gstr2_return_period   = ls_reco-gstr2_return_period.
*          ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
*          ls_gstr2-reason                = ls_reco-mismatch_reason.
*          ls_gstr2-vendor_name           = ls_reco-supplier_name.
*
*        ELSE.
*          ls_gstr2-inum                  = ls_reco-inum.
*          ls_gstr2-idt                   = ls_reco-idt.
*          ls_gstr2-val                   = ls_reco-val.
*          ls_gstr2-inv_typ               = ls_reco-inv_type.
*          ls_gstr2-pos                   = ls_reco-pos.
*          ls_gstr2-rchrg                 = ls_reco-rchrg.
*          ls_gstr2-imonth                = ls_reco-imonth.
*          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
*          ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
*          ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
*          ls_gstr2-contact_name          = ls_reco-contact_name.
*          ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
*          ls_gstr2-cfs                   = ls_reco-cfs.
*          ls_gstr2-invoice_type          = ls_reco-invoice_type.
*          ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
*          ls_gstr2-ttxval                = ls_reco-ttxval.
*          ls_gstr2-net_amount            = ls_reco-net_amount.
*          ls_gstr2-nt_dt                 = ls_reco-pr_data-nt_dt.
*          ls_gstr2-nt_num                = ls_reco-pr_data-nt_num.
*          ls_gstr2-ntty                  = ls_reco-pr_data-ntty.
*          ls_gstr2-location              = ls_reco-location.
*          ls_gstr2-total_cgst            = ls_reco-total_cgst.
*          ls_gstr2-total_sgst            = ls_reco-total_sgst.
*          ls_gstr2-total_igst            = ls_reco-total_igst.
*          ls_gstr2-total_cess            = ls_reco-total_cess.
*          ls_gstr2-portcode              = ls_reco-pr_data-portcode.
*          ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
*          ls_gstr2-org_inum              = ls_reco-pr_data-org_inum.
*          ls_gstr2-org_idt               = ls_reco-pr_data-org_idt.
*          ls_gstr2-itc_alg               = ls_reco-itc_elg.
*          ls_gstr2-transaction_number    = ls_reco-transaction_number.
*          ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
*          ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
*          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
*          ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
*          ls_gstr2-fiscalyear            = ls_reco-f_year.
*          ls_gstr2-status                = ls_reco-match_status.
*          ls_gstr2-reco_action           = ls_reco-reco_action.
*          ls_gstr2-action_date           = ls_reco-action_date.
*          ls_gstr2-gstr2_return_period   = ls_reco-gstr2_return_period.
*          ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
*          ls_gstr2-reason                = ls_reco-mismatch_reason.
*          ls_gstr2-vendor_name           = ls_reco-supplier_name.
*
*        ENDIF.
*
*        MODIFY zgstr2_reco_st FROM @ls_gstr2.
*
*        IF ls_gstr2-reco_action = 'NOT_IN_2A'.
*        ENDIF.
*
*        CLEAR : ls_gstr2,ls_reco.
*      ENDLOOP.
*
*
*    ELSEIF ls_output-status = '2' AND ( ls_output-message = 'Data found' OR ls_output-message = 'data found' ).
*      CLEAR : client,req,lv_response,stat,ls_output,ls_output1,reco_data1,ls_reco,ls_gstr2, ls_gstr2_n.
*      clear : lt_gstr2, it_gstr2.
*
*      /ui2/cl_json=>deserialize(
* EXPORTING
* json = json_response
* CHANGING
* data = ls_output2 ).
*      " ENDIF.
*
*      lt_chunk_url = ls_output2-data-url.
*
*      LOOP AT lt_chunk_url INTO ls_chunk_url.
*
*        TRY.
*            client = create_client( ls_chunk_url ).
*            client->close( ).
*          CATCH cx_static_check.
*        ENDTRY.
*        req = client->get_http_request(  ).
*
*        req->set_header_fields(  VALUE #(
*       ( name = 'GSTIN'      value = buyer_gstin )
*       ( name = 'MiplApiKey' value = api_key ) ) ).
*
*        TRY.
*            DATA(lv_response1)   = client->execute( i_method  = if_web_http_client=>get ).
*            DATA(json_response1) = lv_response1->get_text( ).
*            DATA(stat1)          = lv_response1->get_status(  ).
*            client->close(  ).
*          CATCH: cx_web_http_client_error.
*        ENDTRY.
*
*        /ui2/cl_json=>deserialize(
*    EXPORTING
*    json = json_response1
*    CHANGING
*    data = ls_output1 ).
*        CLEAR reco_data1.
*
*        reco_data1 = ls_output1-data.
*
*        sort reco_data1 by inum ASCENDING.
*        DELETE ADJACENT DUPLICATES FROM reco_data1 COMPARING inum.
*
*        LOOP AT reco_data1 INTO ls_reco.
*
*          ls_gstr2-inum                  = ls_reco-inum.
*          ls_gstr2-idt                   = ls_reco-idt.
*          ls_gstr2-val                   = ls_reco-val.
*          ls_gstr2-inv_typ               = ls_reco-inv_type.
*          ls_gstr2-pos                   = ls_reco-pos.
*          ls_gstr2-rchrg                 = ls_reco-rchrg.
*          ls_gstr2-imonth                = ls_reco-imonth.
*          ls_gstr2-supplier_gstin        = ls_reco-supplier_gstin.
*          ls_gstr2-supplier_gstin_status = ls_reco-supplier_gstin_status.
*          ls_gstr2-supplier_return_type  = ls_reco-supplier_return_type.
*          ls_gstr2-contact_name          = ls_reco-contact_name.
*          ls_gstr2-buyer_gstin           = ls_reco-buyer_gstin.
*          ls_gstr2-cfs                   = ls_reco-cfs.
*          ls_gstr2-invoice_type          = ls_reco-invoice_type.
*          ls_gstr2-gstr1_filling_date    = ls_reco-gstr1_filling_date.
*          ls_gstr2-ttxval                = ls_reco-ttxval.
*          ls_gstr2-net_amount            = ls_reco-net_amount.
*          ls_gstr2-nt_dt                 = ls_reco-pr_data-nt_dt.
*          ls_gstr2-nt_num                = ls_reco-pr_data-nt_num.
*          ls_gstr2-ntty                  = ls_reco-pr_data-ntty.
*          ls_gstr2-location              = ls_reco-location.
*          ls_gstr2-total_cgst            = ls_reco-total_cgst.
*          ls_gstr2-total_sgst            = ls_reco-total_sgst.
*          ls_gstr2-total_igst            = ls_reco-total_igst.
*          ls_gstr2-total_cess            = ls_reco-total_cess.
*          ls_gstr2-portcode              = ls_reco-pr_data-portcode.
*          ls_gstr2-referred_invoice_date = ls_reco-referred_invoice_date.
*          ls_gstr2-org_inum              = ls_reco-pr_data-org_inum.
*          ls_gstr2-org_idt               = ls_reco-pr_data-org_idt.
*          ls_gstr2-itc_alg               = ls_reco-itc_elg.
*          ls_gstr2-transaction_number    = ls_reco-transaction_number.
*          ls_gstr2-autorecoid            = ls_reco-auto_reco_id.
*          ls_gstr2-referencedocumentmiro = ls_reco-referred_invoice_num.
*          ls_gstr2-accountingdocument    = ls_reco-erp_document_number.
*          ls_gstr2-erp_document_date     = ls_reco-erp_document_date.
*          ls_gstr2-fiscalyear            = ls_reco-f_year.
*          ls_gstr2-status                = ls_reco-match_status.
*          ls_gstr2-reco_action           = ls_reco-reco_action.
*          ls_gstr2-action_date           = ls_reco-action_date.
*          ls_gstr2-gstr2_return_period   = ls_reco-gstr2_return_period.
*          ls_gstr2-gstr3b_filling_status = ls_reco-gstr3b_filling_status.
*          ls_gstr2-reason                = ls_reco-mismatch_reason.
*          ls_gstr2-vendor_name           = ls_reco-supplier_name.
*
*          append ls_gstr2 to it_gstr2.
*          CLEAR : ls_reco, lt_gstr2, ls_gstr2.
*        ENDLOOP.
*
*        MODIFY zgstr2_reco_st FROM TABLE @it_gstr2.
*
*        CLEAR : client, req, lv_response, lv_response1, stat, stat1, ls_output,ls_output1,ls_reco,ls_gstr2, ls_chunk_url.
*        WAIT UP TO '5' SECONDS.
*      ENDLOOP.
*
*    ENDIF.
*  ENDMETHOD.
*** End commenting as it is moved to GST ITC RECO *****
ENDCLASS.

CLASS lsc_zi_send_gstr1_mi DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_send_gstr1_mi IMPLEMENTATION.

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
