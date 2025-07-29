@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zexim_portofloading'
define view entity Zexim_portofloading
  as select distinct from I_BillingDocumentPartner as a
  association [0..1] to I_Customer as customer on customer.Customer = a.Customer

{
  key BillingDocument,
      customer.Customer,
      cast(a.PartnerFunction as abap.char( 4 ) ) as PartnerFunction,
      customer.CustomerName
}
where
  a.PartnerFunction = 'ZL'
