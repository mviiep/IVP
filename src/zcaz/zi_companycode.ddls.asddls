@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Company Code'
define view entity ZI_CompanyCode
  as select distinct from I_OperationalAcctgDocItem
{
  key CompanyCode
}
