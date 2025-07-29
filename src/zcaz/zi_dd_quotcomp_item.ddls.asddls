@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for Supp.Quot.CompareItem'
@Metadata.ignorePropagatedAnnotations: true

define view entity zi_dd_quotcomp_item 
    as select from I_RfqItem_Api01 as a
    left outer join I_RfqScheduleLine_Api01 as b on b.RequestForQuotation       = a.RequestForQuotation
                                                and b.RequestForQuotationItem   = a.RequestForQuotationItem
    left outer join I_Plant as c on c.Plant = a.Plant                                             
//    as select from I_SupplierQuotationItem_Api01 as a
//left outer join ZDD_I_SuplrQtnSchedLine as b on b.SupplierQuotation = a.SupplierQuotation
//                                            and b.SupplierQuotationItem = a.SupplierQuotationItem
association to parent ZIDD_Quote_Comparison as _head on $projection.RequestForQuotation = _head.RequestForQuotation
//composition[*] of zi_dd_quotcomp_sup as _RFQSupplier
 
{
  @EndUserText.label: 'Request For Quotation'   
  key a.RequestForQuotation,
  @EndUserText.label: 'RFQ Item'
  key a.RequestForQuotationItem,
  a.Material,
  @EndUserText.label: 'Material Desc'
  a.PurchasingDocumentItemText as MaterialDesc,
  
  @EndUserText.label: 'Plant Code'
  a.Plant,
  @EndUserText.label: 'Plant Name'
  c.PlantName,
  @Semantics.quantity.unitOfMeasure: 'UOM'
  sum(b.ScheduleLineOrderQuantity) as RequestedQuantity,  
  b.OrderQuantityUnit   as UOM,
  _head
//  _RFQSupplier
   
} group by a.RequestForQuotation, a.RequestForQuotationItem, a.Material, a.PurchasingDocumentItemText, a.Plant,c.PlantName, b.OrderQuantityUnit
