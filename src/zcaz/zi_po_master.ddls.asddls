@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For PO Master Details in Pur Reg'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_MASTER
  as select from I_SuplrInvcItemPurOrdRefAPI01 as SupplierInvoicePORef
  association [0..1] to I_PurchaseOrderAPI01           as POAPI01        on  SupplierInvoicePORef.PurchaseOrder = POAPI01.PurchaseOrder
  
  association [1]    to I_PurchaseOrderItemAPI01       as POItemAPI01    on  SupplierInvoicePORef.PurchaseOrder     = POItemAPI01.PurchaseOrder
                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemAPI01.PurchaseOrderItem
                                                                         
  association [0..1] to I_ProductPlantIntlTrd          as ProductPlant   on  SupplierInvoicePORef.PurchaseOrderItemMaterial =  ProductPlant.Product
                                                                         and SupplierInvoicePORef.Plant                     =  ProductPlant.Plant
                                                                         and ProductPlant.ConsumptionTaxCtrlCode            <> ''

  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing.PurchaseOrder
                                                                        and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing.PurchaseOrderItem
                                                                        and POItemPricing.ConditionType            = 'PMP0'
                                                                        and POItemPricing.ConditionType            = 'PPR0'
                                                                        and POItemPricing.ConditionType            = 'DL01'
                                                                        and POItemPricing.ConditionType            = 'ZCES'
                                                                        
//  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing1 on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing1.PurchaseOrder
//                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing1.PurchaseOrderItem
//                                                                         and POItemPricing1.ConditionType           = 'DL01'
//  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing2 on  SupplierInvoicePORef.PurchaseOrder     = POItemPricing2.PurchaseOrder
//                                                                         and SupplierInvoicePORef.PurchaseOrderItem = POItemPricing2.PurchaseOrderItem
//                                                                         and POItemPricing2.ConditionType           = 'ZCES'
                                                                         
  association [0..1] to ZI_JOURNALENTRYITEM2           as JournalItem    on  JournalItem.ReferenceDocumentMIRO = SupplierInvoicePORef.SupplierInvoice
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
      // POItemAPI01.
      ProductPlant.ConsumptionTaxCtrlCode              as ConsumptionTaxCtrlCode,
      POAPI01.PurchaseOrderDate                        as PurchaseOrderDate,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      POItemAPI01.OrderQuantity                        as OrderQuantity,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      case when SupplierInvoicePORef.PurchaseOrder is not initial
      then
      POItemAPI01.NetPriceAmount                     //  as NetPriceAmount,
 else
// @Semantics.amount.currencyCode: 'DocumentCurrency'
JournalItem.amcomp  end as NetPriceAmount,
// JournalItem.net_amt  end as NetPriceAmount,
      SupplierInvoicePORef.DocumentCurrency            as DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      SupplierInvoicePORef.SupplierInvoiceItemAmount   as SupplierInvoiceItemAmount,

      JournalItem.BusinessArea                         as BusinessArea,
   //  JournalItem.
      JournalItem.doctype                              as Doctype,
    //  JournalItem.plant                                as Plant,
    SupplierInvoicePORef.Plant                        as plant,
      JournalItem.Trans_type                           as Trans_Key,
      JournalItem.IGST_GL                              as IGST_GL,
      JournalItem.CGST_GL                              as CGST_GL,
      JournalItem.SGST_GL                              as SGST_GL,

      @Semantics.amount.currencyCode: 'DocumentCurrency'
      JournalItem.Tot_Invoice                          as Tot_Inv,
      JournalItem.GlCode                               as GL_Code,
//      JournalItem.
      //  SupplierInvoicePORef.
      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      //      POItemPricing.ConditionAmount                    as ConditionAmount,
      //      POItemPricing1.ConditionRateValue                as ConditionRateValue,
      SupplierInvoicePORef.TaxCode                     as TaxCode,
      //      POItemPricing2.ConditionRateValue                as ConditionRateValueC,
      SupplierInvoicePORef.ReferenceDocument           as ReferenceDocument,
//      JournalItem.companycodecurrency as ccc,

