@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUSTOMER_AEGING_NEW'
@EndUserText.label: 'Customer Ageing report'
define custom entity ZC_CUSTOMER_AGEING_NEW
{


 @UI.facet           : [

                   {
          id              : '_CHILD',
          purpose         : #STANDARD,
          position        :  1,
          label           : 'Supplier Ageing',
          type            :  #LINEITEM_REFERENCE,
          targetElement   : '_CHILD'
      }

               ]

      @UI                 : {
      lineItem            : [{position: 10, importance: #HIGH}],
      identification      : [{position: 10}],
      selectionField      : [{position: 20}]}
      @EndUserText.label  : 'Supplier Code'

  key Supplier_code     : abap.char(30);

      @UI               : {  lineItem: [ { position: 20 } ],
                identification: [ { position: 20 } ],
                selectionField: [ { position:2  } ]
           }
      @EndUserText.label: 'Fiscal Year'

  key Fiscal_Year       : abap.char(4);
  
    @UI               : {  
//    lineItem: [ { position: 30 } ],
//                identification: [ { position: 30 } ],
                selectionField: [ { position:3  } ]
           }
        @Consumption.filter: {
           
            selectionType: #SINGLE,
            multipleSelections: false
          
        }
        @Consumption.filter.mandatory: true
      @EndUserText.label: 'Posting Date' 
  key Posting_date      : abap.dats(8); 

  Currency_Code     : abap.cuky( 5 );
  
  

      @UI               : {  lineItem       : [ { position: 30 } ],
                     identification : [ { position: 30} ]
            }
      @EndUserText.label: 'Supplier Name'
      Supplier_Name     : abap.char( 100 );

    



      @UI               : {      lineItem: [ { position: 40 } ],
                 identification     : [ { position: 40 } ]
           }
      @EndUserText.label: '0 - 30 Days'

     @Semantics.amount.currencyCode: 'Currency_Code'

      days_0_to_30       : abap.curr(16,2);



      @UI               : {      lineItem: [ { position: 50 } ],
           identification     : [ { position: 50 } ]
      }
      @EndUserText.label: '31 - 60 Days'
            @Semantics.amount.currencyCode: 'Currency_Code'
            days_31_to_60             : abap.curr(16,2);
  


      @UI               : {      lineItem: [ { position: 60 } ],
           identification     : [ { position:60 } ]
      }
      @EndUserText.label: '61 - 90 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_61_to_90     : abap.curr(16,2);



      @UI               : {      lineItem: [ { position: 70 } ],
           identification     : [ { position:70 } ]
      }
      @EndUserText.label: '91 - 120 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_91_to_120    : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 80 } ],
           identification     : [ { position:80 } ]
      }
      @EndUserText.label: '121 - 150 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_121_to_150   : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 90 } ],
           identification     : [ { position:90 } ]
      }
      @EndUserText.label: '151 - 180 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_151_to_180   : abap.curr(16,2);



      @UI               : {      lineItem: [ { position: 100 } ],
            identification     : [ { position:100 } ]
      }
      @EndUserText.label: '181 - 210 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_181_to_210   : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 110 } ],
           identification     : [ { position:110 } ]
      }
      @EndUserText.label: '211 - 240 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      Days_211_to_240   : abap.curr(16,2);
      
      @UI               : {      lineItem: [ { position: 120 } ],
           identification     : [ { position:120 } ]
      }
      @EndUserText.label: '241 - 270 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      Days_241_to_270   : abap.curr(16,2);
      
       @UI               : {      lineItem: [ { position: 130 } ],
           identification     : [ { position:130 } ]
      }
      @EndUserText.label: '271 - 365 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      Days_271_to_365   : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 140 } ],
            identification     : [ { position:140 } ]
      }
      @EndUserText.label: '>365 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'
      days_366          : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 150 } ],
          identification: [ { position:150 } ]
      }
      @EndUserText.label: 'Unadjusted Debits'
      @Semantics.amount.currencyCode: 'Currency_Code'
      Unadjusted_debits : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 160 } ],
            identification     : [ { position:160 } ]
      }
      @EndUserText.label: 'MSME'

      MSME              : abap.char( 10 ); 


//      @UI               : {      lineItem: [ { position: 170 } ],
//             identification     : [ { position:170 } ]
//       }
//      @EndUserText.label: 'Not Due'
//      @Semantics.amount.currencyCode: 'Currency_Code'
//
//      Not_Due           : abap.curr(16,2);
//
//
//      @UI               : {      lineItem: [ { position: 180 } ],
//           identification     : [ { position:180 } ]
//      }
//      @EndUserText.label: 'Over Due'
//      @Semantics.amount.currencyCode: 'Currency_Code'
//
//      over_Due          : abap.curr(16,2);


      @UI               : {      lineItem: [ { position: 190 } ],
           identification     : [ { position:190 } ]
      }
      @EndUserText.label: 'Total Amount'
      @Semantics.amount.currencyCode: 'Currency_Code'
      totalamount       : abap.curr(16,2);
      
      
      
      @ObjectModel.filter.enabled: false
      @ObjectModel.sort.enabled: false
      _CHILD              : composition [*] of ZCHILD_CUSTOMER_AGEING_NEW;
      
      

}
