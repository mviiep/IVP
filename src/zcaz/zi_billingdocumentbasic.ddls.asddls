@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Z table for Billing Document Basic'
define view entity Zi_billingdocumentbasic
  as select distinct from I_BillingDocumentBasic
{
  key BillingDocument,
      BillingDocumentDate,
      PurchaseOrderByCustomer,
      IncotermsClassification,
      IncotermsLocation1,
      TransactionCurrency,
      CustomerPaymentTerms,
      SoldToParty,
      AccountingExchangeRate

}
