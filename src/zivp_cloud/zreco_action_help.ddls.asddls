@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reco action help'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]

@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZRECO_ACTION_HELP
  as select from zgstr2_st as reco
{
  key reco.reco_action as ReverseResponsefilter
}
//where reco.reco_action = 'NOT_IN_2A'
//and reco.reco_action = 'MATCHED'
//and reco.reco_action = 'MISMATCHED'
group by
  reco.reco_action
