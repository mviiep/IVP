@AbapCatalog.sqlViewName: 'Z_DISCNT'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Discount Logic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view Z_Discount
  as select from ZI_JOURNALENTRYITEM2 as JournalItem
  association [0..1] to ZI_PO_MASTER1                   as PO_Master     on  JournalItem.ReferenceDocumentMIRO = PO_Master.SupplierInvoice
                                                                        and JournalItem.ReferenceDocumentItem = PO_Master.SupplierInvoiceItem
                                                                        and JournalItem.FiscalYear            = PO_Master.FiscalYear
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing on  JournalItem.PurchasingDocument     = POItemPricing.PurchaseOrder
                                                                        and JournalItem.PurchasingDocumentItem = POItemPricing.PurchaseOrderItem
                                                                        and (
                                                                           POItemPricing.ConditionType         = 'PMP0'
                                                                          and POItemPricing.ConditionType      = 'PPR0'
                                                                         )
{
  key JournalItem.ReferenceDocumentMIRO                                       as ReferenceDocumentMIRO,
  key JournalItem.ReferenceDocumentItem                                       as ReferenceDocumentItem,
  key JournalItem.FiscalYear                                                  as FiscalYear,
      PO_Master.NetPriceAmount                                                as Rate,
      POItemPricing.ConditionRateValue                                        as ConditionRateValue
    //  division(PO_Master.NetPriceAmount, POItemPricing.ConditionRateValue, 2) as divis
}
