@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Communication ID&PWD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_apicreden 
    as select from ztb_apicreden
//composition of target_data_source_name as _association_name
{
 @UI.facet         : [{
                      id      :'SystemID',
                      label   : 'System No',
                      type    : #IDENTIFICATION_REFERENCE,
                      position: 10}]
          @UI: { lineItem       : [ { position: 10 } ],
                 identification : [ { position:10 } ],
                 selectionField : [ { position:1  } ]
          }               
   @EndUserText.label: 'System No'  
  key $session.client as SystemID,
    @UI: { lineItem       : [ { position: 20 } ],
           identification : [ { position:20 } ],
           selectionField : [ { position:2  } ]
          }                        
   @EndUserText.label: 'User Name'                          
      username        as Username,
    @UI: { lineItem       : [ { position: 30 } ],
           identification : [ { position:30 } ],
           selectionField : [ { position:3  } ]
          }                        
   @EndUserText.label: 'Password'                          
      password        as Password ,   
   @UI: { lineItem       : [ { position: 40 } ],
           identification : [ { position:40 } ],
           selectionField : [ { position:4  } ]
          }                        
   @EndUserText.label: 'Tenant URL'     
      tenanturl       as tenanturl
}
