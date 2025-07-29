@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Digital Signature'

define root view entity Zi_Digital_Sign
  as select from zdigi_sign_table as A
{

      @UI.facet: [{
          id:'User',
          type      : #IDENTIFICATION_REFERENCE,
          label: 'Digital Signature',
          position  : 10
                 }
        ]
      @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position: 10 } ]
              }
      @EndUserText.label: 'System ID'

  key A.systemid           as Systemid,
      @UI: {  lineItem: [ { position: 20 } ],
          identification: [ { position: 20 } ]
          }
      @EndUserText.label: 'Pfxid'
      A.pfxid              as Pfxid,
      @UI: {  lineItem: [ { position: 30 } ],
      identification: [ { position: 30 } ]
      }
      @EndUserText.label: 'Pfxpwd'
      A.pfxpwd             as Pfxpwd,
      @UI: {  lineItem: [ { position: 40 } ],
      identification: [ { position: 40 } ]
      }
      @EndUserText.label: 'Sign Annotation'
      A.signannotation     as Signannotation,
      @UI: {  lineItem: [ { position: 50 } ],
      identification: [ { position: 50 } ]
      }
      @EndUserText.label: 'Signer'
      A.signer             as Signer,
      @UI: {  lineItem: [ { position: 60 } ],
      identification: [ { position: 60 } ]
      }
      @EndUserText.label: 'Checksum'
      A.cs                 as Cs,
      $session.system_date as date_

}
