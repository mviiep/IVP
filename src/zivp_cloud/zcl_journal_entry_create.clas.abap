CLASS zcl_journal_entry_create DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  TYPES : BEGIN OF ty_je_doc,
          docnum TYPE string,
          END OF ty_je_doc.

  TYPES : BEGIN OF ty_je_docnum,
          docnum TYPE string,
          END OF ty_je_docnum.

  DATA : it_je_doc TYPE TABLE OF ty_je_doc.

  DATA : it_je_docnum TYPE TABLE OF ty_je_docnum,
         wa_je_docnum TYPE ty_je_docnum.

  METHODS jornalentrycreation EXPORTING ex_jepost LIKE it_je_doc.

 " METHODS create_journalentry.
*          importing p_it_penalamo_upd TYPE ztb_penalamo_upd
*          RETURNING VALUE(r_val)     TYPE string.


  """""""""""""""""""""""""""Declarations
  DATA :
*         lv_date TYPE sy-datum,
*         lv_time TYPE sy-uzeit,
         lv_date1 TYPE string.

  CONSTANTS : lv_dummy TYPE string VALUE '?',
              lv_text TYPE string VALUE 'Retention Posting for ITC Reconcilation',
*                         CONSTANTS : lv_dummy TYPE string VALUE '?',
                       lv_text_ret TYPE string VALUE 'Retention Posting for ITC Reconcilation',
                       lv_text_rev_ret TYPE string VALUE 'Reverse Retention Posting for ITC Reconcilation',
                       lv_text_vc type string VALUE 'Vendor Retention Credit',
                       lv_text_vd TYPE string VALUE 'Vendor Retention Debit'.


    INTERFACES if_oo_adt_classrun.

    DATA : ls_je       TYPE zjejournal_entry_create_requ18,
           ls_jeitem   TYPE zjejournal_entry_create_reque9,
           ls_je_gl    TYPE zjechart_of_accounts_item_cod1,
           ls_je_trc   TYPE zjeamount,
           ls_msg_id   TYPE zjebusiness_document_message_3,
           ls_msg_hdr  TYPE zjebusiness_document_message_2,
           ls_jecr     TYPE zjejournal_entry_create_reques,
           ls_taxcode  TYPE zjeproduct_taxation_character1,
           ls_tax_item TYPE zjejournal_entry_create_reque2,
           ls_acc      TYPE zjejournal_entry_create_reque8,
           ls_cred     TYPE zjejournal_entry_create_requ16,
           ls_deb      TYPE zjejournal_entry_create_requ13,
           ls_tax      TYPE zjeproduct_taxation_character1,
           ls_prd      TYPE zjejournal_entry_create_reque3,
           ls_hdr      TYPE zjejournal_entry_create_requ19,
           i_user      TYPE string,
           i_pass      TYPE string,
           i_port      TYPE prx_logical_port_name,
           i_msg       TYPE abap_bool,
           response    TYPE zjejournal_entry_bulk_create_c,
           ls_jeconf   TYPE zjejournal_entry_create_confi2,
           ls_jecconf  TYPE zjejournal_entry_create_co_tab,
           ls_jett     TYPE zjejournal_entry_create_confir,
           ls_jest     TYPE zjejournal_entry_create_confi1,
           ls_customer TYPE zjejournal_entry_create_reque6.  "zje_amount.

           data : lv_acc_doc TYPE string,
                  lv_ret_doc TYPE zjeaccounting_document,
                  lv_tot_tax TYPE string.
                  data : lv_tabix TYPE sy-tabix,
                         ls_reco TYPE zgstr2_reco_st.

*  data : lv_acc_doc type string,
*                  lv_date1 TYPE string,
*                  it_reco TYPE TABLE OF zgstr2_reco_st.



  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_JOURNAL_ENTRY_CREATE IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

me->jornalentrycreation(
*  IMPORTING
*    ex_jepost =
).

SELECT * FROM zgstr2_reco_st WHERE accountingdocument NE '' and pr_rchrg <> 'Y' and pr_ttxval <> '' INTO TABLE @DATA(lt_gstr2).

    SORT lt_gstr2 by accountingdocument.
    DELETE lt_gstr2 WHERE accountingdocument = ''. "or ttxval = ''.
    DELETE lt_gstr2 WHERE pr_ttxval = ''.

    SELECT * FROM @lt_gstr2 AS a LEFT OUTER JOIN i_operationalacctgdocitem AS b ON a~accountingdocument = b~accountingdocument
    LEFT OUTER JOIN zdb_org_gstin AS c ON b~postingdate <= c~gst_reten_st_dt
    LEFT OUTER JOIN zi_gstr1_send_mi AS d ON b~accountingdocument = d~accountingdocument
    WHERE b~profitcenter <> '' AND d~supplier <> ''
    INTO TABLE @DATA(it_innerjoin).

    DELETE lt_gstr2 WHERE pr_ttxval = '0.0'.
    LOOP AT lt_gstr2 INTO DATA(wa_gstr2).

READ TABLE it_innerjoin INTO DATA(wa_innerjoin) WITH KEY a-accountingdocument = wa_gstr2-accountingdocument.
if ( wa_gstr2-status eq 'TVD' or wa_gstr2-status eq 'IPM' or wa_gstr2-status eq 'TRD' or wa_gstr2-status eq 'OINM'
     or wa_gstr2-status eq 'OIDM' or wa_gstr2-status eq 'INT' or wa_gstr2-status eq 'PM' or wa_gstr2-status eq 'O'
     or wa_gstr2-status eq 'R' or wa_gstr2-status eq 'NI2A' or wa_gstr2-status eq 'NI2B' or wa_gstr2-status eq 'R_PR'
     or wa_gstr2-status eq 'SG-TVM-TRM' or wa_gstr2-status eq 'SG-TVM' or wa_gstr2-status eq 'SG-IN-IDM'
     or wa_gstr2-status eq 'SG-INM' or wa_gstr2-status eq 'OID' or wa_gstr2-status eq 'OIN' OR wa_gstr2-status eq 'SGM'
     or wa_gstr2-status eq 'SG-TRM' or wa_gstr2-status eq 'SG-POM' or wa_gstr2-status eq 'SG-IDM' or wa_gstr2-status eq 'SG-INV-FUZ'
     or wa_gstr2-status eq 'IGST' or wa_gstr2-status eq 'CGST' or wa_gstr2-status eq 'SGST' or wa_gstr2-status eq 'CESS'
     or wa_gstr2-status eq 'RCM'  ) AND wa_gstr2-reten_post is INITIAL and wa_innerjoin-c-gst_reten_st_dt <= wa_innerjoin-b-PostingDate.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-id = ls_msg_id.
    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_hdr-message_header = ls_msg_hdr.
    clear : ls_msg_hdr, ls_msg_id.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_msg_hdr-id = ls_msg_id.
    ls_jecr-message_header = ls_msg_hdr.

     ls_je-original_reference_document_ty = 'BKPFF'.
    ls_je-document_reference_id = wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
    ls_je-business_transaction_type = 'RFBU'.
    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
    ls_je-document_header_text = 'Retention Posting'.
    ls_je-created_by_user = sy-uname.
    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
    ls_je-document_date = sy-datum.
    ls_je-posting_date = sy-datum.

    ls_je_gl-content = '0020602080'.
    ls_jeitem-glaccount = ls_je_gl.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
*    lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
*    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
*    ls_je_trc-content = ls_je_trc-content * -1.
    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
    ls_jeitem-debit_credit_code = 'H'.
    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
    ls_jeitem-document_item_text = 'Retention Posting'.
    ls_jeitem-assignment_reference = '123'.
    clear : ls_je_trc.

    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
    ls_jeitem-account_assignment = ls_acc.
   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
    ls_jeitem-profitability_supplement = ls_customer.
    APPEND ls_jeitem TO ls_je-item.


wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
ls_cred-creditor = wa_innerjoin-d-Supplier.
ls_cred-debit_credit_code = 'S'.
ls_cred-document_item_text = 'Retention Posting'.
ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
*lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
*    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
    ls_cred-amount_in_transaction_currency = ls_je_trc.
    APPEND ls_cred TO ls_je-creditor_item.


     ls_jecr-journal_entry = ls_je.
    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.

    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
          ).

         DATA(proxy) = NEW zjeco_journal_entry_create_req( destination = destination ).

         DATA(request) = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).

        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).

          " handle response
      CATCH cx_soap_destination_error.
        " handle error
      CATCH cx_ai_system_fault.
        " handle error

         endtry.

    ls_jeconf = response-journal_entry_bulk_create_conf.
              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
              READ TABLE ls_jecconf Into ls_jett INDEX 1.
              if sy-subrc = 0.
              ls_jest = ls_jett-journal_entry_create_confirmat.
              endif.

  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
              wa_gstr2-reten_post_doc = ls_jest-accounting_document.
              wa_gstr2-reten_post = 'X'.
              wa_gstr2-ret_flag = 'X'.
             MODIFY zgstr2_reco_st FROM @wa_gstr2.

  ENDIF.

  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.


*SELECT * FROM zgstr2_reco_st WHERE accountingdocument NE '' and pr_rchrg <> 'Y' and pr_ttxval <> '' INTO TABLE @DATA(lt_gstr2).
*
*    SORT lt_gstr2 by accountingdocument.
*    DELETE lt_gstr2 WHERE accountingdocument = ''. "or ttxval = ''.
*    DELETE lt_gstr2 WHERE pr_ttxval = ''.
*
*    SELECT * FROM @lt_gstr2 AS a LEFT OUTER JOIN i_operationalacctgdocitem AS b ON a~accountingdocument = b~accountingdocument
*    LEFT OUTER JOIN zdb_org_gstin AS c ON b~postingdate <= c~gst_reten_st_dt
*    LEFT OUTER JOIN zi_gstr1_send_mi AS d ON b~accountingdocument = d~accountingdocument
*    WHERE b~profitcenter <> '' AND d~supplier <> ''
*    INTO TABLE @DATA(it_innerjoin).
*
*    DELETE lt_gstr2 WHERE pr_ttxval = '0.0'.
*    LOOP AT lt_gstr2 INTO DATA(wa_gstr2).
*
*READ TABLE it_innerjoin INTO DATA(wa_innerjoin) WITH KEY a-accountingdocument = wa_gstr2-accountingdocument.
*if ( wa_gstr2-status eq 'TVD' or wa_gstr2-status eq 'IPM' or wa_gstr2-status eq 'TRD' or wa_gstr2-status eq 'OINM'
*     or wa_gstr2-status eq 'OIDM' or wa_gstr2-status eq 'INT' or wa_gstr2-status eq 'PM' or wa_gstr2-status eq 'O'
*     or wa_gstr2-status eq 'R' or wa_gstr2-status eq 'NI2A' or wa_gstr2-status eq 'NI2B' or wa_gstr2-status eq 'R_PR'
*     or wa_gstr2-status eq 'SG-TVM-TRM' or wa_gstr2-status eq 'SG-TVM' or wa_gstr2-status eq 'SG-IN-IDM'
*     or wa_gstr2-status eq 'SG-INM' or wa_gstr2-status eq 'OID' or wa_gstr2-status eq 'OIN' OR wa_gstr2-status eq 'SGM'
*     or wa_gstr2-status eq 'SG-TRM' or wa_gstr2-status eq 'SG-POM' or wa_gstr2-status eq 'SG-IDM' or wa_gstr2-status eq 'SG-INV-FUZ'
*     or wa_gstr2-status eq 'IGST' or wa_gstr2-status eq 'CGST' or wa_gstr2-status eq 'SGST' or wa_gstr2-status eq 'CESS'
*     or wa_gstr2-status eq 'RCM'  ) AND wa_gstr2-reten_post is INITIAL and wa_innerjoin-c-gst_reten_st_dt <= wa_innerjoin-b-PostingDate.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-id = ls_msg_id.
*    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_hdr-message_header = ls_msg_hdr.
*    clear : ls_msg_hdr, ls_msg_id.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_msg_hdr-id = ls_msg_id.
*    ls_jecr-message_header = ls_msg_hdr.
**    clear : ls_msg_hdr.
*
*    ls_je-original_reference_document_ty = 'BKPFF'.
*    ls_je-document_reference_id = wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
*    ls_je-business_transaction_type = 'RFBU'.
*    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
*    ls_je-document_header_text = 'Retention Posting'.
*    ls_je-created_by_user = sy-uname.
*    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
*    ls_je-document_date = sy-datum.
*    ls_je-posting_date = sy-datum.
*
*    ls_je_gl-content = '0020602080'.
*    ls_jeitem-glaccount = ls_je_gl.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
*    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
*    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
*    ls_jeitem-debit_credit_code = 'H'.
*    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
*    ls_jeitem-document_item_text = 'Retention Posting'.
*    ls_jeitem-assignment_reference = '123'.
*    clear : ls_je_trc.
*
*    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
*    ls_jeitem-account_assignment = ls_acc.
*    ls_jeitem-profitability_supplement = ls_customer.
*    APPEND ls_jeitem TO ls_je-item.
**    clear : ls_jeitem.
*
*    wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
*    ls_cred-creditor = wa_innerjoin-d-Supplier.
*    ls_cred-debit_credit_code = 'S'.
*    ls_cred-document_item_text = 'Retention Posting'.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
*    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
*    ls_cred-amount_in_transaction_currency = ls_je_trc.
*    APPEND ls_cred TO ls_je-creditor_item.
**    clear : ls_je_trc, ls_cred.
*
*    ls_jecr-journal_entry = ls_je.
*    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
*
*    TRY.
*        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
*          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
*         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
*          ).
*         DATA(proxy) = NEW zjeco_journal_entry_create_req( destination = destination ).
*         DATA(request) = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
*        proxy->journal_entry_create_request_c(
*          EXPORTING
*            input = request
*          IMPORTING
*            output = DATA(response)
*        ).
**        clear : request.
*      CATCH cx_soap_destination_error.
*      CATCH cx_ai_system_fault.
*    endtry.
*
*    ls_jeconf = response-journal_entry_bulk_create_conf.
*    ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
*    READ TABLE ls_jecconf Into ls_jett INDEX 1.
*    if sy-subrc = 0.
*    ls_jest = ls_jett-journal_entry_create_confirmat.
*    endif.
*
*  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
*  wa_gstr2-reten_post_doc = ls_jest-accounting_document.
*  wa_gstr2-reten_post = 'X'.
*  wa_gstr2-ret_flag = 'X'.
*  MODIFY zgstr2_reco_st FROM @wa_gstr2.
*  ENDIF.
*
*  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.", ls_je, ls_jecr.

  ELSEIF  ( wa_gstr2-status eq 'M' or wa_gstr2-status eq 'A' or wa_gstr2-status eq 'A_PR' or wa_gstr2-status eq 'INA-AM'
     or wa_gstr2-status eq 'INA' ) AND wa_gstr2-reten_post is NOT INITIAL AND wa_gstr2-rev_ret_flag is INITIAL.

     ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-id = ls_msg_id.
    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_hdr-message_header = ls_msg_hdr.
    clear : ls_msg_hdr, ls_msg_id.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_msg_hdr-id = ls_msg_id.
    ls_jecr-message_header = ls_msg_hdr.

     ls_je-original_reference_document_ty = 'BKPFF'.
    ls_je-document_reference_id = wa_gstr2-reten_post_doc."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
    ls_je-business_transaction_type = 'RFBU'.
    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
    ls_je-document_header_text = 'Retention Posting'.
    ls_je-created_by_user = sy-uname.
    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
    ls_je-document_date = sy-datum.
    ls_je-posting_date = sy-datum.

    ls_je_gl-content = '0020602080'.
    ls_jeitem-glaccount = ls_je_gl.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
*    lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
*    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
*    ls_je_trc-content = ls_je_trc-content * -1.
    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
    ls_jeitem-debit_credit_code = 'H'.
    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
    ls_jeitem-document_item_text = 'Retention Posting'.
    ls_jeitem-assignment_reference = '123'.
    clear : ls_je_trc.

    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
    ls_jeitem-account_assignment = ls_acc.
   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
    ls_jeitem-profitability_supplement = ls_customer.
    APPEND ls_jeitem TO ls_je-item.


wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
ls_cred-creditor = wa_innerjoin-d-Supplier.
ls_cred-debit_credit_code = 'S'.
ls_cred-document_item_text = 'Retention Posting'.
ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
*lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
*    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
    ls_cred-amount_in_transaction_currency = ls_je_trc.
    APPEND ls_cred TO ls_je-creditor_item.


     ls_jecr-journal_entry = ls_je.
    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.

    TRY.
        destination = cl_soap_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
          ).

         proxy = NEW zjeco_journal_entry_create_req( destination = destination ).

         request = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).

        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = response
        ).

          " handle response
      CATCH cx_soap_destination_error.
        " handle error
      CATCH cx_ai_system_fault.
        " handle error

         endtry.

    ls_jeconf = response-journal_entry_bulk_create_conf.
              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
              READ TABLE ls_jecconf Into ls_jett INDEX 1.
              if sy-subrc = 0.
              ls_jest = ls_jett-journal_entry_create_confirmat.
              endif.

  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
              wa_gstr2-reten_post_doc = ls_jest-accounting_document.
              wa_gstr2-reten_post = 'X'.
              wa_gstr2-ret_flag = 'X'.
             MODIFY zgstr2_reco_st FROM @wa_gstr2.

  ENDIF.

  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.

  ENDIF.

  ENDLOOP.


""""""""""""""""""""""""""""""""""""PERFOMANCE ISSUE SOLVING CODE

ENDMETHOD.


  METHOD JORNALENTRYCREATION.

*SELECT * FROM zgstr2_reco_st WHERE accountingdocument NE '' and pr_rchrg <> 'Y' and pr_ttxval <> '' INTO TABLE @DATA(lt_gstr2).
*
*    SORT lt_gstr2 by accountingdocument.
*    DELETE lt_gstr2 WHERE accountingdocument = ''. "or ttxval = ''.
*    DELETE lt_gstr2 WHERE pr_ttxval = ''.
*
*    SELECT * FROM @lt_gstr2 AS a LEFT OUTER JOIN i_operationalacctgdocitem AS b ON a~accountingdocument = b~accountingdocument
*    LEFT OUTER JOIN zdb_org_gstin AS c ON b~postingdate <= c~gst_reten_st_dt
*    LEFT OUTER JOIN zi_gstr1_send_mi AS d ON b~accountingdocument = d~accountingdocument
*    WHERE b~profitcenter <> '' AND d~supplier <> ''
*    INTO TABLE @DATA(it_innerjoin).
*
*    DELETE lt_gstr2 WHERE pr_ttxval = '0.0'.
*    LOOP AT lt_gstr2 INTO DATA(wa_gstr2).
*
*READ TABLE it_innerjoin INTO DATA(wa_innerjoin) WITH KEY a-accountingdocument = wa_gstr2-accountingdocument.
*if ( wa_gstr2-status eq 'TVD' or wa_gstr2-status eq 'IPM' or wa_gstr2-status eq 'TRD' or wa_gstr2-status eq 'OINM'
*     or wa_gstr2-status eq 'OIDM' or wa_gstr2-status eq 'INT' or wa_gstr2-status eq 'PM' or wa_gstr2-status eq 'O'
*     or wa_gstr2-status eq 'R' or wa_gstr2-status eq 'NI2A' or wa_gstr2-status eq 'NI2B' or wa_gstr2-status eq 'R_PR'
*     or wa_gstr2-status eq 'SG-TVM-TRM' or wa_gstr2-status eq 'SG-TVM' or wa_gstr2-status eq 'SG-IN-IDM'
*     or wa_gstr2-status eq 'SG-INM' or wa_gstr2-status eq 'OID' or wa_gstr2-status eq 'OIN' OR wa_gstr2-status eq 'SGM'
*     or wa_gstr2-status eq 'SG-TRM' or wa_gstr2-status eq 'SG-POM' or wa_gstr2-status eq 'SG-IDM' or wa_gstr2-status eq 'SG-INV-FUZ'
*     or wa_gstr2-status eq 'IGST' or wa_gstr2-status eq 'CGST' or wa_gstr2-status eq 'SGST' or wa_gstr2-status eq 'CESS'
*     or wa_gstr2-status eq 'RCM'  ) AND wa_gstr2-reten_post is INITIAL and wa_innerjoin-c-gst_reten_st_dt <= wa_innerjoin-b-PostingDate.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-id = ls_msg_id.
*    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_hdr-message_header = ls_msg_hdr.
*    clear : ls_msg_hdr, ls_msg_id.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_msg_hdr-id = ls_msg_id.
*    ls_jecr-message_header = ls_msg_hdr.
*
*     ls_je-original_reference_document_ty = 'BKPFF'.
*    ls_je-document_reference_id = wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
*    ls_je-business_transaction_type = 'RFBU'.
*    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
*    ls_je-document_header_text = 'Retention Posting'.
*    ls_je-created_by_user = sy-uname.
*    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
*    ls_je-document_date = sy-datum.
*    ls_je-posting_date = sy-datum.
*
*    ls_je_gl-content = '0020602080'.
*    ls_jeitem-glaccount = ls_je_gl.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
**    lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
**    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
*    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
**    ls_je_trc-content = ls_je_trc-content * -1.
*    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
*    ls_jeitem-debit_credit_code = 'H'.
*    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
*    ls_jeitem-document_item_text = 'Retention Posting'.
*    ls_jeitem-assignment_reference = '123'.
*    clear : ls_je_trc.
*
*    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
*    ls_jeitem-account_assignment = ls_acc.
*   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
*    ls_jeitem-profitability_supplement = ls_customer.
*    APPEND ls_jeitem TO ls_je-item.
*
*
*wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
*ls_cred-creditor = wa_innerjoin-d-Supplier.
*ls_cred-debit_credit_code = 'S'.
*ls_cred-document_item_text = 'Retention Posting'.
*ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
**lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
**    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
*    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
*    ls_cred-amount_in_transaction_currency = ls_je_trc.
*    APPEND ls_cred TO ls_je-creditor_item.
*
*
*     ls_jecr-journal_entry = ls_je.
*    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
*
*    TRY.
*        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
*          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
*         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
*          ).
*
*         DATA(proxy) = NEW zjeco_journal_entry_create_req( destination = destination ).
*
*         DATA(request) = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
*
*        proxy->journal_entry_create_request_c(
*          EXPORTING
*            input = request
*          IMPORTING
*            output = DATA(response)
*        ).
*
*          " handle response
*      CATCH cx_soap_destination_error.
*        " handle error
*      CATCH cx_ai_system_fault.
*        " handle error
*
*         endtry.
*
*    ls_jeconf = response-journal_entry_bulk_create_conf.
*              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
*              READ TABLE ls_jecconf Into ls_jett INDEX 1.
*              if sy-subrc = 0.
*              ls_jest = ls_jett-journal_entry_create_confirmat.
*              endif.
*
*  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
*              wa_gstr2-reten_post_doc = ls_jest-accounting_document.
*              wa_gstr2-reten_post = 'X'.
*              wa_gstr2-ret_flag = 'X'.
*             MODIFY zgstr2_reco_st FROM @wa_gstr2.
*
*  ENDIF.
*
*  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.
*
*  ELSEIF  ( wa_gstr2-status eq 'M' or wa_gstr2-status eq 'A' or wa_gstr2-status eq 'A_PR' or wa_gstr2-status eq 'INA-AM'
*     or wa_gstr2-status eq 'INA' ) AND wa_gstr2-reten_post is NOT INITIAL AND wa_gstr2-rev_ret_flag is INITIAL.
*
*     ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-id = ls_msg_id.
*    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_hdr-message_header = ls_msg_hdr.
*    clear : ls_msg_hdr, ls_msg_id.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_msg_hdr-id = ls_msg_id.
*    ls_jecr-message_header = ls_msg_hdr.
*
*     ls_je-original_reference_document_ty = 'BKPFF'.
*    ls_je-document_reference_id = wa_gstr2-reten_post_doc."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
*    ls_je-business_transaction_type = 'RFBU'.
*    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
*    ls_je-document_header_text = 'Retention Posting'.
*    ls_je-created_by_user = sy-uname.
*    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
*    ls_je-document_date = sy-datum.
*    ls_je-posting_date = sy-datum.
*
*    ls_je_gl-content = '0020602080'.
*    ls_jeitem-glaccount = ls_je_gl.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
**    lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
**    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
*    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
**    ls_je_trc-content = ls_je_trc-content * -1.
*    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
*    ls_jeitem-debit_credit_code = 'H'.
*    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
*    ls_jeitem-document_item_text = 'Retention Posting'.
*    ls_jeitem-assignment_reference = '123'.
*    clear : ls_je_trc.
*
*    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
*    ls_jeitem-account_assignment = ls_acc.
*   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
*    ls_jeitem-profitability_supplement = ls_customer.
*    APPEND ls_jeitem TO ls_je-item.
*
*
*wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
*ls_cred-creditor = wa_innerjoin-d-Supplier.
*ls_cred-debit_credit_code = 'S'.
*ls_cred-document_item_text = 'Retention Posting'.
*ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
**lv_tot_tax = ls_reco-pr_total_cgst + ls_reco-pr_total_igst + ls_reco-pr_total_sgst
**    + ls_reco-total_cgst + ls_reco-total_sgst + ls_reco-total_igst.
*    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
*    ls_cred-amount_in_transaction_currency = ls_je_trc.
*    APPEND ls_cred TO ls_je-creditor_item.
*
*
*     ls_jecr-journal_entry = ls_je.
*    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
*
*    TRY.
*        destination = cl_soap_destination_provider=>create_by_comm_arrangement(
*          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
*         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
*          ).
*
*         proxy = NEW zjeco_journal_entry_create_req( destination = destination ).
*
*         request = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
*
*        proxy->journal_entry_create_request_c(
*          EXPORTING
*            input = request
*          IMPORTING
*            output = response
*        ).
*
*          " handle response
*      CATCH cx_soap_destination_error.
*        " handle error
*      CATCH cx_ai_system_fault.
*        " handle error
*
*         endtry.
*
*    ls_jeconf = response-journal_entry_bulk_create_conf.
*              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
*              READ TABLE ls_jecconf Into ls_jett INDEX 1.
*              if sy-subrc = 0.
*              ls_jest = ls_jett-journal_entry_create_confirmat.
*              endif.
*
*  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
*              wa_gstr2-reten_post_doc = ls_jest-accounting_document.
*              wa_gstr2-reten_post = 'X'.
*              wa_gstr2-ret_flag = 'X'.
*             MODIFY zgstr2_reco_st FROM @wa_gstr2.
*
*  ENDIF.
*
*  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.
*
*  ENDIF.
*
*  ENDLOOP.

SELECT * FROM zgstr2_reco_st WHERE accountingdocument NE '' and pr_rchrg <> 'Y' "and "pr_ttxval <> ''
INTO TABLE @DATA(lt_gstr2).

    SORT lt_gstr2 by accountingdocument ASCENDING.
*    DELETE lt_gstr2 WHERE accountingdocument = ''. "or ttxval = ''.
*    DELETE lt_gstr2 WHERE pr_ttxval = ''.
*    DELETE lt_gstr2 WHERE pr_ttxval = '0.0'.

*SELECT * from @lt_gstr2 as reco INNER JOIN zi_gstr1_send_mi as repo
*ON reco~accountingdocument = repo~AccountingDocument
*INTO TABLE @DATA(test).

    SELECT * FROM @lt_gstr2 AS a INNER JOIN i_operationalacctgdocitem AS b ON a~accountingdocument = b~accountingdocument
    LEFT OUTER JOIN zdb_org_gstin AS c ON b~postingdate >= c~gst_reten_st_dt
    INNER JOIN zi_gstr1_send_mi AS d ON b~accountingdocument = d~accountingdocument
    WHERE b~profitcenter <> ''
    AND d~supplier <> ''
    INTO TABLE @DATA(it_innerjoin).


    LOOP AT lt_gstr2 INTO DATA(wa_gstr2).

READ TABLE it_innerjoin INTO DATA(wa_innerjoin) WITH KEY a-accountingdocument = wa_gstr2-accountingdocument.
if sy-subrc <> 0.
clear : wa_gstr2.
CONTINUE.
ENDIF.

if ( wa_gstr2-status eq 'TVD' or wa_gstr2-status eq 'IPM' or wa_gstr2-status eq 'TRD' or wa_gstr2-status eq 'OINM'
     or wa_gstr2-status eq 'OIDM' or wa_gstr2-status eq 'INT' or wa_gstr2-status eq 'PM' or wa_gstr2-status eq 'O'
     or wa_gstr2-status eq 'R' or wa_gstr2-status eq 'NI2A' or wa_gstr2-status eq 'NI2B' or wa_gstr2-status eq 'R_PR'
     or wa_gstr2-status eq 'SG-TVM-TRM' or wa_gstr2-status eq 'SG-TVM' or wa_gstr2-status eq 'SG-IN-IDM'
     or wa_gstr2-status eq 'SG-INM' or wa_gstr2-status eq 'OID' or wa_gstr2-status eq 'OIN' OR wa_gstr2-status eq 'SGM'
     or wa_gstr2-status eq 'SG-TRM' or wa_gstr2-status eq 'SG-POM' or wa_gstr2-status eq 'SG-IDM' or wa_gstr2-status eq 'SG-INV-FUZ'
     or wa_gstr2-status eq 'IGST' or wa_gstr2-status eq 'CGST' or wa_gstr2-status eq 'SGST' or wa_gstr2-status eq 'CESS'
     or wa_gstr2-status eq 'RCM'  ) AND wa_gstr2-reten_post is INITIAL and wa_innerjoin-c-gst_reten_st_dt <= wa_innerjoin-b-PostingDate.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-id = ls_msg_id.
    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_hdr-message_header = ls_msg_hdr.
    clear : ls_msg_hdr, ls_msg_id.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_msg_hdr-id = ls_msg_id.
    ls_jecr-message_header = ls_msg_hdr.

     ls_je-original_reference_document_ty = 'BKPFF'.
    ls_je-document_reference_id = wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
    ls_je-business_transaction_type = 'RFBU'.
    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
    ls_je-document_header_text = 'Retention Posting'.
    ls_je-created_by_user = sy-uname.
    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
    ls_je-document_date = sy-datum.
    ls_je-posting_date = sy-datum.

    ls_je_gl-content = '0020602080'.
    ls_jeitem-glaccount = ls_je_gl.
*    if wa_innerjoin-b-TransactionCurrency is initial.
*    CONTINUE.
*    clear : wa_innerjoin.
*    endif.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
    ls_je_trc-content = wa_gstr2-pr_total_cgst + wa_gstr2-pr_total_sgst + wa_gstr2-pr_total_igst. "wa_gstr2-pr_ttxval * -1.
    ls_je_trc-content = ls_je_trc-content * -1.
    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
    ls_jeitem-debit_credit_code = 'H'.
    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
    ls_jeitem-document_item_text = 'Retention Posting'.
    ls_jeitem-assignment_reference = '123'.
    clear : ls_je_trc.

    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
    ls_jeitem-account_assignment = ls_acc.
   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
    ls_jeitem-profitability_supplement = ls_customer.
    APPEND ls_jeitem TO ls_je-item.
    clear : ls_jeitem.

*    if wa_innerjoin-d-Supplier is initial.
*    CONTINUE.
*    clear : wa_innerjoin.
*    ENDIF.
    wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
    ls_cred-creditor = wa_innerjoin-d-Supplier.
    ls_cred-debit_credit_code = 'S'.
    ls_cred-document_item_text = 'Retention Posting'.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
    ls_je_trc-content = wa_gstr2-pr_total_cgst + wa_gstr2-pr_total_sgst + wa_gstr2-pr_total_igst. "wa_gstr2-pr_ttxval."'1'."'1500'.
    ls_cred-amount_in_transaction_currency = ls_je_trc.
    APPEND ls_cred TO ls_je-creditor_item.
    clear : ls_cred.


     ls_jecr-journal_entry = ls_je.
    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
    clear : ls_jecr, ls_je.

    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
          ).

TRY.
         DATA(proxy) = NEW zjeco_journal_entry_create_req( destination = destination ).
CATCH cx_static_check.
ENDTRY.

TRY.
         DATA(request) = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
CATCH cx_static_check.
ENDTRY.

TRY.
        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = DATA(response)
        ).
      clear : request.
CATCH cx_static_check.
ENDTRY.

          " handle response
      CATCH cx_soap_destination_error.
        " handle error
      CATCH cx_ai_system_fault.
        " handle error

         endtry.

    ls_jeconf = response-journal_entry_bulk_create_conf.
              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
              READ TABLE ls_jecconf Into ls_jett INDEX 1.
              if sy-subrc = 0.
              ls_jest = ls_jett-journal_entry_create_confirmat.
              endif.

  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
              wa_gstr2-reten_post_doc = ls_jest-accounting_document.
              wa_gstr2-reten_post = 'X'.
              wa_gstr2-ret_flag = 'X'.
             MODIFY zgstr2_reco_st FROM @wa_gstr2.

  ENDIF.

  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.

*  ELSEIF ( wa_gstr2-status eq 'M' or wa_gstr2-status eq 'A' or wa_gstr2-status eq 'A_PR' or wa_gstr2-status eq 'INA-AM'
*  or wa_gstr2-status eq 'INA' ) AND wa_gstr2-reten_post is NOT INITIAL AND wa_gstr2-rev_ret_flag is INITIAL.
*
*      ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-id = ls_msg_id.
*    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_hdr-message_header = ls_msg_hdr.
*    clear : ls_msg_hdr, ls_msg_id.
*
*    ls_msg_id-scheme_id = lv_dummy."'?'.
*    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
*    ls_msg_id-content = lv_text."'JE Post test'.
*    ls_msg_hdr-creation_date_time = lv_date1.
*    ls_msg_hdr-id = ls_msg_id.
*    ls_jecr-message_header = ls_msg_hdr.
*
*     ls_je-original_reference_document_ty = 'BKPFF'.
*    ls_je-document_reference_id = wa_gstr2-reten_post_doc."wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
*    ls_je-business_transaction_type = 'RFBU'.
*    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
*    ls_je-document_header_text = 'Retention Posting'.
*    ls_je-created_by_user = sy-uname.
*    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
*    ls_je-document_date = sy-datum.
*    ls_je-posting_date = sy-datum.
*
*    ls_je_gl-content = '0020602080'.
*    ls_jeitem-glaccount = ls_je_gl.
**    if wa_innerjoin-b-TransactionCurrency is initial.
**    CONTINUE.
**    clear : wa_innerjoin.
**    endif.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
*    ls_je_trc-content = wa_gstr2-pr_ttxval * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
**    ls_je_trc-content = ls_je_trc-content * -1.
*    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
*    ls_jeitem-debit_credit_code = 'H'.
*    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
*    ls_jeitem-document_item_text = 'Retention Posting'.
*    ls_jeitem-assignment_reference = '123'.
*    clear : ls_je_trc.
*
*    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
*    ls_jeitem-account_assignment = ls_acc.
*   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
*    ls_jeitem-profitability_supplement = ls_customer.
*    APPEND ls_jeitem TO ls_je-item.
*    clear : ls_jeitem.
*
**    if wa_innerjoin-d-Supplier is initial.
**    CONTINUE.
**    clear : wa_innerjoin.
**    ENDIF.
*    wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
*    ls_cred-creditor = wa_innerjoin-d-Supplier.
*    ls_cred-debit_credit_code = 'S'.
*    ls_cred-document_item_text = 'Retention Posting'.
*    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
*    ls_je_trc-content = wa_gstr2-pr_ttxval."'1'."'1500'.
*    ls_cred-amount_in_transaction_currency = ls_je_trc.
*    APPEND ls_cred TO ls_je-creditor_item.
*    clear : ls_cred.
*
*
*     ls_jecr-journal_entry = ls_je.
*    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
*    clear : ls_jecr, ls_je.
*
*    TRY.
*        destination = cl_soap_destination_provider=>create_by_comm_arrangement(
*          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
*         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
*          ).
*
*TRY.
*         proxy = NEW zjeco_journal_entry_create_req( destination = destination ).
*CATCH cx_static_check.
*ENDTRY.
*
*TRY.
*         request = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
*CATCH cx_static_check.
*ENDTRY.
*
*TRY.
*        proxy->journal_entry_create_request_c(
*          EXPORTING
*            input = request
*          IMPORTING
*            output = response
*        ).
*      clear : request.
*CATCH cx_static_check.
*ENDTRY.
*
*          " handle response
*      CATCH cx_soap_destination_error.
*        " handle error
*      CATCH cx_ai_system_fault.
*        " handle error
*
*         endtry.
*
*    ls_jeconf = response-journal_entry_bulk_create_conf.
*              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
*              READ TABLE ls_jecconf Into ls_jett INDEX 1.
*              if sy-subrc = 0.
*              ls_jest = ls_jett-journal_entry_create_confirmat.
*              endif.
*
*  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
*              wa_gstr2-reverse_ret = ls_jest-accounting_document.
*              wa_gstr2-rev_ret_flag = 'X'.
**              wa_gstr2-ret_flag = 'X'.
*             MODIFY zgstr2_reco_st FROM @wa_gstr2.
*
*  ENDIF.
*

    ELSEIF ( wa_gstr2-status eq 'M' or wa_gstr2-status eq 'A' or wa_gstr2-status eq 'A_PR' or wa_gstr2-status eq 'INA-AM'
  or wa_gstr2-status eq 'INA' ) AND wa_gstr2-reten_post is NOT INITIAL AND wa_gstr2-rev_ret_flag is INITIAL.

      ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-id = ls_msg_id.
    CONCATENATE sy-datum sy-uzeit '.0000000' INTO lv_date1.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_hdr-message_header = ls_msg_hdr.
    clear : ls_msg_hdr, ls_msg_id.

    ls_msg_id-scheme_id = lv_dummy."'?'.
    ls_msg_id-scheme_agency_id = lv_dummy."'?'.
    ls_msg_id-content = lv_text."'JE Post test'.
    ls_msg_hdr-creation_date_time = lv_date1.
    ls_msg_hdr-id = ls_msg_id.
    ls_jecr-message_header = ls_msg_hdr.

     ls_je-original_reference_document_ty = 'BKPFF'.
    ls_je-document_reference_id = wa_gstr2-reten_post_doc."wa_innerjoin-b-AccountingDocument."wa_OperationalAcctgDocItem-accountingdocument."'1800000055'."ls_amount-RefDocNo.
    ls_je-business_transaction_type = 'RFBU'.
    ls_je-accounting_document_type = 'RT'."wa_OperationalAcctgDocItem-AccountingDocumentType."'DR'.
    ls_je-document_header_text = 'Reverse Retention Posting'.
    ls_je-created_by_user = sy-uname.
    ls_je-company_code = wa_innerjoin-b-CompanyCode."wa_OperationalAcctgDocItem-companycode.
    ls_je-document_date = sy-datum.
    ls_je-posting_date = sy-datum.

    ls_je_gl-content = '0020602080'.
    ls_jeitem-glaccount = ls_je_gl.
*    if wa_innerjoin-b-TransactionCurrency is initial.
*    CONTINUE.
*    clear : wa_innerjoin.
*    endif.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_OperationalAcctgDocItem-TransactionCurrency."'INR'.
    ls_je_trc-content = wa_gstr2-pr_total_cgst + wa_gstr2-pr_total_sgst + wa_gstr2-pr_total_igst. "wa_gstr2-pr_ttxval." * -1."wa_OperationalAcctgDocItem-AmountInTransactionCurrency."'-1'."'1500'.
*    ls_je_trc-content = ls_je_trc-content * -1.
    ls_jeitem-amount_in_transaction_currency = ls_je_trc.
    ls_jeitem-debit_credit_code = 'S'.
    ls_jeitem-business_place = wa_innerjoin-c-business_place."wa_OperationalAcctgDocItem-BusinessPlace."'1001'.
    ls_jeitem-document_item_text = 'Reverse Retention Posting'.
    ls_jeitem-assignment_reference = '123'.
    clear : ls_je_trc.

    ls_acc-profit_center = wa_innerjoin-b-ProfitCenter."wa_operationalacctgdocitem-ProfitCenter."'2001'.
    ls_jeitem-account_assignment = ls_acc.
   " ls_customer-customer = wa_operationalacctgdocitem-Customer."wa_operationalacctgdocitem-Customer."wa_penalamo_upd-customer.
    ls_jeitem-profitability_supplement = ls_customer.
    APPEND ls_jeitem TO ls_je-item.
    clear : ls_jeitem.

*    if wa_innerjoin-d-Supplier is initial.
*    CONTINUE.
*    clear : wa_innerjoin.
*    ENDIF.
    wa_innerjoin-d-Supplier = |{ wa_innerjoin-d-Supplier ALPHA = IN }|.
    ls_cred-creditor = wa_innerjoin-d-Supplier.
    ls_cred-debit_credit_code = 'H'.
    ls_cred-document_item_text = 'Reverse Retention Posting'.
    ls_je_trc-currency_code = wa_innerjoin-b-TransactionCurrency."wa_operationalacctgdocitem-TransactionCurrency."'INR'.
    ls_je_trc-content = wa_gstr2-pr_total_cgst + wa_gstr2-pr_total_sgst + wa_gstr2-pr_total_igst. "wa_gstr2-pr_ttxval * -1."'1'."'1500'.
    ls_je_trc-content = ls_je_trc-content * -1.
    ls_cred-amount_in_transaction_currency = ls_je_trc.
    APPEND ls_cred TO ls_je-creditor_item.
    clear : ls_cred.


     ls_jecr-journal_entry = ls_je.
    APPEND ls_jecr TO ls_hdr-journal_entry_create_request.
    clear : ls_jecr, ls_je.

    TRY.
        destination = cl_soap_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = 'ZCS_JOURNAL_ENTRY_CREATE'
         service_id     = 'ZOB_JOURNAL_ENTRY_CREATE_RE_SPRX'
          ).

TRY.
         proxy = NEW zjeco_journal_entry_create_req( destination = destination ).
CATCH cx_static_check.
ENDTRY.

TRY.
         request = VALUE ZJEJOURNAL_ENTRY_BULK_CREATE_R( journal_entry_bulk_create_requ = ls_hdr ).
CATCH cx_static_check.
ENDTRY.

TRY.
        proxy->journal_entry_create_request_c(
          EXPORTING
            input = request
          IMPORTING
            output = response
        ).
      clear : request.
CATCH cx_static_check.
ENDTRY.

          " handle response
      CATCH cx_soap_destination_error.
        " handle error
      CATCH cx_ai_system_fault.
        " handle error

         endtry.

    ls_jeconf = response-journal_entry_bulk_create_conf.
              ls_jecconf = ls_jeconf-journal_entry_create_confirmat.
              READ TABLE ls_jecconf Into ls_jett INDEX 1.
              if sy-subrc = 0.
              ls_jest = ls_jett-journal_entry_create_confirmat.
              endif.

  if ls_jest-accounting_document ne '0000000000' and ls_jest-fiscal_year ne ''. "and ls_jest-company_code eq wa_innerjoin-b-CompanyCode
              wa_gstr2-reverse_ret = ls_jest-accounting_document.
              wa_gstr2-rev_ret_flag = 'X'.
*              wa_gstr2-ret_flag = 'X'.
             MODIFY zgstr2_reco_st FROM @wa_gstr2.

  ENDIF.

  clear : response, ls_jeconf, ls_jecconf, ls_jest, ls_jett, wa_gstr2, wa_innerjoin, ls_hdr.

  ENDIF.
  ENDLOOP.





  ENDMETHOD.
ENDCLASS.
