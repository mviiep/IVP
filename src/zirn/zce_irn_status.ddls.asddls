@ObjectModel.query.implementedBy: 'ABAP:ZCL_IRN_REPORT'
@EndUserText.label: 'Custom Entity E-Invoicing Report'
@UI : {
headerInfo:{
typeNamePlural: 'E-Documents',
title: {
type : #STANDARD, value : 'BillingDocument'},
description:{
value: 'BillingDocument'
}
}
}
define root custom entity ZCE_IRN_STATUS
{
      @UI.facet       : [
                       {
                         id:       'Product',
                         purpose        :  #STANDARD,
                         type           :     #IDENTIFICATION_REFERENCE,
                         label          : 'IRN Report',
                         position       : 1 }]
      @UI             : {
      lineItem        : [{position: 10}     , { type: #FOR_ACTION, dataAction: 'IRN_GEN', label: 'Generate IRN'}],
      identification  : [{position: 10}       ,{ type: #FOR_ACTION, dataAction: 'IRN_GEN', label: 'Generate IRN'}],
      selectionField  : [{position: 3}]}

      @EndUserText.label          : 'Document'
  key BillingDocument : abap.char(10);
      @UI             : {
      lineItem        : [{position: 20}, { type: #FOR_ACTION, dataAction: 'EWAY_GEN', label: 'Generate Eway with IRN'}],
      identification  : [{position: 20}, { type: #FOR_ACTION, dataAction: 'EWAY_GEN', label: 'Generate Eway with IRN'}],
      selectionField  : [{position: 1}]
      }
      //      @Consumption.filter.mandatory: true
      @EndUserText.label          : 'Company Code'
  key CompanyCode     : abap.char( 4 );

      @UI             : {
      lineItem        : [{position: 40}, { type: #FOR_ACTION, dataAction: 'EWB_GEN', label: 'Generate Eway'}],
      identification  : [{position: 40}, { type: #FOR_ACTION, dataAction: 'EWB_GEN', label: 'Generate Eway'}],
      selectionField  : [{position: 2}]
          }
      @EndUserText.label          : 'Fiscal Year'
  key FiscalYear      : abap.char( 4 );
      @UI             : {
      lineItem        : [{position: 60}, { type: #FOR_ACTION, dataAction: 'IRN_CNC', label: 'Cancel IRN'}],
      identification  : [{position: 60}, { type: #FOR_ACTION, dataAction: 'IRN_CNC', label: 'Cancel IRN'}],
      selectionField  : [{position: 4}]
      }
      @EndUserText.label : 'Posting Date'
      PostingDate     : abap.datn;
      @UI             : {
      lineItem        : [{position: 120}, { type: #FOR_ACTION, dataAction: 'EWAY_CNC', label: 'Cancel Eway'}],
      identification  : [{position: 120}, { type: #FOR_ACTION, dataAction: 'EWAY_CNC', label: 'Cancel Eway'}]
      }
      @EndUserText.label          : 'IRN No.'
      IRN             : abap.char( 64 );
      @UI             : {
      lineItem        : [{position: 31}],
//      , { type: #FOR_ACTION, dataAction: 'UPDATE_EWAY', label: 'Update Eway'}
      identification  : [{position: 31}],
//      , { type: #FOR_ACTION, dataAction: 'UPDATE_EWAY', label: 'Update Eway'}
      selectionField  : [{position: 5}]
      }
      @EndUserText.label          : 'Plant'
      Plant           : abap.char( 4 );
      @UI             : {
      lineItem        : [{position: 32}],
      identification  : [{position: 32}]
      }
      @EndUserText.label          : 'GST Invoice Number'
      ODN             : abap.char( 20 );
      @UI             : {
      lineItem        : [{position: 33}],
      identification  : [{position: 33}]
      }
      @EndUserText.label          : 'Region'
      Region          : abap.char( 20 );
      @UI             : {
      lineItem        : [{position: 50}],
      identification  : [{position: 50}]
      }
      @UI.hidden      : true
      @EndUserText.label          : 'Module'
      ModuleName      : abap.char( 5 );
      @UI             : {
      lineItem        : [{position: 70}],
      identification  : [{position: 70}]
      }
      @UI.hidden      : true
      @EndUserText.label          : 'Document Type'
      DocumentType    : abap.char( 4 );
      @UI             : {
      lineItem        : [{position: 80}],
      identification  : [{position: 80}]
      }
      @EndUserText.label          : 'IRN Created'
      IRNCreated      : abap.char( 3 );
      @UI             : {
      lineItem        : [{position: 81}],
      identification  : [{position: 81}]
      }
      @EndUserText.label          : 'E-way Created'
      EWayCreated     : abap.char( 3 );
      @UI             : {
      lineItem        : [{position: 90}],
      identification  : [{position: 90}]
      }
      @EndUserText.label          : 'Invoice Canceled'
      InvoiceCanceled : abap.char( 3 );
      @UI             : {
      lineItem        : [{position: 100}],
      identification  : [{position: 100}]
      }
      @EndUserText.label          : 'IRN Canceled'
      IRNCanceled     : abap.char( 3 );
      @UI             : {
      lineItem        : [{position: 101}],
      identification  : [{position: 101}]
      }
      @EndUserText.label          : 'Eway Canceled'
      EwayCanceled    : abap.char( 3 );
      @UI             : {
      lineItem        : [{position: 110}],
      identification  : [{position: 110}]
      }
      @EndUserText.label          : 'Canceled Date'
      CanceledDate    : abap.datn;
      @UI             : {
      lineItem        : [{position: 120 }],
      identification  : [{position: 120}]
      }
      @EndUserText.label          : 'E-Way No'
      eway            : abap.char( 20 );
      @UI             : {
      lineItem        : [{position: 130}],
      identification  : [{position: 130}]
      }
      @EndUserText.label          : 'E-Way Validity'
      ewayvalidity    : abap.char( 20 );
      @UI             : {
      lineItem        : [{position: 135,  type: #WITH_URL , url: 'EwayPdf'  }],
      identification  : [{position: 135,  type: #WITH_URL , url: 'EwayPdf'  }]
      }
      @EndUserText.label          : 'E-Way PDF'
      EwayPdf         : abap.char( 200 );
      @UI             : {
      lineItem        : [{position: 140}],
      identification  : [{position: 140}]
      }
      @EndUserText.label          : 'Status'
      Status          : abap.char( 7 );
      @UI             : {
      lineItem        : [{position: 150}],
      identification  : [{position: 150}]
      }
      @EndUserText.label          : 'Message'
      Message         : abap.char( 256 );
      @UI             : {
      lineItem        : [{position: 160}],
      identification  : [{position: 160}]}
      @EndUserText.label: 'Transporter ID'
      trans_id        : abap.char(15);
      @UI             : {
      lineItem        : [{position: 170}],
      identification  : [{position: 170}]}
      @EndUserText.label: 'Transporter Doc No'
      trans_doc_no    : abap.char(15);
      @UI             : {
      lineItem        : [{position: 180}],
      identification  : [{position: 180}]}
      @EndUserText.label: 'Transport Distance'
      trans_dist      : abap.numc(4);
      @UI             : {
      lineItem        : [{position: 190}],
      identification  : [{position: 190}]}
      @EndUserText.label: 'Transporter Name'
      trans_name      : abap.char(100);
      @UI             : {
      lineItem        : [{position: 200}],
      identification  : [{position: 200}]}
      @EndUserText.label: 'Transporter Doc Date'
      trans_doc_date  : abap.dats;
      @UI             : {
      lineItem        : [{position: 210}],
      identification  : [{position: 210}]}
      @EndUserText.label: 'Vehicle No'
      vehicle_no      : abap.char(10);
      @UI             : {
      lineItem        : [{position: 220}],
      identification  : [{position: 220}]}
      @EndUserText.label: 'Transport Mode'
      modeoftransport : abap.char(1);
}
