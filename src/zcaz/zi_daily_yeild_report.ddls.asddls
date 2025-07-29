@AbapCatalog.sqlViewName: 'ZZI_YEILD_REP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Daily Yeild Report'
define view ZI_DAILY_YEILD_REPORT
  as select distinct from I_ManufacturingOrder as A
  association [0..1] to I_ManufacturingOrderItem      as b                             on  A.ManufacturingOrder = b.ManufacturingOrder
  association [0..1] to I_MaterialDocumentItem_2      as _batch                        on  A.ManufacturingOrder     = _batch.OrderID
                                                                                       and _batch.GoodsMovementType = '101'
  association [0..1] to I_MfgOrderActlPlanTgtLdgrCost as _MFGORDERACTLPLANTGTLDGRCOST1 on  A.ManufacturingOrder                         =  _MFGORDERACTLPLANTGTLDGRCOST1.OrderID
                                                                                       and A.Material                                   =  _MFGORDERACTLPLANTGTLDGRCOST1.Product
                                                                                       and _MFGORDERACTLPLANTGTLDGRCOST1.OrderOperation <> ''
  association [0..1] to I_MfgOrderActlPlanTgtLdgrCost as _MFGORDERACTLPLANTGTLDGRCOST  on  A.ManufacturingOrder                        =  _MFGORDERACTLPLANTGTLDGRCOST.OrderID
  //                                                                                      and A.Material                                  =  _MFGORDERACTLPLANTGTLDGRCOST.Product
                                                                                       and _MFGORDERACTLPLANTGTLDGRCOST.OrderOperation <> ''
  association [0..1] to I_BillOfMaterialWithKeyDate   as _altrntvtext                  on  _altrntvtext.BillOfMaterial             = A.BillOfMaterialInternalID
                                                                                       and _altrntvtext.BillOfMaterialVariantUsage = '1'
  association [0..1] to I_MfgOrderOperationComponent  as _MFGORDEROPERATIONCOMPONENT   on  A.ManufacturingOrder                          = _MFGORDEROPERATIONCOMPONENT.ManufacturingOrder
                                                                                       and _MFGORDEROPERATIONCOMPONENT.GoodsMovementType = '261'
  association [0..1] to ZI_YIELD_OutputQty            as _OPqty                        on  A.ManufacturingOrder = _OPqty.processorder
                                                                                       and _OPqty.MovementType  = '101'
  association [0..1] to I_Product                     as _product                      on  A.Product = _product.Product
  association [0..1] to I_ProductText                 as _prdtext                      on  A.Product         = _prdtext.Product
                                                                                       and _prdtext.Language = 'E'
  association [0..1] to I_InspectionLot               as _inspectionlot                on  A.ManufacturingOrder = _inspectionlot.ManufacturingOrder
  association [0..1] to I_MfgOrderEvtBsdWIPVariance   as _variance                     on  A.ManufacturingOrder = _variance.OrderID
  association [0..1] to ZI_POINPUTQTY_YIELD           as _poinpuqty                    on  A.ManufacturingOrder         = _poinpuqty.ManufacturingOrder
                                                                                       and _poinpuqty.GoodsMovementType = '261'
{
  key A.ManufacturingOrder                                                                                              as ProcessOrder,
      b.MfgOrderItemPlannedTotalQty                                                                                     as totqty,
      A.ProductionPlant                                                                                                 as Plant,
      A.ManufacturingOrderType                                                                                          as OrderType,
      A.Product                                                                                                         as Product,
      _prdtext.ProductName                                                                                              as ProductName,
      //      cast( b.MfgOrderItemPlannedTotalQty as abap.fltp) * cast(cast(cast( _altrntvtext(P_KeyDate: '20240701').BOMAlternativeText as abap.sstring( 15 )) as abap.numc( 15 )) as abap.fltp) as standardinputqnty,
      b.MfgOrderItemPlannedTotalQty                                                                                     as standardinputqnty1,
      _altrntvtext(P_KeyDate: '20240701').BOMAlternativeText                                                            as standardinputqnty2,
      _batch.Batch                                                                                                      as Batch,
      A._Batch_2.ManufactureDate                                                                                        as manufacturedate,
      _MFGORDERACTLPLANTGTLDGRCOST1(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
              P_Ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').WorkCenter                                 as WorkCenter,
      //      _altrntvtext(P_KeyDate: '20240701').BOMAlternativeText                                                                                                                                      as StandardInputqty,
      _MFGORDEROPERATIONCOMPONENT.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      sum( _MFGORDEROPERATIONCOMPONENT.GoodsMovementEntryQty )                                                          as processorderinputqty,
      _poinpuqty.POinputqty                                                                                             as poinputqty,
      _OPqty.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      cast(_OPqty.Qnty  as abap.dec( 10, 2 ))                                                                           as OutputQuantity,
      _product.SizeOrDimensionText                                                                                      as ExpectedYeild,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //      //      fltp_to_dec (  PO_Master.SGST as abap.dec(16,4))
      ( cast(_OPqty.Qnty  as abap.fltp) / cast(sum( _MFGORDEROPERATIONCOMPONENT.GoodsMovementEntryQty ) as abap.fltp) ) as Actualyield,

      _inspectionlot._InspLotUsageDecision._UsageDecisionCode.UsageDecisionCodeText                                     as UsageDecision,

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      _MFGORDERACTLPLANTGTLDGRCOST(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
        P_Ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').DebitPlanCostInDspCrcy                           as PlantCost,

      @Semantics.amount.currencyCode: 'DisplayCurrency'
      _MFGORDERACTLPLANTGTLDGRCOST(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
      P_ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').DebitActlCostInDspCrcy                             as ActualCost,

      @Semantics.currencyCode: true
      _variance(P_Ledger: '0L', P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
                P_CurrencyRole: '10'  ).DisplayCurrency

}
group by
  A.ManufacturingOrder,
  A.ProductionPlant,
  A.ManufacturingOrderType,
  A.Product,
  _poinpuqty.POinputqty,
  b.MfgOrderItemPlannedTotalQty,
  _prdtext.ProductName,
  _batch.Batch,
  _OPqty.MaterialBaseUnit,
  _MFGORDEROPERATIONCOMPONENT.EntryUnit,
  A._Batch_2.ManufactureDate,
  _variance(P_Ledger: '0L', P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
                P_CurrencyRole: '10'  ).DisplayCurrency,
  _MFGORDERACTLPLANTGTLDGRCOST1(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
                P_Ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').WorkCenter,
  _altrntvtext(P_KeyDate: '20240701').BOMAlternativeText,
  _OPqty.Qnty,
  _product.SizeOrDimensionText,
  _inspectionlot._InspLotUsageDecision._UsageDecisionCode.UsageDecisionCodeText,
  _MFGORDERACTLPLANTGTLDGRCOST(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
        P_Ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').DebitPlanCostInDspCrcy,
  _MFGORDERACTLPLANTGTLDGRCOST(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
             P_ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0').DebitActlCostInDspCrcy
