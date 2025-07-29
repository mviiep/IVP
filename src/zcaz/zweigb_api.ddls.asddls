@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for weigh bridge API'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZWEIGB_API as select from zwb_details

{
 @UI.facet         : [{
                  id      :'WbNo',
                  label   : 'Weighbridge No',
                  type    : #IDENTIFICATION_REFERENCE,
                  position: 10}]
      @UI               : {  lineItem: [ { position: 10 } ],
         identification : [ { position:10 } ],
         selectionField : [ { position:1  } ]
      }
      @EndUserText.label: 'Plant'
     key zwb_details.plant as plant,
      @UI               : {  lineItem: [ { position: 20 } ],
             identification: [ { position: 20 } ],
             selectionField: [ { position:2 } ]
        }
     @EndUserText.label: 'WeighBridge No'
     key zwb_details.wb_no as wb_no,
      @UI : {  lineItem     : [ { position: 30 } ],
             identification : [ { position: 30 } ],
             selectionField : [ { position: 3  } ]
      }
      @EndUserText.label       : 'Weight'
     zwb_details.weight as weight,
     @UI : {  lineItem     : [ { position: 40 } ],
             identification : [ { position: 40 } ],
             selectionField : [ { position: 4  } ]
             }
      @EndUserText.label       : 'Date'
     zwb_details.zdate as zdate,
     @UI : {  lineItem     : [ { position: 50 } ],
             identification : [ { position: 50 } ],
             selectionField : [ { position: 5  } ]
             }
         @EndUserText.label       : 'Time'
     zwb_details.time as time
             
}
