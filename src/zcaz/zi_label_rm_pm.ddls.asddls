@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Label RM and PM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Label_RM_PM
  as select distinct from I_MaterialDocumentItem_2
  association [0..1] to I_Supplier      on  I_MaterialDocumentItem_2.Supplier = I_Supplier.Supplier
  association [0..1] to ZI_Materialtext on  I_MaterialDocumentItem_2.Material = ZI_Materialtext.Product
  association [0..1] to I_InspectionLot on  I_MaterialDocumentItem_2.MaterialDocument = I_InspectionLot.MaterialDocument
                                        and I_MaterialDocumentItem_2.Material         = I_InspectionLot.Material
                                        and I_MaterialDocumentItem_2.Batch            = I_InspectionLot.Batch
{
  key MaterialDocument,
  key Plant,
      I_Supplier.SupplierName,
      Batch,
      Material,
      ZI_Materialtext.ProductName            as MaterialName,
      MaterialBaseUnit,
      GoodsMovementType,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      QuantityInBaseUnit                     as GRNQuantity,
      PostingDate                            as GRNDate,
      ManufactureDate,
      ShelfLifeExpirationDate                as ExpiryDate,
      I_InspectionLot.InspectionLotContainerUnit,
      @DefaultAggregation:#NONE
      @Semantics.quantity.unitOfMeasure: 'InspectionLotContainerUnit'
      I_InspectionLot.InspectionLotContainer as noofContainer
}
//where
//  MaterialDocumentItem = '0001'
