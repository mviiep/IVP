//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Quotation Price Details'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HDLR_SUPP_QUOTES'

define root custom entity ZI_DD_SUPQTPRICE
  //    as select from I_SupplierQuotationItem_Api01 as a
  //
  //    left outer join I_SupplierQuotationPrcElmntTP  as a
  //    inner join I_PurchaseOrderAPI01 as _po on _po.PurchaseOrder = a.SupplierQuotation
  //    left outer join I_SLSPRCGCONDITIONRECORD as b on b.ConditionRecord = _po.condi
  //                                                and b.PurchasingDocumentItem = a.SupplierQuotationItem
  //    association to parent zi_dd_quotcomp_sup as b on b.SupplierQuotation = a.SupplierQuotation
  //                                                 and b.SupplierQuotationItem = a.SupplierQuotationItem
  //    association[1..*] to I_SupplierQuotationPrcElmnttp as _b on _b.SupplierQuotation = a.SupplierQuotation
  //                                                            and _b.SupplierQuotationItem = a.SupplierQuotationItem
{
      @EndUserText.label      : 'Request For Quotation'
  key RequestForQuotation     : ebeln;
      @EndUserText.label      : 'Request For Quotation Item'
  key RequestForQuotationItem : ebelp;

      @EndUserText.label      : 'Supplier Quotation'
  key SupplierQuotation       : ebeln;
      @EndUserText.label      : 'Supplier Quotation Item'
  key SupplierQuotationItem   : ebelp;


      @EndUserText.label      : 'Supplier'
      Supplier                : lifnr;
      @EndUserText.label      : 'Supplier Name'
      SupplierName            : abap.char(80);
      @EndUserText.label      : 'Plant'
      Plant                   : werks_d;

      @Semantics.quantity.unitOfMeasure: 'UOM'
      @EndUserText.label      : 'Requested Quantity'
      RequestedQuantity       : abap.quan(12,2);
      @EndUserText.label      : 'Quotation Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      QuotationQuantity       : abap.quan(12,2);
      @EndUserText.label      : 'Awarded Quantity'
      @Semantics.quantity.unitOfMeasure: 'UOM'
      AwardedQuantity         : abap.quan(12,2);
      @EndUserText.label      : 'Unit of Measure'
      UOM                     : meins;
      @EndUserText.label      : 'Payment Terms'
      PaymentTerms            : abap.char(4);
      @EndUserText.label      : 'Inco Terms'
      Incoterms               : abap.char(3);
      @EndUserText.label      : 'Delivery Date'
      DeliveryDate            : abap.dats;
      @EndUserText.label      : 'Currency'
      DocCurrency             : abap.cuky(5);

      @EndUserText.label      : 'Quoted Rate/Unit'
      @Semantics.amount.currencyCode: 'DocCurrency'
      QuotedRate              : abap.curr( 12,2 );
      @EndUserText.label      : 'Exchange Rate'
      //        @Semantics.amount.currencyCode: 'DocCurrency'
      ExchangeRate            : abap.dec(9,5);
      @EndUserText.label      : 'Discount'
      @Semantics.amount.currencyCode: 'DocCurrency'
      Discount                : abap.curr(12,2);
      @EndUserText.label      : 'Negotiated Rate'
      @Semantics.amount.currencyCode: 'DocCurrency'
      NegotiatedRate          : abap.curr(12,2);
      @EndUserText.label      : 'Customs Duty(Amount)'
      @Semantics.amount.currencyCode: 'DocCurrency'
      CustomsDutyAmt          : abap.curr(12,2);
      @EndUserText.label      : 'Customs Duty/Qty'
      @Semantics.amount.currencyCode: 'DocCurrency'
      CustomsDutyQtyAmt       : abap.curr(12,2);
      @EndUserText.label      : 'Freight Amount'
      @Semantics.amount.currencyCode: 'DocCurrency'
      FreightAmt              : abap.curr(12,2);
      @EndUserText.label      : 'Other Charges Amount'
      @Semantics.amount.currencyCode: 'DocCurrency'
      OTChargesAmt            : abap.curr(12,2);
      @EndUserText.label      : 'Other Charges Qty'
      @Semantics.amount.currencyCode: 'DocCurrency'
      OTChargesQtyAmt         : abap.curr(12,2);
      @Semantics.amount.currencyCode: 'DocCurrency'
      LandedCost              : abap.curr(12,2);
      @Semantics.amount.currencyCode: 'DocCurrency'
      GrossTotal              : abap.curr(12,2);
      @Semantics.amount.currencyCode: 'DocCurrency'
      ForeignRate             : abap.curr(12,2);
      @Semantics.amount.currencyCode: 'DocCurrency'
      antidumping             : abap.curr(12,2);
      @EndUserText.label      : 'ForeignCurr'
      ForeignCurr             : abap.cuky(5);
      @Semantics.quantity.unitOfMeasure: 'UOM'
      @EndUserText.label      : 'Condition Quantity'
      ConditionQuantity       : abap.quan(12,2);
      Remarks                 : abap.char(100);
      Ranking                 : abap.char(10);
      QTNstatus               : abap.char(2);
      PaymentTermsName        : abap.char(30);

}
