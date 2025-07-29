@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Petty Cash Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_Petty_Cash
  as select distinct from I_JournalEntryItem as journalentryitem
  association [0..1] to I_GLAccountText as gl_name  on  journalentryitem.GLAccount = gl_name.GLAccount
                                                    and gl_name.Language           = 'E'
  association [0..1] to I_Supplier      as supplier on  journalentryitem.Supplier = supplier.Supplier
  association [0..1] to I_Plant         as Plant    on  journalentryitem.Plant = Plant.Plant
{
  key journalentryitem.AccountingDocument,
  key journalentryitem.LedgerGLLineItem,
      journalentryitem.FiscalYear,
      journalentryitem.CompanyCode,
      journalentryitem.PostingDate,
      journalentryitem.DocumentItemText            as Narration,
      journalentryitem.AccountingDocumentType,
      case
       when  journalentryitem.AccountingDocumentType = 'KZ'
        and journalentryitem.Supplier <> ' '
        then ltrim(journalentryitem.Supplier,'0')
      //        then journalentryitem.Supplier

      when  journalentryitem.AccountingDocumentType = 'SJ'
        and journalentryitem.GLAccountType = 'P'
        and journalentryitem.GLAccount <> ' '
        then ltrim(journalentryitem.GLAccount,'0')
      //        then journalentryitem.GLAccount

        else null end                              as AccountCode,

      case
      when  journalentryitem.AccountingDocumentType   = 'KZ'
      and supplier.SupplierName <> ' '
            then supplier.SupplierName

      when  journalentryitem.AccountingDocumentType = 'SJ'
        and journalentryitem.GLAccountType = 'P'
        and gl_name.GLAccountLongName <> ' '
        then gl_name.GLAccountLongName

       else null end                               as AccountDescription,

      journalentryitem.Ledger,
      journalentryitem.Supplier,
      supplier.SupplierName,
      case
      when journalentryitem.AccountingDocumentType   = 'SJ'
      then ltrim(journalentryitem.CostCenter,'0')
      else null end                                as CostCenter,
      journalentryitem.ControllingArea,
      journalentryitem.GLAccount,
      journalentryitem.GLAccountType,
      case
      when journalentryitem.AccountingDocumentType   = 'SJ'
      then  journalentryitem._CostCenterTxt.CostCenterDescription
      else null end                                as CostCenterDescription,
      journalentryitem.Plant,
      Plant.PlantName,
      journalentryitem.CompanyCodeCurrency         as CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      journalentryitem.AmountInCompanyCodeCurrency as AMOUNTINCOMPANYCODECURRENCY,
      journalentryitem.TransactionCurrency         as TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      journalentryitem.AmountInTransactionCurrency as AmountInTransactionCurrency

}
where
  journalentryitem.Ledger = '0L'
