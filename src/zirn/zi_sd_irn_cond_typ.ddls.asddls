@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface  CDS view for SD IRN cond type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_sd_irn_cond_typ
  as select from zsd_irn_cond_typ
{
      @UI.facet: [{
                   id:'kschl',
                   label: 'GST Condition Type',
                   type      : #IDENTIFICATION_REFERENCE,
                   position  : 10
                          }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'Condition Type'
  key kschl  as Kschl,
      @UI: {  lineItem: [ { position: 20 } ],
                identification: [ { position:20 } ] }
      @EndUserText.label: 'IRN Condition Group'
  key gstgrp as Gstgrp,
      @UI: {  lineItem: [ { position: 30 } ],
                  identification: [ { position:30 } ] }
      @EndUserText.label: 'IRN Invoice Document Type'
  key gstdoc as Gstdoc
}
