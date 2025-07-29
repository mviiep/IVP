@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For GST Region Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_REGION_MAP
  as select from zgst_region_map
{
      @UI.facet: [{
                     id:'kschl',
                     label: 'Region Map',
                     type      : #IDENTIFICATION_REFERENCE,
                     position  : 10
                            }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'Land(Country)'
  key land1 as Land1,
      @UI: {  lineItem: [ { position: 20 } ],
                identification: [ { position: 20 } ] }
      @EndUserText.label: 'Region'
  key regio as Regio,
      @UI: {  lineItem: [ { position: 30 } ],
               identification: [ { position: 30 } ] }
      @EndUserText.label: 'GSTIN Region No'
  key zgstr as Zgstr,
      @UI: {  lineItem: [ { position: 30 } ],
                identification: [ { position: 30 } ] }
      @EndUserText.label: 'State Description'
  key bezei as Bezei
}
