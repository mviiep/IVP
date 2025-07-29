//@AbapCatalog.sqlViewName: 'ZZC_DPR'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for DPR'
//@UI.presentationVariant: [{
//
//    sortOrder: [
//
//       { by: 'ManufacturingOrder' }]}]
define root view entity ZC_DPR
  as projection on ZI_DPR
{
          @UI.facet         : [{
                      id      :'TradersNo',
                      label   : 'Process Order',
                      type    : #IDENTIFICATION_REFERENCE,
                      position: 10}]
          @UI               : {  lineItem: [ { position: 30 } ],
             identification : [ { position:30 } ],
             selectionField : [ { position:3  } ]
          }
          @EndUserText.label: 'Process Order'
  key     ManufacturingOrder,
          @UI               : {  lineItem: [ { position: 10 } ],
                 identification: [ { position: 10 } ],
                 selectionField: [ { position:1  } ]
            }
          @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
          @Consumption.filter.mandatory: true
          @EndUserText.label: 'Plant'
  key     Plant,
          @UI : {  lineItem     : [ { position: 40 } ],
                 identification : [ { position: 40 } ],
                 selectionField : [ { position: 2  } ]
          }
          @EndUserText.label: 'Order Type'
          @Consumption.valueHelpDefinition: [{entity: {element: 'OrderType' , name: 'ZI_order_typeF' }}]
          //      @ObjectModel.text.element: [ 'OrderType' ]
          @Consumption.filter.mandatory: true
  key     ManufacturingOrderType,
          @UI : {  lineItem       : [ { position: 20 } ],
                   identification : [ { position: 20 } ]
          }
          @EndUserText.label: 'Posting Date'
  key     PostingDate,
          @UI : {  lineItem       : [ { position: 25 } ],
                   identification : [ { position: 25 } ]
          }
          @EndUserText.label: 'Material Number'
          material,
          @UI : {  lineItem       : [ { position: 26 } ],
                   identification : [ { position: 26 } ]
          }
          @EndUserText.label: 'Material Description'
          ManufacturingOrderText,
          @UI : {  lineItem       : [ { position: 50 } ],
                   identification : [ { position: 50 } ]
          }
          @EndUserText.label: 'Resource'
//          WorkCenter,
         zyata as WorkCenter,
          @UI : {  lineItem       : [ { position: 45 } ],
                   identification : [ { position: 45 } ]
          }
          @UI.hidden: true
          @EndUserText.label: 'Overall Resource Capacity(KG)'
          design_cap,
          @UI : {  lineItem       : [ { position: 50 } ],
                   identification : [ { position: 50 } ]
          }
          @EndUserText.label: 'Resource Capacity(KG)'
           Capcity,
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_DESIGN_CAP'
//  virtual DesignCap : abap.dec( 15, 2 ),
          ProductionUnit,
         
          @UI : {  lineItem       : [ { position: 60 } ],
                   identification : [ { position: 60 } ]
          }
          @EndUserText.label: 'Production Achieved(KG)'
          @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
          ConfYieldQtyInProductionUnit,
           @UI : {  lineItem       : [ { position: 65 } ],
                   identification : [ { position: 65 } ]
          }
          @EndUserText.label: 'Production Achieved %'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_PROD_ACH'
  virtual ProductionAchievedPercentage : abap.dec( 15, 2 ),    
          //      @UI : { lineItem       : [ { position: 70 } ],
          //              identification : [ { position: 70 } ]
          //      }
          //      @EndUserText.label: 'Actual Achieved %'
          //      fltp_to_dec (ActualAchieved as abap.dec(10,2)) as ActualAchiev,
          @UI : {  lineItem       : [ { position: 80 } ],
                   identification : [ { position: 80 } ]
          }
          @EndUserText.label: 'Remark/Comment'
          ConfirmationText
}
