@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Billing Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_BILLINGDETAILS
  as select from I_BillingDocumentItem as billitem
    inner join   I_BillingDocument     as billhead on billhead.BillingDocument = billitem.BillingDocument
    inner join   ZI_GSTIN_DETAILS      as gstin    on gstin.Plant = billitem.Plant
  //                                                   and gstin.billingdocumentitem = billitem.BillingDocumentItem
  association [0..*] to I_Customer       as _customer on _customer.Customer   = billitem.SoldToParty
                                                      or _customer.TaxNumber3 = billitem.BillToParty
                                                      or _customer.TaxNumber3 = billitem.ShipToParty
                                                      or _customer.TaxNumber3 = billitem.PayerParty
  association [0..1] to ztab_itc045a_res as response  on response.billingdocument = billitem.BillingDocument

{
  key billitem.BillingDocument         as billingdocument,
  key billitem.BillingDocumentItem     as billingdocumentitem,
      billitem.BillingDocumentType     as billingdocumenttype,
      billitem.Plant                   as billingdocumentplant,
      billitem.BillingDocumentDate     as billindocumentdate,
      billitem.BillingDocumentItemText as billingdocumentitemtext,
      billitem.CompanyCode             as companycode,
      @Semantics.quantity.unitOfMeasure: 'billingquantityunit'
      billitem.BillingQuantity         as billingitemquantity,
      billitem.BillingQuantityUnit     as billingquantityunit,
      @Semantics.amount.currencyCode: 'billingitemtransactioncurrency'
      billitem.NetAmount               as billingitemnetamount,
      billitem.TransactionCurrency     as billingitemtransactioncurrency,
      billitem.SoldToParty             as billingsoldtoparty,
      billitem.BillToParty             as billingbilltoparty,
      billitem.ShipToParty             as billingshiptoparty,
      billitem.PayerParty              as billingpayerparty,
      @Semantics.amount.currencyCode: 'billingitemtransactioncurrency'
      billitem.TaxAmount               as billingtaxamount,
      billitem.TaxCode                 as billingtaxcode,


      billhead.DocumentReferenceID     as chellannumber,

      gstin.BusinessPlace              as businessplace,
      gstin.IN_GSTIdentificationNumber as gstinnumber,

      _customer.CustomerName           as customername,
      _customer.TaxNumber3             as customergstin,

      response.itc04_5arespons         as portalresponse




}
where
  billitem.BillingDocumentType = 'JSN'
