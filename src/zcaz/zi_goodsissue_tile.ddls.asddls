@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GoodsIsssueTile'
define view entity ZI_GoodsIssue_Tile
  as select distinct from I_MaterialDocumentHeader_2
{

  key MaterialDocumentYear,
  key MaterialDocument
}
