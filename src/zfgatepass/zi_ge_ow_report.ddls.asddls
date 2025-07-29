@AbapCatalog.sqlViewName: 'ZIGEOWREPORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For Outward report based on header datas'
define view ZI_GE_OW_REPORT as select from  ZI_GE_OW_HEAD as ZOWHEAD

association [0..1] to I_MaterialDocumentHeader_2 as ZMATDOC on ZOWHEAD.Id = ZMATDOC.MaterialDocumentHeaderText 

{  

    key ZOWHEAD.Id,
        ZOWHEAD.SAP_UUID,
        ZOWHEAD.Root_Id,
        ZOWHEAD.ReferenceDocumentYear,
        ZOWHEAD.ReferenceDocument,
        ZOWHEAD.ReferenceDocumentType,
        ZOWHEAD.PlantCode,
        ZOWHEAD.PlantName,
        ZOWHEAD.SupplierCode,
        ZOWHEAD.SupplierName,
        ZOWHEAD.SupplierType,
        ZOWHEAD.CustomerCode,
        ZOWHEAD.CustomerName,
        ZOWHEAD.CustomerType,
        ZOWHEAD.EWayBill,
        ZOWHEAD.GateEnrtyDate,
        ZOWHEAD.GateEntryDate0,
        ZOWHEAD.VehicleType,
        ZOWHEAD.VehicleNo,
        ZOWHEAD.InvoiceNo,
        ZOWHEAD.InvoiceDate,
        ZOWHEAD.Transporter,
        ZOWHEAD.TransporterMode,
        ZOWHEAD.LRNo,
        ZOWHEAD.LRDate,
        ZOWHEAD.GrossWeight,
        ZOWHEAD.WeightTime,
        ZOWHEAD.WeightDate,
        ZOWHEAD.NoOfPackages,
        ZOWHEAD.Remarks,
        ZOWHEAD.Status,
        ZOWHEAD.DeliveryDocumentNo,
        ZOWHEAD.BillingDocumentNo,
        ZOWHEAD.SalesReturnNo,
        ZOWHEAD.ScreenCode,
        ZOWHEAD.TareWeight,
        ZOWHEAD.NetWeight,
        ZOWHEAD.DelDocGrossWeight,
        ZOWHEAD.ChallanNo,
        ZOWHEAD.ChallanDate,
        ZOWHEAD.PostingDate,
        ZOWHEAD.CreatedBy,
        ZOWHEAD.CreatedAt,
        ZOWHEAD.LastChangedBy,
        ZOWHEAD.LastChangedAt,
        ZOWHEAD.CreatedDate,
        ZOWHEAD.ActualGrossWeight,
        ZOWHEAD.VehicleInTimes,
        ZOWHEAD.vehicleoutimes,
        ZOWHEAD.VehicleStatus,
        ZOWHEAD.VehicleInDate,
        ZOWHEAD.VehicleOutDate,
        
        ZMATDOC.MaterialDocument,
        ZMATDOC.MaterialDocumentYear,
        ZMATDOC.MaterialDocumentHeaderText,
        ZMATDOC.VersionForPrintingSlip        

}
