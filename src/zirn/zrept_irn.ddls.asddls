@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Report for IRN Manage scenario'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZREPT_IRN
  as select from ZI_IRN_ALV
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
  key BillingDocument,
      @UI             : {
        lineItem        : [{position: 20}
        //      , { type: #FOR_ACTION, dataAction: 'EWAY_GEN', label: 'Generate Eway with IRN'}
        ],
        identification  : [{position: 20}
        //      , { type: #FOR_ACTION, dataAction: 'EWAY_GEN', label: 'Generate Eway with IRN'}
        ],
        selectionField  : [{position: 1}]
        }
        //      @Consumption.filter.mandatory: true
      @EndUserText.label          : 'Company Code'
  key CompanyCode,
      @UI             : {
      lineItem        : [{position: 40}
      //            , { type: #FOR_ACTION, dataAction: 'EWAY_CNC', label: 'Cancel Eway'}
      ],
      identification  : [{position: 40}
      //            , { type: #FOR_ACTION, dataAction: 'EWAY_CNC', label: 'Cancel Eway'}
      ],
      selectionField  : [{position: 2}]
          }
      @EndUserText.label          : 'Fiscal Year'
  key FiscalYear,
      @UI             : {
      lineItem        : [{position: 60}
      //      , { type: #FOR_ACTION, dataAction: 'IRN_CNC', label: 'Cancel IRN'}
      ],
      identification  : [{position: 60}
      //      , { type: #FOR_ACTION, dataAction: 'IRN_CNC', label: 'Cancel IRN'}
      ],
      selectionField  : [{position: 4}]
      }
      //      @Consumption.filter.mandatory: true
      @EndUserText.label          : 'Posting Date'
  key PostingDate,
      @UI             : {
          lineItem        : [{position: 120}
          //            , { type: #FOR_ACTION, dataAction: 'EWB_GEN', label: 'Generate Eway'}
          ],
          identification  : [{position: 120}
          //            , { type: #FOR_ACTION, dataAction: 'EWB_GEN', label: 'Generate Eway'}
          ]
          }
      @EndUserText.label          : 'IRN No.'
  key IRN,
      @UI             : {
          lineItem        : [{position: 31}],
          identification  : [{position: 31}],
          selectionField  : [{position: 5}]
          }
      @EndUserText.label          : 'Plant'
      plant,
      @UI             : {
      lineItem        : [{position: 50}],
      identification  : [{position: 50}]
      }
      @UI.hidden      : true
      @EndUserText.label          : 'Module'
      ModuleName,
      @UI             : {
      lineItem        : [{position: 70}],
      identification  : [{position: 70}]
      }
      @UI.hidden      : true
      @EndUserText.label          : 'Document Type'
      DocumentType,
      @UI             : {
      lineItem        : [{position: 80}],
      identification  : [{position: 80}]
      }
      @EndUserText.label          : 'IRN Created'
      IRNCreated,
      @UI             : {
      lineItem        : [{position: 81}],
      identification  : [{position: 81}]
      }
      @EndUserText.label          : 'E-way Created'
      EwayCreated,
      @UI             : {
      lineItem        : [{position: 90}],
      identification  : [{position: 90}]
      }
      @EndUserText.label          : 'Invoice Canceled'
      InvoiceCanceled,
      @UI             : {
      lineItem        : [{position: 100}],
      identification  : [{position: 100}]
      }
      @EndUserText.label          : 'IRN Canceled'
      IRNCanceled,
      @UI             : {
      lineItem        : [{position: 101}],
      identification  : [{position: 101}]
      }
      @EndUserText.label          : 'Eway Canceled'
      EwayCanceled,
      @UI             : {
      lineItem        : [{position: 110}],
      identification  : [{position: 110}]
      }
      @EndUserText.label          : 'Canceled Date'
      CanceledDate,
      @UI             : {
      lineItem        : [{position: 120}],
      identification  : [{position: 120}]
      }
      @EndUserText.label          : 'E-Way No'
      eway,
      @UI             : {
      lineItem        : [{position: 130}],
      identification  : [{position: 130}]
      }
      @EndUserText.label          : 'E-Way Validity'
      ewayvalidity,
      @UI             : {
      lineItem        : [{position: 140}],
      identification  : [{position: 140}]
      }
      @EndUserText.label          : 'Status'
      Status,
      @UI             : {
      lineItem        : [{position: 150}],
      identification  : [{position: 150}]
      }
      @EndUserText.label          : 'Message'
      Message
}
