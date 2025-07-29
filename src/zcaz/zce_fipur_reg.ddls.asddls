@ObjectModel.query.implementedBy: 'ABAP:ZCL_FI_PUR_REG'
@EndUserText.label: 'FI Purchase Register'

define custom entity ZCE_FIPUR_REG
{
      @UI.facet                : [
                  {
                    id         :  'Product',
                    purpose    :  #STANDARD,
                    type       :     #IDENTIFICATION_REFERENCE,
                    label      : 'FI Purchase Register',
                    position   : 10 }
                ]
      @UI                      : {
      lineItem                 : [{position: 260 }],
      identification           : [{position: 260}]
      }
      @EndUserText.label       : 'Migo Doc No'
  key ReferenceDocumentMIRO    : abap.char( 20 );

      @UI                      : {
                lineItem       : [{position: 640}],
                identification : [{position: 640}]
                }
      @EndUserText.label       : 'Reference Document Item'
  key ReferenceDocumentItem    : abap.char( 6 );

      @UI                      : {
      lineItem                 : [{position: 290 }], //, importance: #HIGH}],
      identification           : [{position: 290}],
      selectionField           : [{position: 11}]

      }
      @EndUserText.label       : 'Invoice No'
  key AccountingDocument       : abap.char( 10 );

      @UI                      : {
                lineItem       : [{position: 5}],
                identification : [{position: 5}]
                }
      @EndUserText.label       : 'Plant'
      Plant                    : abap.char( 4 );

      @UI                      : {
          lineItem             : [{position: 10}],
          identification       : [{position: 10}]
          }
      @EndUserText.label       : 'Plant Name'
      PlantName                : abap.char(20);

      @UI                      : {
      lineItem                 : [{position: 25}],
      identification           : [{position: 25}]
      }
      @EndUserText.label       : 'PR Date'
      PRDate                   : abap.datn;

      @UI                      : {
      lineItem                 : [{position: 30}],
      identification           : [{position: 30}]
      }
      @EndUserText.label       : 'PR Number'
      PRNumber                 : abap.char(10);

      @UI                      : {
      lineItem                 : [{position: 40}],
      identification           : [{position: 40}]
      }
      @EndUserText.label       : 'PR Item No'
      PRItemNo                 : abap.char(5);

      @UI                      : {
      lineItem                 : [{position: 50}],
      identification           : [{position: 50}]
      }
      @EndUserText.label       : 'PO Type'
      AccountingDocumentType   : abap.char( 2 );

      @UI                      : {
      lineItem                 : [{position: 60}],
      identification           : [{position: 60}]
      }
      @EndUserText.label       : 'Purchase Order Date'
      PODate                   : abap.datn;

      @UI                      : {
      lineItem                 : [{position: 70}],
      identification           : [{position: 70}]
      }
      @EndUserText.label       : 'PO Number'
      PONumber                 : abap.char(10);

      @UI                      : {
      lineItem                 : [{position: 80}],
      identification           : [{position: 80}]
      }
      @EndUserText.label       : 'PO LineItem'
      POLineItem               : abap.char(4);

      @UI                      : {
      lineItem                 : [{position: 90}],
      identification           : [{position: 90}]
      }
      @EndUserText.label       : 'Material Code'
      MaterialCode             : abap.char( 18 );

      @UI                      : {
      lineItem                 : [{position: 100}],
      identification           : [{position: 100}]
      }
      @EndUserText.label       : 'Material Description'
      MaterialDescription      : abap.char( 40 );

      @UI                      : {
      lineItem                 : [{position: 110}],
      identification           : [{position: 110}]
      }
      @EndUserText.label       : 'UOM'
      UOM                      : abap.unit( 3 );
      
      @UI                      : {
      lineItem                 : [{position: 115}],
      identification           : [{position: 115}]
      }
      @EndUserText.label       : 'Delivery Date'
      DeliveryDate            : abap.dats( 8 );

      @UI                      : {
      lineItem                 : [{position: 120}],
      identification           : [{position: 120}]
      }
      @EndUserText.label       : 'HSN Code'
      HSN                      : abap.char( 16 );

      @UI                      : {
      lineItem                 : [{position: 130}],
      identification           : [{position: 130}],
      selectionField           : [{position: 30}]
      }
      @EndUserText.label       : 'Supplier Code'
      Vendor                   : abap.char( 10 );

      @UI                      : {
      lineItem                 : [{position: 140}],
      identification           : [{position: 140}]
      }
      @EndUserText.label       : 'Supplier Name'
      VendorName               : abap.char( 80 );
      @UI                      : {
      lineItem                 : [{position: 150}],
      identification           : [{position: 150}]
      }
      @EndUserText.label       : 'Supplier Region'
      VendorRegion             : abap.char( 3 );
      @UI                      : {
      lineItem                 : [{position: 160}],
      identification           : [{position: 160}]
      }
      @EndUserText.label       : 'Supplier Region Name'
      RegionName               : abap.char( 20 );

      @UI                      : {
      lineItem                 : [{position: 170}],
      identification           : [{position: 170}]
      }
      @EndUserText.label       : 'Supplier GSTIN'
      GSTIN                    : abap.char( 18 );

      @UI                      : {
      lineItem                 : [{position: 180}],
      identification           : [{position: 180}]
      }
      @EndUserText.label       : 'Department'
      Department               : abap.char( 3 );

      @UI                      : {
      lineItem                 : [{position: 190}],
      identification           : [{position: 190}]
      }
      @EndUserText.label       : 'Department Description'
      DepartmentDescription    : abap.char( 25 );

      @UI                      : {
      lineItem                 : [{position: 200}],
      identification           : [{position: 200}]
      }
      @EndUserText.label       : 'Inco Term'
      IncoTerm                 : abap.char( 3 );

      @UI                      : {
      lineItem                 : [{position: 210}],
      identification           : [{position: 210}]
      }
      @EndUserText.label       : 'Payment Term'
      PaymentTerm              : abap.char( 4 );

      @UI                      : {
      lineItem                 : [{position: 220}],
      identification           : [{position: 220}]
      }
      @EndUserText.label       : 'PO Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      POQuantity               : abap.quan( 13, 0 );

      @UI                      : {
      lineItem                 : [{position: 230}],
      identification           : [{position: 230}]
      }
      @EndUserText.label       : 'Balance Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      BalanceQuantity          : abap.quan( 13, 0 );
      
        @UI                      : {
      lineItem                 : [{position: 235}],
      identification           : [{position: 235}]
      }
      @EndUserText.label       : 'Per UOM '
      @Semantics.quantity.unitOfMeasure: 'UOM'
      peruom          : abap.quan( 13, 0 );

      @UI                      : {
      lineItem                 : [{position: 240}],
      identification           : [{position: 240}]
      }
      @EndUserText.label       : 'Delivery Completed'
      DeliveryCompleted        : abap.char( 3 );

      @UI                      : {
      lineItem                 : [{position: 250}],
      identification           : [{position: 250}]
      }
      @EndUserText.label       : 'Rate'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      Rate                     : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 270}],
      identification           : [{position: 270}]
      }
      @EndUserText.label       : 'Migo Doc Item'
      MigoDocItem              : abap.char( 6 );
      
         @UI                      : {
      lineItem                 : [{position: 275}],
      identification           : [{position: 275}]
      }
      @EndUserText.label       : 'Migo Date'
      MigoDate              : abap.dats;

      @UI                      : {
      lineItem                 : [{position: 280}],
      identification           : [{position: 280}]
      }
      @EndUserText.label       : 'Good Receipt Qty.'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      GoodReceiptQty           : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 300}],
      identification           : [{position: 300}]
      }
      @EndUserText.label       : 'Invoice Item'
      InvoiceItem              : abap.char( 6 );

      @UI                      : {
      lineItem                 : [{position: 310}], //, importance: #HIGH}],
      identification           : [{position: 310}]
      }
      @EndUserText.label       : 'Invoice Date'
      InvoiceDate              : abap.dats( 8 );

      @Consumption.filter.mandatory: true
      @UI                      : {
      lineItem                 : [{position: 320}], //, importance: #HIGH}],
      identification           : [{position: 320}],
      selectionField           : [{position: 20}]
      }
      @EndUserText.label       : 'Posting Date'
      PostingDate              : abap.dats( 8 );
      
        @UI                      : {
      lineItem                 : [{position: 325}], //, importance: #HIGH}],
      identification           : [{position: 325}]
      }
      @EndUserText.label       : 'GSTN PARTN'
      GSTNParter              : abap.char(40); 

      @UI                      : {
      lineItem                 : [{position: 330, importance: #HIGH}],
      identification           : [{position: 330}]
      }
      @EndUserText.label       : 'Reference Document Number'
      RefDocNo                 : abap.char( 16 );

      @UI                      : {
      lineItem                 : [{position: 340}],
      identification           : [{position: 340}]
      }
      @EndUserText.label       : 'Invoice Line Item Text'
      InvoiceLineItemText      : abap.char( 40 );

      @UI                      : {
      lineItem                 : [{position: 350}],
      identification           : [{position: 350}]
      }
      @EndUserText.label       : 'Business Place'
      BusinessPlace            : abap.char( 10 );

      @UI                      : {
      lineItem                 : [{position: 360}],
      identification           : [{position: 360}]
      }
      @EndUserText.label       : 'Business Place Description'
      BusinessPlaceDescription : abap.char( 40 );

      @UI                      : {
      lineItem                 : [{position: 370}],
      identification           : [{position: 370}]
      }
      @EndUserText.label       : 'Business Place GSTIN'
      BusinessPlaceGSTIN       : abap.char( 18 );

      @UI                      : {
      lineItem                 : [{position: 380}],
      identification           : [{position: 380}]
      }
      @EndUserText.label       : 'Invoice Qty'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      InvoiceQty               : abap.quan( 13, 0 );

      @UI                      : {
      lineItem                 : [{position: 580}],
      identification           : [{position: 580}]
      }
      @EndUserText.label       : 'DocumentCurrency'
      DocumentCurrency         : abap.cuky( 5 );

      @UI                      : {
      lineItem                 : [{position: 590}],
      identification           : [{position: 590}]
      }
      @EndUserText.label       : 'supplierdocumentcurrency'
      supplierdocumentcurrency : abap.cuky( 5 );

      @UI                      : {
      lineItem                 : [{position: 400}],
      identification           : [{position: 400}]
      }
      @EndUserText.label       : 'Base Amount'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      BaseAmount               : abap.curr( 15, 2 );

      @UI                      : {
      lineItem                 : [{position: 410}],
      identification           : [{position: 410}]
      }
      @EndUserText.label       : 'Condition Type'
      ConditionType            : abap.char( 4 );

      @UI                      : {
      lineItem                 : [{position: 420}],
      identification           : [{position: 420}]
      }
      @EndUserText.label       : 'Exchange Rate'
      TaxRate                  : abap.char( 4 );


      @UI                      : {
       lineItem                : [{position: 430}],
       identification          : [{position: 430}]
       }
      @EndUserText.label       : 'Base Amount with Exchange Rate(INR)'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      BaseAmountwexchangerate  : abap.curr( 15, 2 );


      @UI                      : {
      lineItem                 : [{position: 440}],
      identification           : [{position: 440}]
      }
      @EndUserText.label       : 'Tax Code'
      TaxCode                  : abap.char( 2 );

      @UI                      : {
      lineItem                 : [{position: 450}],
      identification           : [{position: 450}]
      }
      @EndUserText.label       : 'Tax Description'
      TaxDescription           : abap.char( 4 );

      @UI                      : {
      lineItem                 : [{position: 460}],
      identification           : [{position: 460}]
      }
      @EndUserText.label       : 'SGST Amount'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      SGST                     : abap.curr( 13, 2 );


      @UI                      : {
      lineItem                 : [{position: 470}],
      identification           : [{position: 470}]
      }
      @EndUserText.label       : 'CGST Amount'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      CGST                     : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 480}],
      identification           : [{position: 480}]
      }
      @EndUserText.label       : 'IGST Amount'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      IGST                     : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 490}],
      identification           : [{position: 490}]
      }
      @EndUserText.label       : 'RCM CGST OUTPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RCGST                    : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 500}],
      identification           : [{position: 500}]
      }
      @EndUserText.label       : 'RCM SGST OUTPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RSGST                    : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 510}],
      identification           : [{position: 510}]
      }
      @EndUserText.label       : 'RCM IGST OUTPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RIGST                    : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 520}],
      identification           : [{position: 520}]
      }
      @EndUserText.label       : 'RCM CGST INPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RCGSTO                   : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 530}],
      identification           : [{position: 530}]
      }
      @EndUserText.label       : 'RCM SGST INPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RSGSTO                   : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 540}],
      identification           : [{position: 540}]
      }
      @EndUserText.label       : 'RCM IGST INPUT AMT'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      RIGSTO                   : abap.curr( 13, 2 );

      @UI                      : {
      lineItem                 : [{position: 550}],
      identification           : [{position: 550}]
      }
      @EndUserText.label       : 'Gross Amount'
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      GrossAmountwexchange     : abap.curr( 15, 2 );

      @UI                      : {
      lineItem                 : [{position: 560}],
      identification           : [{position: 560}]
      }
      @EndUserText.label       : 'Gross Invoice Amount with Exchange(INR) '
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      GrossAmount              : abap.curr( 15, 2 );
      
            @UI                      : {
      lineItem                 : [{position: 565}],
      identification           : [{position: 565}]
      }
      @EndUserText.label       : 'Accounting Document Number'
      Accountingdocumentno             : abap.char(10);
      

      @UI                      : {
      lineItem                 : [{position: 570}],
      identification           : [{position: 570}]
      }
      @EndUserText.label       : 'Debit Credit Code'
      DebitCreditCode          : abap.char( 50 );


      @UI                      : {
      lineItem                 : [{position: 600}],
      identification           : [{position: 600}]
      }
      @EndUserText.label       : 'GL Account'
      GLAccount                : abap.char( 10 );

      @UI                      : {
      lineItem                 : [{position: 610}],
      identification           : [{position: 610}]
      }
      @EndUserText.label       : 'GL Account Name'
      GLAccountLongName        : abap.char( 40 );

      @UI                      : {
      lineItem                 : [{position: 620}],
      identification           : [{position: 620}]
      }
      @EndUserText.label       : 'Document Text'
      DOCUMENTITEMTEXT         : abap.char( 50 );

      @UI                      : {
                lineItem       : [{position: 630}],
                identification : [{position: 630}]
                }
      @EndUserText.label       : 'Accounting Document Item'
      AccountingDocumentItem   : abap.char( 6 );

}
