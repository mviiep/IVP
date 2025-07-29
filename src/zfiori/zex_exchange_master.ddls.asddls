@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Exchange Master'
@Metadata.allowExtensions: true
define root view entity ZEX_EXCHANGE_MASTER as select from zexi_exchan_mast

{
    key sap_uuid as SAP_UUID,
    id as ID,
    currency as Currency,
    excfrom as ExcFrom,
    excrate as ExcRate,
     status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
    
}
