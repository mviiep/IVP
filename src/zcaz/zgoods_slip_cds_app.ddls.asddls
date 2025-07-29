@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for tile creation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGOODS_SLIP_CDS_APP
  as select distinct from I_MaterialDocumentHeader_2
{

  key MaterialDocumentYear,
  key MaterialDocument
}
