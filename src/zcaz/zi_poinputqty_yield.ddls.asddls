@AbapCatalog.sqlViewName: 'ZZI_POINPUTQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for po input qnty yield'
define view ZI_POINPUTQTY_YIELD
  as select from I_MaterialDocumentItem_2 as a
{
  key a.ManufacturingOrder,
      a.GoodsMovementType,
      sum(a.QuantityInEntryUnit) as POinputqty
}
where
  a.GoodsMovementType = '261'
group by
  a.ManufacturingOrder,
  a.GoodsMovementType
