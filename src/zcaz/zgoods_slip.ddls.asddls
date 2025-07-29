@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'POST GOODS SLIP'
define root view entity ZGOODS_SLIP
  as select from I_MaterialDocumentItem_2 as Matdocitem
  association [0..1] to I_Plant                              on  I_Plant.Plant = Matdocitem.Plant

  association [0..1] to I_MaterialDocumentHeader_2 as header on  header.MaterialDocument = Matdocitem.MaterialDocument

  association [0..1] to I_ProductDescription       as product      on  product.Product = Matdocitem.Material
                                                             and product.Language      = 'E'

  association [0..1] to I_ReservationDocumentItem  as reserve on  reserve.Reservation    = Matdocitem.Reservation
                                                             and reserve.ReservationItem = Matdocitem.ReservationItem
  
   association [0..1] to I_StorageLocationStdVH as storage on storage.StorageLocation = Matdocitem.StorageLocation
                                                                                                                    

  // association [0..1] to  I_GoodsMovementTypeStdVH as goodmov on goodmov.GoodsMovementType = matdocitem.GoodsMovementType




{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
      Matdocitem._GoodsMovementType._Text[ Language = 'E' ].GoodsMovementTypeName,
      Plant,
      I_Plant.PlantName,
      header.CreatedByUser,
      GoodsMovementType,
      //goodmov.GoodsMovementTypeName,
      Reservation,
      OrderID,
      PostingDate,
      Material,
      product.ProductDescription,
      reserve.ResvnItmRequiredQtyInBaseUnit,
      reserve.BaseUnit,
      StorageLocation,
      QuantityInBaseUnit,
      MaterialBaseUnit,
      Batch,
      MaterialDocumentItemText,
      storage.StorageLocationName,
      //ReservationItemRecordType,
      //ReservationIsFinallyIssued,
      ReservationItem,
      IsAutomaticallyCreated

}