JournalItem.ccc as com_code_curr,
      case
      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      // tax calculation
       when SupplierInvoicePORef.TaxCode = 'AA'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
       when SupplierInvoicePORef.TaxCode = 'AB'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
       when SupplierInvoicePORef.TaxCode = 'AC'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
       when SupplierInvoicePORef.TaxCode = 'AD' or SupplierInvoicePORef.TaxCode = 'G4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
       when SupplierInvoicePORef.TaxCode = 'AE'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
        end                                            as SGST,
      case
      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      // tax calculation
       when SupplierInvoicePORef.TaxCode = 'AA'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
       when SupplierInvoicePORef.TaxCode = 'AB'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
       when SupplierInvoicePORef.TaxCode = 'AC'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
       when SupplierInvoicePORef.TaxCode = 'AD' or SupplierInvoicePORef.TaxCode = 'G4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
       when SupplierInvoicePORef.TaxCode = 'AE'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
       end                                             as CGST,
      case
      when SupplierInvoicePORef.TaxCode = 'A5' or SupplierInvoicePORef.TaxCode = 'B5'
        or SupplierInvoicePORef.TaxCode = 'C5' or SupplierInvoicePORef.TaxCode = 'D5'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      when SupplierInvoicePORef.TaxCode = 'G6' or SupplierInvoicePORef.TaxCode = 'H5'
        or SupplierInvoicePORef.TaxCode = 'A6' or SupplierInvoicePORef.TaxCode = 'B6'
        or SupplierInvoicePORef.TaxCode = 'C6' or SupplierInvoicePORef.TaxCode = 'D6'
        or SupplierInvoicePORef.TaxCode = 'BA' or SupplierInvoicePORef.TaxCode = 'BH'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      when SupplierInvoicePORef.TaxCode = 'G7' or SupplierInvoicePORef.TaxCode = 'H6'
        or SupplierInvoicePORef.TaxCode = 'A7' or SupplierInvoicePORef.TaxCode = 'B7'
        or SupplierInvoicePORef.TaxCode = 'C7' or SupplierInvoicePORef.TaxCode = 'D7'
        or SupplierInvoicePORef.TaxCode = 'BB'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      when SupplierInvoicePORef.TaxCode = 'G8' or SupplierInvoicePORef.TaxCode = 'H7'
        or SupplierInvoicePORef.TaxCode = 'G9' or SupplierInvoicePORef.TaxCode = 'H8'
        or SupplierInvoicePORef.TaxCode = 'A8' or SupplierInvoicePORef.TaxCode = 'B8'
        or SupplierInvoicePORef.TaxCode = 'C8' or SupplierInvoicePORef.TaxCode = 'D8'
        or SupplierInvoicePORef.TaxCode = 'BC' or SupplierInvoicePORef.TaxCode = 'BL'
        or SupplierInvoicePORef.TaxCode = 'E1' or SupplierInvoicePORef.TaxCode = 'E2'
        or SupplierInvoicePORef.TaxCode = 'E3' or SupplierInvoicePORef.TaxCode = 'F3'
        or SupplierInvoicePORef.TaxCode = 'IS'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      when SupplierInvoicePORef.TaxCode = 'A9' or SupplierInvoicePORef.TaxCode = 'B9'
        or SupplierInvoicePORef.TaxCode = 'C9' or SupplierInvoicePORef.TaxCode = 'D9'
        or SupplierInvoicePORef.TaxCode = 'BD'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
        end                                            as IGST,

      case
      when JournalItem.TaxCode = 'R0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
        end                                            as RSGST,
      case
      when JournalItem.TaxCode = 'R0'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
       end                                             as RCGST,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'R9'
       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
        end                                            as RIGST

      //            case
      //            when JournalItem.TaxCode = 'AA'
      //            then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      //            when JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'AH'
      //            or JournalItem.TaxCode = 'AK'
      //            then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      //            when JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'AI'
      //            then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      //            when JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'AJ'
      //            then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      //            when JournalItem.TaxCode = 'AE'
      //            then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
      //            end                                        as SGST,
      //
      //      case
      //      when JournalItem.TaxCode = 'AA'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      //      when JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'AH'
      //      or JournalItem.TaxCode = 'AK'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      //      when JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'AI'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      //      when JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'AJ'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      //      when JournalItem.TaxCode = 'AE'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
      //      end                                              as CGST,


      //      case
      //      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
      //        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
      //        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
      //        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
      //        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
      //        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      //        end                                            as SGST,
      //
      //      case
      //      when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0'
      //        or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'D0'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      //      when JournalItem.TaxCode = 'G2' or JournalItem.TaxCode = 'H1'
      //        or JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'B1'
      //        or JournalItem.TaxCode = 'C1' or JournalItem.TaxCode = 'D1'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'G3' or JournalItem.TaxCode = 'H2'
      //        or JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'B2'
      //        or JournalItem.TaxCode = 'C2' or JournalItem.TaxCode = 'D2'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'H3'
      //        or JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'B3'
      //        or JournalItem.TaxCode = 'C3' or JournalItem.TaxCode = 'D3'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'G5' or JournalItem.TaxCode = 'H4'
      //        or JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'B4'
      //        or JournalItem.TaxCode = 'C4' or JournalItem.TaxCode = 'D4'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      //       end                                             as CGST,
      //      case
      //      when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'B5'
      //        or JournalItem.TaxCode = 'C5' or JournalItem.TaxCode = 'D5'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      //      when JournalItem.TaxCode = 'G6' or JournalItem.TaxCode = 'H5'
      //        or JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'B6'
      //        or JournalItem.TaxCode = 'C6' or JournalItem.TaxCode = 'D6'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      //      when JournalItem.TaxCode = 'G7' or JournalItem.TaxCode = 'H6'
      //        or JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'B7'
      //        or JournalItem.TaxCode = 'C7' or JournalItem.TaxCode = 'D7'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      //      when JournalItem.TaxCode = 'G8' or JournalItem.TaxCode = 'H7'
      //        or JournalItem.TaxCode = 'G9' or JournalItem.TaxCode = 'H8'
      //        or JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'B8'
      //        or JournalItem.TaxCode = 'C8' or JournalItem.TaxCode = 'D8'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      //      when JournalItem.TaxCode = 'A9' or JournalItem.TaxCode = 'B9'
      //        or JournalItem.TaxCode = 'C9' or JournalItem.TaxCode = 'D9'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
      //        end                                            as IGST,
      //
      //      case
      //      when JournalItem.TaxCode = 'R0'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      //      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      //        end                                            as RSGST,
      //      case
      //      when JournalItem.TaxCode = 'R0'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.015)
      //      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.025)
      //      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.06)
      //      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.09)
      //      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      //      then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.14)
      //       end                                             as RCGST,
      //      case
      //      when JournalItem.TaxCode = 'R5'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.03)
      //      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.05)
      //      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.12)
      //      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
      //        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.18)
      //      when JournalItem.TaxCode = 'R9'
      //       then (cast(SupplierInvoicePORef.SupplierInvoiceItemAmount as abap.fltp)*0.28)
      //        end                                            as RIGST
}


