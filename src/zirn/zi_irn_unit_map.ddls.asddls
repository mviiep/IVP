@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for irn unit mapping'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Zi_irn_unit_map
  as select from zirn_unit_mapng
{
      @UI.facet: [{
                      id:'vrkme_i',
                      label: 'Unit Map',
                      type      : #IDENTIFICATION_REFERENCE,
                      position  : 10
                             }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'Unit 1 - VrkmeI'
  key vrkme_i as vrkme_i,
      @UI: {  lineItem: [ { position: 20 } ],
            identification: [ { position: 20 } ] }
      @EndUserText.label: 'Unit 2 - Irnut'
  key irnut   as irnut
}
