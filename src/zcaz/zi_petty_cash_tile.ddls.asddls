@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Tile Petty Cash Form'
define view entity ZI_Petty_Cash_Tile
  as select distinct from I_JournalEntry
{
  key AccountingDocument,
      CompanyCode,
      FiscalYear
}
