@AbapCatalog.sqlViewName: 'ZSQL_LCPO'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for LC Purchase Order'
define view ZI_LCPO
  as select distinct from I_PurchaseOrderAPI01
{
  key PurchaseOrder
}
where
  PurchaseOrder <> ' '
