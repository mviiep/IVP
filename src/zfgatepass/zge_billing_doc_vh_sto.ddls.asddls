@EndUserText.label: 'Supplier and Customer KYC Report'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_GE_BILLING_DOC_VH_STO'
    }
}
define custom entity ZGE_BILLING_DOC_VH_sto
{
      @UI.facet               : [{
      //          id:'TradersNo',
                label         : 'ROOM',
                type          : #IDENTIFICATION_REFERENCE,
            //          targetQualifier:'Sales_Tender.SoldToParty',
                position      : 10
                }
                ]

      @UI.selectionField      :[ { position: 10}]
      @UI                     :{lineItem: [{ position: 10,label: 'Billing DOcument' }]}
      //   @UI.selectionField    :[ { position: 10}]
      //  key FREIGHT_ORDER : abap.char( 20 ) ;
  key BillingDocument         : abap.char( 10 );

      @UI                     : {
                 lineItem     : [{position: 20}],
                 identification   : [{position: 20}]
                 }
      @EndUserText.label      : 'Billing Document Type'
  key BillingDocumentType     : abap.char( 10 );

      @UI                     : {
               lineItem       : [{position: 30}],
               identification : [{position: 30}]
               }
      @EndUserText.label      : 'Billing Document Category'
  key BillingDocumentCategory : abap.char( 10 );

      @UI                     : {
               lineItem       : [{position: 40}],
               identification : [{position: 40}]
               }
      @EndUserText.label      : 'Supplier'
  key Supplier                : abap.char( 10 );


      @UI                     : {
            lineItem          : [{position: 50}],
            identification    : [{position: 50}]
            }
      @EndUserText.label      : 'Supplier Name'
  key SupplierName            : abap.char( 30 );

      @UI                     : {
              lineItem        : [{position: 60}],
              identification  : [{position: 60}]
              }
      @EndUserText.label      : 'Supplier Account Group'
  key SupplierAccountGroup    : abap.char( 10 );

      @UI                     : {
              lineItem        : [{position: 70}],
              identification  : [{position: 70}]
              }
      @EndUserText.label      : 'Customer Name'
  key CustomerName            : abap.char( 30 );

      @UI                     : {
              lineItem        : [{position: 80}],
              identification  : [{position: 80}]
              }
      @EndUserText.label      : 'Customer Account Group'
  key CustomerAccountGroup    : abap.char( 10 );

      @UI                     : {
              lineItem        : [{position: 90}],
              identification  : [{position: 90}]
              }
      @EndUserText.label      : 'Creation Date'
  key CreationDate            : abap.char( 10 );

      @UI                     : {
              lineItem        : [{position: 93}],
              identification  : [{position: 93}]
              }
      @EndUserText.label      : 'Created By User'
  key CreatedByUser           : abap.char( 10 );



}
