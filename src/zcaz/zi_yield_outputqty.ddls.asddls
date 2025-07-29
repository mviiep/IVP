@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Output Qnty logic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_YIELD_OutputQty
  as select from     I_MaterialDocumentItem_2 as a
    right outer join I_MaterialDocumentItem_2 as b on  a.Material          = b.Material
                                                   and a.Batch             = b.Batch
                                                   and b.GoodsMovementType = '261'
    right outer join I_MaterialDocumentItem_2 as c on  b.OrderID           = c.OrderID
                                                   and c.GoodsMovementType = '101'

{
  a.ManufacturingOrder as processorder,
  a.Batch              as BatchA,
  a.GoodsMovementType  as MovementType,
  b.GoodsMovementType  as MovementTypeB,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  b.QuantityInBaseUnit as Qnty1,
  b.MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  c.QuantityInBaseUnit as Qnty

}
