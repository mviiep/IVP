@AbapCatalog.sqlViewName: 'ZGEODHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass- STO(outbound)'
define view ZGE_OD_HEAD as select distinct from I_OutboundDelivery as ZOD 


/*  Association           */

association [0..*]  to ZGE_SUPPLIER as ZSUP on ZOD.Supplier = ZSUP.Supplier
association [0..*]  to ZGE_CUSTOMER as ZCUST on ZOD.ShipToParty = ZCUST.Customer
association [0..*]  to ZGE_OD_ITEM as ZODITEM on ZOD.OutboundDelivery = ZODITEM.OutboundDelivery


{
  key ZOD.OutboundDelivery  as OutboundDelivery,
      ZOD.DeliveryDocumentType as  DeliveryDocumentType,
      ZOD.Supplier as Supplier ,
      ZSUP.SupplierName as SupplierName,
      ZSUP.SupplierAccountGroup as SupplierAccountGroup,
      ZOD.ShipToParty as ShipToParty ,
      ZCUST.CustomerName as CustomerName ,
      ZCUST.CustomerAccountGroup as CustomerAccountGroup ,
      ZOD.CreationDate,
      ZOD.CreatedByUser,
      ZOD.LastChangedByUser,
      ZODITEM
  
}

where ZOD.DeliveryDocumentType = 'JNL' or ZOD.DeliveryDocumentType = 'NL'
