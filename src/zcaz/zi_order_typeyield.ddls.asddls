@AbapCatalog.sqlViewName: 'ZZI_ORDERTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Type CDS for Yeild Report'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
@ObjectModel.resultSet.sizeCategory: #XS
define view ZI_order_typeyield
  as select distinct from I_ManufacturingOrder as A
{
       @UI.textArrangement: #TEXT_ONLY
  key  A.ManufacturingOrderType as OrderType

}
where
     ManufacturingOrderType = 'ZS01'
  or ManufacturingOrderType = 'ZS02'
  or ManufacturingOrderType = 'ZS03'
  or ManufacturingOrderType = 'ZS04'
  or ManufacturingOrderType = 'ZI01'
  or ManufacturingOrderType = 'ZR01'
  or ManufacturingOrderType = 'ZR02'
  or ManufacturingOrderType = 'ZP01'
  or ManufacturingOrderType = 'ZP02'
  or ManufacturingOrderType = 'ZB01'
  or ManufacturingOrderType = 'ZB02'

