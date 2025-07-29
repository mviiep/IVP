@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'State Code'

define root view entity ZI_State_Code
  as select from zj1istatecdm
{
      @UI.facet: [{
        id:'StateCode',
        label: 'GSTIN State Code',
        type      : #IDENTIFICATION_REFERENCE,
        position  : 10
               }
      ]
      @UI: {  lineItem: [ { position: 10 } ],
                     identification: [ { position: 10 } ],
                     selectionField      : [{position: 10}]

             }
      @EndUserText.label: 'Region'
  key region    as Region,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position: 20 } ]
      }
      @EndUserText.label: 'State Code'
      statecode as Statecode,
      @UI: {  lineItem: [ { position: 30 } ],
                    identification: [ { position: 30 } ]
            }
      @EndUserText.label: 'State Name'
      statename as Statename
}
