@AbapCatalog.sqlViewName: 'ZBATCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Batch details'
define root view ZBATCHSTSINQYCDS
  as select from    I_JournalEntry     as a
    left outer join I_JournalEntryItem as b on a.AccountingDocument = b.AccountingDocument
{
  key a.CompanyCode,
  key a.FiscalYear,
  key a.AccountingDocument,
      b.GLAccount,
      a.AccountingDocumentType,
      a.DocumentDate,
      a.PostingDate,
      a.FiscalPeriod,
      a.AccountingDocumentCreationDate,
      a.CreationTime,
      a.LastManualChangeDate,
      a.LastAutomaticChangeDate,
      a.LastChangeDate,
      a.AccountingDocCreatedByUser,
      a.AccountingDocumentHeaderText,
      a.DocumentReferenceID

}
where
  (
       AccountingDocumentHeaderText = '-'
    or AccountingDocumentHeaderText = 'null'
    or AccountingDocumentHeaderText = 'undefined'
  )
  and a.IsReversal = ''
  and a.IsReversed = ''
