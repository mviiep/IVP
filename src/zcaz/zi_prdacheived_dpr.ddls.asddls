@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for production acheived qty kg'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PrdAcheived_DPR
  as select distinct from I_MaterialDocumentItem_2 as a
    left outer join       I_MaterialDocumentItem_2 as b on  a.Material          = b.Material
                                                        and a.Plant             = b.Plant
                                                        and a.Batch             = b.Batch
                                                        and b.GoodsMovementType = '261'
    left outer join       I_ManufacturingOrder     as c on b.ManufacturingOrder = c.ManufacturingOrder
{
  key a.ManufacturingOrder,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  key sum( b.QuantityInBaseUnit ) as QuantityInBaseUnit,
//  key c.ManufacturingOrderType,
      a.Material,
      a.Plant,
      a.Batch,
      a.GoodsMovementType,
      b.MaterialBaseUnit

}
where
      a.GoodsMovementType      =  '101'
  and c.ManufacturingOrderType <> 'ZR01'
  and c.ManufacturingOrderType <> 'ZP01'
  and c.ManufacturingOrderType <> 'ZB01'
group by
  a.ManufacturingOrder,
//  c.ManufacturingOrderType,
  a.Material,
  a.Plant,
  a.Batch,
  a.GoodsMovementType,
  b.MaterialBaseUnit
