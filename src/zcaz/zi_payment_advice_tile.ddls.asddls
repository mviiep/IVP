@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Advice Tile'

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_Payment_Advice_Tile
  as select distinct from I_JournalEntryItem
{

  key case
  when ClearingJournalEntry is not initial
  then ClearingJournalEntry
  else AccountingDocument end as ClearingAccountingDocument,
      CompanyCode,

      case
      when ClearingJournalEntryFiscalYear is not initial
      then ClearingJournalEntryFiscalYear
      else FiscalYear end     as ClearingDocFiscalYear

      //      ClearingJournalEntryFiscalYear as ClearingDocFiscalYear



}
