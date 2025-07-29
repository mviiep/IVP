@AbapCatalog.sqlViewName: 'ZGECOMPANYADD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Company address'
define view ZGE_COMPANY_ADD as select from I_CompanyCode
{
    key CompanyCode,
    CompanyCodeName as CompanyName,
    Company
    
}
