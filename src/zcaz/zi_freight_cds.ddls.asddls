@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for FREIGHT fields'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FREIGHT_CDS
  as select distinct from I_BillingDocumentItemBasic as a
  association        to I_BillingDocumentBasic        as b on  a.BillingDocument = b.BillingDocument
  association [0..1] to I_FrtCostAllocItm             as c on  a.ReferenceSDDocument     = c.SettlmtPrecdgDoc
                                                           and a.ReferenceSDDocumentItem = c.SettlmtPrecdgDocItem
  association [0..*] to I_BillingDocumentPartnerBasic as d on  a.BillingDocument   = d.BillingDocument
                                                           and (
                                                              d.PartnerFunction    = 'U3'
                                                              or d.PartnerFunction = 'SP'
                                                            )
  association [0..*] to I_FrtCostAllocItm             as e on  a.ReferenceSDDocument = e.SettlmtPrecdgDoc
  //                                                           and a.ReferenceSDDocumentItem = c.SettlmtPrecdgDocItem
{
  key ltrim(a.BillingDocument,'0')               as BillingDocument,
  key ltrim(a.BillingDocumentItem, '0')          as BillingDocumentItem,
      e.FreightOrder                             as FREIGHTORDERNO1,
      ltrim(e.FreightOrder, '0')                 as freightorderno,
      a.Plant,
      b.DocumentReferenceID                      as DocumentReferenceID,
      cast(
          concat(
            concat(
              concat(substring(b.BillingDocumentDate, 7, 2), '.' ),
              concat(substring(b.BillingDocumentDate, 5, 2), '.' )
            ),
            substring(b.BillingDocumentDate, 1, 4)
          )
        as abap.char( 10 ) )                     as BillingDocumentDate,
      a.BillingDocumentDate                      as BillingDocumentDate1,
      a.ReferenceSDDocument                      as DeliveryNo,

      a.SalesDocument                            as SalesDocument,
      e.SettlmtItemReltdPurgDoc                  as PO_No,
      c.FreightCostAllocationDocument,
      c.FrtCostAllocDocumentItem,
      b.SoldToParty,
      c.FrtCostAllocDocCurrency,
      @Semantics.amount.currencyCode: 'FrtCostAllocDocCurrency'
      c.FrtCostAllocItemNetAmount                as FrtAmt,
      b._PayerParty.CustomerName,
      c.ProfitCenter,
      //      c._ProfitCenter._Text[Language = 'E'].ProfitCenterName,
      b._PayerParty.CityName                     as Destination,
      ltrim(a.Product,'0')                       as product,
      a._ProductText[Language = 'E'].ProductName as ProductName,
      a.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      a.BillingQuantity                          as NetQty,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      a.BillingQuantity                          as GrossQty,
      a.ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      a.ItemGrossWeight                          as GrossWeght,
      b.IncotermsClassification,
      d.Supplier
}
where
       b.BillingDocumentIsCancelled  =  ''
  and  a.BillingDocumentType         <> 'SVTB'
  and  a.BillingDocumentType         <> 'F8'
  and  a.BillingDocumentType         <> 'G2'
  and  a.BillingDocumentType         <> 'L2'
  and  a.BillingDocumentType         <> 'CBRE'
  and  a.BillingDocumentType         <> 'JSTO'
  and  a.BillingDocumentType         <> 'F5'
  and  a.BillingDocumentType         <> 'JSN'
  and  a.BillingDocumentType         <> 'JSP'
  and  a.BillingDocumentType         <> 'JVR'
  and  a.BillingDocumentType         <> 'S1'
  and  a.BillingDocumentType         <> 'S2'
  and(
       b.IncotermsClassification     =  'CIF'
    or b.IncotermsClassification     =  'CFR'
  )
  and  a.ReferenceSDDocumentCategory =  'J'
  and  b.ShippingCondition           =  '06'
