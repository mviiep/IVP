@AbapCatalog.sqlViewName: 'ZGETRANSPORTER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Transporter'
define view ZGE_TRANSPORTER as select distinct from I_BusinessPartnerSupplier as ZBPS
left outer join I_BusinessPartner as ZBP on ZBPS.BusinessPartner = ZBP.BusinessPartner
left outer join  I_BusinessPartnerType as ZBPT on ZBP.BusinessPartnerType = ZBPT.BusinessPartnerType

{
    key ZBPS.BusinessPartner,
    ZBPS.Supplier,
    ZBPS.SupplierAccountGroup,
    ZBP.BusinessPartnerName,
    ZBPT.BusinessPartnerType
}
