@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Billing Doc  partnr with SP and payer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BILLINGDOCUMENTPARTNER
  as select from I_BillingDocumentPartner as A
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
