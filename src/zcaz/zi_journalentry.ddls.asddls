@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch GL Account from Billing Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntry
  as select from I_BillingDocumentBasic as Billingheader
  association [0..1] to I_JournalEntryItem as Journal on  Journal.AccountingDocument    = Billingheader.AccountingDocument
                                                      and Journal.AccountAssignmentType = 'EO'
{
  key Billingheader.BillingDocument,
  key Billingheader.AccountingDocument,
      Journal.AccountingDocumentItem,
      Journal.DebitCreditCode,
      Journal.PostingKey,
      Journal.GLAccount
}
where
  Journal.AccountingDocumentItem = '002'
