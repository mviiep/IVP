@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for transaction detail pending'
define root view entity ZTB_RESOURCE_CAP1 as select from ztb_resource_cap
{
 @UI.facet: [{
                     id:'TradersNo',
                     label: 'Resource Capacity',
                     type      : #IDENTIFICATION_REFERENCE,
                     position  : 10
                     }]
      @UI: {  lineItem: [ { position: 10 } ],
         identification: [ { position: 10 } ]
      }
      @EndUserText.label: 'Plant'
      
 key ztb_resource_cap.plant as Plant,
      @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position: 20 } ]
           }
      @EndUserText.label: 'Resource'
  
 key ztb_resource_cap.resrce as Resrce,
 
      @UI: {  lineItem: [ { position: 30 } ],
              identification: [ { position: 30 } ]
           }
      @EndUserText.label: 'Design Capacity'

 key ztb_resource_cap.design_cap as Design_Cap
}
