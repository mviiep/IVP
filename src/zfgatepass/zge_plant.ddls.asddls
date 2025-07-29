@AbapCatalog.sqlViewName: 'ZGEPLANT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Plant'
define view ZGE_PLANT as select distinct  from I_Plant as PLNT

association [0..*]  to I_OrganizationAddress as ZORGADD on  ZORGADD.AddressID = PLNT.AddressID


{
    
    key PLNT.Plant as Plant,
        PLNT.PlantName as PlantName,
        PLNT.PlantCategory as PlantCategory,
        ZORGADD.DistrictName as DistrictName,
        ZORGADD.CityNumber as CityNumber,
        ZORGADD.CityName as CityName,
        
         ZORGADD.PostalCode,
        
        ZORGADD.Street as Street,
        ZORGADD.StreetName as StreetName,
        ZORGADD.Country as Country,
        ZORGADD.Region as Region, 
        ZORGADD.HouseNumber as HouseNumber,
        ZORGADD.AddresseeName1 as AddresseeName1,
        ZORGADD.AddresseeName2 as AddresseeName2
    
}
