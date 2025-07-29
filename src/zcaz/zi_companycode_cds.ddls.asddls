@AbapCatalog.sqlViewName: 'ZICOMPANYCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Company address'
define view ZI_COMPANYCODE_CDS as select from I_CompanyCode
{
    key CompanyCode,
    CompanyCodeName as CompanyName,
    Company
    
}
