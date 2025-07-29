@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for I_Journal ENtry item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_JOURNALENTRYITEM
  as select distinct from I_JournalEntryItem as JournalItem

  association [0..1] to I_OperationalAcctgDocItem as _OperationalAcctgDocItem on  JournalItem.CompanyCode            = _OperationalAcctgDocItem.CompanyCode
                                                                              and JournalItem.FiscalYear             = _OperationalAcctgDocItem.FiscalYear
                                                                              and JournalItem.AccountingDocument     = _OperationalAcctgDocItem.AccountingDocument
                                                                              and JournalItem.AccountingDocumentItem = _OperationalAcctgDocItem.AccountingDocumentItem

  association [0..1] to I_OperationalAcctgDocItem as _JCN                     on  JournalItem.CompanyCode           = _JCN.CompanyCode
                                                                              and JournalItem.FiscalYear            = _JCN.FiscalYear
                                                                              and JournalItem.AccountingDocument    = _JCN.AccountingDocument
  //                                                                              and JournalItem.AccountingDocumentItem = _JCN.AccountingDocumentItem
                                                                              and _JCN.TransactionTypeDetermination = 'JCN'

  association [0..1] to I_OperationalAcctgDocItem as _JSN                     on  JournalItem.CompanyCode           = _JSN.CompanyCode
                                                                              and JournalItem.FiscalYear            = _JSN.FiscalYear
                                                                              and JournalItem.AccountingDocument    = _JSN.AccountingDocument
  //                                                                              and JournalItem.AccountingDocumentItem = _JCN.AccountingDocumentItem
                                                                              and _JSN.TransactionTypeDetermination = 'JSN'

  association [0..1] to I_OperationalAcctgDocItem as _JIN                     on  JournalItem.CompanyCode           = _JIN.CompanyCode
                                                                              and JournalItem.FiscalYear            = _JIN.FiscalYear
                                                                              and JournalItem.AccountingDocument    = _JIN.AccountingDocument
  //                                                                              and JournalItem.AccountingDocumentItem = _JCN.AccountingDocumentItem
                                                                              and _JIN.TransactionTypeDetermination = 'JIN'

  association [0..1] to I_JournalEntryItem        as GetSupplier              on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                                              and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                                              and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                                              and GetSupplier.FinancialAccountType =  'K'
                                                                              and GetSupplier.Supplier             <> ''
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
      JournalItem.TransactionCurrency         as TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      JournalItem.AmountInTransactionCurrency as BaseAmount,
      JournalItem.GLAccountType               as GLAccountType,
      JournalItem.IsReversal                  as IsReversal,
      case
      //      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
      //        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'I1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'I2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
      //        or JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'I3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'I4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
        end                                   as SGST,
      case
      //      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
      //        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'I1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'R1'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'I2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
      //        or JournalItem.TaxCode = 'R2'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'I3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'R3'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'I4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'R4'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
       end                                    as CGST,
      case
      when JournalItem.TaxCode = 'I5'
        or JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
      //        or JournalItem.TaxCode = 'R5'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'I6'
      //         or JournalItem.TaxCode = 'R6'
         or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'I7'
      //         or JournalItem.TaxCode = 'R7'
         or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'I8'
      //         or JournalItem.TaxCode = 'R8'
         or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
        end                                   as IGST,

      case
           when  JournalItem.TaxCode = 'R1'
            then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.025)
           when  JournalItem.TaxCode = 'R2'
            then (cast(JournalItem.AmountInTransactionCurrency * -1  as abap.fltp)*0.06)
           when  JournalItem.TaxCode = 'R3'
            then (cast(JournalItem.AmountInTransactionCurrency * -1  as abap.fltp)*0.09)
           when  JournalItem.TaxCode = 'R4'
            then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.14)

            when ( JournalItem.TaxCode between 'S1' and 'S4' and _OperationalAcctgDocItem.TransactionTypeDetermination = ' ' )
            then  (cast(_JCN.AmountInCompanyCodeCurrency * -1 as abap.fltp ))

            end                               as RCGST,

      case
      //      when JournalItem.TaxCode = 'R0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when  JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.025)
      when  JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency * -1  as abap.fltp)*0.06)
      when  JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency * -1  as abap.fltp)*0.09)
      when  JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.14)

       when ( JournalItem.TaxCode between 'S1' and 'S4' and _OperationalAcctgDocItem.TransactionTypeDetermination = ' ' )
            then  (cast(_JSN.AmountInCompanyCodeCurrency * -1 as abap.fltp ))

        end                                   as RSGST,

      case
      when JournalItem.TaxCode = 'R5'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.05)
      when  JournalItem.TaxCode = 'R6'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.12)
      when  JournalItem.TaxCode = 'R7'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.18)
      when  JournalItem.TaxCode = 'R8'
       then (cast(JournalItem.AmountInTransactionCurrency * -1 as abap.fltp)*0.28)

             when ( JournalItem.TaxCode between 'S5' and 'S8' and _OperationalAcctgDocItem.TransactionTypeDetermination = ' ' )
                  then  (cast(_JIN.AmountInCompanyCodeCurrency * -1 as abap.fltp ))

        end                                   as RIGST,
      case
      //      when JournalItem.TaxCode = 'R0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when  JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when  JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency   as abap.fltp)*0.06)
      when  JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency   as abap.fltp)*0.09)
      when  JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
        end                                   as RSGSTO,
      case
      //      when JournalItem.TaxCode = 'R0'
      //       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when  JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when  JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency   as abap.fltp)*0.06)
      when  JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency   as abap.fltp)*0.09)
      when  JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
       end                                    as RCGSTO,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      when  JournalItem.TaxCode = 'R6'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      when  JournalItem.TaxCode = 'R7'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      when  JournalItem.TaxCode = 'R8'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
        end                                   as RIGSTO,
      //            @Semantics: { amount : {currencyCode: 'AmountInFunctionalCurrency'} }
      //      @Semantics.amount.currencyCode:'AmountInFunctionalCurrency'
      //      @Semantics.currencyCode: true
      //      JournalItem.AmountInFunctionalCurrency as AmountInFunctionalCurrency,
      JournalItem.AccountingDocumentType      as AccountingDocumentType,
      GetSupplier.Supplier                    as Supplier,
      _OperationalAcctgDocItem.TransactionTypeDetermination
}
where
       JournalItem.IsReversal             <> 'X'
  and  JournalItem.IsReversed             <> 'X'
  and  JournalItem.OffsettingAccount      <> ''
  and(
       JournalItem.AccountingDocumentType =  'KG'
    or JournalItem.AccountingDocumentType =  'KR'
  )
