@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Inward Head Data Def'
@Metadata.allowExtensions: true
define root view entity ZI_GE_IW_HEAD as select from zge_iw_head
{

   key sap_uuid              as SAP_UUID,
      id                    as Id,
      root_id               as Root_Id,
      referencedocument     as ReferenceDocument,
      referencedocumenttype as ReferenceDocumentType,
      plantcode             as PlantCode,
      plantname             as PlantName,
      suppliercode          as SupplierCode,
      suppliername          as SupplierName,
      suppliertype          as SupplierType,
      customercode          as CustomerCode,
      customername          as CustomerName,
      customertype          as CustomerType,
      status                as Status,
      approvestatus         as ApproveStatus,
      purchaseorderno       as PurchaseOrderNo,
      deliverydocumentno    as DeliveryDocumentNo,
      salesreturnno         as SalesReturnNo,
      customerreturnno      as CustomerReturnNo,
      postingdate           as PostingDate,
      referencedocumentyear as ReferenceDocumentYear,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      actualgrossweight as ActualGrossWeight,
        weighttime            as WeightTime,
      weightdate            as WeightDate,
       tareweight            as TareWeight,
      netweight             as NetWeight,
       grossweight           as GrossWeight,
             vehicleintimes  as VehicleInTimes,
  vehicleoutimes   as vehicleoutimes,
  vehiclestatus    as VehicleStatus,
  vehicleindate    as VehicleInDate,
  vehicleoutdate    as VehicleOutDate

}
