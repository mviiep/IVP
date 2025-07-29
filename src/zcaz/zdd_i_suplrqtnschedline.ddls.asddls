@AbapCatalog.sqlViewName: 'ZIMMQTNSLINE'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@EndUserText.label: 'Sum view of I_SuplrQtnScheduleLine_Api01'
@VDM.viewType: #BASIC
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.supportedCapabilities:[ #SQL_DATA_SOURCE, 
                                     #CDS_MODELING_DATA_SOURCE, 
                                     #CDS_MODELING_ASSOCIATION_TARGET ]
define view ZDD_I_SuplrQtnSchedLine 
as select from I_SuplrQtnScheduleLine_Api01 as a
{
    key a.SupplierQuotation,
    key a.SupplierQuotationItem,
    a.ScheduleLineDeliveryDate,
    a.OrderQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit' 
    sum(a.ScheduleLineOrderQuantity) as ScheduleLineOrderQuantity,
    @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit' 
    sum(a.AwardedQuantity) as AwardedQuantity     
    
   
} group by a.SupplierQuotation, a.SupplierQuotationItem, a.ScheduleLineDeliveryDate,
           a.OrderQuantityUnit
