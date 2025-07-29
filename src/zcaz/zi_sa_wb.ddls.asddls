@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SA WB'
define root view entity ZI_SA_WB
  as select from zsa_wb
{
  key plant  as Plant,
  key wb_no  as WbNo,
      weight as Weight,
      zdate  as Zdate,
      time   as Time

}
