@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PlantSearch Help CDS for Sales Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZSH_MRPController
  as select from I_ProductPlantBasic as a
{
  key a.MRPResponsible as MRPResponsible
      //    a.PlantName
}
where 
a.MRPResponsible <> ''
and a.MRPResponsible <> '001'
and a.MRPResponsible <> '002'
group by
  a.MRPResponsible
