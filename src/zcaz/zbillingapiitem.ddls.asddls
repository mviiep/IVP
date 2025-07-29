@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing API item'
define view entity zbillingapiitem
  as select from    I_BillingDocumentItem as item

    left outer join I_ProductDescription  as d on  item.Material = d.Product
                                               and d.Language    = 'E'
//left outer join I_BILLINGDOCITEMPRCGELMNTBASIC   as b on item.BillingDocument = b.BillingDocument
//                                                        and item.BillingDocumentItem = b.BillingDocumentItem
//                                                        and b.ConditionType = 'ZFOB'
  association to parent zbillingapiexp as _head on $projection.BillingDocument = _head.BillingDocument
  //composition of target_data_source_name as _association_name
{

      //    _association_name // Make association public
  key item.BillingDocument,
      item.BillingDocumentItem,

      item.Material,
      d.ProductDescription,
      item.BillingQuantityUnit,
      item.BillingQuantity,
      item.SalesDocument,
      item.NetAmount,
      item.TransactionCurrency,
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'JOCG' ].ConditionAmount   as freight,
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'JOCG' ].ConditionAmount   as insurance,
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'JOCG' ].ConditionAmount   as commission,
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'JOCG' ].ConditionAmount   as discount,
      

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      
       item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'ZFOB' ].ConditionAmount   as FOB,
      
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'ZDBK' ].ConditionAmount   as DBK_AMT,
      
      
      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
      and ConditionType = 'ZRTP' ].ConditionAmount   as Rodtep_AMT,
      
      
//      item.NetAmount - ( item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
//      and ConditionType = 'JOCG' ].ConditionAmount +
//
//      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
//      and ConditionType = 'JOCG' ].ConditionAmount +
//      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
//      and ConditionType = 'JOCG' ].ConditionAmount +
//      item._PricingElement[ BillingDocument = $projection.billingdocument and BillingDocumentItem = $projection.billingdocumentitem
//      and ConditionType = 'JOCG' ].ConditionAmount ) as fob,



//sum(B.ConditionAmount) AS FOB,




      _head
}
