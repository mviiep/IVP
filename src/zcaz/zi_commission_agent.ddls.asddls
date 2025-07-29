@AbapCatalog.sqlViewName: 'ZZI_CMSN_AGNT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for commision agent'
define view ZI_Commission_Agent
  as select from I_BillingDocItemPartner as A
  association [0..1] to I_Customer as _b on A.Customer = _b.Customer
  association [0..1] to I_Supplier as _c on A.Supplier = _c.Supplier
{
  key A.BillingDocument                  as BillingDocument,
  key A.PartnerFunction                  as PartnerFunction,
      A.Customer                         as Customer,
      _b.CustomerName                    as CustomerName,
      _b._AddressRepresentation.CityName as CustomerCIty,
      A.Supplier                         as Supplier,
      _c.SupplierName                    as SupplierName
}
