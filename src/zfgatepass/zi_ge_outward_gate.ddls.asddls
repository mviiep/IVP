@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Outward Gate'
@Metadata.allowExtensions: true
define root view entity ZI_GE_OUTWARD_GATE as select from zge_outward_gate

{
      key sap_uuid          as SAP_UUID,
    key id                as Id,
  
      ewaybill          as EWayBill,
      gateenrtydate     as GateEnrtyDate,
      gateenrtydate0     as GateEnrtyDate0,
      vehicletype       as VehicleType,
      vehicleno         as VehicleNo,
      invoiceno         as InvoiceNo,
      invoicedate       as InvoiceDate,
      transporter       as Transporter,
      transportermode   as TransporterMode,
      lrno              as LRNo,
      lrdate            as LRDate,
      grossweight       as GrossWeight,
      weighttime        as WeightTime,
      weightdate        as WeightDate,
      noofpackages      as NoOfPackages,
      remarks           as Remarks,
      status            as Status,
      screencode        as ScreenCode,
      tareweight        as TareWeight,
      netweight         as NetWeight,
      deldocgrossweight as DelDocGrossWeight,
      
       vehicleintime as VehicleInTime,
      vehicleoutime as VehicleOutTime,
      vehicleloadtime as VehicleLoadTime,
      challanno         as ChallanNo,
      challandate       as ChallanDate,
      emptyvechicleno as EmptyVechicleNo,
      @Semantics.user.createdBy: true
      created_by        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by   as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at   as LastChangedAt,
        actualgrossweight as ActualGrossWeight,
        
              vehicleintimes  as VehicleInTimes,
  vehicleoutimes   as vehicleoutimes,
  vehiclestatus    as VehicleStatus,
  vehicleindate    as VehicleInDate,
  vehicleoutdate    as VehicleOutDate
}
