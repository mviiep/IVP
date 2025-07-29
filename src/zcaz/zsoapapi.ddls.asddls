//@ObjectModel.query.implementedBy: 'ABAP:ZCL_SOAPAPI'
@EndUserText.label: 'Soap API Test'
define root custom entity ZSOAPAPI
{
  key companycode                   : abap.char(4);
      DocumentReferenceID           : abap.char(10);
      DocumentDate                  : abap.datn;
      AccountingDocument            : abap.char(10);
      FiscalYear                    : abap.char(4);
      OriginalReferenceDocumentType : abap.char(10);
      OriginalRefDocLogicalSystem   : abap.char(10);
      BusinessTransactionType       : abap.char(10);
      AccountingDocumentType        : abap.char(10);
      DocumentHeaderText            : abap.char(10);
      CreatedByUser                 : abap.char(10);
      PostingDate                   : abap.char(10);
      PostingFiscalPeriod           : abap.char(10);
      TaxReportingDate              : abap.char(10);
      TaxDeterminationDate          : abap.char(10);
}
