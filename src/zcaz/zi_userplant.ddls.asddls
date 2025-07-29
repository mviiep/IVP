@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for User Plant'
define root view entity Zi_userplant
  as select from zdb_userplant
{
      @UI.facet: [{
        id:'StateCode',
        label: 'User Plant',
        type      : #IDENTIFICATION_REFERENCE,
        position  : 10
               }
      ]
      @UI: {  lineItem: [ { position: 10 } ],
                     identification: [ { position: 10 } ],
                     selectionField      : [{position: 10}]

             }
      @EndUserText.label: 'User ID'
  key userid   as userid,
      @UI: {  lineItem: [ { position: 30 } ],
                  identification: [ { position: 30 } ]
          }
      @EndUserText.label: 'Plant'
  key plant    as Plant,

      @UI: {  lineItem: [ { position: 20 } ],
                  identification: [ { position: 20 } ]
          }
      @EndUserText.label: 'UserName'
      username as username


}
