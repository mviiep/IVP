@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic IRN ALV Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_IRN_ALV
  as select from    I_BillingDocumentItemBasic as A
    inner join      zsd_irn_doc_typ            as _D on A.BillingDocumentType = _D.fkart
    left outer join I_BillingDocument          as _c on A.BillingDocument = _c.BillingDocument
    left outer join ztab_j1ig_invref           as _B on A.BillingDocument = _B.docno
{
  key  ltrim(A.BillingDocument, '0') as BillingDocument,
  key  A.CompanyCode                 as CompanyCode,
  key  _c.FiscalYear                 as FiscalYear,
  key  A.BillingDocumentDate         as PostingDate,
  key  _c.DocumentReferenceID        as odn,
  key  A.Plant                       as plant,
       A.PlantRegion                 as Region,
       case
         when A.BillingDocument <> ' ' then 'SD'
         else '' end                 as ModuleName,
       A.BillingDocumentType         as DocumentType,
       case
         when _B.irn <> ' ' then 'Yes'
         else 'No' end               as IRNCreated,
       case
         when _B.ewbno <> ' ' then 'Yes'
         else 'No' end               as EwayCreated,
       case
         when _c.BillingDocumentIsCancelled = 'X' then 'Yes'
         else 'No' end               as InvoiceCanceled,
       case
         when _B.irn_status = 'ACT' then 'No'
         when _B.irn_status = 'CNC' then 'Yes'
         else 'No' end               as IRNCanceled,
       case
         when _B.ewb_canceled = 'X' then 'Yes'
         else 'No' end               as EwayCanceled,
       _B.cancel_date                as CanceledDate,
       _B.irn                        as IRN,
       _B.ewbno                      as eway,
       _B.ewbvalidtill               as ewayvalidity,
       _B.ewb_url                    as EwayPdf,
       case
         when _B.irn <> ' ' then 'Success'
         when _B.irn = ' ' and _B.msg_irn <> ' ' then 'Error'
         else ' ' end                as Status,
       case
         when _B.irn <> '' and _B.ewbno = '' and _B.irn_canceled = '' then 'IRN Created'
         when _B.irn <> '' and _B.ewbno <> '' then 'IRN/E-Way Created'
         when _B.irn = '' and _B.ewbno <> ''  then 'E-Way Created'
         when _B.irn_canceled = 'X' and _B.ewb_canceled = '' then 'IRN Cancelled'
         when _B.irn_canceled = 'X' and _B.ewb_canceled = 'X' then 'IRN/E-Way Cancelled'
         when _B.irn <> '' and _B.irn_canceled = 'X' then 'IRN Cancelled'
         else ' ' end                as Message
}
where

     _c.AccountingTransferStatus = 'D'
  or _c.AccountingTransferStatus = 'C'
