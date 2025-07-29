@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Vendor Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_VENDOR_MASTER
  as select from I_Supplier as Supplier
  association [0..1] to I_RegionText as RegionText on  Supplier.Region  = RegionText.Region
                                                   and Supplier.Country = RegionText.Country
{
  key Supplier.Supplier                                            as Supplier,
  key Supplier.Region                                              as Region,
  key Supplier._AddressRepresentation._OrganizationAddress.Country as Country,
  key Supplier.SupplierLanguage                                    as Langauage,
      Supplier.SupplierName                                        as SupplierName,
      Supplier.TaxNumber2                                          as TaxNumber2,
      Supplier.TaxNumber3                                          as TaxNumber3,
      Supplier.BusinessPartnerPanNumber                            as Panno,
      RegionText.RegionName                                        as RegionName
}
