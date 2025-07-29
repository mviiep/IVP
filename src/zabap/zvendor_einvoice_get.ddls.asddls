@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor E-Invoice 11.01.2024 ANurag'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true 
define root view entity ZVendor_EInvoice_Get
  as select from zvendor_einv_tab
{
  key id                     as Id,
  key item_slno              as ItemSlno,
      ack_no                 as AckNo,
      ack_dt                 as AckDt,
      irn                    as Irn,
      tax_sch                as TaxSch,
      sup_typ                as SupTyp,
      reg_rev                as RegRev,
      igst_on_intra          as IgstOnIntra,
      doc_type               as DocType,
      doc_no                 as DocNo,
      doc_date as DocDate,
      suppl_gstin            as SupplGstin,
      suppl_legal_name       as SupplLegalName,
      suppl_addr             as SupplAddr,
      suppl_loc              as SupplLoc,
      suppl_pincode          as SupplPincode,
      suppl_stcd             as SupplStcd,
      cust_gstin             as CustGstin,
      cust_legal_name        as CustLegalName,
      cust_pos               as CustPos,
      cust_addr              as CustAddr,
      cust_loc               as CustLoc,
      cust_pincode           as CustPincode,
      cust_stcd              as CustStcd,
      item_itemno            as ItemItemno,
//      item_slno              as ItemSlno,
      item_isservc           as ItemIsservc,
      item_proddesc          as ItemProddesc,
      item_hsn_code          as ItemHsnCode,
      item_unit              as ItemUnit,

      item_qty               as ItemQty,

      item_free_qty          as ItemFreeQty,
//      item_currency          as ItemCurrency,

      item_unitprice         as ItemUnitprice,

      item_tot_amt           as ItemTotAmt,

      item_discount          as ItemDiscount,

      item_assamt            as ItemAssamt,
      item_gst_rate          as ItemGstRate,

      item_igst_amt          as ItemIgstAmt,

      item_cgst_amt          as ItemCgstAmt,

      item_sgst_amt          as ItemSgstAmt,
      item_cess_rate         as ItemCessRate,

      item_cess_amt          as ItemCessAmt,

      item_cess_non_advl_amt as ItemCessNonAdvlAmt,

      item_tot_item_val      as ItemTotItemVal,

      assval                 as Assval,

      cgstval                as Cgstval,

      sgstval                as Sgstval,

      igstval                as Igstval,

      cessval                as Cessval,

      discount               as Discount,

      other_chrg             as OtherChrg,

      roundoff_val           as RoundoffVal,

      totinv_val             as TotinvVal
}
