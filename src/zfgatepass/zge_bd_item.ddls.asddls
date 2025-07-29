@AbapCatalog.sqlViewName: 'ZGEBDITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Billing Document'
define view ZGE_BD_ITEM as select distinct from I_BillingDocumentItem as ZBDITEM
association [0..1] to ZGE_PLANT as ZPLANT on ZPLANT.Plant = ZBDITEM.Plant
association [0..1] to ZGE_BD_HEAD as ZODHD on ZODHD.BillingDocument = ZBDITEM.BillingDocument
association [0..1] to ZGE_PRODUCT as ZPRDT on ZPRDT.Product = ZBDITEM.Product

{
    key ZBDITEM.BillingDocument as BillingDocument,
    key ZBDITEM.BillingDocumentItem as BillingDocumentItem,
    ZBDITEM.SalesDocumentItemType as SalesDocumentItemType,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      ZBDITEM.BillingQuantity as BillingQuantity,
     @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
       ZBDITEM.ItemGrossWeight as GrossWeight,
    ZBDITEM.ItemNetWeight as NetWeight,
      ZBDITEM.ItemWeightUnit as ItemWeightUnit,
    ZBDITEM.Product as Product,
    ZBDITEM.Plant as Plant,
    ZBDITEM.BaseUnit as BaseUnit,
    ZPLANT.PlantName as PlantName,
    ZPRDT.ProductName as ProductName, 
    ZBDITEM.CreatedByUser,
    ZBDITEM.CreationDate,
    ZODHD
}
