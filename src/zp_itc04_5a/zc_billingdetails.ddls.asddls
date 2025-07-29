@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption view for Billing Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@UI:{ headerInfo: { typeName: 'ITC_04_5A',
                    typeNamePlural: 'ITC_04_5A',
                    title: { type: #STANDARD, label: 'ITC_04_5A' }}}
define root view entity ZC_BILLINGDETAILS
  provider contract transactional_query as projection on ZI_BILLINGDETAILS
{

@UI.facet: [{ id: 'ITC',
              purpose: #STANDARD,
              type: #IDENTIFICATION_REFERENCE,
              label: 'ITC_04_5A',
              position: 01 }]

    @EndUserText.label: 'Billing Document'
    @UI: { lineItem: [{ position: 10,label: 'Billing Document' },
    { type: #FOR_ACTION, dataAction: 'send_to_portal', label: 'Send To Portal', position: 10}],
    identification: [{ position: 10,label: 'Billing Document' },
    { type: #FOR_ACTION, dataAction: 'send_to_portal', label: 'Send To Portal', position: 10}],
    selectionField: [{ position: 10 }] }
    key billingdocument,
    @EndUserText.label: 'Billing Document Item'
    @UI: { lineItem: [{ position: 20,label: 'Billing Document Item' }],
    identification: [{ position: 20, label: 'Billing Document Item' }],
    selectionField: [{ position: 20 }] }
    key billingdocumentitem,
    @EndUserText.label: 'Billing Document Type'
    @UI: { lineItem: [{ position: 30,label: 'Billing Document Type' }],
    identification: [{ position: 30, label: 'Billing Document Type' }] }
    billingdocumenttype,
    @EndUserText.label: 'Plant'
    @UI: { lineItem: [{ position: 40,label: 'Plant' }],
    identification: [{ position: 40, label: 'Plant' }] }
    billingdocumentplant,
    @EndUserText.label: 'Billing Document Date'
    @UI: { lineItem: [{ position: 50,label: 'Billing Document Date' }],
    identification: [{ position: 50, label: 'Billing Document Date' }],
    selectionField: [{ position: 50 }] }
    @Consumption.filter.mandatory: true
    billindocumentdate,
    @EndUserText.label: 'Item Text'
    @UI: { lineItem: [{ position: 60,label: 'Item Text' }],
    identification: [{ position: 60, label: 'Item Text' }] }
    billingdocumentitemtext,
    @EndUserText.label: 'Company Code'
    @UI: { lineItem: [{ position: 70,label: 'Company Code' }],
    identification: [{ position: 70, label: 'Company Code' }] }
    companycode,
    @EndUserText.label: 'Item Quantity'
    @Semantics.quantity.unitOfMeasure: 'billingquantityunit'
    @UI: { lineItem: [{ position: 80,label: 'Item Quantity' }],
    identification: [{ position: 80, label: 'Item Quantity' }] }
    billingitemquantity,
    @EndUserText.label: 'Item Unit'
    @UI: { lineItem: [{ position: 90,label: 'Item Unit' }],
    identification: [{ position: 90, label: 'Item Unit' }] }
    billingquantityunit,
    @EndUserText.label: 'Item Amount'
    @Semantics.amount.currencyCode: 'billingitemtransactioncurrency'
    @UI: { lineItem: [{ position: 100,label: 'Item Amount' }],
    identification: [{ position: 100, label: 'Item Amount' }] }
    billingitemnetamount,
    @EndUserText.label: 'Item Currency'
    @UI: { lineItem: [{ position: 110,label: 'Item Currency' }],
    identification: [{ position: 110, label: 'Item Currency' }] }
    billingitemtransactioncurrency,
    @EndUserText.label: 'Sold To Party'
    @UI: { lineItem: [{ position: 120,label: 'Sold To Party' }],
    identification: [{ position: 120, label: 'Sold To Party' }] }
    billingsoldtoparty,
    @EndUserText.label: 'Bill To Party'
    @UI: { lineItem: [{ position: 130,label: 'Bill To Party' }],
    identification: [{ position: 130, label: 'Bill To Party' }] }
    billingbilltoparty,
    @EndUserText.label: 'Ship To Party'
    @UI: { lineItem: [{ position: 140,label: 'Ship To Party' }],
    identification: [{ position: 140, label: 'Ship To Party' }] }
    billingshiptoparty,
    @EndUserText.label: 'Payer Party'
    @UI: { lineItem: [{ position: 150,label: 'Payer Party' }],
    identification: [{ position: 150, label: 'Payer Party' }] }
    billingpayerparty,
    @EndUserText.label: 'Item Tax Amount'
    @Semantics.amount.currencyCode: 'billingitemtransactioncurrency'
    @UI: { lineItem: [{ position: 160,label: 'Item Tax Amount' }],
    identification: [{ position: 160, label: 'Item Tax Amount' }] }
    billingtaxamount,
    @EndUserText.label: 'Item TAX Code'
    @UI: { lineItem: [{ position: 170,label: 'Item TAX Code' }],
    identification: [{ position: 170, label: 'Item TAX Code' }] }
    billingtaxcode,
    @EndUserText.label: 'Chellan Number'
    @UI: { lineItem: [{ position: 180,label: 'Chellan Number' }],
    identification: [{ position: 180, label: 'Chellan Number' }] }
    chellannumber,
    @EndUserText.label: 'Business Place'
    @UI: { lineItem: [{ position: 190,label: 'Business Place' }],
    identification: [{ position: 190, label: 'Business Place' }] }
    businessplace,
    @EndUserText.label: 'Business Place GSTIN'
    @UI: { lineItem: [{ position: 200,label: 'Business Place GSTIN' }],
    identification: [{ position: 200, label: 'Business Place GSTIN' }] }
    gstinnumber,
    @EndUserText.label: 'Job Worker Name'
    @UI: { lineItem: [{ position: 210,label: 'Job Worker Name' }],
    identification: [{ position: 210, label: 'Job Worker Name' }] }
    customername,
    @EndUserText.label: 'Job Worker GSTIN'
    @UI: { lineItem: [{ position: 220,label: 'Job Worker GSTIN' }],
    identification: [{ position: 220, label: 'Job Worker GSTIN' }] }
    customergstin,
    @EndUserText.label: 'Portal Response'
    @UI: { lineItem: [{ position: 230,label: 'Portal Response' }],
    identification: [{ position: 230, label: 'Portal Response' }] }
    portalresponse
}
