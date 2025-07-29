@AbapCatalog.sqlViewName: 'ZZI_FI_JOURNAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI Journal ENtry CDS'
define view ZI_FI_JOURNAL_ENRTY
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem as GetSupplier on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                          and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                          and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                          and GetSupplier.FinancialAccountType =  'D' //changed by sanjay from K
                                                          and GetSupplier.Customer             <> ''
{
  key JournalItem.AccountingDocument          as AccountingDocument,
  key JournalItem.AccountingDocumentItem      as AccountingDocumentItem,
  key JournalItem.PurchasingDocument          as PurchasingDocument,
  key JournalItem.FiscalYear                  as FiscalYear,
      JournalItem.DocumentDate                as DocumentDate,
      JournalItem.PostingDate                 as PostingDate,
      JournalItem.OffsettingAccount           as OffsettingAccount,
      JournalItem.PurchasingDocumentItem      as PurchasingDocumentItem,
      JournalItem.DebitCreditCode             as DebitCreditCode,
      JournalItem.ReferenceDocument           as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem       as ReferenceDocumentItem,
      JournalItem.TaxCode                     as TaxCode,
      JournalItem.GLAccount                   as GLAccount,
      JournalItem.AmountInTransactionCurrency as BaseAmount,
      JournalItem.GLAccountType               as GLAccountType,
      JournalItem.IsReversal                  as IsReversal,
      case
      when JournalItem.TaxCode = 'D1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'D2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'D3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'D4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
      when JournalItem.TaxCode = 'F1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0005 )
        end                                   as SGST,
      case
      when JournalItem.TaxCode = 'D1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'D2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'D3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'D4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
      when JournalItem.TaxCode = 'F1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0005 )
       end                                    as CGST,
      case
      when JournalItem.TaxCode = 'D5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'D6'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'D7'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'D8'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
      when JournalItem.TaxCode = 'E1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.001) 
      when JournalItem.TaxCode = 'E2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18) 
        end                                   as IGST,

      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
        end                                   as RSGST,
      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
       end                                    as RCGST,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
      when JournalItem.TaxCode = 'R9'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.0)
        end                                   as RIGST,
      //            @Semantics: { amount : {currencyCode: 'AmountInFunctionalCurrency'} }
      //      @Semantics.amount.currencyCode:'AmountInFunctionalCurrency'
      //      @Semantics.currencyCode: true
      //      JournalItem.AmountInFunctionalCurrency as AmountInFunctionalCurrency,
      JournalItem.AccountingDocumentType      as AccountingDocumentType,
      GetSupplier.Supplier                    as Supplier,
      GetSupplier.Customer //Added by sanjay 15.01.2024
}
where
  //      JournalItem.PurchasingDocument     <> ''
  //  and
  //       JournalItem.DebitCreditCode        =  'S'
  //  and
       JournalItem.IsReversal             <> 'X'
  and  JournalItem.IsReversed             <> 'X'
  and  JournalItem.OffsettingAccount      <> ''
  and  JournalItem.GLAccountType          =  'P'
  and  JournalItem.ReferenceDocumentType  =  'BKPF'
  and(
       JournalItem.AccountingDocumentType =  'DR'
    or JournalItem.AccountingDocumentType =  'DG'
  )
