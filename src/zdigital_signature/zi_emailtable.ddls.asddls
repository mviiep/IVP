@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Email Template Table'
define root view entity zi_emailtable
  as select from zdb_emailtable
{
      @UI.facet: [    {
                     label: 'General Information',
                     id: 'GeneralInfo',
                     type: #COLLECTION,
                     position: 10
                     },
                          { id:         'Emailtable',
                         purpose:       #STANDARD,
                         type:          #IDENTIFICATION_REFERENCE,
                         label:         'Maintain Email Address',
                         parentId: 'GeneralInfo',
                         position:      10 }
                       ]

      @UI: { lineItem:       [ { position: 10,  label: 'SalesOrganization'} ] ,
               identification: [ { position: 10 , label: 'SalesOrganization' } ] }
  key salesorganization   as Salesorganization,
      @UI: { lineItem:       [ { position: 20,  label: 'DistributionChannel'} ] ,
             identification: [ { position: 20 , label: 'DistributionChannel' } ] }
  key distributionchannel as Distributionchannel,
      @UI: { lineItem:       [ { position: 30,  label: 'Division'} ] ,
             identification: [ { position: 30 , label: 'Division' } ] }
  key division            as Division,
      @UI: { lineItem:       [ { position: 40,  label: 'Sender ID'} ] ,
             identification: [ { position: 40 , label: 'Sender ID' } ] }
      senderid            as Senderid,
      @UI: { lineItem:       [ { position: 50,  label: 'Recipient ID'} ] ,
         identification: [ { position: 50 , label: 'Recipient ID' } ] }
      recipientid         as Recipientid,
      @UI: { lineItem:       [ { position: 60,  label: 'CC'} ] ,
         identification: [ { position: 60 , label: 'CC' } ] }
      cc                  as Cc
}
