@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'GST ITC Reconcialation Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZGST_ITC_RECO 
  as projection on ZI_GST_ITC_RECO
{
      @EndUserText.label: 'GST2A Doc. Number'
  key Inum,
      @EndUserText.label: 'GST2A Doc. Date'
  key Idt,
      @EndUserText.label: 'PR Doc. Number'
  key PrInum,
      @EndUserText.label: 'PR Doc. Date'
  key PrIdt,
      @EndUserText.label: 'Supplier GSTIN'
  key SupplierGstin,
      @EndUserText.label: 'Accounting Document'
  key Accountingdocument,
      @EndUserText.label: 'Auto Reconciliation ID'
      Autorecoid,
      @EndUserText.label: 'Value'
      Val,
      @EndUserText.label: '2A Note Number'
      NtNum,
      @EndUserText.label: '2A Note date'
      NtDt,
      @EndUserText.label: 'Inv Type'
      InvTyp,
      @EndUserText.label: 'POS'
      Pos,
      @EndUserText.label: 'R Chrg'
      Rchrg,
      @EndUserText.label: 'Month'
      Imonth,
      @EndUserText.label: 'Supplier Name'
      SupplierName,
      @EndUserText.label: 'Supplier GSTIN Status'
      SupplierGstinStatus,
      @EndUserText.label: 'Supplier Return Type'
      SupplierReturnType,
      @EndUserText.label: 'Contact Name'
      ContactName,
      @EndUserText.label: 'Buyer GSTIN'
      BuyerGstin,
      @EndUserText.label: 'CFS'
      Cfs,
      @EndUserText.label: 'Invoice Type'
      InvoiceType,
      @EndUserText.label: 'GSTR1 Filling Date'
      Gstr1FillingDate,
      @EndUserText.label: 'Tot. Tax Value'
      Ttxval,
      @EndUserText.label: 'Net Amount'
      NetAmount,
      @EndUserText.label: 'ITC Elg'
      ItcAlg,
      @EndUserText.label: 'Transaction Number'
      TransactionNumber,
      @EndUserText.label: 'Referred Invoice Number'
      Referencedocumentmiro,
      @EndUserText.label: 'Referred Invoice Date'
      ReferredInvoiceDate,
      @EndUserText.label: 'Acc. Doc. Date'
      ErpDocumentDate,
      @EndUserText.label: 'Total IGST'
      TotalIgst,
      @EndUserText.label: 'Total CGST'
      TotalCgst,
      @EndUserText.label: 'Total SGST'
      TotalSgst,
      @EndUserText.label: 'Total CESS'
      TotalCess,
      @EndUserText.label: 'Fiscal Year'
      Fiscalyear,
      @EndUserText.label: 'Match Status'
      Status,
      @EndUserText.label: 'Reco Action'
      RecoAction,
      @EndUserText.label: 'Action Date'
      ActionDate,
      @EndUserText.label: 'Retention Posting'
      RetenPost,
      @EndUserText.label: 'Retention Post Doc.'
      RetenPostDoc,
      @EndUserText.label: 'Reverse Return'
      ReverseRet,
      @EndUserText.label: 'Reverse Return Flag'
      ReverseRetFlag,
      @EndUserText.label: 'GSTR3b Filling Status'
      Gstr3bFillingStatus,
      @EndUserText.label: 'Mismatch Reason'
      Reason,
      @EndUserText.label: 'PR Supplier Name'
      PrSupplierName,
      @EndUserText.label: 'PR Buyer GSTIN'
      PrBuyerGstin,
      @EndUserText.label: 'PR Gl Code'
      PrGlCode,
      @EndUserText.label: 'PR Supplier GSTIN'
      PrSupplierGstin,
      @EndUserText.label: 'PR Invoice Type'
      PrInvoiceType,
      @EndUserText.label: 'PR Net Amount'
      PrNetAmount,
      @EndUserText.label: 'PR Value'
      PrVal,
      @EndUserText.label: 'PR Note Number'
      PrNtNum,
      @EndUserText.label: 'PR Note Date'
      PrNtDt,
      @EndUserText.label: 'PR Ntty'
      PrNtty,
      @EndUserText.label: 'PR Location'
      PrLocation,
      @EndUserText.label: 'PR Total IGST'
      PrTotalIgst,
      @EndUserText.label: 'PR Total CGST'
      PrTotalCgst,
      @EndUserText.label: 'PR Total SGST'
      PrTotalSgst,
      @EndUserText.label: 'PR Total CESS'
      PrTotalCess,
      @EndUserText.label: 'Org. PR Doc. Number'
      PrOrgInum,
      @EndUserText.label: 'Org. PR Doc. Date'
      PrOrgIdt,
      @EndUserText.label: 'Org. ITC Elg'
      PrItcAlg,
      @EndUserText.label: 'GSTR2 Return Period'
      PrGstr2ReturnPeriod,
      @EndUserText.label: 'PR ERP Doc. No'
      PrErpDocumentNumber,
      @EndUserText.label: 'PR ERP Doc. Date'
      PrErpDocumentDate,
      @EndUserText.label: 'PR Fiscal year'
      PrFiscalyear,
      @EndUserText.label: 'PR Month'
      PrImonth,
      @EndUserText.label: 'PR POS'
      PrPos,
      @EndUserText.label: 'PR R Chrg'
      PrRchrg,
      @EndUserText.label: 'PR Tot. Tax Value'
      PrTtxval
}
