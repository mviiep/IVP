@AbapCatalog.sqlViewName: 'ZZI_DPR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface  CDS view for DPR Report'
define root view ZI_DPR  
  as select distinct from    I_MfgOrderConfirmation as a
    left outer join I_WorkCenter           as b on a.WorkCenterInternalID = b.WorkCenterInternalID
    left outer join I_ManufacturingOrder   as d on  a.ManufacturingOrder     = d.ManufacturingOrder
                                                and a.ManufacturingOrderType = d.ManufacturingOrderType
  //    left outer join I_MfgOrderActlPlanTgtLdgrCost(P_FromFiscalYearPeriod: '2024001', P_ToFiscalYearPeriod: '9999012',
  //                    P_Ledger: '0L',P_CurrencyRole: '10', P_TargetCostVariant: '0') as b on a.ManufacturingOrder = b.OrderID
    left outer join ztb_resource_cap       as c on b.WorkCenter = c.resrce
    left outer join ZI_PrdAcheived_DPR     as e on  a.ManufacturingOrder = e.ManufacturingOrder
                                                and e.GoodsMovementType  = '101'
//*******************
left outer join I_MaterialDocumentItem_2 as s on a.ManufacturingOrder = s.ManufacturingOrder 
                                              and s.GoodsMovementType = '101' 
                                           
                                                
                                          
 left outer join  I_MaterialDocumentItem_2 as x on s.ManufacturingOrder = x.ManufacturingOrder
                                             and s.Batch = x.Batch
                                             and x.GoodsMovementType = '261'
                                             
 left outer join  I_MaterialDocumentItem_2 as z on x.Material = z.Material
                                           and      x.Batch = z.Batch
                                           and   z.GoodsMovementType = '101'                                           

                                                
left outer join I_MfgOrderConfirmation  as w on z.ManufacturingOrder = w.ManufacturingOrder 
                                               

left outer join I_WorkCenter as r on w.WorkCenterInternalID = r.WorkCenterInternalID
left outer join ztb_resource_cap as U on a.Plant = U.plant
                                       and r.WorkCenter = U.resrce

{
  key ltrim(a.ManufacturingOrder,'0')                                                                  as ManufacturingOrder,
  key a.Plant,
  key a.ManufacturingOrderType,
  key a.PostingDate,

      ltrim(d.Material,'0')                                                                            as material,
      d.ManufacturingOrderText,
      a.ProductionUnit,
      a.ConfYieldQtyInProductionUnit                                                                   as test,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      //      case
      //      when e.QuantityInBaseUnit < 1
      //      then a.ConfYieldQtyInProductionUnit
      //      else
      a.ConfYieldQtyInProductionUnit  - coalesce(e.QuantityInBaseUnit,0 )                              as ConfYieldQtyInProductionUnit,
      e.QuantityInBaseUnit,
      a.ConfirmationText,
      b.WorkCenter,
      c.design_cap,
      ( cast(a.ConfYieldQtyInProductionUnit as abap.fltp) / cast(c.design_cap as abap.fltp) ) * 100.00 as ActualAchieved,
      s.Batch,
      x.Material as Mat,
      x.Batch as Disb,
      z.OrderID,
      w.WorkCenterInternalID,
      r.WorkCenter as zyata,
      U.design_cap as Capcity 
}
where
      a.IsReversal           = ''
  and a.IsReversed           = ''
  and a.MilestoneIsConfirmed = ''
  
