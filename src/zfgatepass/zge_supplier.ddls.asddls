@AbapCatalog.sqlViewName: 'ZGESUPPLIER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Supplier'
define view ZGE_SUPPLIER as select distinct from I_Supplier as SUP
association [0..*] to I_RegionText as RegionText on SUP.Region = RegionText.Region
                                                  and RegionText.Language = 'E'
                                                  and RegionText.Country = 'IN'
{
  key SUP.Supplier              as Supplier,
  key SUP.Region                as Region,
  key SUP.Country               as Country,
  key SUP.SupplierLanguage      as Langauage,
      SUP.StreetName       as Street,
      SUP.BPAddrCityName   as City,
      SUP.DistrictName     as District,
      SUP.PostalCode    as Postal,
      SUP.AddressID as Address,
      SUP.PhoneNumber1 as PhoneNo,
      SUP.FaxNumber  as FaxNo,
      SUP.TaxNumber1 as GSTNo,
      SUP.BusinessPartnerPanNumber as PAN,
      SUP.SupplierAccountGroup  as SupplierAccountGroup,
      SUP.SupplierFullName      as SupplierFullName,
      SUP.SupplierName          as SupplierName,
      SUP.TaxNumber2            as TaxNumber2,
      SUP.TaxNumber3            as TaxNumber3,
      RegionText.RegionName     as RegionName
        
}
