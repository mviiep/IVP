@AbapCatalog.sqlViewName: 'ZGECUSTOMER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass - Customer Code/Name'
define view ZGE_CUSTOMER as select from I_Customer as a
 
  association [0..1] to I_RegionText as Rtext on a.Region = Rtext.Region and Rtext.Country = 'IN'
{
  key a.Customer     as Customer,
      a.Language     as Language,
      a.CustomerName as CustomerName,
      a.CreationDate as CreationDate,
      a.TaxNumber3   as TaxNumber3,
      a.TaxNumber2   as TaxNumber2,
      a.Region       as Region,
      a.CustomerAccountGroup as CustomerAccountGroup,
      Rtext.RegionName as RegionName,
      a.Country as Country,
      a.CityName as CityName,
      a.PostalCode as PostalCode,
a.StreetName as StreetName,
a.FaxNumber as  FaxNumber,
a.TelephoneNumber1 as TelephoneNumber1,
a.AddressID as Address,
a.DistrictName as DistrictName
}
where a.Language = 'E'