group by
  SupplierInvoicePORef.SupplierInvoice,
  SupplierInvoiceItem,
  SupplierInvoicePORef.PurchaseOrder,
  SupplierInvoicePORef.FiscalYear,
  SupplierInvoicePORef.PurchaseOrderItem,
  PurchaseOrderItemMaterial,
  SupplierInvoicePORef.QuantityInPurchaseOrderUnit,
  POAPI01.PurchasingGroup,
  POItemAPI01.BaseUnit,
  ProductPlant.ConsumptionTaxCtrlCode,
  POAPI01.PurchaseOrderDate,
  POItemAPI01.OrderQuantity,
  POItemAPI01.NetPriceAmount,
  SupplierInvoicePORef.DocumentCurrency,
  SupplierInvoicePORef.SupplierInvoiceItemAmount,
  //  POItemPricing1.ConditionRateValue,
  SupplierInvoicePORef.TaxCode,
  SupplierInvoicePORef.ReferenceDocument,
  JournalItem.TaxCode,
  JournalItem.BusinessArea,
  JournalItem.doctype,
 // JournalItem.plant,
  SupplierInvoicePORef.Plant,
  JournalItem.Tot_Invoice,
  POItemAPI01.PurchaseOrderItemText,
  POItemPricing.ConditionAmount,
  JournalItem.GlCode,
  JournalItem.Trans_type,
  JournalItem.CGST_GL,
  JournalItem.SGST_GL,
  JournalItem.IGST_GL,
  JournalItem.ccc,
  JournalItem.amcomp
//  POItemPricing2.ConditionRateValue
