@ObjectModel.query.implementedBy: 'ABAP:ZCL_DAILY_BREAKDOWN'
@EndUserText.label: 'Composite view for daily breakdown'
define custom entity ZC_DAILY_Breakdown
{
      @UI.facet          : [{
                    id   :'ProcessOrder',
                    label: 'Daily Breakdown Report',
                    type : #IDENTIFICATION_REFERENCE,
                    position  : 10   }]
      @UI                : {  lineItem: [ { position: 15 } ],
              identification: [ { position:15 } ],
          selectionField : [ { position: 2 } ]
         }
      @EndUserText.label : 'Process Order'
  key ProcessOrder       : abap.char( 12 );

      @UI                : {  lineItem: [ { position: 70 } ],
             identification: [ { position: 70 } ]
        }
      @EndUserText.label : 'Reason'
  key reason             : abap.char(40);

      @UI                : {  lineItem: [ { position: 40 } ],
                 identification: [ { position: 40 } ]
            }
      @EndUserText.label : 'Work Center'
  key WorkCenter         : abap.char(10);

      @UI                : {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ],
          selectionField : [ { position: 1 } ]
         }
      @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
      @EndUserText.label : 'Plant'
      plant              : bukrs;
      
      @UI : {  lineItem      : [ { position: 16 } ],
               identification: [ { position: 16 } ]
         }
      @EndUserText.label : 'Product'
      Product : abap.char(20);
      
      @UI : {  lineItem      : [ { position: 17 } ],
               identification: [ { position: 17 } ]
         }
      @EndUserText.label : 'Product Description'
      ProductDescription : abap.char(20);
      
      @UI : {  lineItem      : [ { position: 18 } ],
               identification: [ { position: 18 } ]
         }
      @EndUserText.label : 'Batch'
      Batch : abap.char(20);

      @UI                : {  lineItem: [ { position: 20 } ],
              identification: [ { position: 20 } ],
              selectionField: [ { position: 4  } ]
         }
      @EndUserText.label : 'Date'
      datep              : abap.datn;

      @UI                : {  lineItem: [ { position: 30 } ],
              identification: [ { position: 30 } ],
          selectionField : [ { position: 3  } ]
         }
      @Consumption.valueHelpDefinition: [{entity: {element: 'OrderType' , name: 'ZI_order_type' }}]
      @ObjectModel.text.element: [ 'OrderType' ]
      @EndUserText.label : 'Order Type'
      OrderType          : abap.char( 4 );

      @UI                : {  lineItem: [ { position: 40 } ],
              identification: [ { position: 40 } ]
         }
      @EndUserText.label : 'Batch Start Time'
      confirmedstarttime : abap.tims;

      @UI                : {  lineItem: [ { position: 50 } ],
              identification: [ { position: 50 } ]
         }
      @EndUserText.label : 'Batch End Time'
      confirmedendtime   : abap.tims;

      @UI                : {  lineItem: [ { position: 40 } ],
         identification  : [ { position: 40 } ]
      }
      @EndUserText.label : 'Batch Start Date'
      confirmedstartdate : abap.datn;

      @UI                : {  lineItem: [ { position: 50 } ],
              identification: [ { position: 50 } ]
         }
      @EndUserText.label : 'Batch End Date'
      confirmedenddate   : abap.datn;

      @UI                : {  lineItem: [ { position: 60 } ],
              identification: [ { position: 60 } ]
         }
      @EndUserText.label : 'Maintainance Hours'
      MaintainanceHours  : abap.string( 256 );

      @UI                : {  lineItem: [ { position: 80 } ],
              identification: [ { position: 80 } ]
         }
      @EndUserText.label : 'Batch Cycle Time'
      processorderhrs    : abap.tims;

}
