@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Eway Bill Transporter Detail'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zI_eway_trans
  as select distinct from ztab_eway_trans
{
  key billingdocument  as Billingdocument,
  key fiscalyear       as Fiscalyear,
  key postingdate      as Postingdate,
  key companycode      as Companycode,
  key transporterid    as Transporterid,
      transporterdocno as Transporterdocno,
      transdistance    as Transdistance,
      subsplytyp       as Subsplytyp,
      transportername  as Transportername,
      transdocdate     as Transdocdate,
      vehicleno        as Vehicleno,
      transportmode    as Transportmode,
      vehicletype      as Vehicletype
}
