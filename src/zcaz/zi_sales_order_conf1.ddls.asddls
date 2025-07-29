@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SALES_ORDER_CoNF1
  as select distinct from I_SalesDocumentItem as A

  association [0..1] to I_SalesOrder                 as _salesorder      on  A.SalesDocument = _salesorder.SalesOrder

  association [0..1] to I_ProductSalesDelivery       as _productsalesdel on  A.Material            = _productsalesdel.Product
                                                                         and A.DistributionChannel = _productsalesdel.ProductDistributionChnl
                                                                         and A.SalesOrganization   = _productsalesdel.ProductSalesOrg

  association [0..1] to I_UnitOfMeasure              as _uom             on  A.OrderQuantityUnit = _uom.UnitOfMeasure
  association [0..1] to I_UnitOfMeasureText          as _uomtext         on  A.OrderQuantityUnit = _uomtext.UnitOfMeasure
                                                                         and _uomtext.Language   = 'E'
  association [0..1] to I_CustomerPaymentTermsText   as _PaymentTerm     on  A.CustomerPaymentTerms = _PaymentTerm.CustomerPaymentTerms
                                                                         and _PaymentTerm.Language  = 'E'
  association [0..1] to I_DeliveryPriority           as _DelPriority     on  A.DeliveryPriority = _DelPriority.DeliveryPriority
  association [0..1] to I_PurchaseOrderAPI01         as _POAPI01         on  A.PurchaseOrderByCustomer = _POAPI01.PurchaseOrder

  association [0..1] to I_ShippingTypeText           as _ShipText        on  A.ShippingType     = _ShipText.ShippingType
                                                                         and _ShipText.Language = 'E'

  association [0..1] to I_SalesDocumentScheduleLine  as _SDSchedule      on  A.SalesDocument = _SDSchedule.SalesDocument
                                                                         and A.SalesDocument = _SDSchedule.SalesDocumentItem

  association [0..1] to ZI_OrderBy_BPCustomer1       as _OrderBy         on  A.SalesDocument = _OrderBy.SalesDocument

  association [0..1] to ZI_ShipBy_SPCustomer1        as _ShipBy          on  A.SalesDocument = _ShipBy.SalesDocument

  association [0..1] to I_Customer                   as _customer        on  _customer.Language = 'E'

  association [0..1] to I_ProductPlantBasic          as _HSN             on  A.Product = _HSN.Product
                                                                         and A.Plant   = _HSN.Plant

  association [0..1] to I_SalesDocItemPricingElement as _ItemValues      on  A.SalesDocument           = _ItemValues.SalesDocument
                                                                         and A.SalesDocumentItem       = _ItemValues.SalesDocumentItem
                                                                         and _ItemValues.ConditionType = 'PPR0'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValues1     on  A.SalesDocument            = _ItemValues1.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValues1.SalesDocumentItem
                                                                         and _ItemValues1.ConditionType = 'PMP0'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValues2     on  A.SalesDocument            = _ItemValues2.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValues2.SalesDocumentItem
                                                                         and _ItemValues2.ConditionType = 'ZDEV'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesM     on  A.SalesDocument            = _ItemValuesM.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValuesM.SalesDocumentItem
                                                                         and _ItemValuesM.ConditionType = 'ZMRP'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesC     on  A.SalesDocument            = _ItemValuesC.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValuesC.SalesDocumentItem
                                                                         and _ItemValuesC.ConditionType = 'JOCG'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesI     on  A.SalesDocument            = _ItemValuesI.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValuesI.SalesDocumentItem
                                                                         and _ItemValuesI.ConditionType = 'JOIG'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesU     on  A.SalesDocument            = _ItemValuesU.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValuesU.SalesDocumentItem
                                                                         and _ItemValuesU.ConditionType = 'JOUG'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesT     on  A.SalesDocument            = _ItemValuesT.SalesDocument
                                                                         and A.SalesDocumentItem        = _ItemValuesT.SalesDocumentItem
                                                                         and _ItemValuesT.ConditionType = 'JTC1'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesrate  on  A.SalesDocument               = _ItemValuesrate.SalesDocument
                                                                         and A.SalesDocumentItem           = _ItemValuesrate.SalesDocumentItem
                                                                         and _ItemValuesrate.ConditionType = 'PPR0'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesDISC  on  A.SalesDocument               = _ItemValuesDISC.SalesDocument
                                                                         and A.SalesDocumentItem           = _ItemValuesDISC.SalesDocumentItem
                                                                         and _ItemValuesDISC.ConditionType = 'DRD1'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesD     on  A.SalesDocument              = _ItemValuesD.SalesDocument
                                                                         and A.SalesDocumentItem          = _ItemValuesD.SalesDocumentItem
                                                                         and (
                                                                            _ItemValuesD.ConditionType    = 'YK07'
                                                                            or _ItemValuesD.ConditionType = 'DM01'
                                                                          )

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesD1    on  A.SalesDocument             = _ItemValuesD1.SalesDocument
                                                                         and A.SalesDocumentItem         = _ItemValuesD1.SalesDocumentItem
                                                                         and _ItemValuesD1.ConditionType = 'YK07'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesD3    on  A.SalesDocument             = _ItemValuesD3.SalesDocument
                                                                         and A.SalesDocumentItem         = _ItemValuesD3.SalesDocumentItem
                                                                         and _ItemValuesD3.ConditionType = 'ZK07'

  association [0..1] to I_SalesDocItemPricingElement as _ItemValuesD2    on  A.SalesDocument             = _ItemValuesD2.SalesDocument
                                                                         and A.SalesDocumentItem         = _ItemValuesD2.SalesDocumentItem
                                                                         and _ItemValuesD2.ConditionType = 'DM01'

  association [0..1] to I_SalesDocItemPricingElement as _freight         on  A.SalesDocument        = _freight.SalesDocument
                                                                         and A.SalesDocumentItem    = _freight.SalesDocumentItem
                                                                         and _freight.ConditionType = 'YBHD'

  association [0..1] to I_SalesDocItemPricingElement as _ins             on  A.SalesDocument     = _ins.SalesDocument
                                                                         and A.SalesDocumentItem = _ins.SalesDocumentItem
                                                                         and _ins.ConditionType  = 'FIN1'

  association [0..1] to I_SalesDocItemPricingElement as _addduty         on  A.SalesDocument        = _addduty.SalesDocument
                                                                         and A.SalesDocumentItem    = _addduty.SalesDocumentItem
                                                                         and _addduty.ConditionType = 'TTX1'

