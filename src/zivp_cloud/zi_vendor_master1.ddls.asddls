@AbapCatalog.sqlViewName: 'ZI_VENDOR_DET'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View for Vendor Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_VENDOR_MASTER1
  as select distinct from I_Supplier as Supplier
//  association [0..1] to I_RegionText as RegionText on Supplier.Region = RegionText.Region
inner join  I_RegionText as RegionText on Supplier.Region = RegionText.Region
{
  key Supplier.Supplier     as Supplier,
  key Supplier.Region       as Region,
  key RegionText.Country    as Country,
  key RegionText.Language   as Langauage,
      Supplier.SupplierName as SupplierName,
      Supplier.TaxNumber2   as TaxNumber2,
      Supplier.TaxNumber3   as TaxNumber3,
      Supplier.BusinessPartnerPanNumber as Panno,
     // Supplier.
      RegionText.RegionName as RegionName
}
