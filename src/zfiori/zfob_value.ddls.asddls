@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Export Shippint Detail'
@Metadata.allowExtensions: true

define root view entity  zfob_value as select from I_BillingDocItemPrcgElmntBasic as a

association [0..1] to I_BillingDocItemPrcgElmntBasic  as fob on  a.BillingDocument = fob.BillingDocument
                                                         and fob.ConditionType = 'ZFOB'

 association [0..1] to I_BillingDocItemPrcgElmntBasic  as dbk on  a.BillingDocument = dbk.BillingDocument
                                                         and dbk.ConditionType = 'ZDBK'                                               

association [0..1] to I_BillingDocItemPrcgElmntBasic  as rod on  a.BillingDocument = rod.BillingDocument
                                                         and rod.ConditionType = 'ZRTP'     


{
    key a.BillingDocument as id, 
    fob.TransactionCurrency as TransactionCurrency, 
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(fob.ConditionAmount) as fobamount,
   
      @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(dbk.ConditionAmount) as dbkcondamount,
    
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(rod.ConditionAmount) as rodcondamount
        
}

group by  a.BillingDocument , fob.ConditionAmount , fob.TransactionCurrency,dbk.ConditionAmount , rod.ConditionAmount
