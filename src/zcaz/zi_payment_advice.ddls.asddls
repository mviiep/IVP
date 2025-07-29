@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Payment Advice'
define view entity Zi_payment_advice
  as select distinct from I_JournalEntryItem as journalentryitem
  association [0..1] to I_OperationalAcctgDocItem as _OperationalAcctgDocItem on  journalentryitem.CompanyCode            = _OperationalAcctgDocItem.CompanyCode
                                                                              and journalentryitem.FiscalYear             = _OperationalAcctgDocItem.FiscalYear
                                                                              and journalentryitem.AccountingDocument     = _OperationalAcctgDocItem.AccountingDocument
                                                                              and journalentryitem.AccountingDocumentItem = _OperationalAcctgDocItem.AccountingDocumentItem

  association [0..1] to I_JournalEntry            as _journalentry            on  journalentryitem.CompanyCode        = _journalentry.CompanyCode
                                                                              and journalentryitem.FiscalYear         = _journalentry.FiscalYear
                                                                              and journalentryitem.AccountingDocument = _journalentry.AccountingDocument

  association [0..1] to I_Supplier                as supplier                 on  journalentryitem.Supplier = supplier.Supplier
  association [0..1] to I_Plant                   as Plant                    on  journalentryitem.Plant = Plant.Plant

{
  key ClearingJournalEntry,
  key ClearingJournalEntryFiscalYear,
  key CompanyCode,
      DocumentDate,
      AccountingDocument,
      _OperationalAcctgDocItem.AccountingDocumentType,
      FiscalYear,
      _OperationalAcctgDocItem.FinancialAccountType,
      case
      when _OperationalAcctgDocItem.AccountingDocumentType = 'OP'
      then _OperationalAcctgDocItem.DocumentItemText
      else
      _journalentry.DocumentReferenceID end                                                                    as DocumentReferenceID,
      journalentryitem.PostingDate,
      journalentryitem.Supplier,
      journalentryitem.CompanyCodeCurrency,
      _journalentry.AccountingDocumentHeaderText,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case
      when _OperationalAcctgDocItem.AccountingDocumentType = 'KZ'
      and _OperationalAcctgDocItem.SpecialGLCode = 'A'
      then 0
      else
      cast( _OperationalAcctgDocItem.WithholdingTaxAmount as abap.dec( 10, 3 ) )           end                 as TDSDeduction,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      _OperationalAcctgDocItem.WithholdingTaxBaseAmount,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      _OperationalAcctgDocItem.AmountInCompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      case
      when _OperationalAcctgDocItem.AccountingDocumentType = 'KZ'
      and _OperationalAcctgDocItem.SpecialGLCode = 'A'
      then _OperationalAcctgDocItem.AmountInCompanyCodeCurrency
      else
      _OperationalAcctgDocItem.AmountInCompanyCodeCurrency + _OperationalAcctgDocItem.WithholdingTaxAmount end as GrossAmount,

      //      _OperationalAcctgDocItem.AmountInCompanyCodeCurrency as GrossAmount,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      //      case
      //      when _OperationalAcctgDocItem.WithholdingTaxAmount <> 0
      //      then _OperationalAcctgDocItem.WithholdingTaxBaseAmount - _OperationalAcctgDocItem.WithholdingTaxAmount
      //      else
      _OperationalAcctgDocItem.AmountInCompanyCodeCurrency                                                     as NetAmount,

      //Supplier Address
      supplier.SupplierName,
      supplier._AddressDefaultRepresentation.StreetName,
      supplier._AddressDefaultRepresentation.StreetPrefixName1,
      supplier._AddressDefaultRepresentation.StreetPrefixName2,
      supplier._AddressDefaultRepresentation.StreetSuffixName1,
      supplier._AddressDefaultRepresentation.StreetSuffixName2,
      supplier._AddressDefaultRepresentation.DistrictName,
      supplier._AddressDefaultRepresentation.CityName,
      supplier._AddressDefaultRepresentation.PostalCode,
//      supplier._AddressDefaultRepresentation._EmailAddress[ EmailAddressIsCurrentDefault = 'X' ].EmailAddress
      supplier._AddressDefaultRepresentation._EmailAddress.EmailAddress


}
where
      ClearingJournalEntry <> ' '
  and ClearingJournalEntry <> AccountingDocument
