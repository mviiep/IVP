@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Discount for FI Pur Reg Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DISCOUNT
  as select from ZI_FI_JOURNALENTRYITEM as JournalItem
  association [0..1] to ZI_FIPO_MASTER                 as PO_Master     on  JournalItem.ReferenceDocumentMIRO = PO_Master.SupplierInvoice
                                                                        and JournalItem.ReferenceDocumentItem = PO_Master.SupplierInvoiceItem
                                                                        and JournalItem.FiscalYear            = PO_Master.FiscalYear
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing on  JournalItem.PurchasingDocument     = POItemPricing.PurchaseOrder
                                                                        and JournalItem.PurchasingDocumentItem = POItemPricing.PurchaseOrderItem
                                                                        and (
                                                                           POItemPricing.ConditionType         = 'PMP0'
                                                                           or POItemPricing.ConditionType      = 'PPR0'
                                                                         )
{
  key JournalItem.ReferenceDocumentMIRO                                                                    as ReferenceDocumentMIRO,
  key JournalItem.ReferenceDocumentItem                                                                    as ReferenceDocumentItem,
  key JournalItem.FiscalYear                                                                               as FiscalYear,
      PO_Master.DocumentCurrency                                                                           as DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      PO_Master.NetPriceAmount                                                                             as Rate,
      POItemPricing.ConditionRateValue                                                                     as ConditionRateValue,
      //      ,
      division( cast(PO_Master.NetPriceAmount as abap.dec( 10, 2 )) , POItemPricing.ConditionRateValue, 2) as divis
}
