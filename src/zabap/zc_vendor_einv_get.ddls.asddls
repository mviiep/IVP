@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor E-Invoice Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true 
define root view entity ZC_VENDOR_EINV_GET
//provider contract transactional_query
  as projection on ZVendor_EInvoice_Get
{
  key Id,
  key ItemSlno,
      AckNo,
      AckDt,
      Irn,
      TaxSch,
      SupTyp,
      RegRev,
      IgstOnIntra,
      DocType,
      DocNo,
      @Consumption.filter.mandatory: true
      @EndUserText.label: 'Document Date'
      @Search.defaultSearchElement: true
      @UI:{ selectionField: [{ position: 04 }]}
      DocDate,
      SupplGstin,
      SupplLegalName,
      SupplAddr,
      SupplLoc,
      SupplPincode,
      SupplStcd,
      CustGstin,
      CustLegalName,
      CustPos,
      CustAddr,
      CustLoc,
      CustPincode,
      CustStcd,
      ItemItemno,
//      ItemSlno,
      ItemIsservc,
      ItemProddesc,
      ItemHsnCode,
      ItemUnit,
      ItemQty,

      ItemFreeQty,
//      ItemCurrency,
      ItemUnitprice,
      ItemTotAmt,

      ItemDiscount,

      ItemAssamt,
      ItemGstRate,

      ItemIgstAmt,

      ItemCgstAmt,

      ItemSgstAmt,
      ItemCessRate,

      ItemCessAmt,

      ItemCessNonAdvlAmt,

      ItemTotItemVal,

      Assval,

      Cgstval,

      Sgstval,

      Igstval,

      Cessval,

      Discount,

      OtherChrg,

      RoundoffVal,

      TotinvVal
}
