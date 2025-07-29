@AbapCatalog.sqlViewName: 'ZI_DEBITCREDITNT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Debit Credit Note Data in adobe form'
define view z_debitcredit_note
  as select distinct from I_OperationalAcctgDocItem as DEBIT
  association [0..1] to Z_debitcredit_custsup     as supplier             on  DEBIT.AccountingDocument = supplier.ACCOUNTINGDOCUMENT
  association [0..1] to I_OperationalAcctgDocItem as CGST                 on  DEBIT.AccountingDocument            = CGST.AccountingDocument
                                                                          and DEBIT.TaxItemGroup                  = CGST.TaxItemGroup

  //                                                                      and DEBIT.AccountingDocumentItem      = CGST.AccountingDocumentItem
                                                                          and CGST.FiscalYear                     = DEBIT.FiscalYear
                                                                          and (
                                                                             CGST.TransactionTypeDetermination    = 'JIC'
                                                                             or CGST.TransactionTypeDetermination = 'JCN'
                                                                           )
  association [0..1] to I_OperationalAcctgDocItem as IGST                 on  DEBIT.AccountingDocument            = IGST.AccountingDocument
  //                                                                      and DEBIT.AccountingDocumentItem      = IGST.AccountingDocumentItem
                                                                          and IGST.FiscalYear                     = DEBIT.FiscalYear
                                                                          and (
                                                                             IGST.TransactionTypeDetermination    = 'JII'
                                                                             or IGST.TransactionTypeDetermination = 'JIN'
                                                                           )

  association [0..1] to I_OperationalAcctgDocItem as WIT                  on  DEBIT.AccountingDocument         = WIT.AccountingDocument
                                                                          and WIT.FiscalYear                   = DEBIT.FiscalYear
                                                                          and WIT.TransactionTypeDetermination = 'WIT'

  association [0..1] to I_OperationalAcctgDocItem as taxable              on  DEBIT.AccountingDocument               = taxable.AccountingDocument
                                                                          and DEBIT.AccountingDocumentItem           = taxable.AccountingDocumentItem
                                                                          and taxable.FiscalYear                     = DEBIT.FiscalYear
                                                                          and (
                                                                             taxable.TransactionTypeDetermination    = ' '
                                                                             or taxable.TransactionTypeDetermination = 'KBS'
                                                                           )

  association [0..1] to I_OperationalAcctgDocItem as documentitemtext     on  DEBIT.AccountingDocument                      = documentitemtext.AccountingDocument
                                                                          and DEBIT.AccountingDocumentItem                  = documentitemtext.AccountingDocumentItem
                                                                          and documentitemtext.FiscalYear                   = DEBIT.FiscalYear
                                                                          and documentitemtext.TransactionTypeDetermination = ' '
                                                                          and documentitemtext.FinancialAccountType         = 'S'

  association [0..1] to I_OperationalAcctgDocItem as documentitemtextrepl on  DEBIT.AccountingDocument                  = documentitemtextrepl.AccountingDocument
                                                                          and DEBIT.AccountingDocumentItem              = documentitemtextrepl.AccountingDocumentItem
                                                                          and documentitemtextrepl.FiscalYear           = DEBIT.FiscalYear
                                                                          and documentitemtextrepl.FinancialAccountType = 'S'

  association [0..1] to I_OperationalAcctgDocItem as documentitemtext1    on  DEBIT.AccountingDocument               = documentitemtext1.AccountingDocument
  //                                                                       and DEBIT.AccountingDocumentItem                   = documentitemtext1.AccountingDocumentItem
                                                                          and documentitemtext1.FiscalYear           = DEBIT.FiscalYear
  //                                                                       and documentitemtext1.TransactionTypeDetermination = ' '
                                                                          and documentitemtext1.FinancialAccountType = 'K'

  association [0..1] to I_OperationalAcctgDocItem as HSNCODE              on  DEBIT.AccountingDocument             = HSNCODE.AccountingDocument
                                                                          and DEBIT.AccountingDocumentItem         = HSNCODE.AccountingDocumentItem
                                                                          and HSNCODE.FiscalYear                   = DEBIT.FiscalYear
                                                                          and HSNCODE.TransactionTypeDetermination = ' '
  //                                                                      and HSNCODE._GLAccountInChartOfAccounts.GLAccountType =  'P'

{
  key DEBIT.AccountingDocument                     as ACCOUNTINGDOCUMENT,
  key DEBIT.AccountingDocumentItem                 as AccountingDocumentItem,
  key DEBIT.CompanyCode                            as companycode,
  key DEBIT.FiscalYear                             as FiscalYear,

  key case when CGST.AmountInTransactionCurrency < 0
       then CGST.AmountInTransactionCurrency * -1
       else CGST.AmountInTransactionCurrency end   as CGST,

      //  key CGST.AmountInTransactionCurrency             as CGST1,

  key case when IGST.AmountInTransactionCurrency < 0
        then IGST.AmountInTransactionCurrency * -1
        else IGST.AmountInTransactionCurrency end  as IGST,

      //  key IGST.AmountInTransactionCurrency             as IGST2,

      case
      when WIT.AmountInTransactionCurrency > 0
      then WIT.AmountInTransactionCurrency * -1
      else WIT.AmountInTransactionCurrency end     as TDS,
      DEBIT.AccountingDocumentType                 as AccountingDocumentType,
      DEBIT.PostingDate                            as postingdate,
      supplier.AddressSearchTerm1                  as addresss1,
      supplier.BPAddrstreetName                    as BPAddrstreetName,
      supplier.SupplierFullName                    as suppliername,
      ltrim(supplier.supplier1, '0')               as supplier1,
      supplier.BusinessPartnerPanNumber            as pannumber,
      supplier.TaxNumber3                          as gst,
      case
      when documentitemtext.DocumentItemText is not initial
      then  documentitemtext.DocumentItemText
      else documentitemtextrepl.DocumentItemText
       end                                         as DocumentItemText,
      //      documentitemtextrepl.DocumentItemText    as test,
      //      documentitemtext.DocumentItemText        as DocumentItemText,
      documentitemtext1.DocumentItemText           as DocumentText,
      //      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }

      taxable.AmountInTransactionCurrency          as taxable,
      case
        when CGST.TransactionTypeDetermination = 'JCN' or CGST.TransactionTypeDetermination = 'JIC'
        then CGST.TransactionTypeDetermination
        when IGST.TransactionTypeDetermination = 'JIN' or IGST.TransactionTypeDetermination = 'JII'
        then IGST.TransactionTypeDetermination end as TaxCondition,
      DEBIT.TaxCode                                as taxcode,
      HSNCODE.IN_HSNOrSACCode                      as HSNCODE


}
where
      DEBIT._GLAccountInChartOfAccounts.GLAccountType =  'P'
  and DEBIT.TransactionTypeDetermination              <> 'DIF'
