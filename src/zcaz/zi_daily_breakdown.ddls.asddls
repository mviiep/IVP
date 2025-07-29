@AbapCatalog.sqlViewName: 'ZZI_DAILY_BRKDWN'
//@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for daily breakdown report'
define view ZI_DAILY_Breakdown
  as select from I_ManufacturingOrder as a
  association [0..1] to I_MfgOrderConfirmation        as b                            on  a.ManufacturingOrder = b.ManufacturingOrder
                                                                                      and b.IsReversal         = ''
                                                                                      and b.IsReversed         = ''
  //  association [0..1] to I_MfgOrderConfirmation        as _MfgOrderConfirmationtext    on  a.ManufacturingOrder                 = _MfgOrderConfirmationtext.ManufacturingOrder
  //
  //  association [0..1] to ZI_PLant_SR                   as _plant                       on  $projection.plant = _plant.Plant
  association [0..1] to I_MfgOrderActlPlanTgtLdgrCost as _MFGORDERACTLPLANTGTLDGRCOST on  a.ManufacturingOrder                        =  _MFGORDERACTLPLANTGTLDGRCOST.OrderID
                                                                                      and a.Material                                  =  _MFGORDERACTLPLANTGTLDGRCOST.Product
                                                                                      and _MFGORDERACTLPLANTGTLDGRCOST.OrderOperation <> ''
{
  key   ltrim( a.ManufacturingOrder, '0') as ProcessOrder,
  key   b.ConfirmationText                as ConfirmationText,
  key   b.Plant                           as plant,
  key   b.PostingDate                     as datep,
  key   a.ManufacturingOrderType          as OrderType,
  key   b.ConfirmedExecutionStartDate,
  key   b.ConfirmedExecutionEndDate,
  key   b.ConfirmedExecutionStartTime,
  key   b.ConfirmedExecutionEndTime,
        a.Batch,
        a.Product,
        a._MaterialText[ Language = 'E' ].ProductName as productname,
        b.MilestoneIsConfirmed,
        b.WorkCenterInternalID            as WorkCenter,
        b.ConfirmedBreakDuration          as MaintainanceHours,
        b.ConfirmedBreakDuration
}
//where
//       b.ManufacturingOrderOperation_2 = '0020'
//  and(
//     a.ManufacturingOrderType = 'ZS01'
//  or a.ManufacturingOrderType = 'ZS02'
//  or a.ManufacturingOrderType = 'ZS03'
//  or a.ManufacturingOrderType = 'ZS04'
//  )
