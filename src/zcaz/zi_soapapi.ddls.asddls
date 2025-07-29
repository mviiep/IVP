@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Zi_SOAPAPI'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK", "KEY_CHECK" ]  } */
define root view entity Zi_SOAPAPI
  as select from zdb_soapapi as header
  composition [0..*] of Zi_SOAPAPI_item as item
{
  key companycode         as Companycode,
  key accountingdocument  as Accountingdocument,
      documentreferenceid as Documentreferenceid,
      documentdate,
      fiscalyear,
      originalreferencedocumenttype,
      originalrefdoclogicalsystem,
      businesstransactiontype,
      accountingdocumenttype,
      documentheadertext,
      createdbyuser,
      postingdate,
      postingfiscalperiod,
      taxreportingdate,
      taxdeterminationdate,
      item
}
