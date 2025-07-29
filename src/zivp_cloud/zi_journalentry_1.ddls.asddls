@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntry_1 as select from I_BillingDocumentBasic as Billingheader
association [0..1] to I_JournalEntryItem as Journal 
on Journal.AccountingDocument = Billingheader.AccountingDocument 
and Journal.AccountAssignmentType = 'EO'
//and Journal.DebitCreditCode  = 'H'
//and Journal.PostingKey       = '50'
//AND JOURNAL.IT

//association [0..1] to ZI_GLACCOUNTDATA as GLname
//on GLname.AccountingDocument = Billingheader.AccountingDocument
//and GLname.GLAccount         = journal.GLAccount
{
    key Billingheader.BillingDocument ,
    key Billingheader.AccountingDocument,
        Journal.AccountingDocumentItem,
        Journal.DebitCreditCode,
        Journal.PostingKey,
        Journal.GLAccount,
        Journal.IsReversal,
        Journal.CompanyCodeCurrency,
        
        Journal.ReversalReferenceDocument
//        @Semantics.amount.currencyCode: 'BalanceTransactionCurrency'
//        Journal.AmountInBalanceTransacCrcy,
//        Journal.BalanceTransactionCurrency,
//        journal.a
//        Journal.TaxCode
//        
//        GLname.GLAccountName
}// where Billingheader.BillingDocument = '0090000009'
where Journal.AccountingDocumentItem = '002'
//and Journal.AccountingDocumentType = 'DR'
//and Journal.AccountingDocumentType =

//group by Billingheader.BillingDocument, Billingheader.AccountingDocument, Journal.AccountingDocumentItem,
//         Journal.DebitCreditCode, Journal.PostingKey, Journal.GLAccount;
