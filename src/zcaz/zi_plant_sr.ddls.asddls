@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PlantSearch Help CDS for Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_PLant_SR as select from I_Plant as a
{
    key a.Plant as Plant
//    a.PlantName
}
group by a.Plant
