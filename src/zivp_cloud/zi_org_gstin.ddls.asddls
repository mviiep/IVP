@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for ORG GSTIN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_ORG_GSTIN
  as select from zdb_org_gstin
{
  key comp_code      as CompCode,
  key plant          as Plant,
  key business_place as BusinessPlace,
      gstin          as Gstin,
      gst_reten_st_dt as reten_st_Date,
      e_invoice as e_invoice
}
