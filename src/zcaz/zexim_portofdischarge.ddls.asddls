@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Port of Discharge Odata Service'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zexim_portofdischarge
  as select distinct from ZI_Sd_Address
{
  key Customer,
      CustomerName as CustomerFullName,
      CustomerAccountGroup
}
where
  CustomerAccountGroup = 'ZPLD'
