@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Digital Signature Purchase Order'

define root view entity ZI_DS_PO
  as select from I_PurchaseOrderAPI01 as purcorder
  association to ZI_DS_PO_cds        as pdfdata           on purcorder.PurchaseOrder = pdfdata.purchaseorder
  association to ZI_DS_PO_Plant      as plant             on purcorder.PurchaseOrder = plant.PurchaseOrder
  association to I_PurchaseOrderType as purchaseordertype on purcorder.PurchaseOrderType = purchaseordertype.PurchaseOrderType
{

      @UI.facet: [{ id: 'DS',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Purchase Order Sign Digitally',
                position: 01 }]

      @UI: { lineItem: [{ position: 30, label: 'PurchaseOrder' },
      { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally', position: 03 }],
                    identification: [{ position: 30, label: 'PurchaseOrder'  },
                    { type: #FOR_ACTION, dataAction: 'BDDigitalSignature', label: 'Sign Digitally', position: 03 }],
                    selectionField: [{ position: 01 }]}

  key purcorder.PurchaseOrder,

      @UI: { lineItem:       [ { position: 01, label: 'CompanyCode'}],
       identification: [ { position: 01, label: 'CompanyCode'}] }
      purcorder.CompanyCode,

      @UI: { lineItem:       [ { position: 20, label: 'Plant'}],
       identification: [ { position: 20, label: 'Plant'}] }
      plant.Plant,

      @UI: { lineItem:       [ { position: 40, label: 'PurchaseOrderType'}],
           identification: [ { position: 40, label: 'PurchaseOrderType'}] }
      purcorder.PurchaseOrderType,

      @UI: { lineItem:       [ { position: 50, label: 'PurchaseOrderType'}],
           identification: [ { position: 50, label: 'PurchaseOrderType'}] }
      purchaseordertype._Text[ Language = 'E'  ].PurchasingDocumentTypeName,

      @UI: { lineItem:       [ { position: 60, label: 'PurchaseOrderDate'}],
       identification: [ { position: 60, label: 'PurchaseOrderDate'}] }
      purcorder.PurchaseOrderDate,

      @UI: { lineItem:       [ { position: 70, label: 'CreatedByUser'}],
       identification: [ { position: 70, label: 'CreatedByUser'}] }
      purcorder.CreatedByUser,

      @UI: { lineItem:       [ { position: 80, label: 'PurchasingGroup'}],
       identification: [ { position: 80, label: 'PurchasingGroup'}] }
      purcorder.PurchasingGroup,

      @UI: { lineItem:       [ { position: 90, label: 'PurchaseOrderType'}],
      identification: [ { position: 90, label: 'PurchaseOrderType'}] }
      purcorder._PurchasingGroup.PurchasingGroupName,

      @Semantics.largeObject:
      { mimeType: 'MimeType',
      fileName: 'Filename'
      //            contentDispositionPreference: #INLINE
      }
      @UI: { lineItem:       [ { position: 110, label: 'Digitally Signed PDF'}],
             identification: [ { position: 110, label: 'Digitally Signed PDF'}] }
      pdfdata.Attachment,

      @Semantics.mimeType: true
      @UI.hidden: true
      pdfdata.MimeType,

      @UI.hidden: true
      pdfdata.Filename,


      @UI: { lineItem:       [ { position: 100, label: 'Sign Status'}],
               identification: [ { position: 100, label: 'Sign Status'}] }
      case
      when pdfdata.Filename <> ''
      then 'Signed'
      else  'Not Signed'
      end as Signedpdf



}
where
  purcorder.PurchasingProcessingStatus = '05'
