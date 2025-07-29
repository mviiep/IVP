@AbapCatalog.sqlViewName: 'ZBILLINGDET'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Detail Billing Exp'
define view zbillingexpdet
  as select from    I_BillingDocument              as b
    left outer join I_BillingDocumentPartner       as a             on  b.BillingDocument = a.BillingDocument
                                                                    and a.PartnerFunction = 'RE' //billtoparty
    left outer join I_Address_2                    as c             on a.AddressID = c.AddressID

    left outer join I_BillingDocumentPartner       as d             on  b.BillingDocument = d.BillingDocument
                                                                    and d.PartnerFunction = 'WE' //soldtoparty
    left outer join I_Address_2                    as e             on a.AddressID = e.AddressID
  //    left outer join I_SalesOrderItem         as f on f.SalesOrder = b.SalesDocument
    left outer join I_Customer                     as f             on a.Customer = f.Customer
    left outer join I_Customer                     as g             on d.Customer = g.Customer

    left outer join I_BillingDocumentItem          as it            on b.BillingDocument = it.BillingDocument
    left outer join I_BillingDocumentItemPrcgElmnt as pr            on  it.BillingDocument     =  pr.BillingDocument
                                                                    and it.BillingDocumentItem =  pr.BillingDocumentItem
                                                                    and (
                                                                       pr.ConditionType        =  'FIN1'
                                                                       or pr.ConditionType     =  'ZSIN'
                                                                     )
                                                                    and pr.ConditionAmount     <> 0
    left outer join I_BillingDocumentItemPrcgElmnt as pr1           on  it.BillingDocument     =  pr1.BillingDocument
                                                                    and it.BillingDocumentItem =  pr1.BillingDocumentItem
                                                                    and (
                                                                       pr1.ConditionType       =  'YBHD'
                                                                       or pr1.ConditionType    =  'ZSFT'
                                                                     )
                                                                    and pr1.ConditionAmount    <> 0

    left outer join Ziexim_transporter             as transporter   on b.BillingDocument = transporter.BillingDocument

    left outer join Zexim_portofloading            as portofloading on b.BillingDocument = portofloading.BillingDocument

  //                                                          and pr1.ConditionOrigin    = 'A'

  //  composition [0..*] of zbillingapiitem as _Item //on  $projection.BillingDocument = _Item.BillingDocument


{
  key b.BillingDocument,
      b.BillingDocumentDate,
      b.BillingDocumentType,
      b.CompanyCode,
      //      f.IncotermsClassification,
      //      f.CustomerPaymentTerms                                                                        as paymentterms,
      b.TransactionCurrency,
      b.TotalNetAmount,
      b.TotalTaxAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      b.TotalNetAmount + b.TotalTaxAmount                                                           as totalinvocieamount,
      it._SalesDocument.ShippingType,
      it._SalesDocument._ShippingType._Text[ Language = 'E' ].ShippingTypeName,
      it._SalesDocument.PurchaseOrderByCustomer                                                     as buyersorder,
      it._SalesDocument.CustomerPurchaseOrderDate                                                   as buyerorderdate,
      it._SalesDocument.SalesDocument                                                               as salesorder,
      it._SalesDocumentItem.SalesDocumentDate                                                       as salesorderdate,
      it._SalesDocument.CustomerPaymentTerms                                                        as payment_terms,
      it._SalesDocument._CustomerPaymentTerms._Text
      [ Language = 'E'  ].CustomerPaymentTermsName                                                  as payment_termsdesc,
      it._SalesDocument.IncotermsLocation1                                                          as incoterms,
      it._SalesDocument.IncotermsClassification                                                     as incotermscode,
      a.Customer                                                                                    as billtoparty,
      f.CustomerName                                                                                as billtopartyname,
      c.Street                                                                                      as billtopartystreet,
      c.StreetName                                                                                  as billtopartystreetname,
      //  a._Address[ AddressID = a.AddressID ].StreetName,
      c.CityName                                                                                    as billtopartycity,
      c.Region                                                                                      as billtopartyregion,
      c._Region._RegionText[ Language = 'E' and Region = $projection.billtopartyregion ].RegionName as billtoregion,
      c.PostalCode                                                                                  as billtopartypostalcode,
      c.Country                                                                                     as billtopartycountry,
      c._Country._Text[ Language = 'E' ].CountryName,

      d.Customer                                                                                    as soldtoparty,
      g.CustomerName                                                                                as soldtopartyname,
      e.Street                                                                                      as soldtopartystreet,
      e.StreetName                                                                                  as soldtopartystreetname,
      e.CityName                                                                                    as soldtopartycity,
      e.Region                                                                                      as soldtopartyregion,
      e._Region._RegionText[ Language = 'E' and Region = $projection.soldtopartyregion ].RegionName as soldtoregion,
      e.PostalCode                                                                                  as soldtopartypostalcode,
      e.Country                                                                                     as soldtopartycountry,
      e._Country._Text[ Language = 'E' ].CountryName                                                as soldtocountry,
      transporter.SupplierName                                                                      as transporter,
      portofloading.CustomerName                                                                    as portofloading,
      portofloading.Customer                                                                        as portofloadingcode,

      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      it.BillingQuantity,
      it.BillingQuantityUnit,
      pr.ConditionAmount                                                                            as insurance,
      pr1.ConditionAmount                                                                           as freight

      //      _Item


}
