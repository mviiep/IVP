@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Digital Signature PDF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_digiforpdf
  as select from zdb_digiforpdf
{

      @UI.facet: [    {
                    label: 'General Information',
                    id: 'GeneralInfo',
                    type: #COLLECTION,
                    position: 10
                    },
                         { id:            'Invoicedet',
                        purpose:       #STANDARD,
                        type:          #IDENTIFICATION_REFERENCE,
                        label:         'Invoice Details',
                        parentId: 'GeneralInfo',
                        position:      10 }
                      ]

      @UI: { lineItem:       [ { position: 10,  label: 'Invoice Number'} ] ,
               identification: [ { position: 10 , label: 'Invoice Number' } ] }
  key billingdocument as billingdocument,
      @UI: { lineItem:       [ { position: 20, importance: #HIGH , label: 'Comments'} ] ,
             identification: [ { position: 20 , label: 'Comments' } ] }
      plant           as plant,
      @Semantics.largeObject:
      { mimeType: 'MimeType',
      fileName: 'Filename',
      contentDispositionPreference: #INLINE 
      }
      @UI: { lineItem:       [ { position: 30, label: 'Attachment'}],
             identification: [ { position: 30, label: 'Attachment'}] }
      attachment      as Attachment,
      @Semantics.mimeType: true
      @UI.hidden: true
      mimetype        as MimeType,
      @UI.hidden: true
      filename        as Filename
}
