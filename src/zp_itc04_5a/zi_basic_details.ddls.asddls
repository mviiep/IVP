@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Org basic details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BASIC_DETAILS as select from ZI_BILLINGDETAILS as _billdoc
association [1..1] to I_Plant as plant on plant.Plant = _billdoc.billingdocumentplant
{   key _billdoc.billingdocument,
    key _billdoc.billingdocumentitem,
    key plant.BusinessPlace as businessplace
    
}
//group by plant.BusinessPlace,
//    _billdoc.billingdocument,
//    _billdoc.billingdocumentitem
