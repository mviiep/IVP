@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for QM Label FG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality:  #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_qmlabel_fg
  as select distinct from I_ManufacturingOrder
  association [0..1] to ZI_qmlabel_fg_productdesc  on  ZI_qmlabel_fg_productdesc.Product = I_ManufacturingOrder.Product
  association [0..1] to ZI_qmlabel_fg_Plantaddress on  ZI_qmlabel_fg_Plantaddress.Plant = I_ManufacturingOrder.ProductionPlant
  association [0..1] to I_Plant                    on  I_Plant.Plant = I_ManufacturingOrder.ProductionPlant
//  association [0..1] to I_BatchDistinct            on  I_BatchDistinct.Material = I_ManufacturingOrder.Material
//                                                   and I_BatchDistinct.Batch    = I_ManufacturingOrder.Batch
  association [0..1] to Zi_batchdetails            on  Zi_batchdetails.ManufacturingOrder = I_ManufacturingOrder.ManufacturingOrder
  association [0..1] to I_Product                  on  I_Product.Product = I_ManufacturingOrder.Product
//  association [0..1] to I_MaterialDocumentItem_2   on  I_MaterialDocumentItem_2.ManufacturingOrder = I_ManufacturingOrder.ManufacturingOrder
//                                                   and I_MaterialDocumentItem_2.GoodsMovementType  = '101'
{
  key I_ManufacturingOrder.ManufacturingOrder,
      I_ManufacturingOrder.ProductionPlant,
      case 
      when I_Product.IndustryStandardName is not initial
      then I_Product.IndustryStandardName 
      else ZI_qmlabel_fg_productdesc.ProductDescription end as ProductDescription,
//      ZI_qmlabel_fg_productdesc.ProductDescription,
      I_ManufacturingOrder.ManufacturingOrderHasLongText,
      I_ManufacturingOrder.Batch,
      Zi_batchdetails.ManufactureDate,
      Zi_batchdetails.ShelfLifeExpirationDate,
      I_Product.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      I_Product.GrossWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      I_Product.NetWeight,
      I_Product.ProductionOrInspectionMemoTxt,
      I_Product.Product,
      I_Product.BaseUnit,


      //Plant Address
      I_Plant.Plant,
      ZI_qmlabel_fg_Plantaddress.StreetName,
      ZI_qmlabel_fg_Plantaddress.AddresseeFullName,
      ZI_qmlabel_fg_Plantaddress.StreetSuffixName1,
      ZI_qmlabel_fg_Plantaddress.StreetSuffixName2,
      ZI_qmlabel_fg_Plantaddress.CityName,
      ZI_qmlabel_fg_Plantaddress.PostalCode,
      ZI_qmlabel_fg_Plantaddress.RegionName,
      ZI_qmlabel_fg_Plantaddress.StreetPrefixName1,
      ZI_qmlabel_fg_Plantaddress.DistrictName,
      ZI_qmlabel_fg_Plantaddress.AddressPersonID,
      ZI_qmlabel_fg_Plantaddress.EmailAddress,
      ZI_qmlabel_fg_Plantaddress.InternationalPhoneNumber,
      ZI_qmlabel_fg_Plantaddress.InternationalPhoneNumber1,
      ZI_qmlabel_fg_Plantaddress.CountryName




}
