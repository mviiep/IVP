@AbapCatalog.sqlViewName: 'ZGEODITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass- STO(outbound)Item'
define view ZGE_OD_ITEM as select distinct from I_OutboundDeliveryItem as ZODITEM

association [0..1] to ZGE_PLANT as ZPLANT on ZPLANT.Plant = ZODITEM.Plant
association [0..1] to ZGE_OD_HEAD as ZODHD on ZODHD.OutboundDelivery = ZODITEM.OutboundDelivery
association [0..1] to ZGE_PRODUCT as ZPRDT on ZPRDT.Product = ZODITEM.Product
{
    key ZODITEM.OutboundDelivery as OutboundDelivery,
    key ZODITEM.OutboundDeliveryItem as OutboundDeliveryItem,
    ZODITEM.SalesDocumentItemType as SalesDocumentItemType,
    ZODITEM.Product as Product,
    ZODITEM.Plant as Plant,
    ZODITEM.BaseUnit as BaseUnit,
    ZODITEM.OriginalDeliveryQuantity as OriginalDeliveryQuantity,
    ZODITEM.DeliveryQuantityUnit as DeliveryQuantityUnit,
    ZPLANT.PlantName as PlantName,
    ZPRDT.ProductName as ProductName,
    ZODITEM.CreatedByUser,
    ZODITEM.CreationDate,
    ZODITEM.LastChangeDate,
    ZODHD
} 
