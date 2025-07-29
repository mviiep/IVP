@AbapCatalog.sqlViewName: 'ZGEBDHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Billing Document'
define view ZGE_BD_HEAD as select distinct from I_BillingDocument as ZBD



left outer join I_Customer as ZCUST on ZBD.SoldToParty = ZCUST.Customer
 left outer join I_Supplier as ZSUP on ZCUST.Supplier = ZSUP.Supplier


{
    key ZBD.BillingDocument  as BillingDocument,  
    ZBD.BillingDocumentType  as BillingDocumentType,
    ZBD.BillingDocumentCategory  as BillingDocumentCategory,
    ZCUST.Supplier as Supplier ,
      ZSUP.SupplierName as SupplierName,
      ZSUP.SupplierAccountGroup as SupplierAccountGroup,
      ZCUST.CustomerName as CustomerName ,
      ZCUST.CustomerAccountGroup as CustomerAccountGroup,
      ZBD.CreationDate,
      ZBD.CreatedByUser
    
      
    
     
}
