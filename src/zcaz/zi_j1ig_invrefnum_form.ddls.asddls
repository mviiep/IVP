@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for j1ig_invrefnum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_j1ig_invrefnum_form
  as select from ztab_j1ig_invref
{
  key bukrs         as Bukrs,
  key docno         as Docno,
  key doc_year      as DocYear,
  key doc_type      as DocType,
  key odn           as Odn,
  key irn           as Irn,
  key version       as Version,
      bupla         as Bupla,
      odn_date      as OdnDate,
      ack_no        as AckNo,
      ack_date      as AckDate,
      qrcode        as Qrcode,
      irn_status    as IrnStatus,
      cancel_date   as CancelDate,
      irn_canceled  as IrnCanceled,
      ernam         as Ernam,
      erdat         as Erdat,
      erzet         as Erzet,
      signed_inv    as SignedInv,
      signed_qrcode as SignedQrcode,
      ewbno         as Ewbno,
      ewbdt         as Ewbdt,
      ewbvalidtill  as Ewbvalidtill,
      ewbstatus     as Ewbstatus,
      msg_irn       as MsgIrn,
      msg_ewb       as MsgEwb,
      ewb_canceled  as EwbCanceled
}
