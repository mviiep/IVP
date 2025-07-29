@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Lut ARN Table'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_lutarncds
  as select from zdb_lutarntable
{

      @UI.facet: [    {
                    label: 'General Information',
                    id: 'GeneralInfo',
                    type: #COLLECTION,
                    position: 10
                    },
                         { id:         'COAtab',
                        purpose:       #STANDARD,
                        type:          #IDENTIFICATION_REFERENCE,
                        label:         'Lut ARN Table',
                        parentId: 'GeneralInfo',
                        position:      10 }
                      ]

      @UI: { lineItem:       [ { position: 10,  label: 'Plant'} ] ,
               identification: [ { position: 10 , label: 'Plant' } ] }

  key plant    as Plant,
  
      @UI: { lineItem:       [ { position: 20,  label: 'Lut ARN No'} ] ,
                 identification: [ { position: 20 , label: 'Lut ARN No' } ] }
      lutno    as Lutno,
      
      @UI: { lineItem:       [ { position: 30,  label: 'FromDate'} ] ,
             identification: [ { position: 30 , label: 'FromDate' } ] }
      fromdate as Fromdate,
      
      @UI: { lineItem:       [ { position: 40,  label: 'ToDate'} ] ,
             identification: [ { position: 40 , label: 'ToDate' } ] }
      todate   as Todate
}
