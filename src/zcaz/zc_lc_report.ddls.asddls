//@AbapCatalog.sqlViewName: 'zc_exim_report'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim Report'


define view entity zc_lc_report
  as select from zlc_report as lc
{
       @UI.facet          : [{
                      id   :'Lcnum',
                      label: 'LC Number',
                      type : #IDENTIFICATION_REFERENCE,
                      position  : 10  }]


       @UI : {  lineItem       : [ { position: 20 } ],
                    identification : [ { position: 20} ]
           }
       @EndUserText.label: 'Internal LC Number'

  key  lc.Lcnum,


       @UI : {  lineItem       : [ { position: 60 } ],
                 identification : [ { position: 60}],
                 selectionField: [ { position:1  } ]
        }
       @EndUserText.label: 'Status Date'

       lc.zstatusdate,



       @UI : {  lineItem       : [ { position: 25 } ],
                      identification : [ { position: 25} ]
             }

       @EndUserText.label: 'External LC Number'
       lc.Extlcnum,




       @UI : {  lineItem       : [ { position: 30 } ],
                    identification : [ { position: 30} ]
           }
       @EndUserText.label: 'Letter of credit type'

       lc.lctyp,


       @UI : {  lineItem       : [ { position: 40 } ],
                     identification : [ { position: 40} ]
            }
       @EndUserText.label: 'Commodity'

       lc.commodity,


       @UI : {  lineItem       : [ { position: 50 } ],
                     identification : [ { position: 50} ]
            }
       @EndUserText.label: 'Domain'

       lc.zdomain,


       @UI : {  lineItem       : [ { position: 50 } ],
                         identification : [ { position: 50} ]
                }
       @EndUserText.label: 'Customer/Vendor'

       lc.partner,



       @UI : {  lineItem       : [ { position: 70 } ],
                    identification : [ { position: 70} ]
           }
       @EndUserText.label: 'Amount'

       lc.amount,

       @UI : {  lineItem       : [ { position: 80 } ],
                     identification : [ { position: 80} ]
            }
       @EndUserText.label: 'Currency'

       lc.currency,

       @UI : {  lineItem       : [ { position: 90 } ],
                     identification : [ { position: 90} ]
            }
       @EndUserText.label: 'Tolerance Upper Limit (%)'

       lc.ToleranceUl,

       @UI : {  lineItem       : [ { position: 100 } ],
                    identification : [ { position: 100} ]
           }
       @EndUserText.label: 'Tolerance Lower Limit (%)'

       lc.Tolerancel1,

       @UI : {  lineItem       : [ { position: 110 } ],
                    identification : [ { position: 110} ]
           }
       @EndUserText.label: 'Payment Mode'

       lc.paymentmode,

       @UI : {  lineItem       : [ { position: 120 } ],
                    identification : [ { position: 120} ]
           }
       @EndUserText.label: 'No of days'

       lc.nodays,

       @UI : {  lineItem       : [ { position: 130 } ],
                     identification : [ { position: 130} ]
            }
       @EndUserText.label: 'Inco terms'

       lc.incoterms,

       @UI : {  lineItem       : [ { position: 140 } ],
                     identification : [ { position: 140} ]
            }
       @EndUserText.label: 'baneficiary code'

       lc.benecode,

       @UI : {  lineItem       : [ { position: 150 } ],
                     identification : [ { position: 150} ]
            }
       @EndUserText.label: 'baneficiary name'

       lc.benename,

       @UI : {  lineItem       : [ { position: 160 } ],
                      identification : [ { position: 160} ]
             }
       @EndUserText.label: 'Classification'

       lc.classification,

       @UI : {  lineItem       : [ { position: 170 } ],
                      identification : [ { position: 170} ]
             }
       @EndUserText.label: 'Loading Port'

       lc.loadingport,


       @UI : {  lineItem       : [ { position: 180 } ],
                      identification : [ { position: 180} ]
             }
       @EndUserText.label: 'Discharging Port'

       lc.dischargingport,

       @UI : {  lineItem       : [ { position: 190 } ],
                     identification : [ { position: 190} ]
            }
       @EndUserText.label: 'Place of expiry '

       lc.placeofexpiry,


       @UI : {  lineItem       : [ { position: 200 } ],
                      identification : [ { position: 200} ]
             }
       @EndUserText.label: 'Transhipment'

       lc.transshipment,


       @UI : {  lineItem       : [ { position: 210 } ],
                     identification : [ { position: 210} ]
            }
       @EndUserText.label: 'Partial shipment'

       lc.partialshipment,

       @UI : {  lineItem       : [ { position: 220 } ],
                      identification : [ { position: 220} ]
             }
       @EndUserText.label: 'Request date'

       lc.requestdate,

       @UI : {  lineItem       : [ { position: 230 } ],
                      identification : [ { position: 230} ]
             }
       @EndUserText.label: 'Last shipment date'

       lc.lastshipmentdate,

       @UI : {  lineItem       : [ { position: 240 } ],
                     identification : [ { position: 240} ]
            }
       @EndUserText.label: 'date of issue'

       lc.dateofissue,


       @UI : {  lineItem       : [ { position: 241 } ],
                         identification : [ { position: 241} ]
                }
       @EndUserText.label: 'date of expiry'

       lc.dateofexpiry,

       @UI : {  lineItem       : [ { position: 242 } ],
                    identification : [ { position: 242} ]
           }
       @EndUserText.label: 'Opening date'

       lc.openingdate,


       @UI : {  lineItem       : [ { position: 243 } ],
                  identification : [ { position: 243} ]
         }
       @EndUserText.label: 'issuing Bank Code'

       lc.bamkcode,


       @UI : {  lineItem       : [ { position: 244} ],
                identification : [ { position: 244} ]
       }
       @EndUserText.label: 'Issuing Bank Name'

       lc.bankname,

       @UI : {  lineItem       : [ { position: 245} ],
                identification : [ { position: 245} ]
       }
       @EndUserText.label: 'Advising Bank Code'

       lc.adbankcode,

       @UI : {  lineItem       : [ { position: 245} ],
                 identification : [ { position: 245} ]
        }
       @EndUserText.label: 'Advising Bank Name'

       lc.adbankname,
       
        @UI : {  lineItem       : [ { position: 245} ],
                 identification : [ { position: 245} ]
        }
       @EndUserText.label: 'Due Datee'

       lc.Duwdate,
       
        @UI : {  lineItem       : [ { position: 245} ],
                 identification : [ { position: 245} ]
        }
       @EndUserText.label: 'Buyers Credit Facility'

       lc.buyerscredit



}
