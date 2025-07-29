@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Export Document Details Item DD'
@Metadata.allowExtensions: true
define root view entity ZEXI_EXPORT_DOC_ITEM as select from zexi_expt_docite

{
    key sap_uuid as SAP_UUID,
    id as ID,
    material as Material,
    description as Description,
    billedquantity as BilledQuantity,
    uom as UOM,
    status as Status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
}
