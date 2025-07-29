@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transporter Odata for EXIM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Ziexim_transporter
  as select distinct from I_BillingDocumentPartner
  association [0..1] to I_Supplier as supplier on supplier.Supplier = I_BillingDocumentPartner.Supplier
{
  key BillingDocument,
      supplier.SupplierName

}
where
  I_BillingDocumentPartner.PartnerFunction = 'U3'
