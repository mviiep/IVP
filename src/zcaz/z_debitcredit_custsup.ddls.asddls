@AbapCatalog.sqlViewName: 'ZZI_DEBCRED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for creditdebit cust or suppl details'
define view Z_debitcredit_custsup
  as select distinct from I_OperationalAcctgDocItem as DEBIT
  association [0..1] to I_Supplier                as supplier         on  DEBIT.Supplier = supplier.Supplier
  association [0..1] to I_OperationalAcctgDocItem as CGST             on  DEBIT.AccountingDocument          = CGST.AccountingDocument
                                                                      and DEBIT.AccountingDocumentItem      = CGST.AccountingDocumentItem
                                                                      and CGST.FiscalYear                   = DEBIT.FiscalYear
                                                                      and CGST.TransactionTypeDetermination = 'JIC'
  association [0..1] to I_OperationalAcctgDocItem as IGST             on  DEBIT.AccountingDocument          = IGST.AccountingDocument
                                                                      and DEBIT.AccountingDocumentItem      = IGST.AccountingDocumentItem
                                                                      and IGST.FiscalYear                   = DEBIT.FiscalYear
                                                                      and IGST.TransactionTypeDetermination = 'JII'

  association [0..1] to I_OperationalAcctgDocItem as taxable          on  DEBIT.AccountingDocument             = taxable.AccountingDocument
                                                                      and DEBIT.AccountingDocumentItem         = taxable.AccountingDocumentItem
                                                                      and taxable.FiscalYear                   = DEBIT.FiscalYear
                                                                      and taxable.TransactionTypeDetermination = ' '

  association [0..1] to I_OperationalAcctgDocItem as documentitemtext on  DEBIT.AccountingDocument                      = documentitemtext.AccountingDocument
                                                                      and DEBIT.AccountingDocumentItem                  = documentitemtext.AccountingDocumentItem
                                                                      and documentitemtext.FiscalYear                   = DEBIT.FiscalYear
                                                                      and documentitemtext.TransactionTypeDetermination = ' '

  association [0..1] to I_OperationalAcctgDocItem as HSNCODE          on  DEBIT.AccountingDocument             = HSNCODE.AccountingDocument
                                                                      and DEBIT.AccountingDocumentItem         = HSNCODE.AccountingDocumentItem
                                                                      and HSNCODE.FiscalYear                   = DEBIT.FiscalYear
                                                                      and HSNCODE.TransactionTypeDetermination = ' '
  //                                                                      and HSNCODE._GLAccountInChartOfAccounts.GLAccountType =  'P'

{
  key DEBIT.AccountingDocument                                                                                                                                                                                                                                                                                 as ACCOUNTINGDOCUMENT,
  key DEBIT.AccountingDocumentItem                                                                                                                                                                                                                                                                             as AccountingDocumentItem,
  key DEBIT.CompanyCode                                                                                                                                                                                                                                                                                        as companycode,
  key DEBIT.FiscalYear                                                                                                                                                                                                                                                                                         as FiscalYear,
  key CGST.AmountInTransactionCurrency                                                                                                                                                                                                                                                                         as CGST,
  key IGST.AmountInTransactionCurrency                                                                                                                                                                                                                                                                         as IGST,
      DEBIT.AccountingDocumentType                                                                                                                                                                                                                                                                             as AccountingDocumentType,
      DEBIT.PostingDate                                                                                                                                                                                                                                                                                        as postingdate,
      supplier.AddressSearchTerm1                                                                                                                                                                                                                                                                              as AddressSearchTerm1,
      //      supplier.BPAddrStreetName                                                                                              as BPAddrstreetName,
//      concat_with_space(concat_with_space(concat_with_space(supplier._AddressRepresentation.StreetPrefixName1, concat_with_space(supplier.BPAddrStreetName, ( concat_with_space(supplier.BPAddrCityName, supplier.PostalCode, 1 )),1),1), supplier._AddressRepresentation._Region._RegionText[ Language = 'E' ].RegionName,1),supplier._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName,1) as BPAddrstreetName,
//      concat(supplier._AddressRepresentation.StreetPrefixName1, concat(',',concat(supplier.BPAddrStreetName, concat(',', concat(supplier.BPAddrCityName,','))))) as test,
      concat(supplier._AddressRepresentation.StreetPrefixName1 ,concat(',',concat( supplier.BPAddrStreetName,concat(',', concat(concat(supplier.BPAddrCityName,'-'),concat( supplier.PostalCode , concat(',', concat(supplier._AddressRepresentation._Region._RegionText[ Language = 'E' ].RegionName, concat(',', supplier._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName ))))))))) as BPAddrstreetName,
//      concat_with_space(concat_with_space(concat_with_space(supplier._AddressRepresentation.StreetPrefixName1, concat_with_space(supplier.BPAddrStreetName, ( concat_with_space(supplier.BPAddrCityName, supplier.PostalCode, 1 )),1),1), supplier._AddressRepresentation._Region._RegionText[ Language = 'E' ].RegionName,1),supplier._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName,1) as BPAddrstreetName,
//      supplier._AddressRepresentation.StreetPrefixName1,
//      supplier._AddressRepresentation._Region._RegionText[ Language = 'E' ].RegionName,
//      supplier._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName,
      //      supplier.PostalCode                 as PostalCode,
      supplier.SupplierName                                                                                                                                                                                                                                                                                    as SupplierFullName,
      DEBIT.Supplier                                                                                                                                                                                                                                                                                           as supplier1,
      supplier.BusinessPartnerPanNumber                                                                                                                                                                                                                                                                        as BusinessPartnerPanNumber,
      supplier.TaxNumber3                                                                                                                                                                                                                                                                                      as TaxNumber3,
      //      DEBIT.CompanyCodeCurrency           as CompanyCodeCurrency,
      //      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      //      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'}
      documentitemtext.DocumentItemText                                                                                                                                                                                                                                                                        as DocumentItemText,
      //      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }

      taxable.AmountInTransactionCurrency                                                                                                                                                                                                                                                                      as taxable,
      DEBIT.TaxCode                                                                                                                                                                                                                                                                                            as taxcode,
      HSNCODE.IN_HSNOrSACCode                                                                                                                                                                                                                                                                                  as HSNCODE

}
where
  //      DEBIT._GLAccountInChartOfAccounts.GLAccountType =  'P'
  ////  and
  supplier.Supplier <> ' '
