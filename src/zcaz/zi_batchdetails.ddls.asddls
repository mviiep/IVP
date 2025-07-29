@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for QM Batch Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_batchdetails
  as select distinct from I_ManufacturingOrder
  association [0..1] to I_BatchDistinct on  I_BatchDistinct.Material = I_ManufacturingOrder.Material
                                        and I_BatchDistinct.Batch    = I_ManufacturingOrder.Batch

{
  Material,
  ManufacturingOrder,
  I_BatchDistinct.Batch,
  I_BatchDistinct.ManufactureDate,
  I_BatchDistinct.ShelfLifeExpirationDate

}
//where
//  I_ManufacturingOrder.GoodsMovementType = '101'
