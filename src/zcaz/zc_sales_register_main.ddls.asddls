@EndUserText.label: 'Projection View for sales register'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_SALES_REGISTER_MAIN
  as projection on ZC_SALE_REGISTER
{
          @UI.facet: [{
                      id:'TradersNo',
                      label: 'Sales Register',
                      type      : #IDENTIFICATION_REFERENCE,
                  //          targetQualifier:'Sales_Tender.SoldToParty',
                      position  : 10
                      }
                      ]
                                @UI: {  lineItem: [ { position: 110 } ],
                        identification: [ { position: 110 } ]

                   }
          @EndUserText.label: 'Ref. Invoice No.'
      key    Ref_Invoice_No,
          @UI: {  lineItem: [ { position: 30 } ],
             identification: [ { position:30 } ],
             selectionField: [ { position:1  } ]

          }
          @EndUserText.label: 'SAP Invoice Number'
  key     Invoice_No,

          @UI: {  lineItem: [ { position: 480 } ],
                     identification: [ { position: 480 } ]

                }
          @EndUserText.label: 'Item No.'
  key     Item_No,
      //    bd,

          //       @UI: {  lineItem: [ { position: 10 } ],
          //                identification: [ { position: 10 } ]//,
          //       //              selectionField: [ { position:2  } ]
          //
          //           }
          //       @EndUserText.label: 'Company Code'
          //        Company_Code,
          //
          //       @UI: {  lineItem: [ { position: 20 } ],
          //                 identification: [ { position: 20 } ]//,
          //       //              selectionField: [ { position:2  } ]
          //
          //            }
          //       @EndUserText.label: 'Company Name'
          //        Company_Name,

          @UI: {  lineItem: [ { position: 40 } ],
                        identification: [ { position: 40 } ]

                   }
          @EndUserText.label: 'GST Invoice No.'
          GST_Invoice_No,

          @Consumption.filter.mandatory: true
          @UI: {  lineItem: [ { position: 10 } ],
                        identification: [ { position: 10 } ],
                        selectionField: [ { position:2  } ]

                   }
          @EndUserText.label: 'Billing Date'
          Billing_date,

          @UI: {  lineItem: [ { position: 55 } ],
                       identification: [ { position: 55 } ],
                       selectionField: [ { position: 7  } ]

                  }
          @EndUserText.label: 'Business Place'
          BusinessPlace,

          @UI: {  lineItem: [ { position: 60 } ],
                        identification: [ { position: 60 } ],
                        selectionField: [ { position:6  } ]

                   }
          @EndUserText.label: 'Plant'
          @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
          Plant,


          @UI: {  lineItem: [ { position: 70 } ],
                        identification: [ { position: 70 } ]//,
          //              selectionField: [ { position:5  } ]

                   }
          @EndUserText.label: 'Plant Name'
          //       @Consumption.valueHelpDefinition: [{entity: {element: 'PlantName' , name: 'ZI_PLant_SR' }}]
          PlantName,

          //;ogic pending for plant gstin
          @UI: {  lineItem: [ { position: 80 } ],
                        identification: [ { position: 80 }]}
          @EndUserText.label: 'Plant GSTIN'
          plantgstin, //logic pending for Plant GSTIN

          @UI: {  lineItem: [ { position: 90 } ],
                        identification: [ { position: 90 } ],
                        selectionField: [ { position:5  } ]

                   }
          @EndUserText.label: 'Billing Type'
          @Consumption.valueHelpDefinition: [{entity: {element: 'BillingDocumentType' , name: 'ZH_BILLINGType' }}]
          Billing_Type,

          @UI: {  lineItem: [ { position: 100 } ],
                        identification: [ { position: 100 } ]

                   }
          @EndUserText.label: 'Billing Description'
          Billing_Description,



          @UI: {  lineItem: [ { position: 120 } ],
                        identification: [ { position: 120 } ]

                   }
          @EndUserText.label: 'Ref. Invoice Date'
          Ref_Invoice_date,

          @UI: {  lineItem: [ { position: 130 } ],
                        identification: [ { position: 130 } ],
                        selectionField: [ { position:3  } ]

                   }
          @EndUserText.label: 'Distribution Channel'
          Distribution_Channel,

          @UI: {  lineItem: [ { position: 140 } ],
                        identification: [ { position: 140 } ]

                   }
          @EndUserText.label: 'Dist. Channel Desc.'
          Dist_Channel_Desc,

          @UI: {  lineItem: [ { position: 150 } ],
                        identification: [ { position: 150 } ],
                        selectionField: [ { position:4  } ]

                   }
          @EndUserText.label: 'Division'
          @Consumption.valueHelpDefinition: [{entity: {element: 'Division' , name: 'ZH_DIVISION' }}]
          Division,

          @UI: {  lineItem: [ { position: 160 } ],
                        identification: [ { position: 160 } ]
                   }
          @EndUserText.label: 'Division Desc.'
          Division_Desc,

          @UI: {  lineItem: [ { position: 170 } ],
                        identification: [ { position: 170 } ],
                        selectionField: [ { position:6  } ]

                   }
          @EndUserText.label: 'Sold To Party'
          Customer_No,

          @UI: {  lineItem: [ { position: 180 } ],
                        identification: [ { position: 180 } ]

                   }
          @EndUserText.label: 'Sold To Party Name'
          Customer_Name,


          @UI: {  lineItem: [ { position: 190 } ],
                        identification: [ { position: 190 } ]

                   }
          @EndUserText.label: 'Ship To Party'
          ShipTo,

          @UI: {  lineItem: [ { position: 200 } ],
                        identification: [ { position: 200 } ]

                   }
          @EndUserText.label: 'Ship To Party Name'
          ShipToName,

          @UI: {  lineItem: [ { position: 210 } ],
                        identification: [ { position: 210 } ]

                   }
          @EndUserText.label: 'Bill To Party'
          BillTo,

          @UI: {  lineItem: [ { position: 220 } ],
                        identification: [ { position: 220 } ]

                   }
          @EndUserText.label: 'Bill To Party Name'
          BillToName,

          @UI: {  lineItem: [ { position: 230 } ],
                        identification: [ { position: 230 } ]
                   }
          @EndUserText.label: 'Payer'
          Payer,

          @UI: {  lineItem: [ { position: 240 } ],
                        identification: [ { position: 240 } ]
                   }
          @EndUserText.label: 'Payer Name'
          PayerName,
          //       Commented for VISEN prjct
          //       @UI: {  lineItem: [ { position: 18 } ],     Commented for VISEN
          //                     identification: [ { position: 18 } ]
          //
          //                }
          //       @EndUserText.label: 'Accounting Doc. No.'
          //        Accounting_Doc_No,

          @UI: {  lineItem: [ { position: 250 } ],
                  identification: [ { position: 250 } ],
                   selectionField: [ { position:9  } ]
                   }
          @EndUserText.label: 'Sales Type'
          Customer_Group,

          @UI: {  lineItem: [ { position: 255 } ],
                  identification: [ { position: 255 } ]
                   }
          @EndUserText.label: 'Customer Region'
          SalesDistrict,

          @UI: {  lineItem: [ { position: 260 } ],
                        identification: [ { position: 260 } ]

                   }
          @EndUserText.label: 'Customer Region Description'
          Sales_district_Desc,

          @UI: {  lineItem: [ { position: 270 } ],
                   identification: [ { position: 270 } ]

              }
          @EndUserText.label: 'Sales Type Desc'
          Cust_Group_Desc,

          @UI: {  lineItem: [ { position: 290 } ],
                        identification: [ { position: 290 } ]

                   }
          @EndUserText.label: 'Bill To GSTIN / Tax No.'
          Customer_GSTIN_No,

          @UI: {  lineItem: [ { position: 300 } ],
                        identification: [ { position: 300 } ]

                   }
          @EndUserText.label: 'Bill To Pan'
          Customer_Pan,
          //
          //       @UI: {  lineItem: [ { position: 305 } ],
          //                     identification: [ { position: 305 } ]
          //
          //                }
          //       @EndUserText.label: 'Bill To VAN'
          //        Customer_VAN,

          @UI: {  lineItem: [ { position: 310 } ],
                        identification: [ { position: 310 } ]

                   }
          @EndUserText.label: 'Customer State'
          Region,
          //       logic pending
          ////       @UI: {  lineItem: [ { position: 320 } ],
          ////                     identification: [ { position: 320 } ]
          ////
          ////                }
          ////       @EndUserText.label: 'Customer State Description'
          ////        RegionName,

          @UI: {  lineItem: [ { position: 330 } ],
                       identification: [ { position: 330 } ]

                  }
          @EndUserText.label: 'Regional Head' // Label change from "Sales Executive" to "Sales Person" as per functional logic
          Sales_Executive,

          @UI: {  lineItem: [ { position: 340 } ],
                        identification: [ { position: 340 } ]

                   }
          @EndUserText.label: 'Sales Person' //Label change from "Sales ASM" to "Sales Manager" as per new logic in visen
          Sales_ASM,

          @UI: {  lineItem: [ { position: 350 } ],
                        identification: [ { position: 350 } ]

                   }
          @EndUserText.label: 'Transporter Name' //logic pending for transporter name
          TransporterName,

          @UI: {  lineItem: [ { position: 360 } ],
                        identification: [ { position: 360 } ]

                   }
          @EndUserText.label: 'Commision Agent' //logic pending for commision agent
          CommissionAgent,

          @UI: {  lineItem: [ { position: 370 } ],
                        identification: [ { position: 370 } ] }
          @EndUserText.label: 'Commision Agent Name' //logic pending for commision agent name
          CommissionAgentName,

          @UI: {  lineItem: [ { position: 380 } ],
                        identification: [ { position: 380 } ] }
          @EndUserText.label: 'Inco Term'
          IncotermsClassification,

          @UI: {  lineItem: [ { position: 390 } ],
                        identification: [ { position: 390 } ] }
          @EndUserText.label: 'Payment Term'
          CustomerPaymentTerms,

          @UI: {  lineItem: [ { position: 400 } ],
                        identification: [ { position: 400 } ] }
          @EndUserText.label: 'Payment Term Text'
          PAYMENT_TERM_TEXT,

          @UI: {  lineItem: [ { position: 410 } ],
                        identification: [ { position: 410 } ]

                   }
          @EndUserText.label: 'Customer PO No.'
          Customer_PO_No,

          @UI: {  lineItem: [ { position: 420 } ],
                  identification: [ { position: 420 } ] }
          @EndUserText.label: 'Customer PO Date'
          //        Customer_PO_Date,
          Customer_PO_Date as Customer_PO_Date,

          @UI: {  lineItem: [ { position: 430 } ],
                        identification: [ { position: 430 } ]
                   }
          @EndUserText.label: 'LR No'
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LR'
          LRNo,

          //          @UI: {  lineItem: [ { position: 440 } ],
          //                        identification: [ { position: 440 } ]
          //                   }
          //          @EndUserText.label: 'LR Date' //Logic pending for LR Date
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LR'
          //  virtual LRDate : abap.char(20),

          //       @UI: {  lineItem: [ { position: 450 } ],
          //                 identification: [ { position: 450 } ]
          //
          //            }
          //       @EndUserText.label: 'Transaction Type' //Logic Pending for Transaction Type
          //        Type,

          @UI: {  lineItem: [ { position: 460 } ],
                        identification: [ { position: 460 } ]

                   }
          @EndUserText.label: 'Sales Order No.'
          sales_order_no,
//          @UI: {  lineItem: [ { position: 465 } ],
//                        identification: [ { position: 465 } ]
//                   }
//          @EndUserText.label: 'Freight Order No'
//          FreightOrdNo,

          @UI: {  lineItem: [ { position: 470 } ],
                        identification: [ { position: 470 } ]

                   }
          @EndUserText.label: 'Sales Order Date'
          Sales_Order_Date,
          //480 IS KEY ITEMNO
          @UI: {  lineItem: [ { position: 490 } ],
                        identification: [ { position: 490 } ],
                        selectionField: [ { position:7  } ]


                   }
          @EndUserText.label: 'Product'
          //       @Consumption.valueHelpDefinition: [{entity: { name: 'ZHelp_product' , element: 'PRODUCT'  } ,
          //                        additionalBinding: [{ element: 'BillingDocumentItemText' }]  }]
          Product,

          @UI: {  lineItem: [ { position: 500 } ],
                        identification: [ { position: 500 } ]
                   }
          @EndUserText.label: 'Product Name'
          Product_Name,

          @UI: {  lineItem: [ { position: 510 } ],
                        identification: [ { position: 510 } ]
                   }
          @EndUserText.label: 'Product Group'
          Material_Group,

          @UI: {  lineItem: [ { position: 520 } ],
                        identification: [ { position: 520 } ]
                   }
          @EndUserText.label: 'Product Group Description' //logic pending
          ProductGroupName,

          //       @UI: {  lineItem: [ { position: 525 } ],
          //                     identification: [ { position: 525 } ]
          //                }
          //       @EndUserText.label: 'Product Hierarchy'
          //        PrdctHrchy,

          @UI: {  lineItem: [ { position: 530 } ],
                  identification: [ { position: 530 } ]
                   }
          @EndUserText.label: 'HSN Code'
          HSN_Code,

          //       @UI: {  lineItem: [ { position: 540 } ],
          //               identification: [ { position: 540 } ]
          //           }
          //       @EndUserText.label: 'Batch No'
          //        Batch,
          //       @Consumption.hidden: true
          @UI: {  lineItem: [ { position: 950 } ],
                        identification: [ { position: 950 } ]

                   }
          @EndUserText.label: 'Unit'
          unit,
          @Semantics.quantity.unitOfMeasure: 'unit'
          @UI: {  lineItem: [ { position: 550 } ],
                        identification: [ { position: 550 } ]
                   }
          @EndUserText.label: 'Invoice Qty'
          @Aggregation.default: #SUM
          Invoice_Qty,

          @UI: {  lineItem: [ { position: 560 } ],
                        identification: [ { position: 560 } ]
                   }
          @EndUserText.label: 'Sales Unit'
          Sales_Unit,

          @UI: {  lineItem: [ { position: 561 } ],
                        identification: [ { position: 561 } ]
                   }
          @EndUserText.label: 'List Price'
          ListPrice        as ListPrice,

          @UI: {  lineItem: [ { position: 562 } ],
                        identification: [ { position: 562 } ]
                   }
          @EndUserText.label: 'Customer Freight'
          Customer_Freight as Customer_Freight,

          @UI: {  lineItem: [ { position: 565 } ],
                        identification: [ { position: 565 } ]
                   }
          @EndUserText.label: 'Transfer Freight'
          Transfer_Freight as Transfer_Freight,

          @UI: {  lineItem: [ { position: 570 } ],
                        identification: [ { position: 570 } ]
                   }
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @EndUserText.label: 'Unit Rate'
          Unit_Rate        as Unit_Rate,

          @UI: {  lineItem: [ { position: 575 } ],
                        identification: [ { position: 575 } ]
                   }
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @EndUserText.label: 'Agreed Price'
          AGRRED_PRICE     as AGRRED_PRICE,

          @Aggregation.default: #SUM
          // @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 580 } ],
                        identification: [ { position: 580 } ]
                   }
          @EndUserText.label: 'Basic Amount'
          Net_Amount       as Net_Amount,

          //       @Consumption.hidden: true
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 590 } ],
                        identification: [ { position: 590 } ]
                   }
          @EndUserText.label: 'Freight Amount'
          @Aggregation.default: #SUM
          Freight_Amount   as Freight_Amount,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 600 } ],
                  identification: [ { position: 600 } ]
                   }
          @EndUserText.label: 'Insurance Amount'
          @Aggregation.default: #SUM
          InsuranceAmount  as InsuranceAmount,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 610 } ],
                  identification: [ { position: 610 } ]
                   }
          @EndUserText.label: 'Round Off Amount'
          @Aggregation.default: #SUM
          RoundOffAmount   as RoundOffAmount,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 620 } ],
                  identification: [ { position: 620 } ]
                   }
          @EndUserText.label: 'Sales Value in Loc. Curr.'
          @Aggregation.default: #SUM
          sALESVALUEc      as sALESVALUEc,
          //       cast( SalesValueinLC as abap.dec( 13, 2 )) as SalesValueinLC,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 630 } ],
                  identification: [ { position: 630 } ]
                   }
          @EndUserText.label: 'Taxable Value'
          @Aggregation.default: #SUM
          TaxableValue     as TaxableValue,

          @UI: {  lineItem: [ { position: 640 } ],
                        identification: [ { position: 640 } ]

                   }
          @EndUserText.label: 'CGST Rate'
          CGST_RATE,
          //  @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 650 } ],
                        identification: [ { position: 650 } ]

                   }
          @EndUserText.label: 'CGST'
          @Aggregation.default: #SUM
          CGST             as CGST,

          @UI: {  lineItem: [ { position: 660 } ],
                        identification: [ { position: 660 } ]

                   }
          @EndUserText.label: 'SGST Rate'
          SGST_Rate,
          //  @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 670 } ],
                        identification: [ { position: 670 } ]

                   }
          @EndUserText.label: 'SGST'
          @Aggregation.default: #SUM
          SGST             as SGST,

          @UI: {  lineItem: [ { position: 680 } ],
                        identification: [ { position: 680 } ]

                   }
          @EndUserText.label: 'IGST Rate'
          IGST_Rate,
          //  @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 690 } ],
                        identification: [ { position: 690 } ]

                   }
          @EndUserText.label: 'IGST'
          @Aggregation.default: #SUM
          IGST             as IGST,

          //logic pending
          @UI: {  lineItem: [ { position: 700 } ],
                        identification: [ { position: 700 } ]
                   }
          @EndUserText.label: 'UGST Rate'
          UGST_Rate,
          //  @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 710 } ],
                        identification: [ { position: 710 } ]
                   }
          @EndUserText.label: 'UGST'
          @Aggregation.default: #SUM
          UGST             as UGST,

          @UI: {  lineItem: [ { position: 720 } ],
                        identification: [ { position: 720 } ]
                   }
          @EndUserText.label: 'TCS Rate'
          TCS_Rate,

          //   @Semantics.quantity.unitOfMeasure: 'Unit'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 730 } ],
                        identification: [ { position: 730 } ]
                   }
          @EndUserText.label: 'TCS'
          @Aggregation.default: #SUM
          TCS              as TCS,

          @Aggregation.default: #SUM
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 740 } ],
                        identification: [ { position: 740 } ]

                   }
          @EndUserText.label: 'Total Tax'
          TCS              as Totaltax,

          @UI: {  lineItem: [ { position: 750 } ],
                        identification: [ { position: 750 } ]

                   }
          @EndUserText.label: 'Transaction Currency'
          TransactionCurrency,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 760 } ],
                   identification: [ { position: 760 } ]
              }
          @EndUserText.label: 'Billing Amount'
          @Aggregation.default: #SUM
          Billing_Amount   as Billing_Amount,

          @Semantics.amount.currencyCode: 'TransactionCurrency'
          @UI: {  lineItem: [ { position: 770 } ],
                   identification: [ { position: 770 } ]
              }
          @EndUserText.label: 'Gross Amount'
          @Aggregation.default: #SUM
          Gross_value      as Gross_value,

          //       @Semantics.amount.currencyCode: 'TransactionCurrency'
          //       @UI: {  lineItem: [ { position: 780 } ],
          //                identification: [ { position: 780 } ]
          //           }
          //       @EndUserText.label: 'Commission %'
          //        CommisionPrcntg,

          //       @Semantics.amount.currencyCode: 'TransactionCurrency'
          //       @UI: {  lineItem: [ { position: 790 } ],
          //                identification: [ { position: 790 } ]
          //           }
          //       @EndUserText.label: 'Commission Value'
          //       @Aggregation.default: #SUM
          //        CommisionValue,

          //       @UI: {  lineItem: [ { position: 800 } ],
          //                identification: [ { position: 800 } ]
          //           }
          //       @EndUserText.label: 'Total Commission Amount'
          //       @Semantics.amount.currencyCode: 'TransactionCurrency'
          //       @Aggregation.default: #SUM
          //        TotCmsnAmnt,

          @UI: {  lineItem: [ { position: 810 } ],
                   identification: [ { position: 810 } ]
              }
          @EndUserText.label: 'Credit Note Rate'
          CRDNoteRate      as CRDNoteRate,

          @UI: {  lineItem: [ { position: 820 } ],
                   identification: [ { position: 820 } ]
              }
          @EndUserText.label: 'Credit Note Amt'
          @Semantics.amount.currencyCode: 'TransactionCurrency'
          CRDNote          as CRDNote,

          ////       @UI: {  lineItem: [ { position: 820 } ],
          ////                identification: [ { position: 820 } ]
          ////           }
          ////       @EndUserText.label: 'Bill of Entry'
          ////        Gross_value,

          ////       @UI: {  lineItem: [ { position: 830 } ],
          ////                identification: [ { position: 830 } ]
          ////           }
          ////       @EndUserText.label: 'No.of packages'
          ////        Gross_value,

          @UI: {  lineItem: [ { position: 840 } ],
                   identification: [ { position: 840 } ]
              }
          @EndUserText.label: 'Avg. Count per package'
          @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
          AvgCntPckgs,
          DeliveryQuantityUnit,
          @UI: {  lineItem: [ { position: 850 } ],
                   identification: [ { position: 850 } ]
              }
          @EndUserText.label: 'Dispatch From'
          PlantCity,

          @UI: {  lineItem: [ { position: 860 } ],
                   identification: [ { position: 860 } ]
              }
          @EndUserText.label: 'Dispatch To'
          CustomerCity,

          @UI: {  lineItem: [ { position: 870 } ],
                   identification: [ { position: 870 } ]
              }
          @EndUserText.label: 'Exchange Rate'
          AccountingExchangeRate,

          @UI: {  lineItem: [ { position: 880 } ],
                   identification: [ { position: 880 } ]
              }
          @EndUserText.label: 'IRN No.'
          IRN,

          @UI: {  lineItem: [ { position: 890 } ],
                   identification: [ { position: 890 } ]
              }
          @EndUserText.label: 'Ewaybill No.'
          EWB,

          @UI: {  lineItem: [ { position: 900 } ],
                   identification: [ { position: 900 } ]
              }
          @EndUserText.label: 'Ewaybill Date'
          EWBDT,

          ////       @UI: {  lineItem: [ { position: 910 } ],
          ////                identification: [ { position: 910 } ]
          ////           }
          ////       @EndUserText.label: 'Invoice Status'
          ////        Gross_value,

          ////       @UI: {  lineItem: [ { position: 920 } ],
          ////                identification: [ { position: 920 } ]
          ////           }
          ////       @EndUserText.label: 'Due date'
          ////        Gross_value,

          @UI: {  lineItem: [ { position: 930 } ],
                   identification: [ { position: 930 } ]
              }
          @EndUserText.label: 'Created By'
          CreatedByUser
//          ,
//
//          @UI: {  lineItem: [ { position: 940 } ],
//                   identification: [ { position: 940 } ]
//              }
//          @EndUserText.label: 'Created ON'
//          CreationDate
}
