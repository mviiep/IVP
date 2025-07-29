@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zi_SOAPAPI_item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_SOAPAPI_item
  as select from zdb_soapapi_item as item
  association to parent Zi_SOAPAPI as header on  $projection.companycode        = header.Companycode
                                             and $projection.accountingdocument = header.Accountingdocument
{
  key  referencedocumentitem,
  key  companycode,
  key  documentreferenceid,
  key  accountingdocument,
       glaccount,
       currency,
//       @Semantics.amount.currencyCode: 'currency'
       amountintransactioncurrency,
       debitcreditcode,
       documentitemtext,
       housebank,
       housebankaccount,
       profitcenter,
       header
}