{
  key A.SalesDocument                       as SalesDocument,
      A.SalesDocumentItem                   as SalesDocumentItem,
      A.Plant,
      A.RequestedDeliveryDate,
      _salesorder.PurchaseOrderByCustomer,
      _salesorder.SalesDocApprovalStatus,
      right( _salesorder.CreatedByUser, 10) as CreatedByUser,
      _salesorder.CreatedByUser             as CreatedByUser1,
      A.IncotermsClassification             as DeliveryTerm,
      A.IncotermsLocation1                  as DeliveryTerm1,
      _PaymentTerm.CustomerPaymentTermsName as PaymentTerm,
      _salesorder.TransactionCurrency       as Headercurrency,
      A.SalesDocumentDate                   as SalesOrderDate,
      A.PurchaseOrderByCustomer             as CustomerPONO,
      A.CustomerPurchaseOrderDate           as PODate,
      A.Material                            as Material,
      A.CommittedDeliveryDate               as DeliveryDate,
      _ShipText.ShippingTypeName            as DeliveryMode,
      //      _SDSchedule.DeliveryDate                                                                               as DeliveryDate,
      _DelPriority.DeliveryPriorityDesc     as DeliveryPriority,
      _salesorder.IncotermsClassification   as IncotermsClassification,
      _OrderBy.OrderByName                  as OrderByName,
      _OrderBy.OrderByAddressName           as OrderByAddressName,
      _OrderBy.OrderBySreet1                as OrderBySreet1,
      _OrderBy.OrderByStreet2               as OrderByStreet2,
      _OrderBy.OrderByStreet3               as OrderByStreet3,
      _OrderBy.OrderByCity                  as OrderByCity,
      _OrderBy.OrderByPostalCode            as OrderByPostalCode,
      _OrderBy.OrderByRegionName,
      _OrderBy.OrderByState                 as OrderByState,
      _OrderBy.OrderByPAN                   as OrderByPAN,
      _OrderBy.OrderByFASSAI                as OrderByFASSAI,
      _OrderBy.OrderByGST                   as OrderByGST,
      _ShipBy.ShipToFASSAI                  as ShipToFASSAI,
      _ShipBy.ShipToGST                     as ShipToGST,
      _ShipBy.SPCustomer                    as SPCustomer,
      _ShipBy.ShipToName                    as ShipToName,
      _ShipBy.ShipToAddressName             as ShipToAddressName,
      _ShipBy.ShipToSreet1                  as ShipToSreet1,
      _ShipBy.ShipToStreet2                 as ShipToStreet2,
      _ShipBy.ShipToStreet3                 as ShipToStreet3,
      _ShipBy.ShipToCity                    as ShipToCity,
      _ShipBy.ShipToPostalCode              as ShipToPostalCode,
      _ShipBy.ShiptoRegionName,
      _ShipBy.ShipToState                   as ShipToState,
      _ShipBy.ShipToPAN                     as ShipToPAN,
      A.SalesDocumentItemText               as ProductDiscription,
      @Semantics.quantity.unitOfMeasure: 'UNIT1'
      _productsalesdel.DeliveryQuantity     as deliveryqty,
      _HSN.ConsumptionTaxCtrlCode           as HSNCode,
      _uom.UnitOfMeasure_E                  as UNIT,
      _uomtext.UnitOfMeasureLongName        as unitname,
      A.OrderQuantityUnit                   as UNIT1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesM.ConditionRateAmount      as MRP,
      @Semantics.quantity.unitOfMeasure: 'UNIT1'
      A.OrderQuantity                       as OrderQuantity,
      A.TransactionCurrency                 as TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues.ConditionRateValue        as rate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues.ConditionRateValue        as PPR0r,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues1.ConditionRateValue       as PMP0r,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues2.ConditionRateValue       as ZDEVr,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues.ConditionAmount           as PPR0amt,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues1.ConditionAmount          as PMP0amt,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues2.ConditionAmount          as ZDEVamt,

      @Semantics.amount.currencyCode: 'TransactionCurrency'

      _ItemValues.ConditionAmount           as Amount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesD.ConditionAmount          as Discount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesD1.ConditionAmount * -1    as Discount1,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesD2.ConditionAmount * -1    as Discount2,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesD3.ConditionAmount * -1    as Discount3,

      _ItemValuesC.ConditionRateValue       as CGSTValue,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesC.ConditionAmount          as CGSTRate,

      _ItemValuesC.ConditionRateValue       as SGSTValue,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesC.ConditionAmount          as SGSTRate,

      _ItemValuesU.ConditionRateValue       as UTGSTValue,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesU.ConditionAmount          as UTGSTRate,

      _ItemValuesI.ConditionRateValue       as IGSTValue,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _freight.ConditionAmount              as freight,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ins.ConditionAmount                  as insuarance,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesI.ConditionAmount          as IGSTRate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesT.ConditionAmount          as TCSAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ItemValuesDISC.ConditionAmount       as Roundoff,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _addduty.ConditionAmount              as adddutyvalue

}
where
      _HSN.ConsumptionTaxCtrlCode <> ' '
  and _OrderBy.OrderByName        <> ' '
  and _ShipBy.ShipToName          <> ' '
