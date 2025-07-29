@AbapCatalog.sqlViewName: 'ZIGEIWREPORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ForINWARDreportbasedonItembaseddatas'
define view ZI_GE_IW_REPORT as select distinct from ZI_GE_IW_ITEM as ZIWHEAD


association [0..1] to ZI_GE_MATDOC_FILTER as ZMATDOC on ZIWHEAD.Id = ZMATDOC.MaterialDocumentHeaderText 

{
    key ZIWHEAD.SAP_UUID,
    ZIWHEAD.Id, 
    ZIWHEAD.Root_Id,
    ZIWHEAD.ItemNo,
    ZIWHEAD.ReferenceDocument,
    ZIWHEAD.ReferenceDocumentType,
    ZIWHEAD.ProductCode,
    ZIWHEAD.ProductName,
    ZIWHEAD.ProductType,
    ZIWHEAD.OrderQuantity,
    ZIWHEAD.UOM,
    ZIWHEAD.OpenQuantity,
    ZIWHEAD.OpenQuantityUOM,
    ZIWHEAD.QuantityInGE,
    ZIWHEAD.QuantityInGEUOM,
    ZIWHEAD.PlantCode,
    ZIWHEAD.PlantName,
    ZIWHEAD.SupplierCode,
    ZIWHEAD.SupplierName,
    ZIWHEAD.SupplierType,
    ZIWHEAD.CustomerCode,
    ZIWHEAD.CustomerName,
    ZIWHEAD.CustomerType,
    ZIWHEAD.EWayBill,
    ZIWHEAD.GateEntryDate,
    ZIWHEAD.VehicleType,
    ZIWHEAD.VehicleNo,
    ZIWHEAD.InvoiceNo,
    ZIWHEAD.InvoiceDate,
    ZIWHEAD.Transporter,
    ZIWHEAD.TransporterMode,
    ZIWHEAD.LRNo,
    ZIWHEAD.LRDate,
    ZIWHEAD.GrossWeight,
    ZIWHEAD.TareWeight,
    ZIWHEAD.NetWeight,
    ZIWHEAD.WeightDateTime,
    ZIWHEAD.NoOfPackages,
    ZIWHEAD.Remarks,
    ZIWHEAD.Status,
    ZIWHEAD.ItemsStatus,
    ZIWHEAD.ApproveStatus,
    ZIWHEAD.PurchaseOrderNo,
    ZIWHEAD.DeliveryDocumentNo,
    ZIWHEAD.SalesReturnNo,
    ZIWHEAD.ScreenCode,
    ZIWHEAD.PostingDate,
    ZIWHEAD.ReferenceDocumentYear,
    ZIWHEAD.CreatedBy,
    ZIWHEAD.CreatedAt,
    ZIWHEAD.LastChangedBy,
    ZIWHEAD.LastChangedAt,
    ZIWHEAD.ActualGrossWeight,
    //ZIWHEAD.WeightTime,
    //ZIWHEAD.WeightDate,
    ZIWHEAD.VehicleInTimes,
    ZIWHEAD.vehicleoutimes,
    ZIWHEAD.VehicleStatus,
    ZIWHEAD.VehicleInDate,
    ZIWHEAD.VehicleOutDate,
    ZIWHEAD.tolerancepercentage,
    ZIWHEAD.tolerancewithorderqty,
    ZIWHEAD.tareweightdate as tareweightdate,
    ZIWHEAD.tareweighttime,
    ZIWHEAD.grossweightdate,
    ZIWHEAD.grossweighttime,
    ZIWHEAD.creationdate,
    
     ZMATDOC.MaterialDocument,
     ZMATDOC.MaterialDocumentYear,
     ZMATDOC.MaterialDocumentHeaderText
     //ZMATDOC.VersionForPrintingSlip  
    
  
}
