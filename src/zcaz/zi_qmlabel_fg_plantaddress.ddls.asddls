@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for QM Label FG Plant Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_qmlabel_fg_Plantaddress
  as select distinct from I_Plant
  association [0..1] to I_Address_2 on I_Address_2.AddressID = I_Plant.AddressID
{
  key I_Plant.Plant,
      I_Address_2.StreetSuffixName1,
      I_Address_2.StreetSuffixName2,
      I_Address_2.AddresseeFullName,
      I_Address_2.StreetName,
      I_Address_2.CityName,
      I_Address_2.PostalCode,
      I_Address_2._Region._RegionText.RegionName,
      I_Address_2.StreetPrefixName1,
      I_Address_2.DistrictName,
      I_Address_2.AddressPersonID,
      I_Address_2.AddressID,
      I_Address_2._EmailAddress.EmailAddress,
      I_Address_2._PhoneNumber.InternationalPhoneNumber,
      I_Address_2._CurrentDfltMobilePhoneNumber.InternationalPhoneNumber as InternationalPhoneNumber1,
      I_Address_2._Country._Text.CountryName
}
