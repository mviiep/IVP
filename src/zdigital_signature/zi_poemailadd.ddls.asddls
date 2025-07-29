@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PO Email Address'

define root view entity zi_poemailadd
  as select from zdb_poemailadd
{
      @UI.facet: [    {
                     label: 'General Information',
                     id: 'GeneralInfo',
                     type: #COLLECTION,
                     position: 10
                     },
                        { id:         'POEmailtable',
                         purpose:       #STANDARD,
                         type:          #IDENTIFICATION_REFERENCE,
                         label:         'Maintain Email Address',
                         parentId: 'GeneralInfo',
                         position:      10 }
                       ]

  key sap_uuid     as SapUuid,
      @UI: { lineItem:       [ { position: 1,  label: 'Sender ID'} ] ,
               identification: [ { position: 1 , label: 'Sender ID' } ] }
      senderid     as Senderid,
      @UI: { lineItem:       [ { position:2,  label: 'Recipient ID 1'} ] ,
         identification: [ { position: 2 , label: 'Recipient ID 1' } ] }
      recipientid1 as Recipientid1,
      @UI: { lineItem:       [ { position: 3,  label: 'Recipient ID 2'} ] ,
         identification: [ { position: 3 , label: 'Recipient ID 2' } ] }
      recipientid2 as Recipientid2,
      @UI: { lineItem:       [ { position: 4,  label: 'CC 1'} ] ,
         identification: [ { position: 4 , label: 'CC 1' } ] }
      cc1          as Cc1,
      @UI: { lineItem:       [ { position: 5,  label: 'CC 2'} ] ,
         identification: [ { position: 5 , label: 'CC 2' } ] }
      cc2          as Cc2,
      @UI: { lineItem:       [ { position: 6,  label: 'CC 3'} ] ,
         identification: [ { position: 6 , label: 'CC 3' } ] }
      cc3          as Cc3
}
