@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM RODTEP Table for data definition'
@Metadata.allowExtensions: true
define root view entity ZEX_RODTEP_MASTER as select from zexi_rodtep_mast

{
    key sap_uuid as SAP_UUID,
    id as ID,
    companycode as CompanyCode,
    companyname as CompanyName,
    materialcode as MaterialCode,
    materialdescription as MaterialDescription,
    rodtepcode as RODTEPCode,
    rodtepfrom as RODTEPFrom,
    rodteprate as RODTEPRate,
    valuecap as ValueCap,
    description as Description,
    status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
    
}
