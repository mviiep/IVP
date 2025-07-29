@EndUserText.label: 'MM Purchase Register'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_MM_PURCHASE_REGISTER'
define custom entity ZMM_PURCHASE_REGISTER
{

      @UI                            : {lineItem: [{ position: 10,label: 'Plant' }]}
      @EndUserText                   : {label: 'Plant'}
      @UI.selectionField             : [ { position: 10}]
      @Consumption.filter.mandatory  : true
  key Plant                          : werks_d;

      @UI                            : {lineItem: [{ position: 70,label: 'PO Number' }]}
      @EndUserText                   : {label: 'PO Number'}
      @UI.selectionField             : [ { position: 20}]
  key PurchaseOrder                  : ebeln;

      @UI                            : {lineItem: [{ position: 80,label: 'PO LineItem' }]}
      @EndUserText                   : {label: 'PO Line Item'}
  key PurchaseOrderItem              : ebelp;

      @UI                            : {lineItem: [{ position: 60,label: 'Purchase Order Date' }]}
      @EndUserText                   : {label: 'Purchase Order Date'}
      @UI.selectionField             : [ { position: 30}]
  key PurchaseOrderDate              : budat;


      @UI                            : {lineItem: [{ position: 280,label: 'Invoice No' }]}
      @EndUserText                   : {label: 'Invoice No'}
      @UI.selectionField             : [ { position: 40}]
  key SupplierInvoice                : ebeln;

      @UI                            : {lineItem: [{ position: 285,label: 'Invoice Item' }]}
      @EndUserText                   : {label: 'Invoice Item'}
  key SupplierInvoiceItem            : abap.numc( 6 );

      @UI                            : {lineItem: [{ position: 250,label: 'Migo Doc No' }]}
      @EndUserText.label             : 'Migo Doc No.'
  key MaterialDocument               : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 260,label: 'Migo Doc Item' }]}
      @EndUserText.label             : 'Migo Doc Item'
  key MaterialDocumentItem           : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 360,label: 'Condition Type' }]}
      @EndUserText.label             : 'Condition Type'
  key ConditionType                  : abap.char(10);

      @UI                            : {lineItem: [{ position: 20,label: 'Plant Name' }]}
      @EndUserText.label             : 'Plant Name'
      PlantName                      : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 30,label: 'PR Date' }]}
      @EndUserText.label             : 'PR Date'
      PurReqCreationDate             : abap.dats( 8 );

      @UI                            : {lineItem: [{ position: 40,label: 'PR Number' }]}
      @EndUserText.label             : 'PR Number'
      PurchaseRequisition            : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 50,label: 'PR Item No' }]}
      @EndUserText.label             : 'PR Item No'
      PurchaseRequisitionItem        : abap.char( 8 );

      @UI                            : {lineItem: [{ position: 55,label: 'PO Type' }]}
      @EndUserText.label             : 'PO Document Time'
      PurchaseOrderType              : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 90,label: 'Material Code' }]}
      @EndUserText.label             : 'Material Code'
      Material                       : abap.char( 18 );

      @UI                            : {lineItem: [{ position: 100,label: 'Material Description' }]}
      @EndUserText.label             : 'Material Description'
      MaterialName                   : abap.char( 40 );

      @UI                            : {lineItem: [{ position: 110,label: 'UOM' }]}
      @EndUserText.label             : 'UOM'
      BaseUnit                       : abap.unit( 3 );

      @UI                            : {lineItem: [{ position: 115,label: 'Delivery Date' }]}
      @EndUserText.label             : 'Delivery Date'
      Deliverydate                   : abap.dats;

      @UI                            : {lineItem: [{ position: 120,label: 'HSN Code' }]}
      @EndUserText.label             : 'HSN Code'
      hsn_code                       : abap.char( 16 );

      @UI                            : {lineItem: [{ position: 130,label: 'Supplier Code' }]}
      @EndUserText.label             : 'Supplier Code'
      Supplier                       : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 140,label: 'Supplier Name' }]}
      @EndUserText.label             : 'Supplier Name'
      SupplierName                   : abap.char( 50 );

      @UI                            : {lineItem: [{ position: 150,label: 'Supplier Region' }]}
      @EndUserText.label             : 'Supplier Region'
      Region                         : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 160,label: 'Supplier Region Name' }]}
      @EndUserText.label             : 'Supplier Region Name'
      RegionName                     : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 170, label: 'Supplier GSTIN' }]}
      @EndUserText.label             : 'Supplier GSTIN'
      SupplierGSTIN                  : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 180,label: 'Department' }]}
      @EndUserText.label             : 'Department'
      PurchasingGroup                : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 190,label: 'Department Description' }]}
      @EndUserText.label             : 'Department Description'
      PurchasingGroupName            : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 200,label: 'Inco Term' }]}
      @EndUserText.label             : 'Inco Terms'
      IncotermsClassification        : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 210,label: 'Payment Term' }]}
      @EndUserText.label             : 'Payment Term'
      PaymentTerms                   : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 220,label: 'PO Quantity' }]}
      @EndUserText.label             : 'PO Quantity'
      OrderQuantity                  : abap.dec( 13, 0 );

      //      @UI                           : {lineItem: [{ position: 222,label: 'PO Base Amount' }]}
      //      @EndUserText.label            : 'PO Base Amount'
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      POBaseAmount                  : abap.curr( 13, 2 );

      //      @UI                           : {lineItem: [{ position: 224,label: 'Discount' }]}
      //      @EndUserText.label            : 'Discount'
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      discount                      : abap.curr( 15,2 );

      //      @UI                           : {lineItem: [{ position: 226,label: 'PO Net Amount' }]}
      //      @EndUserText.label            : 'PO Net Amount'
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      NetAmount                     : abap.curr( 15,2 );

      @UI                            : {lineItem: [{ position: 230,label: 'Balance Quantity' }]}
      @EndUserText.label             : 'Balance Quantity'
      balance_qty                    : abap.dec( 13, 0 );

      @UI                            : {lineItem: [{ position: 235,label: 'Delivery Completed' }]}
      @EndUserText.label             : 'Delivery Completed'
      deliverycompleted              : abap.char( 5 );

      @UI                            : {lineItem: [{ position: 235,label: 'Per UOM' }]}
      @EndUserText.label             : 'Per UOM'
      PerUOM                         : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 265,label: 'Migo Date' }]}
      @EndUserText.label             : 'Migo Date'
      Migodate                       : abap.dats;

      @UI                            : {lineItem: [{ position: 270,label: 'Good Receipt Qty.' }]}
      @EndUserText.label             : 'Good Receipt Qty.'
      GRNQuantity                    : abap.dec( 13, 0 );

      @UI                            : {lineItem: [{ position: 240,label: 'Rate' }]}
      @EndUserText.label             : 'Rate'
      @Semantics.amount.currencyCode : 'DocumentCurrency'
      netpriceamount                 : abap.curr(13,2);

      @UI                            : {lineItem: [{ position: 289,label: 'Invoice Date' }]}
      @EndUserText.label             : 'Invoice Date'
      InvoiceDate                    : abap.dats( 8 );

      @UI                            : {lineItem: [{ position: 290,label: 'Posting Date' }]}
      @EndUserText.label             : 'Posting Date'
      @UI.selectionField             : [ { position: 50}]
      PostingDate                    : abap.dats( 8 );

      @UI                            : {lineItem: [{ position: 293,label: 'GST Partner' }]}
      @EndUserText.label             : 'GST Partner'
      GSTPartner                     : abap.char(15);

      @UI                            : {lineItem: [{ position: 295,label: 'GST Partner Name' }]}
      @EndUserText.label             : 'GST Partner Name'
      GSTPartnerName                 : abap.char(40);

      @UI                            : {lineItem: [{ position: 297,label: 'GST Partner GSTIN' }]}
      @EndUserText.label             : 'GST Partner GSTIN'
      GSTPartnerGSTIN                : abap.char(15);

      @UI                            : {lineItem: [{ position: 300,label: 'Reference Document Number' }]}
      @EndUserText.label             : 'Reference document number'
      SupplierInvoiceIDByInvcgParty  : abap.char( 16 );

      @UI                            : {lineItem: [{ position: 305,label: 'Invoice Line Item Text' }]}
      @EndUserText.label             : 'Invoice Line Item Text'
      InvoiceLineItemText            : abap.char( 50 );

      @UI                            : {lineItem: [{ position: 310,label: 'Business Place' }]}
      @EndUserText.label             : 'Business Place'
      BusinessPlace                  : abap.char( 20 );

      @UI                            : {lineItem: [{ position: 320,label: 'Business Place Description' }]}
      @EndUserText.label             : 'Business Place Description'
      BusinessPlaceDescription       : abap.char( 50 );

      @UI                            : {lineItem: [{ position: 330,label: 'Business Place GSTIN' }]}
      @EndUserText.label             : 'Business Place GSTIN'
      TaxNumber3                     : abap.char( 18 );

      //      @UI                           : {lineItem: [{ position: 340,label: 'Section Code' }]}
      //      @EndUserText.label            : 'Section Code'
      //      SectionCode                   : abap.char(20);

      @UI                            : {lineItem: [{ position: 350,label: 'Invoice Qty' }]}
      @EndUserText.label             : 'Invoice Qty'
      Quantity                       : abap.dec( 13, 0 );

      @UI                            : {lineItem: [{ position: 360,label: 'Base Amount' }]}
      @EndUserText.label             : 'Invoice Base Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      SupplierInvoiceItemAmount      : abap.curr( 15, 2 );

      @UI                            : {lineItem: [{ position: 365,label: 'Exchange Rate' }]}
      @EndUserText.label             : 'Exchange Rate'
      ExchangeRate                   : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 367,label: 'Base Amount with Exchange Rate(INR)' }]}
      @EndUserText.label             : 'Base Amount with Exchange Rate(INR)'
      //      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      BaseAmountExchangeRate         : abap.dec( 18,2 );
      //      @UI                           : {lineItem: [{ position: 390,label: 'Other Charges' }]}
      //      @EndUserText.label            : 'Other Charges'
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      OtherCharges                  : abap.curr( 15, 2 );

      @UI                            : {lineItem: [{ position: 400,label: 'Tax Code' }]}
      @EndUserText.label             : 'Tax Code'
      TaxCode                        : abap.char( 2 );

      @UI                            : {lineItem: [{ position: 410,label: 'Tax Description' }]}
      @EndUserText.label             : 'Tax Description'
      TaxCodeName                    : abap.char( 50 );

      @UI                            : {lineItem: [{ position: 420,label: 'SGST Amount' }]}
      @EndUserText.label             : 'SGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      sgst                           : abap.curr( 13, 2 );
      //      Taxamount

      @UI                            : {lineItem: [{ position: 430,label: 'CGST Amount' }]}
      @EndUserText.label             : 'CGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      cgst                           : abap.curr( 13, 2 );

      @UI                            : {lineItem: [{ position: 440,label: 'IGST Amount' }]}
      @EndUserText.label             : 'IGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      igst                           : abap.curr( 13, 2 );

      @UI                            : {lineItem: [{ position: 450,label: 'RCM SGST Amount' }]}
      @EndUserText.label             : 'RCM SGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      rsgst                          : abap.curr( 13, 2 );

      @UI                            : {lineItem: [{ position: 460,label: 'RCM CGST Amount' }]}
      @EndUserText.label             : 'RCM CGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      rcgst                          : abap.curr( 13, 2 );

      @UI                            : {lineItem: [{ position: 470,label: 'RCM IGST Amount' }]}
      @EndUserText.label             : 'RCM IGST Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      rigst                          : abap.curr( 13, 2 );

      @UI                            : {lineItem: [{ position: 480,label: 'Gross Invoice Amount' }]}
      @EndUserText.label             : 'Gross Invoice Amount'
      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      InvoiceGrossAmount             : abap.curr( 15, 2 );

      @UI                            : {lineItem: [{ position: 485,label: 'Gross Invoice Amount with Exchange(INR)' }]}
      @EndUserText.label             : 'Gross Invoice Amount with Exchange Rate(INR)'
      //      @Semantics.amount.currencyCode : 'supplierdocumentcurrency'
      InvoiceGrossAmountExchangeRate : abap.dec( 18,2 );
      //      @UI                           : {lineItem: [{ position: 380,label: 'Document Currency' }]}
      //      @EndUserText.label            : 'Document Currency'
      DocumentCurrency               : abap.cuky( 5 );
      supplierdocumentcurrency       : abap.cuky( 5 );
      //      @UI                           : {lineItem: [{ position: 510,label: 'Discount%' }]}
      //      @EndUserText.label            : 'Discount%'
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      InvoiceGrossAmount            : abap.curr( 13, 2 );   "gross_inv_amount


      @UI                            : {lineItem: [{ position: 490,label: 'Accounting Document Number' }]}
      @EndUserText.label             : 'Accounting Document Number'
      JournalEntry                   : abap.char( 10 );

      @UI                            : {lineItem: [{ position: 500,label: 'Debit Credit Code' }]}
      @EndUserText.label             : 'Debit Credit Code'
      DebitCreditCode                : abap.char( 50 );

}
