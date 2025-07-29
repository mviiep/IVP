@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Billing Document DS'

define root view entity ZI_BD_DS
  as select from zi_billing_ds as billhead
  association to Zi_plant_sessionuser as userplant on billhead.Plant = userplant.Plant
  association to zi_digiforpdf        as pdfdata   on billhead.BillingDocument = pdfdata.billingdocument
{

      @UI.facet: [{ id: 'DS',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Sign Digitally',
                position: 01 }]

      @UI: { lineItem: [{ position: 01, label: 'Billing Document' },
      { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally', position: 03 }],
                    identification: [{ position: 01, label: 'Document Number'  },
                    { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally', position: 03 }],
                    selectionField: [{ position: 01 }]}

  key billhead.BillingDocument,
      @UI: { lineItem:       [ { position: 20, label: 'BillingDocumentType'}],
           identification: [ { position: 20, label: 'BillingDocumentType'}] }
      billhead.BillingDocumentType,
      @UI: { lineItem:       [ { position: 30, label: 'BillingDocumentDate'}],
       identification: [ { position: 30, label: 'BillingDocumentDate'}] }
      billhead.BillingDocumentDate,
      @UI: { lineItem:       [ { position: 40, label: 'CreatedByUser'}],
       identification: [ { position: 40, label: 'CreatedByUser'}] }
      billhead.CreatedByUser,
      @UI: { lineItem:       [ { position: 50, label: 'CreationDate'}],
       identification: [ { position: 50, label: 'CreationDate'}] }
      billhead.CreationDate,
      @UI: { lineItem:       [ { position: 60, label: 'CompanyCode'}],
       identification: [ { position: 60, label: 'CompanyCode'}] }
      billhead.CompanyCode,
      @UI: { lineItem:       [ { position: 70, label: 'SalesOrganization'}],
       identification: [ { position: 70, label: 'SalesOrganization'}] }
      billhead.SalesOrganization,
      @UI: { lineItem:       [ { position: 80, label: 'DistributionChannel'}],
       identification: [ { position: 80, label: 'DistributionChannel'}] }
      billhead.DistributionChannel,
      @UI: { lineItem:       [ { position: 90, label: 'Division'}],
       identification: [ { position: 90, label: 'Division'}] }
      billhead.Division,

      @UI: { lineItem:       [ { position: 100, label: 'Plant'}],
       identification: [ { position: 100, label: 'Plant'}] }
      billhead.Plant,

      @Semantics.largeObject:
      { mimeType: 'MimeType',
      fileName: 'Filename'
      //            contentDispositionPreference: #INLINE
      }
      @UI: { lineItem:       [ { position: 120, label: 'Digitally Signed PDF'}],
             identification: [ { position: 120, label: 'Digitally Signed PDF'}] }
      pdfdata.Attachment,
      @Semantics.mimeType: true
      @UI.hidden: true
      pdfdata.MimeType,
      @UI.hidden: true
      pdfdata.Filename,


      @UI: { lineItem:       [ { position: 130, label: 'Sign Status'}],
               identification: [ { position: 130, label: 'Sign Status'}] }
      case
      when pdfdata.Filename <> ''
      then 'Signed'
      else  'Not Signed'
      end as Signedpdf

}
where
  billhead.Plant = userplant.Plant
