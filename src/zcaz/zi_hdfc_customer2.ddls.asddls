@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Customer HDFC Bank Integration'
define view entity zi_hdfc_customer2
  as select from zdb_hdfctab
{
  key alertsequenceno,
      lpad( right( virtualaccount, 6), 6, '0' ) as customer,
      virtualaccount
}
