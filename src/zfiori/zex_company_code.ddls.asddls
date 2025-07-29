@AbapCatalog.sqlViewName: 'ZEXSQCOMPANYCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for company code'
define view ZEX_COMPANY_CODE as select from I_CompanyCode as ZCC
{
    key ZCC.CompanyCode as CompanyCode,
        ZCC.Company as Company,
        ZCC.Currency as Currency,
        ZCC.Language as Language
    
    
}
