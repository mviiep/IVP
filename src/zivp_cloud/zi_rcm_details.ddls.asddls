@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RCM Details for GSTR1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RCM_DETAILS
  as select from I_OperationalAcctgDocItem
{
  key AccountingDocument,
  key AccountingDocumentItem,
  key FiscalYear,
  key CompanyCode,
      case when TaxItemGroup is not initial then
      concat('000',TaxItemGroup) end as TaxItem,
      TransactionTypeDetermination,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TaxBaseAmountInCoCodeCrcy
}
where
      AccountingDocumentItemType   = 'T'
  and TransactionTypeDetermination = 'JRC'
  or TransactionTypeDetermination = 'JRS'
  or TransactionTypeDetermination = 'JRI'
