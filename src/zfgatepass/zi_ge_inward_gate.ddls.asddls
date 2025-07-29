@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Inward Gate Data Def'
@Metadata.allowExtensions: true
define root view entity ZI_GE_INWARD_GATE as select from zge_inward_gate

{
    key sap_uuid        as SAP_UUID,
  key id              as Id,
      status          as Status,
      screencode      as ScreenCode,
      approvestatus   as ApproveStatus,
      vehicleno       as VehicleNo,
      vehicletype     as VehicleType,
      transporter     as Transporter,
      transportermode as TransporterMode,
      gateentrydate   as GateEntryDate,
      grossweight     as GrossWeight,
      netweight       as NetWeight,
      tareweight      as TareWeight,
      remarks         as Remarks,
      ewaybill        as EWayBill,
      invoiceno       as InvoiceNo,
      invoicedate     as InvoiceDate,
      lrno            as LRNo,
      lrdate          as LRDate,
      noofpackages    as NoOfPackages,
      postingdate     as PostingDate,
      vehicleintime as VehicleInTime,
      vehicleoutime as VehicleOutTime,
      vehicleloadtime as VehicleLoadTime,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      actualgrossweight as ActualGrossWeight,
       weighttime        as WeightTime,
      weightdate        as WeightDate,
   vehicleintimes  as VehicleInTimes,
  vehicleoutimes   as vehicleoutimes,
  vehiclestatus    as VehicleStatus,
  vehicleindate    as VehicleInDate,
  vehicleoutdate    as VehicleOutDate,
  
  tareweightdate as tareweightdate,
  tareweighttime as tareweighttime,
  grossweightdate as grossweightdate,
  grossweighttime as grossweighttime,
  creationdate as creationdate

}
