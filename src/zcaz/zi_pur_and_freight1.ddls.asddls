@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS of ZI_PUR_AND_FREIGHT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PUR_AND_FREIGHT1
  as select from I_FrtCostAllocItm as Frtcost
  association [0..1] to I_PurchaseOrderItemAPI01 as PO_check on PO_check.PurchaseOrder = Frtcost.SettlmtItemReltdPurgDoc
{
  key Frtcost.SettlmtSourceDoc,
      PO_check.PurchaseOrder,
      //  @Semantics.amount.currencyCode:'FrtCostAllocDocCurrency'
      Frtcost.SettlmtSourceDocItem,
      Frtcost.FrtCostAllocDocCurrency,
      @Semantics.amount.currencyCode: 'FrtCostAllocDocCurrency'
      Frtcost.FrtCostAllocItemNetAmount

}

where
  PO_check.PurchasingDocumentDeletionCode <> 'L'
