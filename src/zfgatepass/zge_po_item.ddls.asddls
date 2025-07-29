@AbapCatalog.sqlViewName: 'ZGEPOITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass - Purchase Order Item'
define view ZGE_PO_ITEM as select distinct from  I_PurchaseOrderItemAPI01 as POITEM

association [0..1] to ZGE_PRODUCT as ZPRD on POITEM.Material = ZPRD.Product

association [0..1] to ZGE_PLANT as ZPL on POITEM.Plant = ZPL.Plant

{
    key POITEM.PurchaseOrder as PurchaseOrder,
    key POITEM.PurchaseOrderItem as PurchaseOrderItem,
        POITEM.PurchaseOrderCategory as PurchaseOrderCategory,
        POITEM.PurchaseOrderItemText as PurchaseOrderItemText,
        POITEM.NetPriceQuantity as NetPriceQuantity,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        POITEM.OrderQuantity as OrderQuantity,
        POITEM.BaseUnit as BaseUnit,
        POITEM.Plant,
        ZPL.PlantName,
        POITEM.PurchaseOrderQuantityUnit,
        POITEM.Material as Material,
        ZPRD.ProductName as ProductName,
        ZPRD.ConsumptionTaxCtrlCode as ConsumptionTaxCtrlCode,
        POITEM.MaterialType as MaterialType,
        POITEM.MaterialGroup as MaterialGroup
}
