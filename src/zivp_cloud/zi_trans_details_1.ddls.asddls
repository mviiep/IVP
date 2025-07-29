@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transporter Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRANS_DETAILS_1 as select from I_BillingDocumentPartnerBasic as Partner
association [0..1] to I_Supplier as Supplier
 on Supplier.Supplier = Partner.Supplier 
{
    key Partner.BillingDocument,
    key Partner.Supplier,
        Partner.PartnerFunction,
        Supplier.SupplierName
}
