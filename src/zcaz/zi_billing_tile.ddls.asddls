@AbapCatalog.sqlViewName: 'ZZ_BILLING_TILE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tile for Custom Commerical and Packing List'
define view Zi_billing_tile
  as select distinct from I_BillingDocumentBasic
{
  key BillingDocument
}
