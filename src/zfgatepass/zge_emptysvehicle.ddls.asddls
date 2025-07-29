@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Empty Vehicle'
@Metadata.allowExtensions: true
define root view entity ZGE_EMPTYSVEHICLE as select from zge_emptsvehicle

{
      key sap_uuid as SAP_UUID,
    id as Id,
    plant as Plant,
    plantname as PlantName,
    transporter as Transporter,
    vehicleno as VehicleNo,
    vehicletype as VehicleType,
    weightdate as WeightDate,
    weighttime as WeightTime,
    suppliercode as SupplierCode,
    suppliername as SupplierName,
    customercode as CustomerCode,
    customername as CustomerName,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    tareweight as TareWeight,
    remarks  as Remarks,
    status as Status,
     weighttimes as WeightTimes,
       vehicleintimes  as VehicleInTimes,
  vehicleoutimes   as vehicleoutimes,
  vehiclestatus    as VehicleStatus,
  vehicleindate    as VehicleInDate,
  vehicleoutdate    as VehicleOutDate
}
