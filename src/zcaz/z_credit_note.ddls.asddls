@AbapCatalog.sqlViewName: 'ZI_CREDIT_NOTE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for cust Credit note data'
define view z_credit_note
  as select distinct from I_OperationalAcctgDocItem as DEBIT
  association [0..1] to I_Customer                as customer          on  DEBIT.Customer = customer.Customer
  //   association [0..1] to  YY1_Customerdetail     as cuspan          on  DEBIT.Customer = cuspan.Customer
  association [0..1] to I_OperationalAcctgDocItem as CGST              on  DEBIT.AccountingDocument            = CGST.AccountingDocument
                                                                       and DEBIT.TaxItemGroup                  = CGST.TaxItemGroup

  //                                                                      and DEBIT.AccountingDocumentItem      = CGST.AccountingDocumentItem
                                                                       and CGST.FiscalYear                     = DEBIT.FiscalYear
                                                                       and (
                                                                          CGST.TransactionTypeDetermination    = 'JIC'
                                                                          or CGST.TransactionTypeDetermination = 'JCN'
                                                                          or CGST.TransactionTypeDetermination = 'JOC'
                                                                        )
  association [0..1] to I_OperationalAcctgDocItem as IGST              on  DEBIT.AccountingDocument            = IGST.AccountingDocument
                                                                       and DEBIT.TaxItemGroup                  = IGST.TaxItemGroup
                                                                       and IGST.FiscalYear                     = DEBIT.FiscalYear
                                                                       and (
                                                                          IGST.TransactionTypeDetermination    = 'JII'
                                                                          or IGST.TransactionTypeDetermination = 'JIN'
                                                                          or IGST.TransactionTypeDetermination = 'JOI'
                                                                        )

  association [0..1] to I_OperationalAcctgDocItem as WIT               on  DEBIT.AccountingDocument         = WIT.AccountingDocument
                                                                       and WIT.FiscalYear                   = DEBIT.FiscalYear
                                                                       and WIT.TransactionTypeDetermination = 'WIT'

  association [0..1] to I_OperationalAcctgDocItem as taxable           on  DEBIT.AccountingDocument             = taxable.AccountingDocument
                                                                       and DEBIT.AccountingDocumentItem         = taxable.AccountingDocumentItem
                                                                       and taxable.FiscalYear                   = DEBIT.FiscalYear
                                                                       and taxable.TransactionTypeDetermination = ' '

  association [0..1] to I_OperationalAcctgDocItem as documentitemtext  on  DEBIT.AccountingDocument                      = documentitemtext.AccountingDocument
                                                                       and DEBIT.AccountingDocumentItem                  = documentitemtext.AccountingDocumentItem
                                                                       and documentitemtext.FiscalYear                   = DEBIT.FiscalYear
                                                                       and documentitemtext.TransactionTypeDetermination = ' '

  association [0..1] to I_OperationalAcctgDocItem as documentitemtext1 on  DEBIT.AccountingDocument                 = documentitemtext1.AccountingDocument
  //                                                                       and DEBIT.AccountingDocumentItem                   = documentitemtext1.AccountingDocumentItem
                                                                       and documentitemtext1.FiscalYear             = DEBIT.FiscalYear
  //                                                                       and documentitemtext1.TransactionTypeDetermination = ' '
                                                                       and (
                                                                          documentitemtext1.FinancialAccountType    = 'K'
                                                                          or documentitemtext1.FinancialAccountType = 'D'
                                                                        )

  association [0..1] to I_OperationalAcctgDocItem as HSNCODE           on  DEBIT.AccountingDocument             = HSNCODE.AccountingDocument
                                                                       and HSNCODE.FiscalYear                   = DEBIT.FiscalYear
                                                                       and HSNCODE.TransactionTypeDetermination = ' '
{
  key DEBIT.AccountingDocument                                                                                                                                                                                                                                                                                                                                                                                as ACCOUNTINGDOCUMENT,
  key DEBIT.AccountingDocumentItem                                                                                                                                                                                                                                                                                                                                                                            as AccountingDocumentItem,
  key DEBIT.CompanyCode                                                                                                                                                                                                                                                                                                                                                                                       as companycode,
  key DEBIT.FiscalYear                                                                                                                                                                                                                                                                                                                                                                                        as FiscalYear,
  key CGST.AmountInTransactionCurrency                                                                                                                                                                                                                                                                                                                                                                        as CGST,
  key IGST.AmountInTransactionCurrency                                                                                                                                                                                                                                                                                                                                                                        as IGST,
      case
      when WIT.AmountInTransactionCurrency > 0
      then WIT.AmountInTransactionCurrency * -1
      else WIT.AmountInTransactionCurrency end                                                                                                                                                                                                                                                                                                                                                                as TDS,
      DEBIT.AccountingDocumentType                                                                                                                                                                                                                                                                                                                                                                            as AccountingDocumentType,
      DEBIT.PostingDate                                                                                                                                                                                                                                                                                                                                                                                       as postingdate,
      customer.AddressSearchTerm1                                                                                                                                                                                                                                                                                                                                                                             as addresss1,
      //      customer.BPAddrStreetName                                as BPAddrstreetName,
      concat_with_space(concat_with_space(concat_with_space(customer._AddressRepresentation.StreetPrefixName1, concat_with_space(customer.BPAddrStreetName, ( concat_with_space(customer.BPAddrCityName, customer.PostalCode, 1 )),1),1), customer._AddressRepresentation._Region._RegionText[ Language = 'E' ].RegionName,1),customer._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName,1) as BPAddrstreetName,
      customer.CustomerName                                                                                                                                                                                                                                                                                                                                                                                   as customername,
      customer.CustomerName                                                                                                                                                                                                                                                                                                                                                                                   as suppliername,
      ltrim(customer.Customer, '0')                                                                                                                                                                                                                                                                                                                                                                           as supplier1,
      ltrim(DEBIT.Customer  , '0')                                                                                                                                                                                                                                                                                                                                                                            as customer1,
      customer._CorrespondingSupplier.BusinessPartnerPanNumber                                                                                                                                                                                                                                                                                                                                                as pannumber,
      customer.TaxNumber3                                                                                                                                                                                                                                                                                                                                                                                     as gst,
      documentitemtext.DocumentItemText                                                                                                                                                                                                                                                                                                                                                                       as DocumentItemText,
      documentitemtext1.DocumentItemText                                                                                                                                                                                                                                                                                                                                                                      as DocumentText,
      taxable.AmountInTransactionCurrency                                                                                                                                                                                                                                                                                                                                                                     as taxable,
      case
      when CGST.TransactionTypeDetermination = 'JCN' or CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JOC'
      then CGST.TransactionTypeDetermination
      when IGST.TransactionTypeDetermination = 'JIN' or IGST.TransactionTypeDetermination = 'JII' or IGST.TransactionTypeDetermination = 'JOI'
      then IGST.TransactionTypeDetermination end                                                                                                                                                                                                                                                                                                                                                              as TaxCondition,
      DEBIT.TaxCode                                                                                                                                                                                                                                                                                                                                                                                           as taxcode,
      HSNCODE.IN_HSNOrSACCode                                                                                                                                                                                                                                                                                                                                                                                 as HSNCODE
      //      (case when DEBIT.TransactionTypeDetermination = 'JIC'
      //      then   DEBIT.AmountInTransactionCurrency
      //      end )                                        as CGST,

      //      (case when DEBIT.TransactionTypeDetermination = 'JII'
      //      then   DEBIT.AmountInTransactionCurrency
      //      end )                                        as IGST,
      //
      //      (case when DEBIT.TransactionTypeDetermination  = ' '
      //      then DEBIT.AmountInTransactionCurrency  end) as taxable,
      //
      //      (case when DEBIT.TransactionTypeDetermination  = ' '
      //      then DEBIT.IN_HSNOrSACCode  end)             as HSN,


      //      (case when DEBIT.TransactionTypeDetermination = ' '
      //      then DEBIT.DocumentItemText end)             as DocumentItemText


}

where
      DEBIT.TransactionTypeDetermination <> 'DIF'
  //      DEBIT.TransactionTypeDetermination = ' '
  //where
  and DEBIT.TaxCode                      <> ' '
//  and IGST.TransactionTypeDetermination  <>  'JOI'
//  and CGST.TransactionTypeDetermination  <>  'JOC'
