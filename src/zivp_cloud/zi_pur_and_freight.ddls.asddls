@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Check Pur Order (Cancel or Not) and Fetch Freight Details'

define view entity ZI_PUR_AND_FREIGHT as select from I_FrtCostAllocItm as Frtcost
association [0..1] to I_PurchaseOrderItemAPI01 as PO_check
on PO_check.PurchaseOrder = Frtcost.SettlmtItemReltdPurgDoc
{
  
  key Frtcost.SettlmtSourceDoc ,
        PO_check.PurchaseOrder   ,
       //  @Semantics.amount.currencyCode:'FrtCostAllocDocCurrency'
        Frtcost.SettlmtSourceDocItem,
        Frtcost.FrtCostAllocDocCurrency,
       // @Semantics.amount.currencyCode: 'FrtCostAllocItemNetAmount'
        Frtcost.FrtCostAllocItemNetAmount 
        
    
}

 where PO_check.PurchasingDocumentDeletionCode <> 'L'
