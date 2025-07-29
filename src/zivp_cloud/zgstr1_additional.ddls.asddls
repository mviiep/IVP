@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GSTR1 additional fields'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR1_ADDITIONAL as select from I_BillingDocumentItemCube( P_ExchangeRateType: 'M', P_DisplayCurrency: 'INR' )
{
    key BillingDocument,
    key BillingDocumentItem,
    AccountingExchangeRate,
    ShipToParty,
    ShipToPartyName,
    BillToParty,
    BillToPartyName,
    Product,
    BillingDocumentCategory,
   
    BillToPartyCountry,
    
    BillToPartyRegion,
    BillingDocumentType
}
