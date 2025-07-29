@AbapCatalog.sqlViewName: 'ZGESRITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Sale Return ITEM'
define view ZGE_SR_ITEM as select distinct from I_CustomerReturnItem as ZSRITEM

/*  Association           */

association [0..1]  to ZGE_PLANT as ZPLANT on ZPLANT.Plant = ZSRITEM.Plant
association [0..1]  to ZGE_PRODUCT as ZPRDT on ZPRDT.Product = ZSRITEM.Product
association [0..1]  to ZGE_OD_HEAD as ZODHD on ZODHD.CustomerName = ZSRITEM.CustomerReturn


{
    key ZSRITEM.CustomerReturn,
    key ZSRITEM.CustomerReturnItem,
        ZSRITEM.CustomerReturnItemText,
        ZSRITEM.Plant,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        ZSRITEM.OrderQuantity,
        ZSRITEM.BaseUnit,
        ZSRITEM.Product,
        ZPLANT.PlantName,
        ZPRDT.ProductName,
        ZSRITEM.CreatedByUser,
        ZSRITEM.CreationDate,
        ZODHD
    
}
