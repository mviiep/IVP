@AbapCatalog.sqlViewName: 'ZI_GSTR1_SEND_SQ'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for sending data to MI Portal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_GSTR1_SEND_MI 
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem as GetSupplier  on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                           and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                           and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                           and GetSupplier.FinancialAccountType =  'K'
                                                           and GetSupplier.Supplier             <> ''
  association [0..1] to ZJOURNALENTRY_CDS  as JOURNAL_Spec on  $projection.AccountingDocument             = JOURNAL_Spec.AccountingDocument
                                                           and JournalItem.PurchasingDocument             = JOURNAL_Spec.PurchasingDocument
                                                           and JournalItem.ReferenceDocumentItem          = JOURNAL_Spec.ReferenceDocumentItem
                                                           and (
                                                              JournalItem.TransactionTypeDetermination    = 'KBS'
                                                              or JournalItem.TransactionTypeDetermination = 'WRX'
                                                            )

{
  key JournalItem.AccountingDocument                       as AccountingDocument,
  key JournalItem.AccountingDocumentItem                   as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                       as PurchasingDocument,
  key JournalItem.FiscalYear                               as FiscalYear,
      JournalItem.PostingDate                              as PostingDate,
      JournalItem.DocumentDate                             as Doc_date,
      substring( JournalItem.AccountingDocument , 1 ,  2 ) as DocNum,
      JournalItem.LedgerGLLineItem                         as Ledgergllineitem,
      JournalItem.PurchasingDocumentItem                   as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                          as DebitCreditCode,
      JournalItem.ReferenceDocument                        as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem                    as ReferenceDocumentItem,
      JournalItem.TaxCode                                  as TaxCode,
      JournalItem.TransactionTypeDetermination             as TransactionTypeDetermination,
      @Semantics.amount.currencyCode: 'Compcurr'
      case when JournalItem.TransactionTypeDetermination = ' ' then
      JournalItem.AmountInCompanyCodeCurrency
      else
      case when  JournalItem.TransactionTypeDetermination = 'KBS' or
                 JournalItem.TransactionTypeDetermination = 'WRX' then
      JOURNAL_Spec.amcomp
      else
      JournalItem.AmountInCompanyCodeCurrency end end      as AMCOMP,
      JOURNAL_Spec.amcomp                                  as AMCOMP_SPEC,
      JournalItem.AccountingDocumentItem                   as AccItem,
      JournalItem.FinancialAccountType                     as Acctype,
      JournalItem.GLAccount                                as GLCode,
      JournalItem.CompanyCodeCurrency                      as Compcurr,
      JournalItem.PostingDate                              as PostData,
      GetSupplier.Supplier                                 as Supplier,
      JournalItem.AccountingDocumentType                   as AccountingDocumentType

}
where
       JournalItem.Ledger                       =  '0L'
  and  JournalItem.ReversalReferenceDocument    =  ''
  and  JournalItem.OffsettingAccount            <> ''
  and(
       JournalItem.AccountingDocumentType       =  'KR'
    or JournalItem.AccountingDocumentType       =  'KG'
    or JournalItem.AccountingDocumentType       =  'RE'
  )
  and  JournalItem.AmountInCompanyCodeCurrency  <> 0
  and  JournalItem.TransactionTypeDetermination <> 'JII'
  and  JournalItem.TransactionTypeDetermination <> 'JIC'
  and  JournalItem.TransactionTypeDetermination <> 'JIS'
  and  JournalItem.TransactionTypeDetermination <> 'JRC'
  and  JournalItem.TransactionTypeDetermination <> 'JRS'
  and  JournalItem.TransactionTypeDetermination <> 'JRI'
  and  JournalItem.TransactionTypeDetermination <> 'WIT'
  and JournalItem.GLAccount <> '40402600'
  //  (
//       JournalItem.TaxCode                      <> 'G0'
////  and  JournalItem.TaxCode                      <> 'A0' "(-)ANurag 19.01.2025
//  and  JournalItem.TaxCode                      <> 'AA'
//  and  JournalItem.TaxCode                      <> 'B0'
//  and  JournalItem.TaxCode                      <> 'BB'
//  and  JournalItem.TaxCode                      <> 'C0'
//  and  JournalItem.TaxCode                      <> 'CC'
//  and  JournalItem.TaxCode                      <> 'G1'
//  and  JournalItem.TaxCode                      <> 'G2'
//  and  JournalItem.TaxCode                      <> 'II'
//  and  JournalItem.TaxCode                      <> 'I0'
  //  )
  and  JournalItem.FinancialAccountType         =  'S'

group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.PostingDate,
  JournalItem.DocumentDate,
  JournalItem.OffsettingAccount,
  JournalItem.PurchasingDocumentItem,
  JournalItem.DebitCreditCode,
  JournalItem.ReferenceDocument,
  JournalItem.ReferenceDocumentItem,
  JournalItem.TaxCode,
  JournalItem.TransactionTypeDetermination,
  JournalItem.AmountInCompanyCodeCurrency,
  JOURNAL_Spec.amcomp,
  JournalItem.AccountingDocumentItem,
  JournalItem.FinancialAccountType,
  JournalItem.GLAccount,
  JournalItem.PostingDate,
  JournalItem.CreditAmountInCoCodeCrcy,
  JournalItem.DebitAmountInCoCodeCrcy,
  JournalItem.CompanyCodeCurrency,
  GetSupplier.Supplier,
  JournalItem.AccountingDocumentType,
  JournalItem.LedgerGLLineItem
