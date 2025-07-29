@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Corporate payment user cds'
@Metadata.ignorePropagatedAnnotations: true
@UI.headerInfo:{
typeName: 'Corporate Payment User',
typeNamePlural: 'Corporate Payment User'
}
define root view entity ZCPUSERCDS as select from zgeuseraccess
//composition of target_data_source_name as _association_name
{
 @UI.facet         : [{
                      id      :'TradersNo',
                      label   : 'User Name',
                      type    : #IDENTIFICATION_REFERENCE,
                      position: 10}]
          @UI: { lineItem       : [ { position: 10 } ],
                 identification : [ { position:10 } ],
                 selectionField : [ { position:1  } ]
          }
          @EndUserText.label: 'User Name'
  key username as Username,
   @UI: { lineItem       : [ { position: 20 } ],
           identification : [ { position:20 } ],
           selectionField : [ { position:2  } ]
          }
          @EndUserText.label: 'Password'
  password as Password,
   @UI: { lineItem       : [ { position: 30 } ],
           identification : [ { position:30 } ],
           selectionField : [ { position:3  } ]
          }
          @EndUserText.label: 'First Name'
  firstname as Firstname,
   @UI: { lineItem       : [ { position: 40 } ],
           identification : [ { position:40 } ],
           selectionField : [ { position:4  } ]
          }
          @EndUserText.label: 'Last Name'
  lastname as Lastname,
    @UI: { lineItem       : [ { position: 50 } ],
           identification : [ { position:50 } ],
           selectionField : [ { position:5  } ]
          }
          @EndUserText.label: 'Email id'
  emailid as Emailid,
    @UI: { lineItem       : [ { position: 60 } ],
           identification : [ { position:60 } ],
           selectionField : [ { position:6  } ]
          }
          @EndUserText.label: 'Contact Number'
  contact as Contact,
   @UI: { lineItem       : [ { position: 70 } ],
           identification : [ { position:70 } ],
           selectionField : [ { position:7  } ]
          }
          @EndUserText.label: 'Valid From'
  validfrom as Validfrom,
   @UI: { lineItem       : [ { position: 80 } ],
           identification : [ { position:80 } ],
           selectionField : [ { position:8  } ]
          }
          @EndUserText.label: 'Valid To'
  validto as Validto,
   @UI: { lineItem       : [ { position: 90 } ],
           identification : [ { position:90 } ],
           selectionField : [ { position:9  } ]
          }
          @EndUserText.label: 'Created By'
  createdby as Createdby,
   @UI: { lineItem       : [ { position: 100 } ],
           identification : [ { position:100 } ],
           selectionField : [ { position:10  } ]
          }
          @EndUserText.label: 'Created On'
  createdon as Createdon,
   @UI: { lineItem       : [ { position: 110 } ],
           identification : [ { position:110 } ],
           selectionField : [ { position:11  } ]
          }
          @EndUserText.label: 'Changed By'
  changedby as Changedby,
   @UI: { lineItem       : [ { position: 120 } ],
           identification : [ { position:120 } ],
           selectionField : [ { position:12  } ]
          }
          @EndUserText.label: 'Changed On'
  changedon as Changedon
    
}
