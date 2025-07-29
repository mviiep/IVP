@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry CDS for GST Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJOURNALENTRY_CDS
  as select from I_JournalEntryItem as JournalItem
{
  key JournalItem.AccountingDocument                                            as AccountingDocument,
  key JournalItem.PurchasingDocument                                            as PurchasingDocument,
  key JournalItem.FiscalYear                                                    as FiscalYear,
      JournalItem.ReferenceDocumentItem                                         as ReferenceDocumentItem,
      JournalItem.PostingDate                                                   as PostingDate,
      JournalItem.DocumentDate                                                  as Doc_date,
      sum(cast(JournalItem.AmountInCompanyCodeCurrency as abap.dec( 13, 2 ) ) ) as amcomp

}
where
       JournalItem.Ledger                       =  '0L'
  and  JournalItem.OffsettingAccount            <> ''
  and(
       JournalItem.AccountingDocumentType       =  'KR'
    or JournalItem.AccountingDocumentType       =  'KG'
    or JournalItem.AccountingDocumentType       =  'RE'
  )
  and  JournalItem.AmountInCompanyCodeCurrency  <> 0
  and  JournalItem.ReferenceDocumentItem        <> '000000'
  and  JournalItem.TransactionTypeDetermination <> 'WIT'
  and  JournalItem.TransactionTypeDetermination <> 'JII'
  and  JournalItem.TransactionTypeDetermination <> 'JIS'
  and  JournalItem.TransactionTypeDetermination <> 'JIC'
group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.ReferenceDocumentItem,
  JournalItem.PostingDate,
  JournalItem.DocumentDate
