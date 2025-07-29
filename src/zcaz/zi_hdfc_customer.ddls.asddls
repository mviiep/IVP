@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Customer HDFC Bank Integration'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_hdfc_customer
  as select from zi_hdfc_customer2 as hdfccust
  association to zi_hdfc_customer1 as _customer on hdfccust.customer = _customer.customer
{
  key alertsequenceno,
      virtualaccount,
      _customer.customer,
      _customer.CustomerName
}
