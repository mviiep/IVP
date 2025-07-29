@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Testing'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_TEST
  as select from     I_Customer
    right outer join I_SalesOrder on I_Customer.Customer = I_SalesOrder.SoldToParty
{

  key I_SalesOrder.SalesOrder,
      I_Customer.Customer
}
