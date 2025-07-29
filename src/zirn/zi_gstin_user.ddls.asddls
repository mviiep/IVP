@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for GSTIN User login auth'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GSTIN_USER
  as select from ztab_gstin_user
{
      @UI.facet: [{
                  id:'land1',
                  label: 'GST Login',
                  type      : #IDENTIFICATION_REFERENCE,
                  position  : 10
                         }]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ] }
      @EndUserText.label: 'GSTIN'
  key gstin    as Gstin,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position:20 } ]  }
      @EndUserText.label: 'Email ID'
      email    as Email,
      @UI: {  lineItem: [ { position: 30 } ],
              identification: [ { position: 30 } ]  }
      @EndUserText.label: 'Password'
      password as Password
}
