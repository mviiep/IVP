@ObjectModel.query.implementedBy: 'ABAP:ZCL_DPR_MONTH'
@EndUserText.label: 'Daily Yield Report'
define custom entity ZCE_DPR_Month
{
      @UI.selectionField       : [{ position:1 }]
      @Consumption.filter.mandatory: true
  key DateRange                : abap.dats;
      @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
      @Consumption.filter.mandatory: true
      @UI.selectionField       : [{ position: 2 }]
  key Plant                    : abap.char( 4 );
      @UI.facet                : [{
                       id      :'plant',
                       label   : 'DPR Monthly',
                       type    : #IDENTIFICATION_REFERENCE,
                       position: 10
                       }]
      @UI                      : {      lineItem: [ { position: 10 } ],
            identification     : [ { position: 10 } ]
      }
      @EndUserText.label       : 'Forecast Quantity(KG)'
      ForecastQty              : abap.char( 20 );
//      @UI : { lineItem       : [ { position: 5 } ],
//              identification : [ { position: 5 } ]
//      }
//      @EndUserText.label       : 'MRP Controller'
      @UI.selectionField       : [{ position: 3 }]
      @Consumption.valueHelpDefinition: [{entity: {element: 'MRPResponsible' , name: 'ZSH_MRPController' }}]
      @Consumption.filter.mandatory: true
      MRPController              : abap.char( 3 );
      @UI                      : {      lineItem: [ { position: 20 } ],
            identification     : [ { position: 20 } ]
      }
      @EndUserText.label       : 'Confirmed Orders(KG)'
      ConfirmedOrder           : abap.char( 20 );
      @UI                      : {      lineItem: [ { position: 30 } ],
            identification     : [ { position: 30 } ]
      }
      @EndUserText.label       : 'Sales Delivered(KG)'
      SalesDelivered           : abap.char( 20 );
      @UI                      : {      lineItem: [ { position: 40 } ],
            identification     : [ { position: 40 } ]
      }
      @EndUserText.label       : 'Production Design Capacity(KG)'
      ProductionDesign         : abap.char( 20 );
      @UI                      : {      lineItem: [ { position: 50 } ],
            identification     : [ { position: 50 } ]
      }
      @EndUserText.label       : 'Production Achieved(KG)'
      ProductionAchieved       : abap.char( 20 );
      @UI                      : {      lineItem: [ { position: 60 } ],
            identification     : [ { position: 60 } ]
      }
      @EndUserText.label       : 'Production Achieved %'
      ProductionAchievedPrcntg : abap.dec( 10, 2 );
}
