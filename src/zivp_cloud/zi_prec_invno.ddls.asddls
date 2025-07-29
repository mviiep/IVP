@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice Detalils'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PREC_INVNO as 

////select from I_SalesOrderItmSubsqntProcFlow  as Procflow
//////association [0..1] to I_BillingDocumentItemBasic as billingitem
//////on  billingitem.SalesDocument = Procflow.SubsequentDocument
////
////
////
////association [0..1] to I_SalesOrderItmSubsqntProcFlow  as Procflow2
//////on billingitem.SalesDocument = Procflow.SubsequentDocument
//// on Procflow.SalesOrder = Procflow2.SalesOrder
////and Procflow.SubsequentDocumentItem = Procflow2.SubsequentDocumentItem
//// and Procflow2.SubsequentDocumentCategory = 'M' 
////
////// association [0..1] to I_SalesOrderItmSubsqntProcFlow as Procflow1
////// on Procflow1.SalesOrder = Procflow.SalesOrder 
////// and Procflow1.SubsequentDocumentItem = Procflow.SubsequentDocumentItem
////// and Procflow1.SubsequentDocumentCategory = 'M' 
//// 
////{
//////key billingitem.SalesDocument as Sales_Doc,
////key //Procflow.SalesOrder,
////    Procflow.SubsequentDocument as Sub_1,
//// key   Procflow.SalesOrder as Sales_order,
////    Procflow2.SalesOrder,
////    Procflow.SubsequentDocumentItem,
//////    billingitem.SalesDocument,
////    Procflow.SubsequentDocumentCategory,
////    Procflow2.SubsequentDocument,
////    Procflow2.SubsequentDocument as SUb_DOC2
////}
////where Procflow2.SubsequentDocumentCategory = 'M'
////// where Procflow.SubsequentDocument = '0060000005'
//////
//////and 
//////Procflow.SubsequentDocumentItem <> '000000'
//////and Procflow.SubsequentDocumentCategory = 'M'
//////where Procflow.SalesOrder = '60000005'

//select from I_InvoiceListItem as Invoicelist
//association [1] to I_BillingDocumentItemBasic as Billingitem
//on Invoicelist. = Billingitem.SalesDocument
select from I_SalesOrderItmSubsqntProcFlow  as Procflow1
association [1] to I_BillingDocumentItemBasic as Billingitem
on Procflow1.SubsequentDocument = Billingitem.SalesDocument


 association [1] to  I_SalesOrderItmSubsqntProcFlow as Procflow2
 on  Procflow2.SalesOrder = Procflow1.SalesOrder
 and Procflow2.SubsequentDocumentItem = Procflow1.SubsequentDocumentItem
 and Procflow2.SubsequentDocumentCategory = 'M'

{
    key Billingitem.BillingDocument,
 key Procflow1.SalesOrder as Sal_ord,
 key Procflow1.SubsequentDocument as Sub_1,
    // Procflow1.   
 
 key Procflow2.SubsequentDocumentItem,
     Procflow2.SubsequentDocumentCategory,
     Procflow2.SubsequentDocument,
     Procflow2.CreationDate
}

// where Procflow1.SubsequentDocument = '0060000005'
 //where Procflow1.SubsequentDocument = Procflow1.SubsequentDocument
