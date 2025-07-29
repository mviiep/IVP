@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zexim report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zrpt_exim_report
  as select distinct from ZEXI_EXPORT_SHIP_DT as SHIP

  association [0..1] to ZEXI_EXPORT_DOC_DT    as doc_dt    on SHIP.ID = doc_dt.ID

  association [0..1] to ZEXI_EXPORT_DOC_ITEM  as DOC_ITEM  on SHIP.ID = DOC_ITEM.ID

  association [0..1] to ZEXI_EXPORT_DBK_DT    as dbk_dt    on SHIP.ID = dbk_dt.ID

  association [0..1] to ZEXI_EXPORT_RODTEP_DT as rodtep_dt on SHIP.ID = rodtep_dt.ID

  association [0..1] to ZRPT_EXIM_MASTER      as master    on SHIP.ID = master.id


{

  key SHIP.ID                    as id,
      doc_dt.ModbillDate         as modbilldate,
      doc_dt.BillingDate         as BILLINGDATE,
      SHIP.ShipBillingDate       as shipbillingdate,
      SHIP.ShipBillingNo         as shipbillingno,
      SHIP.shipbldate            as bldate,
      SHIP.shipblno              as blno,
      SHIP.shipairbillno         as airno,
      SHIP.shipairbilldate       as airdate,
      SHIP.shipportofloading     as portloading,
      SHIP.shipportofloadingcode as portloadingcode,
      SHIP.shipplaceofreceipt    as placereceipt,
      SHIP.shipdestcountry       as destcountry,
      SHIP.shipcountryoforgin    as countryorigin,
      SHIP.shipportofdischarge   as portdischarge,
      SHIP.shipprecarriageby     as shipprecarriage,
      SHIP.shiptransporter       as shiptransporter,
      master.materialdescription as materialdescription,
      doc_dt.Quantity            as quantity,
      SHIP.ShipmentType          as shipmenttype,
      SHIP.ConvertInvoiceAmount  as invoiceamt,
      SHIP.ConvertFobValue       as convertfobvalue,
      master.dbkrate             as dbkrate,
      dbk_dt.EligibleDBKAmount   as eligibleamt,
      SHIP.DbkAmountReceived     as dbkamountrecd,
      master.rodrate             as rodtaperate,
      SHIP.RodtepAmountReceived  as rodtaperecd,
      rodtep_dt.rodtepamt        as rodamount,
      SHIP.ConvertDiscountAmount       as gstamount,
      SHIP.ConvertCommisionAmount      as taxableamount   
   
    
}
