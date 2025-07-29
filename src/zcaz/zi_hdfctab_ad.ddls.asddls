@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for HDFC Bank with Acc Doc'
define view entity zi_hdfctab_ad
  as select from zdb_hdfctab_ad
{
  key alertsequenceno   as Alertsequenceno,
      acountingdocument as Acountingdocument
}
