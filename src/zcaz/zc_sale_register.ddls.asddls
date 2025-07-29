@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final CDS for Sales Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.presentationVariant: [{
    sortOrder: [{ by: 'Invoice_No' }]}]
define root view entity ZC_SALE_REGISTER
  as select distinct from ZI_SALES_REGISTER as sales
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
  key       sales.Ref_Invoice_No,



            //            case sales.Customer_PO_Date
            //       when '00.00.0000'
            //       then ''
            //       else sales.Customer_PO_Date end              as Customer_PO_Date,

            //  key    case sales.Ref_Invoice_No
            //       when ' '
            //       then '00000000'
            //       else  sales.Ref_Invoice_No
            //       end  as    Ref_Invoice_No,

            @UI: {  lineItem: [ { position: 30 } ],
               identification: [ { position:30 } ],
               selectionField: [ { position:1  } ]

            }
            @EndUserText.label: 'SAP Invoice Number'
  key       sales.Invoice_No,

            @UI: {  lineItem: [ { position: 480 } ],
                       identification: [ { position: 480 } ]

                  }
            @EndUserText.label: 'Item No.'
  key       sales.Item_No,
            sales.bd,



            //       @UI: {  lineItem: [ { position: 10 } ],
            //                identification: [ { position: 10 } ]//,
            //       //              selectionField: [ { position:2  } ]
            //
            //           }
            //       @EndUserText.label: 'Company Code'
            //       sales.Company_Code,
            //
            //       @UI: {  lineItem: [ { position: 20 } ],
            //                 identification: [ { position: 20 } ]//,
            //       //              selectionField: [ { position:2  } ]
            //
            //            }
            //       @EndUserText.label: 'Company Name'
            //       sales.Company_Name,

            @UI: {  lineItem: [ { position: 40 } ],
                          identification: [ { position: 40 } ]

                     }
            @EndUserText.label: 'GST Invoice No.'
            sales.GST_Invoice_No,

            @Consumption.filter.mandatory: true
            @UI: {  lineItem: [ { position: 10 } ],
                          identification: [ { position: 10 } ],
                          selectionField: [ { position:2  } ]

                     }
            @EndUserText.label: 'Billing Date'
            sales.Billing_date,

            @UI: {  lineItem: [ { position: 55 } ],
                         identification: [ { position: 55 } ],
                         selectionField: [ { position: 7  } ]

                    }
            @EndUserText.label: 'Business Place'
            sales.BusinessPlace,

            @UI: {  lineItem: [ { position: 60 } ],
                          identification: [ { position: 60 } ],
                          selectionField: [ { position:6  } ]

                     }
            @EndUserText.label: 'Plant'
            @Consumption.valueHelpDefinition: [{entity: {element: 'Plant' , name: 'ZI_PLant_SR' }}]
            sales.Plant,


            @UI: {  lineItem: [ { position: 70 } ],
                          identification: [ { position: 70 } ]//,
            //              selectionField: [ { position:5  } ]

                     }
            @EndUserText.label: 'Plant Name'
            //       @Consumption.valueHelpDefinition: [{entity: {element: 'PlantName' , name: 'ZI_PLant_SR' }}]
            sales.PlantName,

            //;ogic pending for plant gstin
            @UI: {  lineItem: [ { position: 80 } ],
                          identification: [ { position: 80 }]}
            @EndUserText.label: 'Plant GSTIN'
            sales.plantgstin, //logic pending for Plant GSTIN

            @UI: {  lineItem: [ { position: 90 } ],
                          identification: [ { position: 90 } ],
                          selectionField: [ { position:5  } ]

                     }
            @EndUserText.label: 'Billing Type'
            @Consumption.valueHelpDefinition: [{entity: {element: 'BillingDocumentType' , name: 'ZH_BILLINGType' }}]
            sales.Billing_Type,

            @UI: {  lineItem: [ { position: 100 } ],
                          identification: [ { position: 100 } ]

                     }
            @EndUserText.label: 'Billing Description'
            sales.Billing_Description,



            @UI: {  lineItem: [ { position: 120 } ],
                          identification: [ { position: 120 } ]

                     }
            @EndUserText.label: 'Ref. Invoice Date'
            sales.Ref_Invoice_date,

            @UI: {  lineItem: [ { position: 130 } ],
                          identification: [ { position: 130 } ],
                          selectionField: [ { position:3  } ]

                     }
            @EndUserText.label: 'Distribution Channel'
            sales.Distribution_Channel,

            @UI: {  lineItem: [ { position: 140 } ],
                          identification: [ { position: 140 } ]

                     }
            @EndUserText.label: 'Dist. Channel Desc.'
            sales.Dist_Channel_Desc,

            @UI: {  lineItem: [ { position: 150 } ],
                          identification: [ { position: 150 } ],
                          selectionField: [ { position:4  } ]

                     }
            @EndUserText.label: 'Division'
            @Consumption.valueHelpDefinition: [{entity: {element: 'Division' , name: 'ZH_DIVISION' }}]
            sales.Division,

            @UI: {  lineItem: [ { position: 160 } ],
                          identification: [ { position: 160 } ]
                     }
            @EndUserText.label: 'Division Desc.'
            sales.Division_Desc,

            @UI: {  lineItem: [ { position: 170 } ],
                          identification: [ { position: 170 } ],
                          selectionField: [ { position:6  } ]

                     }
            @EndUserText.label: 'Sold To Party'
            sales.Customer_No,

            @UI: {  lineItem: [ { position: 180 } ],
                          identification: [ { position: 180 } ]

                     }
            @EndUserText.label: 'Sold To Party Name'
            sales.Customer_Name,


            @UI: {  lineItem: [ { position: 190 } ],
                          identification: [ { position: 190 } ]

                     }
            @EndUserText.label: 'Ship To Party'
            sales.ShipTo,

            @UI: {  lineItem: [ { position: 200 } ],
                          identification: [ { position: 200 } ]

                     }
            @EndUserText.label: 'Ship To Party Name'
            sales.ShipToName,

            @UI: {  lineItem: [ { position: 210 } ],
                          identification: [ { position: 210 } ]

                     }
            @EndUserText.label: 'Bill To Party'
            sales.BillTo,

            @UI: {  lineItem: [ { position: 220 } ],
                          identification: [ { position: 220 } ]

                     }
            @EndUserText.label: 'Bill To Party Name'
            sales.BillToName,

            @UI: {  lineItem: [ { position: 230 } ],
                          identification: [ { position: 230 } ]
                     }
            @EndUserText.label: 'Payer'
            sales.Payer,

            @UI: {  lineItem: [ { position: 240 } ],
                          identification: [ { position: 240 } ]
                     }
            @EndUserText.label: 'Payer Name'
            sales.PayerName,
            //       Commented for VISEN prjct
            //       @UI: {  lineItem: [ { position: 18 } ],     Commented for VISEN
            //                     identification: [ { position: 18 } ]
            //
            //                }
            //       @EndUserText.label: 'Accounting Doc. No.'
            //       sales.Accounting_Doc_No,

            @UI: {  lineItem: [ { position: 250 } ],
                    identification: [ { position: 250 } ],
                     selectionField: [ { position:9  } ]
                     }
            @EndUserText.label: 'Sales Type'
            sales.Customer_Group,

            @UI: {  lineItem: [ { position: 255 } ],
                    identification: [ { position: 255 } ]
                     }
            @EndUserText.label: 'Customer Region'
            sales.SalesDistrict,

            @UI: {  lineItem: [ { position: 260 } ],
                          identification: [ { position: 260 } ]

                     }
            @EndUserText.label: 'Customer Region Description'
            sales.Sales_district_Desc,

            @UI: {  lineItem: [ { position: 270 } ],
                     identification: [ { position: 270 } ]

                }
            @EndUserText.label: 'Sales Type Desc'
            sales.Cust_Group_Desc,

            //       @UI: {  lineItem: [ { position: 270 } ],
            //                    identification: [ { position: 270 } ]
            //               }
            //       @EndUserText.label: 'Customer Zone'
            //       sales.Sales_District,
            //


            @UI: {  lineItem: [ { position: 290 } ],
                          identification: [ { position: 290 } ]

                     }
            @EndUserText.label: 'Bill To GSTIN / Tax No.'
            sales.Customer_GSTIN_No,

            @UI: {  lineItem: [ { position: 300 } ],
                          identification: [ { position: 300 } ]

                     }
            @EndUserText.label: 'Bill To Pan'
            sales.Customer_Pan,
            //
            //       @UI: {  lineItem: [ { position: 305 } ],
            //                     identification: [ { position: 305 } ]
            //
            //                }
            //       @EndUserText.label: 'Bill To VAN'
            //       sales.Customer_VAN,

            @UI: {  lineItem: [ { position: 310 } ],
                          identification: [ { position: 310 } ]

                     }
            @EndUserText.label: 'Customer State'
            sales.Region,
            //       logic pending
            ////       @UI: {  lineItem: [ { position: 320 } ],
            ////                     identification: [ { position: 320 } ]
            ////
            ////                }
            ////       @EndUserText.label: 'Customer State Description'
            ////       sales.RegionName,

            @UI: {  lineItem: [ { position: 330 } ],
                         identification: [ { position: 330 } ]

                    }
            @EndUserText.label: 'Regional Head' // Label change from "Sales Executive" to "Sales Person" as per functional logic
            sales.Sales_Executive,

            @UI: {  lineItem: [ { position: 340 } ],
                          identification: [ { position: 340 } ]

                     }
            @EndUserText.label: 'Sales Person' //Label change from "Sales ASM" to "Sales Manager" as per new logic in visen
            sales.Sales_ASM,

            @UI: {  lineItem: [ { position: 350 } ],
                          identification: [ { position: 350 } ]

                     }
            @EndUserText.label: 'Transporter Name' //logic pending for transporter name
            sales.TransporterName,

            @UI: {  lineItem: [ { position: 360 } ],
                          identification: [ { position: 360 } ]

                     }
            @EndUserText.label: 'Commision Agent' //logic pending for commision agent
            sales.CommissionAgent,

            @UI: {  lineItem: [ { position: 370 } ],
                          identification: [ { position: 370 } ] }
            @EndUserText.label: 'Commision Agent Name' //logic pending for commision agent name
            sales.CommissionAgentName,

            @UI: {  lineItem: [ { position: 380 } ],
                          identification: [ { position: 380 } ] }
            @EndUserText.label: 'Inco Term'
            sales.IncotermsClassification,

            @UI: {  lineItem: [ { position: 390 } ],
                          identification: [ { position: 390 } ] }
            @EndUserText.label: 'Payment Term'
            sales.CustomerPaymentTerms,

            @UI: {  lineItem: [ { position: 400 } ],
                          identification: [ { position: 400 } ] }
            @EndUserText.label: 'Payment Term Text'
            sales.PAYMENT_TERM_TEXT,

            @UI: {  lineItem: [ { position: 410 } ],
                          identification: [ { position: 410 } ]

                     }
            @EndUserText.label: 'Customer PO No.'
            sales.Customer_PO_No,

            @UI: {  lineItem: [ { position: 420 } ],
                    identification: [ { position: 420 } ] }
            @EndUserText.label: 'Customer PO Date'
            //       sales.Customer_PO_Date,
            case sales.Customer_PO_Date
            when '00.00.0000'
            then ''
            else sales.Customer_PO_Date end              as Customer_PO_Date,

            @UI: {  lineItem: [ { position: 430 } ],
                          identification: [ { position: 430 } ]
                     }
            @EndUserText.label: 'LR No'
            sales.LRNo,

            @UI: {  lineItem: [ { position: 440 } ],
                          identification: [ { position: 440 } ]
                     }
            @EndUserText.label: 'LR Date' //Logic pending for LR Date
            sales.LRDate,

            //       @UI: {  lineItem: [ { position: 450 } ],
            //                 identification: [ { position: 450 } ]
            //
            //            }
            //       @EndUserText.label: 'Transaction Type' //Logic Pending for Transaction Type
            //       sales.Type,

            @UI: {  lineItem: [ { position: 460 } ],
                          identification: [ { position: 460 } ]

                     }
            @EndUserText.label: 'Sales Order No.'
            sales.sales_order_no,

            @UI: {  lineItem         : [ { position: 465 } ],
                    identification   : [ { position: 465 } ] }
            @EndUserText.label: 'Freight Order No'
            sales.FreightOrdNo,

            @UI: {  lineItem: [ { position: 470 } ],
                          identification: [ { position: 470 } ]

                     }
            @EndUserText.label: 'Sales Order Date'
            sales.Sales_Order_Date,
            //480 IS KEY ITEMNO
            @UI: {  lineItem: [ { position: 490 } ],
                          identification: [ { position: 490 } ],
                          selectionField: [ { position:7  } ]


                     }
            @EndUserText.label: 'Product'
            //       @Consumption.valueHelpDefinition: [{entity: { name: 'ZHelp_product' , element: 'PRODUCT'  } ,
            //                        additionalBinding: [{ element: 'BillingDocumentItemText' }]  }]
            sales.Product,

            @UI: {  lineItem: [ { position: 500 } ],
                          identification: [ { position: 500 } ]
                     }
            @EndUserText.label: 'Product Name'
            sales.Product_Name,

            @UI: {  lineItem: [ { position: 510 } ],
                          identification: [ { position: 510 } ]
                     }
            @EndUserText.label: 'Product Group'
            sales.Material_Group,

            @UI: {  lineItem: [ { position: 520 } ],
                          identification: [ { position: 520 } ]
                     }
            @EndUserText.label: 'Product Group Description' //logic pending
            sales.ProductGroupName,

            //       @UI: {  lineItem: [ { position: 525 } ],
            //                     identification: [ { position: 525 } ]
            //                }
            //       @EndUserText.label: 'Product Hierarchy'
            //       sales.PrdctHrchy,

            @UI: {  lineItem: [ { position: 530 } ],
                    identification: [ { position: 530 } ]
                     }
            @EndUserText.label: 'HSN Code'
            sales.HSN_Code,

            //       @UI: {  lineItem: [ { position: 540 } ],
            //               identification: [ { position: 540 } ]
            //           }
            //       @EndUserText.label: 'Batch No'
            //       sales.Batch,
            //       @Consumption.hidden: true
            @UI: {  lineItem: [ { position: 950 } ],
                          identification: [ { position: 950 } ]

                     }
            @EndUserText.label: 'Unit'
            sales.unit,
            @Semantics.quantity.unitOfMeasure: 'unit'
            @UI: {  lineItem: [ { position: 550 } ],
                          identification: [ { position: 550 } ]
                     }
            @EndUserText.label: 'Invoice Qty'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'CBRE'
            then
            sales.Invoice_Qty * -1
            when 'L2'
            then
            sales.Invoice_Qty * 0
            when 'G2'
            then
            sales.Invoice_Qty * 0
            else sales.Invoice_Qty end                   as Invoice_Qty,


            @UI: {  lineItem: [ { position: 560 } ],
                          identification: [ { position: 560 } ]
                     }
            @EndUserText.label: 'Sales Unit'
            sales.Sales_Unit,

            @UI: {  lineItem: [ { position: 561 } ],
                          identification: [ { position: 561 } ]
                     }
            @EndUserText.label: 'List Price'
            case Billing_Type
            when 'G2'
            then sales.List_Amount * -1
            when 'CBRE'
            then sales.List_Amount * -1
            else sales.List_Amount end                   as ListPrice,

            @UI: {  lineItem: [ { position: 562 } ],
                          identification: [ { position: 562 } ]
                     }
            @EndUserText.label: 'Customer Freight'
            case Billing_Type
            when 'G2'
            then sales.Customer_Freight * -1
            when 'CBRE'
            then sales.Customer_Freight * -1
            else sales.Customer_Freight end              as Customer_Freight,

            @UI: {  lineItem: [ { position: 565 } ],
                          identification: [ { position: 565 } ]
                     }
            @EndUserText.label: 'Transfer Freight'
            case Billing_Type
            when 'G2'
            then sales.Transfer_Freight * -1
            when 'CBRE'
            then sales.Transfer_Freight * -1
            else sales.Transfer_Freight end              as Transfer_Freight,

            @UI: {  lineItem: [ { position: 570 } ],
                          identification: [ { position: 570 } ]
                     }
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @EndUserText.label: 'Unit Rate'
            case Billing_Type
            when 'G2'
            then sales.Unit_Rate * -1
            when 'CBRE'
            then sales.Unit_Rate * -1
            else sales.Unit_Rate end                     as Unit_Rate,

            @UI: {  lineItem: [ { position: 575 } ],
                          identification: [ { position: 575 } ]
                     }
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @EndUserText.label: 'Agreed Price'
            case Billing_Type
            when 'G2'
            then
            cast(( cast( sales.AGRRED_PRICE as abap.fltp) / cast( sales.Invoice_Qty as abap.fltp) ) *  -1.00 as abap.dec( 15, 2 ))
            when 'CBRE'
            then cast(( cast( sales.AGRRED_PRICE as abap.fltp) / cast( sales.Invoice_Qty as abap.fltp) ) *  -1.00 as abap.dec( 15, 2 ))
            else cast(( cast( sales.AGRRED_PRICE as abap.fltp) / cast( sales.Invoice_Qty as abap.fltp) ) *  1 as abap.dec( 15, 2 ))
            end                                          as AGRRED_PRICE,

            @Aggregation.default: #SUM
            // @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 580 } ],
                          identification: [ { position: 580 } ]
                     }
            @EndUserText.label: 'Basic Amount'
            case Billing_Type
            when 'G2'
            then sales.Net_Amount * -1
            when 'CBRE'
            then sales.Net_Amount * -1
            else sales.Net_Amount end                    as Net_Amount,

            //       @Consumption.hidden: true
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 590 } ],
                          identification: [ { position: 590 } ]
                     }
            @EndUserText.label: 'Freight Amount'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.Freight_Amount * -1
            when 'CBRE'
            then sales.Freight_Amount * -1
            else sales.Freight_Amount end                as Freight_Amount,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 600 } ],
                    identification: [ { position: 600 } ]
                     }
            @EndUserText.label: 'Insurance Amount'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.InsuranceAmount * -1
            when 'CBRE'
            then sales.InsuranceAmount * -1
            else sales.InsuranceAmount end               as InsuranceAmount,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 610 } ],
                    identification: [ { position: 610 } ]
                     }
            @EndUserText.label: 'Round Off Amount'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.RoundOffAmount * -1
            when 'CBRE'
            then sales.RoundOffAmount * -1
            else sales.RoundOffAmount end                as RoundOffAmount,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 620 } ],
                    identification: [ { position: 620 } ]
                     }
            @EndUserText.label: 'Sales Value in Loc. Curr.'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.SalesValueinLC * -1
            when 'CBRE'
            then sales.SalesValueinLC * -1
            else sales.SalesValueinLC end                as sALESVALUEc,
            //       cast(sales.SalesValueinLC as abap.dec( 13, 2 )) as SalesValueinLC,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 630 } ],
                    identification: [ { position: 630 } ]
                     }
            @EndUserText.label: 'Taxable Value'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.TaxableValue * -1
            when 'CBRE'
            then sales.TaxableValue * -1
            else sales.TaxableValue end                  as TaxableValue,

            @UI: {  lineItem: [ { position: 640 } ],
                          identification: [ { position: 640 } ]

                     }
            @EndUserText.label: 'CGST Rate'
            sales.CGST_RATE,
            //  @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 650 } ],
                          identification: [ { position: 650 } ]

                     }
            @EndUserText.label: 'CGST'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.CGST * -1
            when 'CBRE'
            then sales.CGST * -1
            else sales.CGST end                          as CGST,

            @UI: {  lineItem: [ { position: 660 } ],
                          identification: [ { position: 660 } ]

                     }
            @EndUserText.label: 'SGST Rate'
            sales.SGST_Rate,
            //  @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 670 } ],
                          identification: [ { position: 670 } ]

                     }
            @EndUserText.label: 'SGST'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.SGST * -1
            when 'CBRE'
            then sales.SGST * -1
            else sales.SGST end                          as SGST,

            @UI: {  lineItem: [ { position: 680 } ],
                          identification: [ { position: 680 } ]

                     }
            @EndUserText.label: 'IGST Rate'
            sales.IGST_Rate,
            //  @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 690 } ],
                          identification: [ { position: 690 } ]

                     }
            @EndUserText.label: 'IGST'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.IGST * -1
            when 'CBRE'
            then sales.IGST * -1
            else sales.IGST end                          as IGST,

            //logic pending
            @UI: {  lineItem: [ { position: 700 } ],
                          identification: [ { position: 700 } ]
                     }
            @EndUserText.label: 'UGST Rate'
            sales.UGST_Rate,
            //  @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 710 } ],
                          identification: [ { position: 710 } ]
                     }
            @EndUserText.label: 'UGST'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.UGST * -1
            when 'CBRE'
            then sales.UGST * -1
            else sales.UGST end                          as UGST,

            @UI: {  lineItem: [ { position: 720 } ],
                          identification: [ { position: 720 } ]
                     }
            @EndUserText.label: 'TCS Rate'
            sales.TCS_Rate,

            //   @Semantics.quantity.unitOfMeasure: 'Unit'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 730 } ],
                          identification: [ { position: 730 } ]
                     }
            @EndUserText.label: 'TCS'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then sales.TCS * -1
            when 'CBRE'
            then sales.TCS * -1
            else sales.TCS end                           as TCS,

            @Aggregation.default: #SUM
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 740 } ],
                          identification: [ { position: 740 } ]

                     }
            @EndUserText.label: 'Total Tax'
            case Billing_Type
            when 'G2'
            then sales.Totaltax * -1
            when 'CBRE'
            then sales.Totaltax * -1
            else sales.Totaltax end                      as Totaltax,

            @UI: {  lineItem: [ { position: 750 } ],
                          identification: [ { position: 750 } ]

                     }
            @EndUserText.label: 'Transaction Currency'
            sales.TransactionCurrency,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 760 } ],
                     identification: [ { position: 760 } ]
                }
            @EndUserText.label: 'Billing Amount'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then Billing_Amount * -1
            when 'CBRE'
            then Billing_Amount * -1
            else Billing_Amount end                      as Billing_Amount,

            @Semantics.amount.currencyCode: 'TransactionCurrency'
            @UI: {  lineItem: [ { position: 770 } ],
                     identification: [ { position: 770 } ]
                }
            @EndUserText.label: 'Net Value'
            @Aggregation.default: #SUM
            case Billing_Type
            when 'G2'
            then Gross_value * -1
            when 'CBRE'
            then Gross_value * -1
            else Gross_value end                         as Gross_value,

            //       @Semantics.amount.currencyCode: 'TransactionCurrency'
            //       @UI: {  lineItem: [ { position: 780 } ],
            //                identification: [ { position: 780 } ]
            //           }
            //       @EndUserText.label: 'Commission %'
            //       sales.CommisionPrcntg,

            //       @Semantics.amount.currencyCode: 'TransactionCurrency'
            //       @UI: {  lineItem: [ { position: 790 } ],
            //                identification: [ { position: 790 } ]
            //           }
            //       @EndUserText.label: 'Commission Value'
            //       @Aggregation.default: #SUM
            //       sales.CommisionValue,

            //       @UI: {  lineItem: [ { position: 800 } ],
            //                identification: [ { position: 800 } ]
            //           }
            //       @EndUserText.label: 'Total Commission Amount'
            //       @Semantics.amount.currencyCode: 'TransactionCurrency'
            //       @Aggregation.default: #SUM
            //       sales.TotCmsnAmnt,

            @UI: {  lineItem: [ { position: 810 } ],
                     identification: [ { position: 810 } ]
                }
            @EndUserText.label: 'Credit Note Rate'
            cast(sales.CRDNoteRate as abap.dec( 10, 2 )) as CRDNoteRate,

            @UI: {  lineItem: [ { position: 820 } ],
                     identification: [ { position: 820 } ]
                }
            @EndUserText.label: 'Credit Note Amt'
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            case Billing_Type
            when 'G2'
            then sales.CRDNote * -1
            when 'CBRE'
            then sales.CRDNote * -1
            else sales.CRDNote end                       as CRDNote,

            ////       @UI: {  lineItem: [ { position: 820 } ],
            ////                identification: [ { position: 820 } ]
            ////           }
            ////       @EndUserText.label: 'Bill of Entry'
            ////       sales.Gross_value,

            ////       @UI: {  lineItem: [ { position: 830 } ],
            ////                identification: [ { position: 830 } ]
            ////           }
            ////       @EndUserText.label: 'No.of packages'
            ////       sales.Gross_value,

            @UI: {  lineItem: [ { position: 840 } ],
                     identification: [ { position: 840 } ]
                }
            @EndUserText.label: 'Avg. Count per package'
            @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
            sales.AvgCntPckgs,
            sales.DeliveryQuantityUnit,
            @UI: {  lineItem: [ { position: 850 } ],
                     identification: [ { position: 850 } ]
                }
            @EndUserText.label: 'Dispatch From'
            sales.PlantCity,

            @UI: {  lineItem: [ { position: 860 } ],
                     identification: [ { position: 860 } ]
                }
            @EndUserText.label: 'Dispatch To'
            sales.CustomerCity,

            @UI: {  lineItem: [ { position: 870 } ],
                     identification: [ { position: 870 } ]
                }
            @EndUserText.label: 'Exchange Rate'
            sales.AccountingExchangeRate,

            @UI: {  lineItem: [ { position: 880 } ],
                     identification: [ { position: 880 } ]
                }
            @EndUserText.label: 'IRN No.'
            sales.IRN,

            @UI: {  lineItem: [ { position: 890 } ],
                     identification: [ { position: 890 } ]
                }
            @EndUserText.label: 'Ewaybill No.'
            sales.EWB,

            @UI: {  lineItem: [ { position: 900 } ],
                     identification: [ { position: 900 } ]
                }
            @EndUserText.label: 'Ewaybill Date'
            sales.EWBDT, //sales.EWBVALIDITY
            sales.EWBVALIDITY,


            ////       @UI: {  lineItem: [ { position: 910 } ],
            ////                identification: [ { position: 910 } ]
            ////           }
            ////       @EndUserText.label: 'Invoice Status'
            ////       sales.Gross_value,

            ////       @UI: {  lineItem: [ { position: 920 } ],
            ////                identification: [ { position: 920 } ]
            ////           }
            ////       @EndUserText.label: 'Due date'
            ////       sales.Gross_value,

            @UI: {  lineItem: [ { position: 930 } ],
                     identification: [ { position: 930 } ]
                }
            @EndUserText.label: 'Created By'
            sales.CreatedByUser
            //       ,
            //
            //       @UI: {  lineItem: [ { position: 940 } ],
            //                identification: [ { position: 940 } ]
            //           }
            //       @EndUserText.label: 'Created ON'
            //       sales.CreationDate
}
