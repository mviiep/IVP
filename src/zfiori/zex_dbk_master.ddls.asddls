@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM DATA Table for data definition'
@Metadata.allowExtensions: true
define root view entity ZEX_DBK_MASTER as select from zexi_dbk_master

{
     key sap_uuid as SAP_UUID,
    id as ID,
    companycode as CompanyCode,
    companyname as CompanyName,
    materialcode as MaterialCode,
    materialdescription as MaterialDescription,
    dbkcode as DBKCode,
    dbkfrom as DBKFrom,
    dbkrate as DBKRate,
    valuecap as ValueCap,
    description as Description,
    status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt

}
