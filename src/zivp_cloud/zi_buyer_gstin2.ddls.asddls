@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface view for buyer gstin'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BUYER_GSTIN2 
 as select from ZI_SEND_GSTR2 as accdoc
  //  association [1] to ZI_ORG_GSTIN as orggstin on  accdoc.Plant          = orggstin.Plant
  //                                              and accdoc.business_place = orggstin.BusinessPlace
  association [1] to ZI_ORG_GSTIN as orggstin on accdoc.ProftCenter = orggstin.Plant
{
  accdoc.AccountingDocument,
  orggstin.Plant,
  orggstin.BusinessPlace,
  orggstin.Gstin  
}
