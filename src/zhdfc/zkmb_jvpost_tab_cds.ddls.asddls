@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'kmb inc pay jv positng'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define view entity zkmb_jvpost_tab_cds as select from zkmb_jvpost_tab
{
    key utrno as Utrno,
    acountingdocument as Acountingdocument
}
