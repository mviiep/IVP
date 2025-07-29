//@AbapCatalog.sqlViewName: 'zc_exim_report'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim Report'


define view entity zc_exim_report
  as select from zrpt_exim_report as exim

{
      @UI.facet          : [{
                 id   :'id',
                 label: 'Exim report',
                 type : #IDENTIFICATION_REFERENCE,
                 position  : 10   }]

      @UI : {  lineItem       : [ { position: 10 } ],
                identification : [ { position: 10} ]
       }
      @EndUserText.label: 'Invoice Number'

  key exim.id,

      @UI : {  lineItem       : [ { position: 20 } ],
                   identification : [ { position: 20} ]
          }
      @EndUserText.label: 'Mod. Bill Date'

      exim.modbilldate,

    @UI : {  lineItem       : [ { position: 30 } ],
                   identification : [ { position: 30} ],
                   selectionField: [ { position:1  } ]
          }

      @EndUserText.label: 'Billing Date'
      exim.BILLINGDATE,




      @UI : {  lineItem       : [ { position: 30 } ],
                   identification : [ { position: 30} ]
          }
      @EndUserText.label: 'Ship.bill no'

      exim.shipbillingno,


      @UI : {  lineItem       : [ { position: 40 } ],
                    identification : [ { position: 40} ]
           }
      @EndUserText.label: 'Ship.bill date'

      exim.shipbillingdate,


      @UI : {  lineItem       : [ { position: 50 } ],
                    identification : [ { position: 50} ]
           }
      @EndUserText.label: 'Air Bill Number'

      exim.airno,

      @UI : {  lineItem       : [ { position: 60 } ],
                    identification : [ { position: 60} ]
           }
      @EndUserText.label: 'Air Bill Date'

      exim.airdate,

      @UI : {  lineItem       : [ { position: 70 } ],
                   identification : [ { position: 70} ]
          }
      @EndUserText.label: 'Port of Loading'

      exim.portloading,
      
      
      
      @UI : {  lineItem       : [ { position: 70 } ],
                   identification : [ { position: 70} ]
          }
      @EndUserText.label: 'Port of Loading-code'

      exim.portloadingcode,
      
      
     
      @UI : {  lineItem       : [ { position: 80 } ],
                    identification : [ { position: 80} ]
           }
      @EndUserText.label: 'Place of Receipt'

      exim.placereceipt,

      @UI : {  lineItem       : [ { position: 90 } ],
                    identification : [ { position: 90} ]
           }
      @EndUserText.label: 'Destination Country'

      exim.destcountry,

      @UI : {  lineItem       : [ { position: 100 } ],
                   identification : [ { position: 100} ]
          }
      @EndUserText.label: 'Country of Origin'

      exim.countryorigin,

      @UI : {  lineItem       : [ { position: 110 } ],
                   identification : [ { position: 110} ]
          }
      @EndUserText.label: 'Port of Discharge'

      exim.portdischarge,

      @UI : {  lineItem       : [ { position: 120 } ],
                   identification : [ { position: 120} ]
          }
      @EndUserText.label: 'Pre cariage by'

      exim.shipprecarriage,

      @UI : {  lineItem       : [ { position: 130 } ],
                    identification : [ { position: 130} ]
           }
      @EndUserText.label: 'Transporter'

      exim.shiptransporter,

//      @UI : {  lineItem       : [ { position: 140 } ],
//                    identification : [ { position: 140} ]
//           }
//      @EndUserText.label: 'Material Description'
//
//      exim.materialdescription,

      @UI : {  lineItem       : [ { position: 150 } ],
                    identification : [ { position: 150} ]
           }
      @EndUserText.label: 'Quantity'

      exim.quantity,

      @UI : {  lineItem       : [ { position: 160 } ],
                     identification : [ { position: 160} ]
            }
      @EndUserText.label: 'Ship.Type'

      exim.shipmenttype,

      @UI : {  lineItem       : [ { position: 170 } ],
                     identification : [ { position: 170} ]
            }
      @EndUserText.label: 'Export Invoice Amount'

      exim.invoiceamt,


      @UI : {  lineItem       : [ { position: 180 } ],
                     identification : [ { position: 180} ]
            }
      @EndUserText.label: 'FOB as per S/Bill'

      exim.convertfobvalue,

      @UI : {  lineItem       : [ { position: 190 } ],
                    identification : [ { position: 190} ]
           }
      @EndUserText.label: 'DBK Rate'

      exim.dbkrate,


      @UI : {  lineItem       : [ { position: 200 } ],
                     identification : [ { position: 200} ]
            }
      @EndUserText.label: 'Eligible Draw Back A'

      exim.eligibleamt,


      @UI : {  lineItem       : [ { position: 210 } ],
                    identification : [ { position: 210} ]
           }
      @EndUserText.label: 'DBK Amt Recived'

      exim.dbkamountrecd,

      @UI : {  lineItem       : [ { position: 220 } ],
                     identification : [ { position: 220} ]
            }
      @EndUserText.label: 'RODTEP Rate'

      exim.rodtaperate,

      @UI : {  lineItem       : [ { position: 230 } ],
                     identification : [ { position: 230} ]
            }
      @EndUserText.label: 'RODTEP Amt Recived'

      exim.rodtaperecd,

      @UI : {  lineItem       : [ { position: 240 } ],
                    identification : [ { position: 240} ]
           }
      @EndUserText.label: 'Eligible RODTEP Amount'

      exim.rodamount,
      
      
       @UI : {  lineItem       : [ { position: 241 } ],
                    identification : [ { position: 241} ]
           }
      @EndUserText.label: 'BL Date'

      exim.bldate,
      
 @UI : {  lineItem       : [ { position: 242 } ],
                    identification : [ { position: 242} ]
           }
      @EndUserText.label: 'BL Number'

      exim.blno,


@UI : {  lineItem       : [ { position: 243 } ],
                    identification : [ { position: 243} ]
           }
      @EndUserText.label: 'GST Amount'

      exim.gstamount,
 
 
      

@UI : {  lineItem       : [ { position: 243 } ],
                    identification : [ { position: 243} ]
           }
      @EndUserText.label: 'Taxable Amount'

      exim.taxableamount
 


}
