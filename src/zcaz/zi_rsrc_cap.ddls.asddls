@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR RESOURCE CAPACITY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RSRC_CAP
  as select from ztb_resource_cap
{
      @UI.facet: [{
                     id:'TradersNo',
                     label: 'Resource Capacity',
                     type      : #IDENTIFICATION_REFERENCE,
                     position  : 10
                     }]
      @UI: {  lineItem: [ { position: 10 } ],
         identification: [ { position: 10 } ]
      }
      @EndUserText.label: 'Plant'
  key plant      as Plant,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position: 20 } ]
           }
      @EndUserText.label: 'Resource'
  key resrce     as Resrce,
      @UI: {  lineItem: [ { position: 30 } ],
              identification: [ { position: 30 } ]
           }
      @EndUserText.label: 'Design Capacity'
  key design_cap as DesignCap
}
