@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for IRN Links'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_IRN_LINKS
  as select from zirn_login
{
      @UI.facet: [{
                  id:'systemid',
                  label: 'SystemId',
                  type      : #IDENTIFICATION_REFERENCE,
                  position  : 10
                         }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'SystemID'
  key systemid as Systemid,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position: 20 } ] }
      @EndUserText.label: 'Link'
      link     as Link
}
