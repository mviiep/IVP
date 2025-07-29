@AbapCatalog.sqlViewName: 'ZGEMDITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass- Material Document for Item'
define view ZGE_MD_ITEM as select distinct from I_MaterialDocumentItem_2 as ZMD


association[0..*] to I_Plant as ZPLANT  on ZPLANT.Plant = ZMD.Plant
association[0..*] to I_ProductText as ZPRODUCT on ZPRODUCT.Product = ZMD.Material
association[0..*] to I_Supplier as ZSUP on ZSUP.Supplier = ZMD.Supplier
association[0..*] to I_Customer as ZCUSTOMER on ZCUSTOMER.Customer = ZMD.Customer

//association [0..1]  to ZGE_MD_HEAD as ZMDHEAD on $projection.MaterialDocumentYear = ZMDHEAD.MaterialDocumentYear and 
                                    
                                                 //$projection.MaterialDocument = ZMDHEAD.MaterialDocument

{
    key ZMD.MaterialDocumentYear,
    key ZMD.MaterialDocument,
    key ZMD.MaterialDocumentItem,
        ZMD.Material,
        ZMD.Plant,
        ZMD.Supplier,
        ZMD.Customer,
        ZMD.GoodsMovementType,
        ZMD.PurchaseOrder,
        ZMD.PurchaseOrderItem,
        ZMD.SalesOrder,
        ZMD.SalesOrderItem,
        ZPRODUCT.Product,
        ZPRODUCT.ProductName,
        @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
        ZMD.QuantityInBaseUnit,
        ZMD.MaterialBaseUnit,
        ZPLANT.PlantName,
        ZSUP.SupplierName,
        ZCUSTOMER.CustomerName,
        ZCUSTOMER.CustomerAccountGroup
        
        //ZMDHEAD
        
        
    
    
    
}
where ZMD.IsAutomaticallyCreated = ''
