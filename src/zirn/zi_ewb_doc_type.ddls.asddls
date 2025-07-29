//@AbapCatalog.sqlViewName: 'ZZI_EWBDOC'
////@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Eway Bill Document type'
define root view entity ZI_EWB_DOC_TYPE
  as select from zsd_eway_doc_typ
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
  key billingtype as Billingtype,
      @UI: {  lineItem: [ { position: 40 } ],
              identification: [ { position:40 } ] }
      @EndUserText.label: 'Invoice Types For IRN(GST Type)'
      gsttyp      as Gsttyp,
      @UI: {  lineItem: [ { position: 50 } ],
              identification: [ { position:50 } ] }
      @EndUserText.label: 'IRN Invoice Document Type(GST DOC)'
      gstdoc      as Gstdoc
}
