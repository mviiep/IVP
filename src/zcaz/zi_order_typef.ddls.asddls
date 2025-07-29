@AbapCatalog.sqlViewName: 'ZZI_ORDER_TYPEF'
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
define view ZI_order_typeF
  as select distinct from I_ManufacturingOrder as A
{
       @UI.textArrangement: #TEXT_ONLY
  key  A.ManufacturingOrderType as OrderType

}
where
     ManufacturingOrderType = 'ZF01'
  or ManufacturingOrderType = 'ZF02'
  or ManufacturingOrderType = 'ZF03'
  or ManufacturingOrderType = 'ZF04'
