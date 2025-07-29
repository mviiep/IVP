@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For FI PO Master Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FIPO_MASTER
  as select from I_SuplrInvcItemPurOrdRefAPI01 as SupplierInvoicePORef
  association [0..1] to I_PurchaseOrderAPI01           as POAPI01        on  SupplierInvoicePORef.PurchaseOrder = POAPI01.PurchaseOrder
  association [1]    to I_PurchaseOrderItemAPI01       as POItemAPI01    on  SupplierInvoicePORef.PurchaseOrder     = POItemAPI01.PurchaseOrder
                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemAPI01.PurchaseOrderItem
  association [0..1] to I_ProductPlantIntlTrd          as ProductPlant   on  SupplierInvoicePORef.PurchaseOrderItemMaterial = ProductPlant.Product
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing  on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing.PurchaseOrder
                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing.PurchaseOrderItem
                                                                         and POItemPricing.ConditionType            = 'PMP0'
                                                                         or  POItemPricing.ConditionType            = 'PPR0'
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing1 on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing1.PurchaseOrder
                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing1.PurchaseOrderItem
                                                                         and POItemPricing1.ConditionType           = 'DL01'
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing2 on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing2.PurchaseOrder
                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing2.PurchaseOrderItem
                                                                         and POItemPricing2.ConditionType           = 'ZCES'
  association [0..1] to ZI_FI_JOURNALENTRYITEM         as JournalItem    on  JournalItem.ReferenceDocumentMIRO = SupplierInvoicePORef.SupplierInvoice
                                                                         and JournalItem.ReferenceDocumentItem = SupplierInvoicePORef.SupplierInvoiceItem
                                                                         and JournalItem.FiscalYear            = SupplierInvoicePORef.FiscalYear
{
  key SupplierInvoicePORef.SupplierInvoice             as SupplierInvoice,
  key SupplierInvoicePORef.SupplierInvoiceItem         as SupplierInvoiceItem,
  key SupplierInvoicePORef.PurchaseOrder               as PurchaseOrder,
  key SupplierInvoicePORef.FiscalYear                  as FiscalYear,
  key SupplierInvoicePORef.PurchaseOrderItem           as PurchaseOrderItem,
  key SupplierInvoicePORef.PurchaseOrderItemMaterial   as PurchaseOrderItemMaterial,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      SupplierInvoicePORef.QuantityInPurchaseOrderUnit as QuantityInPurchaseOrderUnit,
      POAPI01.PurchasingGroup                          as PurchasingGroup,
      POItemAPI01.PurchaseOrderItemText                as PurchaseOrderItemText,
      POItemAPI01.BaseUnit                             as BaseUnit,
      ProductPlant.ConsumptionTaxCtrlCode              as ConsumptionTaxCtrlCode,
      POAPI01.PurchaseOrderDate                        as PurchaseOrderDate,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      POItemAPI01.OrderQuantity                        as OrderQuantity,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POItemAPI01.NetPriceAmount                       as NetPriceAmount,
      SupplierInvoicePORef.DocumentCurrency            as DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      SupplierInvoicePORef.SupplierInvoiceItemAmount   as SupplierInvoiceItemAmount,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      POItemPricing.ConditionAmount                    as ConditionAmount,
      POItemPricing1.ConditionRateValue                as ConditionRateValue,
      SupplierInvoicePORef.TaxCode                     as TaxCode,
      POItemPricing2.ConditionRateValue                as ConditionRateValueC,
      SupplierInvoicePORef.ReferenceDocument           as ReferenceDocument,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      JournalItem.BaseAmount                           as BaseAmount,
      case
      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.14)
        end                                            as SGST,
      case
      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.14)
       end                                             as CGST,
      case
      when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
        or JournalItem.TaxCode = 'C5' or JournalItem.TaxCode = 'D5'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.03)
      when JournalItem.TaxCode = 'G6' or JournalItem.TaxCode = 'H5'
        or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
        or JournalItem.TaxCode = 'C6' or JournalItem.TaxCode = 'D6'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'G7' or JournalItem.TaxCode = 'H6'
        or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
        or JournalItem.TaxCode = 'C7' or JournalItem.TaxCode = 'D7'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'G8' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'G9' or JournalItem.TaxCode = 'H8'
        or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
        or JournalItem.TaxCode = 'C8' or JournalItem.TaxCode = 'D8'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'A9' or JournalItem.TaxCode = 'B9'
        or JournalItem.TaxCode = 'C9' or JournalItem.TaxCode = 'D9'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.28)
        end                                            as IGST,

      case
      when JournalItem.TaxCode = 'R0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.14)
        end                                            as RSGST,
      case
      when JournalItem.TaxCode = 'R0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.14)
       end                                             as RCGST,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.03)
      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'R9'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount  as abap.fltp)*0.28)
        end                                            as RIGST
}
