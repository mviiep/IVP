//@AbapCatalog.sqlViewName: 'ZALES'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Unit'
define root view entity zsalesunit
  as select from I_SalesOrderItem as a
{
  key SalesOrder,
      OrderQuantityUnit
}
where
  SalesOrderItem = '000010'
