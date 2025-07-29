@AbapCatalog.sqlViewName: 'ZZI_FISALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for FI sales Report'
define view ZI_FI_SALES_REPORT
  as select distinct from ZI_FI_JOURNAL_ENRTY as JournalItem
  association [0..1] to ZI_VENDOR_MASTER               as VendorDetails   on  JournalItem.OffsettingAccount = VendorDetails.Supplier
                                                                          and VendorDetails.Langauage       = 'E'
                                                                          and VendorDetails.Country         = 'IN'
  association [0..1] to ZI_FIPO_MASTER                 as PO_Master       on  JournalItem.ReferenceDocumentMIRO = PO_Master.SupplierInvoice
                                                                          and JournalItem.ReferenceDocumentItem = PO_Master.SupplierInvoiceItem
                                                                          and JournalItem.FiscalYear            = PO_Master.FiscalYear
  association [0..1] to I_SupplierInvoiceAPI01         as SupplierInvoice on  SupplierInvoice.SupplierInvoice = JournalItem.ReferenceDocumentMIRO
                                                                          and SupplierInvoice.FiscalYear      = JournalItem.FiscalYear
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing   on  JournalItem.PurchasingDocument     = POItemPricing.PurchaseOrder
                                                                          and JournalItem.PurchasingDocumentItem = POItemPricing.PurchaseOrderItem
                                                                          and (
                                                                             POItemPricing.ConditionType         = 'PMP0'
                                                                             or POItemPricing.ConditionType      = 'PPR0'
                                                                           )
  association [0..1] to ZI_FI_DISCOUNT                 as Discount        on  JournalItem.ReferenceDocumentMIRO = Discount.ReferenceDocumentMIRO
                                                                          and JournalItem.ReferenceDocumentItem = Discount.ReferenceDocumentItem
                                                                          and JournalItem.FiscalYear            = Discount.FiscalYear
  association [0..1] to I_GLAccountText                as GLName          on  JournalItem.GLAccount = GLName.GLAccount
                                                                          and GLName.Language       = 'E'

  association [0..1] to I_GLAccountText                as forblankval     on  JournalItem.GLAccount = forblankval.GLAccount
                                                                          and forblankval.Language       = 'Z'

  association [0..1] to I_OperationalAcctgDocItem      as OpAccText       on  JournalItem.AccountingDocument     = OpAccText.AccountingDocument
                                                                          and JournalItem.AccountingDocumentItem = OpAccText.AccountingDocumentItem
                                                                          and JournalItem.GLAccountType          = 'P'
                                                                          and JournalItem.FiscalYear             = OpAccText.FiscalYear

  association [0..1] to I_Customer                     as customer        on  JournalItem.Customer = customer.Customer
  association [0..1] to ZI_REGION                      as REGION          on  JournalItem.Customer = REGION.Customer
                                                                          and REGION.Language      = 'E'
                                                                          and REGION.Country       = 'IN'
  association [0..1] to I_OperationalAcctgDocItem      as HSN             on  JournalItem.AccountingDocument     = HSN.AccountingDocument
                                                                          and JournalItem.AccountingDocumentItem = HSN.AccountingDocumentItem
                                                                          and JournalItem.FiscalYear             = HSN.FiscalYear
{
  key JournalItem.ReferenceDocumentMIRO                   as ReferenceDocumentMIRO,
  key JournalItem.ReferenceDocumentItem                   as ReferenceDocumentItem,
  key JournalItem.AccountingDocument                      as AccountingDocument,
  key JournalItem.AccountingDocumentItem                  as AccountingDocumentItem,
  key JournalItem.GLAccount                               as GLAccount,
      JournalItem.FiscalYear                              as FiscalYear,
      JournalItem.DebitCreditCode                         as DebitCreditCode,
      JournalItem.Supplier                                as vendor1,
      JournalItem.Customer                                as Vendor, //Added by sanjay 15.01.024
      JournalItem.DocumentDate                            as InvoiceDate,
      JournalItem.PostingDate                             as PostingDate,
      SupplierInvoice.SupplierInvoiceIDByInvcgParty       as RefDocNo,
      customer.CustomerName                               as VendorName,
      //      VendorDetails.SupplierName                          as VendorName,
      customer.Region                                     as VendorRegion,
      //      VendorDetails.Region                                as VendorRegion,
      REGION.RegionName                                   as RegionName,
      //      VendorDetails.RegionName                            as RegionName,
      customer.TaxNumber3                                 as GSTIN,
      //      VendorDetails.TaxNumber3                            as GSTIN,
      VendorDetails.TaxNumber2                            as TIN,
      PO_Master.BaseUnit                                  as UOM,
      POItemPricing.TransactionCurrency                   as DocumentCurrency,
      JournalItem.GLAccountType                           as GLAccountType,
      OpAccText.DocumentItemText                          as DocumentItemText,
      GLName.GLAccountLongName                            as GLAccountLongName,
      forblankval.GLAccountName                           as blank,
      JournalItem.AccountingDocumentType                  as AccountingDocumentType,
      HSN.BusinessPlace                                   as BusinessPlace,
      HSN.IN_HSNOrSACCode                                 as HSN,
      case
      when JournalItem.TaxCode = 'D1'
        then '2.5%'
      when JournalItem.TaxCode = 'D2'
        then '6%'
      when JournalItem.TaxCode = 'D3'
        then '9%'
      when JournalItem.TaxCode = 'D4'
        then '14%'
      when JournalItem.TaxCode = 'D5'
        then '5%'
      when JournalItem.TaxCode = 'D6'
        then '12%'
      when JournalItem.TaxCode = 'D7' or JournalItem.TaxCode = 'E2'
        then '18%'
      when JournalItem.TaxCode = 'D8'
        then '28%'
      when JournalItem.TaxCode = 'E1'
        then '0.1%'
      when JournalItem.TaxCode = 'F1'
        then '0.05%' end                                  as TaxRate,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      JournalItem.BaseAmount                              as BaseAmount,
      JournalItem.TaxCode                                 as TaxCode,
      fltp_to_dec (  JournalItem.SGST as abap.dec(16,4))  as SGST,
      fltp_to_dec (  JournalItem.CGST as abap.dec(16,4))  as CGST,
      fltp_to_dec (  JournalItem.IGST as abap.dec(16,4))  as IGST,
      fltp_to_dec (  JournalItem.RSGST as abap.dec(16,4)) as RSGST,
      fltp_to_dec (  JournalItem.RCGST as abap.dec(16,4)) as RCGST,
      fltp_to_dec (  JournalItem.RIGST as abap.dec(16,4)) as RIGST


}
where
      JournalItem.ReferenceDocumentItem <> '000000'
  and JournalItem.GLAccount             <> '0020602010'
  and JournalItem.GLAccount             <> '0020602020'
  and JournalItem.GLAccount             <> '0020602030'
  and JournalItem.GLAccount             <> '0020602040'
  and JournalItem.GLAccount             <> '0020602050'
  and JournalItem.GLAccount             <> '0020602060'
  and JournalItem.GLAccount             <> '0020602011'
  and JournalItem.GLAccount             <> '0020602021'
  and JournalItem.GLAccount             <> '0020602031'
  and JournalItem.GLAccount             <> '0010504010'
  and JournalItem.GLAccount             <> '0010504020'
  and JournalItem.GLAccount             <> '0010504030'
  and JournalItem.GLAccount             <> '0010504011'
  and JournalItem.GLAccount             <> '0010504021'
  and JournalItem.GLAccount             <> '0010504041'
  and JournalItem.GLAccount             <> '0010504042'
