@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for FI Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_fipur_register
  as select from ZI_FI_JOURNALENTRYITEM as JournalItem
  association [1]    to ZI_VENDOR_MASTER               as VendorDetails   on  JournalItem.OffsettingAccount = VendorDetails.Supplier
                                                                          and VendorDetails.Langauage       = 'E'
  //                                                                          and VendorDetails.Country         = 'IN'
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
  association [0..1] to I_OperationalAcctgDocItem      as OpAccText       on  JournalItem.AccountingDocument     = OpAccText.AccountingDocument
                                                                          and JournalItem.AccountingDocumentItem = OpAccText.AccountingDocumentItem
                                                                          and JournalItem.GLAccountType          = 'P'
                                                                          and JournalItem.FiscalYear             = OpAccText.FiscalYear
  association [0..1] to I_OperationalAcctgDocItem      as HSN             on  JournalItem.AccountingDocument     = HSN.AccountingDocument
                                                                          and JournalItem.AccountingDocumentItem = HSN.AccountingDocumentItem
                                                                          and JournalItem.FiscalYear             = HSN.FiscalYear
{
  key  JournalItem.ReferenceDocumentMIRO                    as ReferenceDocumentMIRO,
  key  JournalItem.ReferenceDocumentItem                    as ReferenceDocumentItem,
  key  JournalItem.AccountingDocument                       as AccountingDocument,
  key  JournalItem.AccountingDocumentItem                   as AccountingDocumentItem,
  key  JournalItem.FiscalYear                               as FiscalYear,
       JournalItem.DebitCreditCode                          as DebitCreditCode,
       JournalItem.Supplier                                 as Vendor,
       JournalItem.DocumentDate                             as InvoiceDate,
       JournalItem.PostingDate                              as PostingDate,
       SupplierInvoice.SupplierInvoiceIDByInvcgParty        as RefDocNo,
       VendorDetails.SupplierName                           as VendorName,
       VendorDetails.Region                                 as VendorRegion,
       VendorDetails.RegionName                             as RegionName,
       VendorDetails.TaxNumber3                             as GSTIN,
       VendorDetails.TaxNumber2                             as TIN,
       PO_Master.BaseUnit                                   as UOM,
       JournalItem.TransactionCurrency                      as DocumentCurrency,
       JournalItem.GLAccountType                            as GLAccountType,
       OpAccText.DocumentItemText                           as DocumentItemText,
       JournalItem.GLAccount                                as GLAccount,
       GLName.GLAccountLongName                             as GLAccountLongName,
       JournalItem.AccountingDocumentType                   as AccountingDocumentType,
       HSN.IN_HSNOrSACCode                                  as HSN,
       HSN.BusinessPlace                                    as BusinessPlace,
       case
       when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'BB' or JournalItem.TaxCode = 'CC'
         or JournalItem.TaxCode = 'II' or JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
         or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'I0'
         then '0.0%'
       when JournalItem.TaxCode = 'I1' or JournalItem.TaxCode = 'S1' or JournalItem.TaxCode = 'R1'
         or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
         then '2.5%'
       when JournalItem.TaxCode = 'I2' or JournalItem.TaxCode = 'S2' or JournalItem.TaxCode = 'R2'
         or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
         then '6%'
       when JournalItem.TaxCode = 'I3' or JournalItem.TaxCode = 'S3' or JournalItem.TaxCode = 'R3'
         or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
         then '9%'
       when JournalItem.TaxCode = 'I4' or JournalItem.TaxCode = 'S4' or JournalItem.TaxCode = 'R4'
         or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
         then '14%'
       when JournalItem.TaxCode = 'I5' or JournalItem.TaxCode = 'S5' or JournalItem.TaxCode = 'R5'
         or JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
         then '5%'
       when JournalItem.TaxCode = 'I6' or JournalItem.TaxCode = 'S6' or JournalItem.TaxCode = 'R6'
         or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
         then '12%'
       when JournalItem.TaxCode = 'I7' or JournalItem.TaxCode = 'S7' or JournalItem.TaxCode = 'R7'
         or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
         then '18%'
       when JournalItem.TaxCode = 'I8' or JournalItem.TaxCode = 'S8' or JournalItem.TaxCode = 'R8'
         or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
         then '28%'        end                              as TaxRate,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       case
       when JournalItem.TaxCode between 'S1' and 'S8'
       then HSN.OriglTaxBaseAmountInCoCodeCrcy
       else
       JournalItem.BaseAmount                   end         as BaseAmount,
       JournalItem.TaxCode                                  as TaxCode,
       fltp_to_dec (  JournalItem.SGST as abap.dec(16,4))   as SGST,
       fltp_to_dec (  JournalItem.CGST as abap.dec(16,4))   as CGST,
       fltp_to_dec (  JournalItem.IGST as abap.dec(16,4))   as IGST,
       fltp_to_dec (  JournalItem.RSGST as abap.dec(16,4))  as RSGST,
       fltp_to_dec (  JournalItem.RCGST as abap.dec(16,4))  as RCGST,
       fltp_to_dec (  JournalItem.RIGST as abap.dec(16,4))  as RIGST,
       fltp_to_dec (  JournalItem.RSGSTO as abap.dec(16,4)) as RSGSTO,
       fltp_to_dec (  JournalItem.RCGSTO as abap.dec(16,4)) as RCGSTO,
       fltp_to_dec (  JournalItem.RIGSTO as abap.dec(16,4)) as RIGSTO
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
