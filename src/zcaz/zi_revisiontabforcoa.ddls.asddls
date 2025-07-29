@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Revision table for COA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Zi_RevisiontabforCOA
  as select from ztableforcoa


{

         @UI.facet: [
         {
                       label: 'General Information',
                       id: 'GeneralInfo',
                      type: #COLLECTION,
                     //  type: #IDENTIFICATION_REFERENCE,
                       position: 10
                       },
                            { id:           'COAtab',
                           purpose:       #STANDARD,
                           type:          #IDENTIFICATION_REFERENCE,
                           label:         'Revision Table for COA',
                           parentId: 'GeneralInfo',
                           position:      10 }
                         ]

         @UI: { lineItem:       [ { position: 10,  label: 'Plant'} ] ,
                  identification: [ { position: 10 , label: 'Plant' } ] }
  key    plant                 as Plant,
         @UI: { lineItem:       [ { position: 20,  label: 'Format Number'} ] ,
                identification: [ { position: 20 , label: 'Format Number' } ] }
  key    formatno              as Formatno,
         @UI: { lineItem:       [ { position: 30,  label: 'Ref SOP Number'} ] ,
            identification: [ { position: 30 , label: 'Ref SOP Number' } ] }
  key    refsopno              as Refsopno,
         @UI: { lineItem:       [ { position: 40,  label: 'Rev Number'} ] ,
         identification: [ { position: 40 , label: 'Rev Number' } ] }
  key    revno                 as Revno,

         @UI: { lineItem:       [ { position: 60,  label: 'Valid from'} ] ,
         identification: [ { position: 60 , label: 'Valid from' } ] }
  key    validfrom             as Validfrom,


         @UI: { lineItem:       [ { position: 70,  label: 'Valid to'} ] ,
         identification: [ { position: 70 , label: 'Valid to' } ] }
  key    validto               as Validto,


         @UI: { lineItem:       [ { position: 50,  label: 'Format Type'} ] ,
         identification: [ { position: 50 , label: 'Format Type' } ] }
         formatetype           as Formatetype,




         @Semantics.user.createdBy: true
         local_created_by      as LocalCreatedBy,
         @Semantics.systemDateTime.createdAt: true
         local_created_at      as LocalCreatedAt,
         @Semantics.user.lastChangedBy: true
         local_last_changed_by as LocalLastChangedBy,
         //local ETag field --> OData ETag
         @Semantics.systemDateTime.localInstanceLastChangedAt: true
         local_last_changed_at as LocalLastChangedAt,

         //total ETag field
         @Semantics.systemDateTime.lastChangedAt: true
         last_changed_at       as LastChangedAt
}
