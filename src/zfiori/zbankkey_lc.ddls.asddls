@AbapCatalog.sqlViewName: 'ZBANKKEY_LC_SQL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.preserveKey: true
@EndUserText.label: 'Bank key & name for LC'
define view ZBANKKEY_LC as select from I_Bank_2 as BANK
{
key BANK.BankCountry,
key BANK.BankInternalID,
    BANK.BankName
}
