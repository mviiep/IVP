@AbapCatalog.sqlViewName: 'ZZC_FISALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FINLAL  CDS for FI Sales Register'
define view ZC_FI_SALES_REPORT
  as select distinct from ZI_FI_SALES_REPORT as SALES_Register

{

          @UI: {  lineItem: [ { position: 30 } ],
                             identification: [ { position: 30 } ] ,
                      selectionField: [ { position:10  } ]}
          @EndUserText.label: 'Reference No.'
  key     SALES_Register.ReferenceDocumentMIRO,

          @UI: {  lineItem: [ { position:20  } ],
                                    identification: [ { position: 20 } ]}
          @EndUserText.label: 'Accounting Document' //Accounting Document
  key     SALES_Register.AccountingDocument,

          @UI: {  lineItem: [ { position: 660 } ],
                                   identification: [ { position: 660 } ]
                           }
          @EndUserText.label: 'Base Amount'
          @Semantics.amount.currencyCode: 'DocumentCurrency'
  key     SALES_Register.BaseAmount,

          @UI: {  lineItem: [ { position:990  } ],
                                           identification: [ { position:990 } ]}
          @EndUserText.label: 'Text'
  key     SALES_Register.DocumentItemText,

          @Consumption.filter.mandatory: true
          @UI: {  lineItem: [ { position: 10 } ],
                  identification: [ { position: 10 } ],
                  selectionField: [ { position: 20 } ]
          }
          @EndUserText.label: 'Posting Date'
          SALES_Register.PostingDate,

          //
          //          @UI: {  lineItem: [ { position:30  } ],
          //                                    identification: [ { position: 30 } ]}
          //          @EndUserText.label: 'Reference No.'
          //          SALES_Register.RefDocNo,

          @UI: {  lineItem: [ { position: 40 } ],
                  identification: [ { position: 40 } ]
          }
          @EndUserText.label: 'Business Place'
          SALES_Register.BusinessPlace          as BusinessPlace,

          @UI: {  lineItem: [ { position:50  } ],
                                    identification: [ { position: 50 } ]}
          @EndUserText.label: 'Plant'
          SALES_Register.blank                  as plant,

          @UI: {  lineItem: [ { position:70  } ],
                                    identification: [ { position: 70 } ]}
          @EndUserText.label: 'Plant Name'
          SALES_Register.blank                  as plantname,

          @UI: {  lineItem: [ { position:80  } ],
                                    identification: [ { position: 80 } ]}
          @EndUserText.label: 'Plant GSTIN'
          SALES_Register.blank                  as PlantGSTIN,

          @UI: {  lineItem: [ { position:90  } ],
                                    identification: [ { position: 90 } ]}
          @EndUserText.label: 'Billing Type'
          SALES_Register.blank                  as BillingType,

          @UI: {  lineItem: [ { position:100  } ],
                                    identification: [ { position: 100 } ]}
          @EndUserText.label: 'Accounting Document Type'
          SALES_Register.AccountingDocumentType as AccountingDocumentType,

          @UI: {  lineItem: [ { position:110  } ],
                                    identification: [ { position: 110 } ]}
          @EndUserText.label: 'Ref. Invoice No.'
          SALES_Register.blank                  as RefInvoiceNo,

          @UI: {  lineItem: [ { position:120  } ],
                                    identification: [ { position: 120 } ]}
          @EndUserText.label: 'Ref. Invoice Date'
          SALES_Register.blank                  as RefInvoiceDate,

          @UI: {  lineItem: [ { position:130  } ],
                                    identification: [ { position: 130 } ]}
          @EndUserText.label: 'Distribution Channel'
          SALES_Register.blank                  as DistributionChannel,

          @UI: {  lineItem: [ { position:140  } ],
                          identification: [ { position: 140 } ]}
          @EndUserText.label: 'Dist. Channel Desc.'
          SALES_Register.blank                  as DistChannelDesc,

          @UI: {  lineItem: [ { position:150  } ],
                          identification: [ { position: 150 } ]}
          @EndUserText.label: 'Division'
          SALES_Register.blank                  as Division,

          @UI: {  lineItem: [ { position:160  } ],
                          identification: [ { position: 160 } ]}
          @EndUserText.label: 'Division Desc.'
          SALES_Register.blank                  as DivisionDesc,

          @UI: {  lineItem: [ { position:170  } ],
                          identification: [ { position: 170 } ]}
          @EndUserText.label: 'Sold To Party'
          SALES_Register.blank                  as SoldToParty,

          @UI: {  lineItem: [ { position:180  } ],
                          identification: [ { position: 180 } ]}
          @EndUserText.label: 'Sold To Party Name'
          SALES_Register.blank                  as SoldToPartyName,

          @UI: {  lineItem: [ { position:190  } ],
                identification: [ { position: 190 } ]}
          @EndUserText.label: 'Ship To Party'
          SALES_Register.blank                  as ShipToParty,

          @UI: {  lineItem: [ { position:200  } ],
                identification: [ { position: 200 } ]}
          @EndUserText.label: 'Ship To Party Name'
          SALES_Register.blank                  as ShipToPartyName,

          @UI: {  lineItem: [ { position:210  } ],
                identification: [ { position: 210 } ]}
          @EndUserText.label: 'Bill To Party'
          SALES_Register.blank                  as BillToParty,

          @UI: {  lineItem: [ { position:220  } ],
                identification: [ { position: 220 } ]}
          @EndUserText.label: 'Bill To Party Name'
          SALES_Register.Vendor                 as BillToPartyName,

          @UI: {  lineItem: [ { position:230  } ],
                identification: [ { position: 230 } ],
                 selectionField: [ { position: 40 } ]}
          @EndUserText.label: 'Customer'
          SALES_Register.Vendor                 as Payer,

          @UI: {  lineItem: [ { position:240  } ],
                identification: [ { position: 240 } ]}
          @EndUserText.label: 'Customer Name'
          SALES_Register.VendorName             as PayerName,

          @UI: {  lineItem: [ { position:250  } ],
                identification: [ { position: 250 } ]}
          @EndUserText.label: 'Sales Type'
          SALES_Register.blank                  as SalesType,

          @UI: {  lineItem: [ { position:260  } ],
          identification: [ { position: 260 } ]}
          @EndUserText.label: 'Customer Region'
          SALES_Register.VendorRegion           as CustomerRegion,

          @UI: {  lineItem: [ { position:270  } ],
          identification: [ { position: 270 } ]}
          @EndUserText.label: 'Region Name'
          SALES_Register.RegionName             as RegionName,

          @UI: {  lineItem: [ { position:280  } ],
          identification: [ { position: 280 } ]}
          @EndUserText.label: 'Sales Type Desc'
          SALES_Register.blank                  as SalesTypeDesc,

          @UI: {  lineItem: [ { position:290  } ],
          identification: [ { position: 290 } ]}
          @EndUserText.label: 'GSTIN'
          SALES_Register.GSTIN                  as GSTIN,

          @UI: {  lineItem: [ { position: 300 } ],
                   identification: [ { position: 300 } ]
           }
          @EndUserText.label: 'Bill To Pan'

          SALES_Register.blank                  as BillToPan,

          @UI: {  lineItem: [ { position:310  } ],
          identification: [ { position: 310 } ]}
          @EndUserText.label: 'Customer State'
          SALES_Register.blank                  as CustomerState,

          @UI: {  lineItem: [ { position: 320 } ],
                   identification: [ { position: 320 } ]}
          @EndUserText.label: 'Regional Head'
          SALES_Register.blank                  as RegionalHead,

          @UI: {  lineItem: [ { position:330  } ],
          identification: [ { position: 330 } ]}
          @EndUserText.label: 'Sales Person'
          SALES_Register.blank                  as SalesPerson,

          @UI: {  lineItem: [ { position:340  } ],
          identification: [ { position: 340 } ]}
          @EndUserText.label: 'Transporter Name'
          SALES_Register.blank                  as TransporterName,

          @UI: {  lineItem: [ { position:350  } ],
          identification: [ { position: 350 } ]}
          @EndUserText.label: 'Commision Agent'
          SALES_Register.blank                  as CommisionAgent,

          @UI: {  lineItem: [ { position:360  } ],
          identification: [ { position: 360 } ]}
          @EndUserText.label: 'Commision Agent Name'
          SALES_Register.blank                  as CommisionAgentName,

          @UI: {  lineItem: [ { position:370  } ],
          identification: [ { position: 370 } ]}
          @EndUserText.label: 'Inco Term'
          SALES_Register.blank                  as IncoTerm,

          @UI: {  lineItem: [ { position:380  } ],
          identification: [ { position: 380 } ]}
          @EndUserText.label: 'Payment Term'
          SALES_Register.blank                  as PaymentTerm,

          @UI: {  lineItem: [ { position:390  } ],
          identification: [ { position: 390 } ]}
          @EndUserText.label: 'Payment Term Text'
          SALES_Register.blank                  as PaymentTermText,

          @UI: {  lineItem: [ { position:400  } ],
          identification: [ { position: 400 } ]}
          @EndUserText.label: 'Customer PO No.'
          SALES_Register.blank                  as CustomerPONo,

          @UI: {  lineItem: [ { position:410  } ],
          identification: [ { position: 410 } ]}
          @EndUserText.label: 'Customer PO Date'
          SALES_Register.blank                  as CustomerPODate,

          @UI: {  lineItem: [ { position:420  } ],
          identification: [ { position: 420 } ]}
          @EndUserText.label: 'LR No'
          SALES_Register.blank                  as LRNo,

          @UI: {  lineItem: [ { position:430  } ],
          identification: [ { position: 430 } ]}
          @EndUserText.label: 'LR Date'
          SALES_Register.blank                  as LRDate,

          @UI: {  lineItem: [ { position:440  } ],
          identification: [ { position: 440 } ]}
          @EndUserText.label: 'Sales Order No.'
          SALES_Register.blank                  as SalesOrderNo,

          @UI: {  lineItem: [ { position:445  } ],
          identification: [ { position: 445 } ]}
          @EndUserText.label: 'Freight Order No'
          SALES_Register.blank                  as FreightOrderNo,

          @UI: {  lineItem: [ { position:450  } ],
          identification: [ { position: 450 } ]}
          @EndUserText.label: 'Sales Order Date'
          SALES_Register.blank                  as SalesOrderDate,

          @UI: {  lineItem: [ { position:460  } ],
          identification: [ { position: 460 } ]}
          @EndUserText.label: 'Item No.'
          SALES_Register.blank                  as ItemNo,

          @UI: {  lineItem: [ { position:470  } ],
          identification: [ { position: 470 } ]}
          @EndUserText.label: 'Product'
          SALES_Register.blank                  as Product,

          @UI: {  lineItem: [ { position:480  } ],
          identification: [ { position: 480 } ]}
          @EndUserText.label: 'Product Name'
          SALES_Register.blank                  as ProductName,

          @UI: {  lineItem: [ { position:490  } ],
          identification: [ { position: 490 } ]}
          @EndUserText.label: 'Product Group'
          SALES_Register.blank                  as ProductGroup,

          @UI: {  lineItem: [ { position:500  } ],
          identification: [ { position: 500 } ]}
          @EndUserText.label: 'Product Group Description'
          SALES_Register.blank                  as ProductGroupDescription,

          @UI: {  lineItem: [ { position: 510 } ],
                  identification: [ { position: 510 } ]
          }
          @EndUserText.label: 'HSN Code'
          SALES_Register.HSN                    as HSN,


          @UI: {  lineItem: [ { position:520  } ],
          identification: [ { position: 520 } ]}
          @EndUserText.label: 'Invoice Qty'
          SALES_Register.blank                  as InvoiceQty,


          @UI: {  lineItem: [ { position:540  } ],
          identification: [ { position: 540 } ]}
          @EndUserText.label: 'Sales Unit'
          SALES_Register.blank                  as SalesUnit,

          @UI: {  lineItem: [ { position:550  } ],
          identification: [ { position: 550 } ]}
          @EndUserText.label: 'List Price'
          SALES_Register.blank                  as ListPrice,

          @UI: {  lineItem: [ { position:560  } ],
          identification: [ { position: 560 } ]}
          @EndUserText.label: 'Customer Freight'
          SALES_Register.blank                  as CustomerFreight,

          @UI: {  lineItem: [ { position:570  } ],
          identification: [ { position: 570 } ]}
          @EndUserText.label: 'Transfer Freight'
          SALES_Register.blank                  as TransferFreight,

          @UI: {  lineItem: [ { position:580  } ],
          identification: [ { position: 580 } ]}
          @EndUserText.label: 'Unit Rate'
          SALES_Register.blank                  as UnitRate,

          @UI: {  lineItem: [ { position:590  } ],
          identification: [ { position: 590 } ]}
          @EndUserText.label: 'Agreed Price'
          SALES_Register.blank                  as AgreedPrice,

          @UI: {  lineItem: [ { position:600  } ],
          identification: [ { position: 600 } ]}
          @EndUserText.label: 'Basic Amount'
          SALES_Register.blank                  as BasicAmount,


          @UI: {  lineItem: [ { position:610  } ],
          identification: [ { position: 610 } ]}
          @EndUserText.label: 'Freight Amount'
          SALES_Register.blank                  as FreightAmount,

          @UI: {  lineItem: [ { position:620  } ],
          identification: [ { position: 620 } ]}
          @EndUserText.label: 'Insurance Amount'
          SALES_Register.blank                  as InsuranceAmount,

          @UI: {  lineItem: [ { position:630  } ],
          identification: [ { position: 630 } ]}
          @EndUserText.label: 'Round Off Amount'
          SALES_Register.blank                  as RoundOffAmount,

          @UI: {  lineItem: [ { position:650  } ],
          identification: [ { position: 650 } ]}
          @EndUserText.label: 'Sales Value in Loc. Curr.'
          SALES_Register.blank                  as SalesValueinLocCurr,

          //          @UI: {  lineItem: [ { position:660  } ],
          //          identification: [ { position: 660 } ]}
          //          @EndUserText.label: 'Base Amount'
          //          SALES_Register.BaseAmount    as BaseAmount,

          @UI: {  lineItem: [ { position: 670 } ],
          identification: [ { position: 670 } ]          }
          @EndUserText.label: 'Tax rate'
          SALES_Register.TaxRate,

          @UI: {  lineItem: [ { position: 680 } ],
                   identification: [ { position: 680 } ]
           }
          @EndUserText.label: 'CGST AMOUNT'
          SALES_Register.CGST,

          @UI: {  lineItem: [ { position:690  } ],
          identification: [ { position: 690 } ]}
          @EndUserText.label: 'SGST Rate'
          SALES_Register.blank                  as SGSTRate,

          @UI: {  lineItem: [ { position: 700 } ],
                  identification: [ { position: 700 } ] }
          @EndUserText.label: 'SGST AMOUNT'
          SALES_Register.SGST,

          @UI: {  lineItem: [ { position:710  } ],
          identification: [ { position: 710 } ]}
          @EndUserText.label: 'IGST Rate'
          SALES_Register.blank                  as IGSTRate,

          @UI: {  lineItem: [ { position: 715 } ],
                  identification: [ { position: 715 } ]}
          @EndUserText.label: 'IGST AMOUNT'
          SALES_Register.IGST,

          @UI: {  lineItem: [ { position:720  } ],
          identification: [ { position: 720 } ]}
          @EndUserText.label: 'UTGST Rate'
          SALES_Register.blank                  as UTGSTRate,

          @UI: {  lineItem: [ { position:730  } ],
          identification: [ { position: 730 } ]}
          @EndUserText.label: 'UTGST'
          SALES_Register.blank                  as UTGST,

          @UI: {  lineItem: [ { position:740  } ],
          identification: [ { position: 740 } ]}
          @EndUserText.label: 'TCS Rate'
          SALES_Register.blank                  as TCSRate,

          @UI: {  lineItem: [ { position:750  } ],
          identification: [ { position: 750 } ]}
          @EndUserText.label: 'TCS'
          SALES_Register.blank                  as TCS,

          @UI: {  lineItem: [ { position:760  } ],
          identification: [ { position: 760 } ]}
          @EndUserText.label: 'Total Tax'
          SALES_Register.blank                  as totaltax,

          @UI: {  lineItem: [ { position: 770 } ],
                         identification: [ { position:770 } ]

                               }
          @EndUserText.label: 'Document Currency'
          SALES_Register.DocumentCurrency,

          @UI: {  lineItem: [ { position: 780 } ],
               identification: [ { position: 780 } ]
          }
          @EndUserText.label: 'Gross Amount'

          case
            when SALES_Register.TaxCode = 'D1' or SALES_Register.TaxCode = 'D2' or SALES_Register.TaxCode = 'D3' or SALES_Register.TaxCode = 'D4'
              or SALES_Register.TaxCode = 'D5' or SALES_Register.TaxCode = 'D6' or SALES_Register.TaxCode = 'D7' or SALES_Register.TaxCode = 'D8'
              or SALES_Register.TaxCode = 'E1' or SALES_Register.TaxCode = 'E2' or SALES_Register.TaxCode = 'F1'
            then cast( coalesce( SALES_Register.CGST,0) + coalesce(SALES_Register.SGST,0) +
                       coalesce( SALES_Register.IGST,0) + SALES_Register.BaseAmount as abap.curr( 13, 2 ) )
            when SALES_Register.TaxCode <> 'J1' and SALES_Register.TaxCode <> 'J2' and SALES_Register.TaxCode <> 'J3' and SALES_Register.TaxCode <> 'J4'
             and SALES_Register.TaxCode <> 'J5' and SALES_Register.TaxCode <> 'J6' and SALES_Register.TaxCode <> 'J7' and SALES_Register.TaxCode <> 'J8'
             and SALES_Register.CGST > 0 or SALES_Register.IGST > 0
            then cast( coalesce( SALES_Register.CGST,0) + coalesce(SALES_Register.SGST,0) +
                       coalesce( SALES_Register.IGST,0) + SALES_Register.BaseAmount as abap.curr( 13, 2 ) )
            when SALES_Register.AccountingDocumentType = 'KG' and
                 SALES_Register.TaxCode <> 'J1' and SALES_Register.TaxCode <> 'J2' and SALES_Register.TaxCode <> 'J3' and SALES_Register.TaxCode <> 'J4'
             and SALES_Register.TaxCode <> 'J5' and SALES_Register.TaxCode <> 'J6' and SALES_Register.TaxCode <> 'J7' and SALES_Register.TaxCode <> 'J8'
          //            and SALES_Register.CGST > 0 or SALES_Register.IGST > 0
            then (cast( coalesce( SALES_Register.CGST * -1 ,0) + coalesce(SALES_Register.SGST * -1 ,0) +
                     coalesce(SALES_Register.IGST * -1 ,0) + SALES_Register.BaseAmount * -1 as abap.curr( 13, 2 ) ) * -1)
            when SALES_Register.RCGST is not null or SALES_Register.RIGST is not null
                then cast( SALES_Register.BaseAmount as abap.curr( 13, 2 ) )
                else SALES_Register.BaseAmount
                     end                        as GrossAmount,

          @UI: {  lineItem: [ { position:790  } ],
          identification: [ { position: 790 } ]}
          @EndUserText.label: 'Net Value'
          SALES_Register.blank                  as netvalue,

          @UI: {  lineItem: [ { position:800  } ],
          identification: [ { position: 800 } ]}
          @EndUserText.label: 'Credit Note Rate'
          SALES_Register.blank                  as creditnoterate,

          @UI: {  lineItem: [ { position:810  } ],
          identification: [ { position: 810 } ]}
          @EndUserText.label: 'Credit Note Amount'
          SALES_Register.blank                  as creditnoteamount,

          @UI: {  lineItem: [ { position:820  } ],
          identification: [ { position: 820 } ]}
          @EndUserText.label: 'Avg. Count per package'
          SALES_Register.blank                  as AvgCountperpackage,

          @UI: {  lineItem: [ { position:830  } ],
          identification: [ { position: 830 } ]}
          @EndUserText.label: 'Dispatch From'
          SALES_Register.blank                  as DispatchFrom,

          @UI: {  lineItem: [ { position:840  } ],
          identification: [ { position: 840 } ]}
          @EndUserText.label: 'Dispatch To'
          SALES_Register.blank                  as DispatchTo,

          @UI: {  lineItem: [ { position:850  } ],
          identification: [ { position: 850 } ]}
          @EndUserText.label: 'Exchange Rate'
          SALES_Register.blank                  as ExchangeRate,

          @UI: {  lineItem: [ { position:860  } ],
          identification: [ { position: 860 } ]}
          @EndUserText.label: 'IRN No.'
          SALES_Register.blank                  as IRNNo,

          @UI: {  lineItem: [ { position:870  } ],
          identification: [ { position: 870 } ]}
          @EndUserText.label: 'Ewaybill No.'
          SALES_Register.blank                  as EwaybillNo,

          @UI: {  lineItem: [ { position:880  } ],
          identification: [ { position: 880 } ]}
          @EndUserText.label: 'Ewaybill Date'
          SALES_Register.blank                  as EwaybillDate,

          @UI: {  lineItem: [ { position:890  } ],
          identification: [ { position: 890 } ]}
          @EndUserText.label: 'Created By'
          SALES_Register.blank                  as CreatedBy,

          @UI: {  lineItem: [ { position:900  } ],
          identification: [ { position: 900 } ]}
          @EndUserText.label: 'CreatedON'
          SALES_Register.blank                  as CreatedON,

          @UI: {  lineItem: [ { position:910  } ],
          identification: [ { position: 910 } ]}
          @EndUserText.label: 'Unit'
          SALES_Register.blank                  as Unit,

          @UI: {  lineItem: [ { position:920  } ],
          identification: [ { position: 920 } ]}
          @EndUserText.label: 'Billing Document'
          SALES_Register.blank                  as BillingDocument,

          @UI: {  lineItem: [ { position:930  } ],
          identification: [ { position: 730 } ]}
          @EndUserText.label: 'Unit Of Measure'
          SALES_Register.blank                  as UnitOfMeasure,


          @UI: {  lineItem: [ { position: 940 } ],
               identification: [ { position: 940 } ]
          }
          @EndUserText.label: 'Document Date'

          SALES_Register.InvoiceDate,

          @UI: {  lineItem: [ { position: 950 } ],
              identification: [ { position: 950 } ]}
          @EndUserText.label: 'GL Account'
          SALES_Register.GLAccount,

          @UI: {  lineItem: [ { position: 960 } ],
                                    identification: [ { position:960 } ]}
          @EndUserText.label: 'GL Account Name'
          SALES_Register.GLAccountLongName,


          @UI: {  lineItem: [ { position: 970 } ],
                identification: [ { position: 970 } ]
          }
          @EndUserText.label: 'Tax Code'

          SALES_Register.TaxCode,

          @UI: {  lineItem: [ { position: 980 } ],
                                   identification: [ { position:980 } ]}
          @EndUserText.label: 'Credit Debit Code'
          SALES_Register.DebitCreditCode


          //                    @UI: {  lineItem: [ { position:480  } ],
          //          identification: [ { position: 480 } ]}
          //          @EndUserText.label: 'Product Name'
          //          SALES_Register.blank         as ProductName,



          //
          //
          //
          //          @UI: {  lineItem: [ { position: 70 } ],
          //                   identification: [ { position: 70 } ]
          //           }
          //          @EndUserText.label: 'Region Name'
          //
          //          SALES_Register.RegionName,
          //
          //
          //

          //
          //
          //

          //

          //


          //

          //
          //
          //          @UI: {  lineItem: [ { position: 160 } ],
          //                   identification: [ { position: 160 } ]//,
          //
          //           }
          //          @EndUserText.label: 'Accounting Document Type'
          //          //
          //          SALES_Register.AccountingDocumentType,
          //

          //
          //

          //





}
where
  (
         SALES_Register.AccountingDocumentType = 'DG'
    and(
         SALES_Register.DebitCreditCode        = 'S'
      or SALES_Register.DebitCreditCode        = 'H'
    )
  )
  or(
         SALES_Register.AccountingDocumentType = 'DR'
    and(
         SALES_Register.DebitCreditCode        = 'S'
      or SALES_Register.DebitCreditCode        = 'H'
    )
  )
