@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDFC bank Batch alv report cds'
@UI.headerInfo:{
typeName: 'HDFC Bank Auto Batch ALV',
typeNamePlural: 'HDFC Bank Auto Batch ALV'
}
define root view entity ZHBBATCHALVCDS as select from zhdfcbatchlog
//composition of target_data_source_name as _association_name

{
     @UI.facet         : [{
                      id      :'TradersNo',
                      label   : 'Document Number',
                      type    : #IDENTIFICATION_REFERENCE,
                      position: 10}]
          @UI: { lineItem       : [ { position: 10 } ],
                 identification : [ { position:10 } ],
                 selectionField : [ { position:1  } ]
          }
          @EndUserText.label: 'Document Number'
    key documentnumber as Documentnumber,
    @UI: { lineItem       : [ { position: 20 } ],
           identification : [ { position:20 } ],
           selectionField : [ { position:2  } ]
          }
          @EndUserText.label: 'Reference Number'
    key referacenumber as Referacenumber,
    @UI: { lineItem       : [ { position: 30 } ],
           identification : [ { position:30 } ]
          }
          @EndUserText.label: 'UTR Number'
    utrnumber as Utrnumber,
     @UI: { lineItem       : [ { position: 40 } ],
           identification : [ { position:40 } ]
          }
          @EndUserText.label: 'Status'
    tnxstatus as Tnxstatus,
     @UI: { lineItem       : [ { position: 50 } ],
           identification : [ { position:50 } ]
          }
          @EndUserText.label: 'Status Description'
    tnxstatusdesc as Tnxstatusdesc,
      @UI: { lineItem       : [ { position: 60 } ],
           identification : [ { position:60 } ]
          }
          @EndUserText.label: 'Error Description'
    errordesc as Errordesc,
      @UI: { lineItem       : [ { position: 60 } ],
           identification : [ { position:60 } ]
          }
          @EndUserText.label: 'Reject Reason'
    rejectreason as Rejectreason,
    @UI.selectionField: [{ position: 10 }]
     @UI: { lineItem       : [ { position: 70 } ],
           identification : [ { position:70 } ]
          }
          @EndUserText.label: 'Transaction Date'
    txndate as Txndate,
     @UI: { lineItem       : [ { position: 80 } ],
           identification : [ { position:80 } ]
          }
          @EndUserText.label: 'Time'
    txntime as Txntime
    //_association_name // Make association public
}
