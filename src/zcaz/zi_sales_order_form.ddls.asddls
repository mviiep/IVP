@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales Order Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Sales_order_form
  as select from I_SalesDocument as a
  association [0..1] to I_Customer as customer on customer.Customer = a.SoldToParty
{
  key a.SalesDocument     as SalesDocument,
      a.SalesDocumentType as SalesDocumentType,
      a.SoldToParty,
      customer.CustomerName
}
