@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for RGP NRGP DATA DEF'
@Metadata.allowExtensions: true
define root view entity ZI_GE_RGP_NRGP_HEAD as select from zrgp_nrgp_head

{
   key id as Id,
    key sap_uuid as SAP_UUID,
    gatepasstype as GatePassType,
    requestor as Requestor,
    plantcode as PlantCode,
    plantname as PlantName,
    suppliercode as SupplierCode,
    suppliername as SupplierName,
    suppliertype as SupplierType,
    customercode as CustomerCode,
    customername as CustomerName,
    customertype as CustomerType,
    valueininr as ValueInINR,
    vehicletype as VehicleType,
    vehicleno as VehicleNo,
    transporter as Transporter,
    transportermode as TransporterMode,
    purchaseorder as PurchaseOrder,
    materialdocument as MaterialDocument,
    referencedocumentno as ReferenceDocumentNo,
    remarks as Remarks,
    status as Status,
    approvestatus as ApproveStatus,
    gatestatus as GateStatus,
    totalamount as TotalAmount,
    gatetype as GateType,
    postingdate as PostingDate,
    nrstatus as NRStatus,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    returndate as returndate
}
