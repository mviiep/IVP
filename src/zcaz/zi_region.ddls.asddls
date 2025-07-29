@AbapCatalog.sqlViewName: 'ZZI_REG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Region text cds'
define view ZI_REGION
  as select from I_Customer as CUST
  association [0..1] to I_RegionText as region on  region.Region   = CUST.Region
                                               and region.Country  = 'IN'
                                               and region.Language = 'E'
{
  key CUST.Customer,
  key region.Region,
      CUST.CustomerName,
      region.RegionName,
      region.Language,
      region.Country
}
where
      region.Country  = 'IN'
  and region.Language = 'E'
