@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For IRN Doc type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_IRN_DOC_TYPE
  as select from zsd_irn_doc_typ
{
      @UI.facet: [{
                  id:'land1',
                  label: 'Document type',
                  type      : #IDENTIFICATION_REFERENCE,
                  position  : 10
                         }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'Billing Type'
  key fkart  as Fkart,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position:20 } ] }
      @EndUserText.label: 'Special G/L Indicator'
  key umskz  as Umskz,
      @UI: {  lineItem: [ { position: 30 } ],
              identification: [ { position:30 } ] }
      @EndUserText.label: 'Selection in PMS'
  key fidtyp as Fidtyp,
      @UI: {  lineItem: [ { position: 40 } ],
              identification: [ { position:40 } ] }
      @EndUserText.label: 'Invoice Types For IRN(GST Type)'
      gsttyp as Gsttyp,
      @UI: {  lineItem: [ { position: 50 } ],
              identification: [ { position:50 } ] }
      @EndUserText.label: 'IRN Invoice Document Type(GST DOC)'
      gstdoc as Gstdoc
}
