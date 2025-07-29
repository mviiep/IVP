@EndUserText.label: 'Track Freight Order'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FREIGHT_ORDER'
define custom entity ZCE_FREIGHT_ORDER
{
      @UI.facet            : [{
                       id  : 'GSTInvoiceNo',
                       label   : 'Track Freight Order ',
                       type: #IDENTIFICATION_REFERENCE,
                       position: 10
                       }]
      @UI                  : { lineItem       : [ { position: 10 } ],
                          identification : [ { position: 10 } ] }
      @EndUserText.label   : 'GST Invoice No'
  key GSTInvoiceNo         : abap.char(20);

      @UI                  : { lineItem       : [ { position: 5 } ],
                          identification : [ { position: 5 } ] }
      @EndUserText.label   : 'Plant'
  key PLANT                : abap.char( 4 );

      @UI                  : { lineItem       : [ { position: 20 } ],
                          identification : [ { position: 20 } ] }
      @UI.selectionField   : [ { position: 10}]
      @EndUserText.label   : 'Billing Document Number'
  key BillingDocument      : abap.char(10);

      @UI                  : { lineItem       : [ { position: 25 } ],
                          identification : [ { position: 25 } ] }
      @EndUserText.label   : 'Billing Item'
  key BillingDocumentItem  : abap.char(6);

      @EndUserText.label   : 'Billing Date'
      @UI.selectionField   : [ { position: 20}]
      @Consumption.filter.mandatory: true
  key BillingDocumentDate1 : abap.dats;

      @UI                  : { lineItem       : [ { position: 90 } ],
                          identification : [ { position: 90 } ] }
      @EndUserText.label   : 'Freight Cost Allocation Doc No.'
  key FreighCostDocNo      : abap.char(20);

      @UI                  : { lineItem       : [ { position: 233 } ],
                          identification : [ { position: 233 } ] }
      @EndUserText.label   : 'MIRO Amount'
  key plancost             : abap.dec( 10, 2 );

      @UI                  : { lineItem       : [ { position: 236 } ],
                              identification : [ { position: 236 } ] }
      @EndUserText.label   : 'MIRO-Unplanned Amount'
  key unplancost           : abap.dec( 10, 2 );

      @UI                  : { lineItem       : [ { position: 80 } ],
                          identification : [ { position: 80 } ] }
      @EndUserText.label   : 'PO No.'
  key PoNo                 : abap.char(10);

      @UI                  : { lineItem       : [ { position: 30 } ],
                          identification : [ { position: 30 } ] }
      @EndUserText.label   : 'Billing Date'
      BillingDocumentDate  : abap.char(10);

      @UI                  : { lineItem       : [ { position: 40 } ],
                              identification : [ { position: 40 } ] }
      @EndUserText.label   : 'Delivery No.'
      @UI.selectionField   : [ { position: 30}]
      DeliveryNo           : abap.char(10);

      @UI                  : { lineItem       : [ { position: 45 } ],
                              identification : [ { position: 45 } ] }
      @EndUserText.label   : 'Delivery Date'
      DeliveryDate         : abap.char(10);

      @UI                  : { lineItem       : [ { position: 50 } ],
                          identification : [ { position: 50 } ] }
      @EndUserText.label   : 'Sales Order No.'
      SalesOrderNo         : abap.char(10);

      //      @UI                 : { lineItem       : [ { position: 60 } ],
      //                          identification : [ { position: 60 } ] }
      //      @EndUserText.label  : 'Freight Unit'
      //      FreightUnit         : abap.char(10);

      @UI                  : { lineItem       : [ { position: 7 } ],
                          identification : [ { position: 7 } ] }
      @EndUserText.label   : 'Freight Order No'
      @UI.selectionField   : [ { position: 5}]
      FreightOrderNo       : abap.char(20);

      @UI                  : { lineItem       : [ { position: 100 } ],
                          identification : [ { position: 100 } ] }
      @EndUserText.label   : 'Customer Code'
      CustomerCode         : abap.char(10);

      @UI                  : { lineItem       : [ { position: 110 } ],
                          identification : [ { position: 110 } ] }
      @EndUserText.label   : 'Customer Name'
      CustomerName         : abap.char(25);

      @UI                  : { lineItem       : [ { position: 120 } ],
                          identification : [ { position: 120 } ] }
      @EndUserText.label   : 'Profit Centre Name'
      ProfitCentreName     : abap.char(30);

      @UI                  : { lineItem       : [ { position: 130 } ],
                          identification : [ { position: 130 } ] }
      @EndUserText.label   : 'Destination'
      Destination          : abap.char(10);

      @UI                  : { lineItem       : [ { position: 140 } ],
                          identification : [ { position: 140 } ] }
      @EndUserText.label   : 'MaterialCode'
      MaterialCode         : abap.char(10);

      @UI                  : { lineItem       : [ { position: 150 } ],
                          identification : [ { position: 150 } ] }
      @EndUserText.label   : 'Product Name'
      ProductName          : abap.char(25);
      BillingQuantityUnit  : abap.unit( 3 );
      @UI                  : { lineItem       : [ { position: 160 } ],
                          identification : [ { position: 160 } ] }
      @EndUserText.label   : 'Net Qty.'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      NetQty               : abap.dec(13,0);

      @UI                  : { lineItem       : [ { position: 170 } ],
                          identification : [ { position: 170 } ] }
      @EndUserText.label   : 'Gross Qty.'
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      GrossQty             : abap.dec(13,0);

      ItemWeightUnit       : abap.unit( 3 );
      @UI                  : { lineItem       : [ { position: 175 } ],
                          identification : [ { position: 175 } ] }
      @EndUserText.label   : 'Gross Weight'
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      Weight               : abap.dec(13,0);

      @UI                  : { lineItem       : [ { position: 180 } ],
                          identification : [ { position: 180 } ] }
      @EndUserText.label   : 'Incoterm'
      Incoterm             : abap.char( 10 );

      @UI                  : { lineItem       : [ { position: 185 } ],
                              identification : [ { position: 185 } ] }
      @EndUserText.label   : 'Transporter'
      Transporter          : abap.char( 10 );

      @UI                  : { lineItem       : [ { position: 190 } ],
                          identification : [ { position: 190 } ] }
      @EndUserText.label   : 'Name Of Transporter'
      NameOfTransporter    : abap.char(30);

      @UI                  : { lineItem       : [ { position: 200 } ],
                          identification : [ { position: 200 } ] }
      @EndUserText.label   : 'Lr No'
      LrNo                 : abap.char( 10 );

      @UI                  : { lineItem       : [ { position: 210 } ],
                          identification : [ { position: 210 } ] }
      @EndUserText.label   : 'Freight Order Status'
      FreightUnitStatus    : abap.char( 20 );

      @UI                  : { lineItem       : [ { position: 220 } ],
                          identification : [ { position: 220 } ] }
      @EndUserText.label   : 'Service Entry Sheet'
      ServiceEntrySheet    : abap.char( 20 );
      
       @UI                  : { lineItem       : [ { position: 240 } ],
                          identification : [ { position: 240 } ] }
      @EndUserText.label   : 'Creation Date'
      creationDate    : abap.char( 20 );
      
      
      

      @UI                  : { lineItem       : [ { position: 230 } ],
                          identification : [ { position: 230 } ] }
      @EndUserText.label   : 'Freight Amount'
      FreightAmount        : abap.dec( 10, 2 );


      @UI                  : { lineItem       : [ { position: 240 } ],
                          identification : [ { position: 240 } ] }
      @EndUserText.label   : 'MIRO Number'
      MIRONo               : abap.char( 20 );

      //      @UI                 : { lineItem       : [ { position: 250 } ],
      //                          identification : [ { position: 250 } ] }
      //      @EndUserText.label  : 'MIRO Amount'
      //      MIROAmount          : abap.dec( 10, 2 );

      @UI                  : { lineItem       : [ { position: 260 } ],
                          identification : [ { position: 260 } ] }
      @EndUserText.label   : 'Variance'
      Variance             : abap.dec( 10, 2 );
      
       @UI                  : { lineItem       : [ { position: 260 } ],
                          identification : [ { position: 260 } ] }
      @EndUserText.label   : 'LR Number'
     LR_NO             : abap.char(30);
      
      
      
      
      
}
