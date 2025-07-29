@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FG Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X, 
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity zc_zfg_table as select from zlabel_rable

{
   
      @UI.facet: [{
                     id:'FG_Table',
                     label: 'label',
                     type      : #IDENTIFICATION_REFERENCE,
                     position  : 10
                            }]
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position:20 } ] }
      @EndUserText.label: 'Material_Code'
  key mcode as mcode,
      @UI: {  lineItem: [ { position: 30 } ],
                identification: [ { position: 30 } ] }
      @EndUserText.label: 'Net Weight'
    net_wt as net_wt,
      @UI: {  lineItem: [ { position: 40 } ],
               identification: [ { position: 40 } ] }
      @EndUserText.label: 'Gross Weight'
   gr_wt as gr_wt,
      @UI: {  lineItem: [ { position: 50 } ],
                identification: [ { position: 50 } ] }
      @EndUserText.label: 'Unit of Measure'
   uom_m as uom_m
}
