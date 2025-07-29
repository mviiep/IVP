@ObjectModel.query.implementedBy: 'ABAP:ZCL_DAILY_YIELD'
@EndUserText.label: 'Daily Yield Report'
@UI : {
headerInfo:{
typeNamePlural: 'Yield Report',
title: {
type : #STANDARD, value : 'ProcessOrder'},
description:{
value: 'ProcessOrder'
}
}
}
define custom entity ZC_DAILY_YEILD_REPORT
{

      @UI.facet         : [{
                id      :'TradersNo',
                label   : 'Process Order',
                type    : #IDENTIFICATION_REFERENCE,
            //          targetQualifier:'Sales_Tender.SoldToParty',
                position: 10
                }
                ]
      @UI               : {  lineItem: [ { position: 30 } ],
         identification : [ { position:30 } ],
         selectionField : [ { position:3  } ]

      }
      @EndUserText.label: 'Process Order'

  key ProcessOrder      : abap.char( 12 );
      @UI               : {  lineItem: [ { position: 10 } ],
             identification: [ { position: 10 } ],
             selectionField: [ { position:1  } ]
        }
      @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
      @Consumption.filter.mandatory: true
      @EndUserText.label: 'Plant'
  key Plant             : abap.char( 4 );
      @UI               : {  lineItem: [ { position: 20 } ],
         identification : [ { position: 20 } ],
         selectionField : [ { position:2  } ]
      }
      @EndUserText.label: 'Order Type'
      @Consumption.valueHelpDefinition: [{entity: {element: 'OrderType' , name: 'ZI_order_typeyield' }}]
      //      @ObjectModel.text.element: [ 'OrderType' ]
      @Consumption.filter.mandatory: true
  key OrderType         : abap.char( 4 );
      @UI               : {  lineItem: [ { position: 32 } ],
         identification : [ { position: 32 } ],
         selectionField : [ { position:5  } ]
      }
      //      @ObjectModel.text.element: [ 'ProductName' ]
      @EndUserText.label: 'Product'
  key Product           : abap.char(18);

      //       div( fltp_to_dec ( a.test as abap.dec( 10, 0 ) ), fltp_to_dec ( a.test as abap.dec( 10, 0 ) )) as test,
      @UI               : {  lineItem: [ { position: 35 } ],
         identification : [ { position: 35 } ]
      }
      @EndUserText.label: 'Product Description'
      ProductName       : abap.char(50);

      @UI               : {  lineItem: [ { position: 40 } ],
         identification : [ { position: 40 } ]

      }
      @EndUserText.label: 'Batch Number'
      Batch             : abap.char( 10 );
      @UI               : {  lineItem: [ { position: 50 } ],
         identification : [ { position: 50 } ],
         selectionField : [ { position:4  } ]

      }
      @EndUserText.label: 'Manufacturing Date'
      ManufactureDate   : abap.datn;
      @UI               : {  lineItem: [ { position: 60 } ],
       identification   : [ { position: 60 } ]
      }
      @EndUserText.label: 'Resource'
      WorkCenter        : abap.char( 10 );
      @UI               : {  lineItem: [ { position: 70 } ],
       identification   : [ { position: 70 } ]
      }
      @EndUserText.label: 'Standard Input Quantity'
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      standardinputqnty : abap.quan( 10, 2 );
      EntryUnit         : abap.unit( 2 );
      @UI               : {  lineItem: [ { position: 80 } ],
       identification   : [ { position: 80 } ]
      }
      @EndUserText.label: 'Process Order Input Quantity'
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      poinputqty        : abap.quan( 10, 2 );
      MaterialBaseUnit  : abap.unit( 2 );

      @UI               : {  lineItem: [ { position: 90 } ],
       identification   : [ { position: 90 } ]
      }
      @EndUserText.label: 'FG Output Quantity'
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      OutputQuantity    : abap.quan( 10, 2 );
      @UI               : {  lineItem: [ { position: 100 } ],
      identification    : [ { position: 100 } ]
      }
      @EndUserText.label: 'Expected Yield'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ExpectedYeild     : abap.char(10);
      @UI               : {  lineItem: [ { position: 110 } ],
      identification    : [ { position: 110 } ]
      }
      @EndUserText.label: 'Actual Yield'
      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      Actualyield       : abap.char(10);
      //              fltp_to_dec ( a.Actualyield as abap.dec(16,4)) * 100 as ActualYield,
      @UI               : {  lineItem: [ { position: 120 } ],
      identification    : [ { position: 120 } ]
      }
      @EndUserText.label: 'Usage Decision'
      UsageDecision     : abap.char(50);
      @UI               : {  lineItem: [ { position: 130 } ],
      identification    : [ { position: 130 } ]
      }
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      @EndUserText.label: 'Planned Cost'
      PlantCost         : abap.curr( 10, 2 );
      //              sum(a.PlantCost)                                     as Pcost,
      @UI               : {  lineItem: [ { position: 140 } ],
      identification    : [ { position: 140 } ]
      }
      //      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      @EndUserText.label: 'Actual Cost'
      ActualCost        : abap.curr( 10, 2 );
      //              sum(a.ActualCost)                                    as Acost,
      DisplayCurrency   : abap.cuky( 5 );
      @UI               : {  lineItem: [ { position: 150 } ],
      identification    : [ { position: 150 } ]
      }
      @EndUserText.label: 'Variance'
      @Semantics.amount.currencyCode: 'DisplayCurrency'
      variance          : abap.curr( 10, 2 );
      @UI               : {  lineItem: [ { position: 85 } ],
      identification    : [ { position: 85 } ]
      }
      @EndUserText.label: 'SFG Output Quantity'
      SFG_output        : abap.char( 10 );
      //              sum(a.ActualCost) - sum(a.PlantCost)                 as variance

}
