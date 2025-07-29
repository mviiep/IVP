@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Subsequent Debit Credit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_Subsequent_debitcredit
  as select distinct from I_JournalEntryItem as journalentryitem
  association [0..1] to I_OperationalAcctgDocItem as _OperationalAcctgDocItem on  journalentryitem.CompanyCode            = _OperationalAcctgDocItem.CompanyCode
                                                                              and journalentryitem.FiscalYear             = _OperationalAcctgDocItem.FiscalYear
                                                                              and journalentryitem.AccountingDocument     = _OperationalAcctgDocItem.AccountingDocument
                                                                              and journalentryitem.AccountingDocumentItem = _OperationalAcctgDocItem.AccountingDocumentItem

  association [0..1] to I_JournalEntry            as journalentry             on  journalentryitem.CompanyCode        = journalentry.CompanyCode
                                                                              and journalentryitem.FiscalYear         = journalentry.FiscalYear
                                                                              and journalentryitem.AccountingDocument = journalentry.AccountingDocument

  association [0..1] to I_Supplier                as supplier                 on  journalentryitem.Supplier = supplier.Supplier
  association [0..1] to I_Plant                   as Plant                    on  journalentryitem.Plant = Plant.Plant

{
  key AccountingDocument,
  key journalentryitem.AccountingDocumentItem,
  key FiscalYear,
  key CompanyCode,
      journalentryitem.PurchasingDocument,
      journalentryitem.PurchasingDocumentItem,
      journalentryitem.InvoiceReference,
      DocumentDate,
      journalentry.PostingDate,
      journalentryitem.Supplier,
      journalentryitem.TaxCode,
      journalentryitem.PostingKey,
      journalentry.DocumentReferenceID,
      journalentry.AccountingDocumentHeaderText,
      
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
      supplier.TaxNumber3 as GSTNumber,
      supplier._AddressDefaultRepresentation._EmailAddress.EmailAddress,

      journalentryitem.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      _OperationalAcctgDocItem.AmountInCompanyCodeCurrency

}
