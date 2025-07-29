//@AbapCatalog.sqlViewName: 'ZC_GSTR2_DET'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Purchase Register'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@Metadata.allowExtensions: true

define root view entity ZC_GSTR2_DETAILS 
  as projection on ZI_SEND_GSTR1_MI as Purchase_Register
{

          @EndUserText.label: 'MIRO No'
  key     Purchase_Register.ReferenceDocumentMIRO,

          @EndUserText.label: ' Ref Doc Item'
  key     Purchase_Register.ReferenceDocumentItem,

          @EndUserText.label: 'DocumentReferenceID'
  key     Purchase_Register.DocumentReferenceID,

          @EndUserText.label: 'Response'
          Purchase_Register.Status,

          @EndUserText.label: 'Reconciliation Action'
          Purchase_Register.reco_action,

          @EndUserText.label: 'Reverse Response'
          Purchase_Register.reason,

          @EndUserText.label: 'POSTING DATE'
          Purchase_Register.PostingDate,

          @EndUserText.label: 'Buyer GSTIN'
          Purchase_Register.buyergstin,

          @EndUserText.label: 'REF NO'
          Purchase_Register.RefDocNo,

          @EndUserText.label: 'Invoice Date'
          Purchase_Register.InvoiceDate,

          @EndUserText.label: 'VENDOR'
          Purchase_Register.Vendor,

          @EndUserText.label: 'VENDOR NAME'
          Purchase_Register.VendorName,

          @EndUserText.label: 'VENDOR REGION'
          Purchase_Register.VendorRegion,

          @EndUserText.label: 'VENDOR STATE'
          Purchase_Register.RegionName,

          @EndUserText.label: 'GSTIN'
          Purchase_Register.GSTIN,

          @EndUserText.label: 'TIN'
          Purchase_Register.TIN,

          @EndUserText.label: 'DEPARTMENT'
          Purchase_Register.Department,

          //      @EndUserText.label: 'DEPARTMENT Description'
          //      Purchase_Register.DepartmentDescreption,

          @EndUserText.label: 'MATERIAL CODE'
          Purchase_Register.MaterialCode,

          @EndUserText.label: 'MATERIAL DESCRIPTION'
          Purchase_Register.MaterialDescription,

          @EndUserText.label: 'UOM'
          Purchase_Register.UOM,

          @EndUserText.label: 'HSN CODE'
          Purchase_Register.HSNCode,

          @EndUserText.label: 'PO DATE'
          Purchase_Register.PurchaseOrderDate,

          @EndUserText.label: 'PO NO'
          @Search.defaultSearchElement: true
          Purchase_Register.PurchasingDocument,

          @Semantics.quantity.unitOfMeasure: 'UOM'
          @EndUserText.label: 'PO QTY'
          Purchase_Register.POrderQuantity,

          @Semantics.quantity.unitOfMeasure: 'UOM'
          @EndUserText.label: 'BILL QTY'

          Purchase_Register.QuantityInPurchaseOrderUnit,



          @EndUserText.label: 'Document Currency'
          Purchase_Register.companycodecurrecy,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'RATE'
          Purchase_Register.Rate,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'BASE AMOUNT'
          Purchase_Register.BaseAmount,

          @EndUserText.label: 'TAX CODE'
          Purchase_Register.TAXCODE,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'SGST AMOUNT'
          Purchase_Register.SGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'CGST AMOUNT'
          Purchase_Register.CGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'IGST AMOUNT'
          Purchase_Register.IGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'RCM CGST INPUT AMT'
          Purchase_Register.RCGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'RCM SGST INPUT AMT'
          Purchase_Register.RSGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'RCM IGST INPUT AMT'
          Purchase_Register.RIGST,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'Net Invoice Amount'
          Purchase_Register.NetInvoiceAmount,

          @EndUserText.label: 'Journal Entry No'
          Purchase_Register.AccountingDocument,

          @EndUserText.label: 'Total Tax Amount'
          Purchase_Register.TotaltaxAmount,

          @EndUserText.label: 'MIGO Doc No'
          Purchase_Register.ReferenceDocumentMIGO,

          @EndUserText.label: '.Trans_Key'
          Purchase_Register.Trans_Key,

          @EndUserText.label: 'igst_gl'
          Purchase_Register.igst_gl,

          @EndUserText.label: 'cgst_gl'
          Purchase_Register.cgst_gl,

          @EndUserText.label: 'sgst_gl'
          Purchase_Register.sgst_gl,

          @EndUserText.label: 'BusinessArea'
          Purchase_Register.BusinessArea,

          @EndUserText.label: 'Doctype'
          Purchase_Register.Doctype,

          @EndUserText.label: 'Plant'
          Purchase_Register.Plant,

          @EndUserText.label: 'Plant'
          Purchase_Register.GL_Code,

          @EndUserText.label: 'panno'
          PANNO,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'Tot_Inv'
          Tot_Inv,

          @EndUserText.label: 'CGST_per'
          CGST_per,

          @EndUserText.label: 'SGST_per'
          SGST_per,

          @EndUserText.label: 'SGST_per'
          IGST_per,

          @EndUserText.label: 'RCGST_per'
          RCGST_per,

          @EndUserText.label: 'RSGST_per'
          RSGST_per,

          @EndUserText.label: 'RIGST_per'
          RIGST_per,



          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'amount in computer currency'
          amnt_com_curr,

          @EndUserText.label: 'Business_Place'
          Purchase_Register.business_place,

          @EndUserText.label: 'Narration'
          Narration,

          @EndUserText.label: 'TDS TAX Code'
          tds_tax_code,

          @Semantics.amount.currencyCode: 'companycodecurrecy'
          @EndUserText.label: 'less_TDS'
          less_TDS,

          @EndUserText.label: 'Profit Cenetr'
          ProftCenter,
          @EndUserText.label: 'Reverse Ref'
          Reverse,

          @EndUserText.label: 'revrseretensionpostingdocno'
          revrseretensionpostingdocno,

          @EndUserText.label: 'Retension Posting Document'
          retensionpostingdocno


}
