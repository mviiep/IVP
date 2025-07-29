@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Account Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGLACCOUNTDATA
  as select from ZI_JournalEntry as journal
  association [0..1] to I_GLAccountTextRawData as GLdesc on  GLdesc.GLAccount = journal.GLAccount
                                                         and GLdesc.Language  = 'E'
{
  key journal.AccountingDocument,
  key journal.BillingDocument,
      GLdesc.GLAccount,
      GLdesc.GLAccountName,
      GLdesc.GLAccountLongName
}
