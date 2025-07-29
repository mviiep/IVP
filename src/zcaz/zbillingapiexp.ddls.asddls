@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing API Exp'
define root view entity zbillingapiexp
  as select distinct from zbillingexpdet as b
  //    left outer join       I_BillingDocumentItemPrcgElmnt as pr  on b.BillingDocument  = pr.BillingDocument
  //                                                                and(
  //                                                                  pr.ConditionType    = 'FIN1'
  //                                                                  or pr.ConditionType = 'ZSIN'
  //                                                                )
  //    left outer join       I_BillingDocumentItemPrcgElmnt as pr1 on b.BillingDocument   = pr1.BillingDocument
  //                                                                and(
  //                                                                  pr1.ConditionType    = 'YBHD'
  //                                                                  or pr1.ConditionType = 'ZSFT'
  //                                                                )
  //    left outer join       I_BillingDocumentItem          as it  on b.BillingDocument = it.BillingDocument

  composition [0..*] of zbillingapiitem as _Item //on  $projection.BillingDocument = _Item.BillingDocument

{
  key b.BillingDocument,
      b.BillingDocumentDate,
      b.BillingDocumentType,
      b.CompanyCode,
      b.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      b.totalinvocieamount,
      b.ShippingType,
      b.TotalNetAmount,
      b.TotalTaxAmount,
      b.ShippingTypeName,
      b.buyersorder,
      b.buyerorderdate,
      b.salesorder,
      b.salesorderdate,
      b.payment_terms,
      b.payment_termsdesc,
      b.incoterms,
      b.incotermscode,
      b.billtoparty,
      b.billtopartyname,
      b.billtopartystreet,
      b.billtopartystreetname,
      b.billtopartycity,
      b.billtopartyregion,
      b.billtoregion,
      b.billtopartypostalcode,
      b.billtopartycountry,
      b.CountryName,
      b.soldtoparty,
      b.soldtopartyname,
      b.soldtopartystreet,
      b.soldtopartystreetname,
      b.soldtopartycity,
      b.soldtopartyregion,
      b.soldtoregion,
      b.soldtopartypostalcode,
      b.soldtopartycountry,
      b.soldtocountry,
      b.portofloading,
      b.portofloadingcode,
      b.transporter,
      b.BillingQuantityUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( b.insurance   )     as insurance,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      sum( b.freight    )      as freight,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      sum( b.BillingQuantity ) as invoiceqty,

      _Item //'/'.Material,
      //      _item.BillingQuantityUnit,
      //      _item.BillingQuantity,
      //      _item.SalesDocument



}
group by
  b.BillingDocument,
  b.BillingDocumentDate,
  b.BillingDocumentType,
  b.CompanyCode,
  b.TotalNetAmount,
  b.TotalTaxAmount,
  b.TransactionCurrency,
  b.totalinvocieamount,
  b.ShippingType,
  b.ShippingTypeName,
  b.buyersorder,
  b.buyerorderdate,
  b.salesorder,
  b.salesorderdate,
  b.payment_terms,
  b.payment_termsdesc,
  b.incoterms,
  b.incotermscode,
  b.billtoparty,
  b.billtopartyname,
  b.billtopartystreet,
  b.billtopartystreetname,
  b.billtopartycity,
  b.billtopartyregion,
  b.billtoregion,
  b.billtopartypostalcode,
  b.billtopartycountry,
  b.CountryName,
  b.soldtoparty,
  b.soldtopartyname,
  b.soldtopartystreet,
  b.soldtopartystreetname,
  b.soldtopartycity,
  b.soldtopartyregion,
  b.soldtoregion,
  b.soldtopartypostalcode,
  b.soldtopartycountry,
  b.soldtocountry,
  b.BillingQuantityUnit,
  b.portofloading,
  b.portofloadingcode,
  b.transporter
