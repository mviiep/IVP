//@AbapCatalog.sqlViewName: 'ZI_SALES_REPORT'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Composite for Sales Register'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@Metadata.allowExtensions: true
define root view entity ZC_SALES_DATA 
  as projection on ZI_SALES_DATA_TO_MI as Sales_Register
{
      @EndUserText.label: 'BILLING DOC. NO.' 
  key Sales_Register.Billing_Doc_No,

      @EndUserText.label: 'ITEM NO.'
  key Sales_Register.Item_No,

      @EndUserText.label: 'GST INVOICE NO.'
  key GST_Invoice_No,

      @EndUserText.label: 'BILLING DATE'
      Sales_Register.Billing_date,

      @EndUserText.label: 'RESPONSE'
      Sales_Register.status,

      @EndUserText.label: 'BILLING TYPE.'
      @Consumption.valueHelpDefinition: [{entity: {element: 'BillingDocumentType' , name: 'Z_I_BILLING_F4HELP' }}]
      Sales_Register.Billing_Type,

//      @EndUserText.label: 'BILLING DESCRIPTION'
//      Sales_Register.Billing_Description,

      @EndUserText.label: 'PRECEDING INVOICE NO.'
      Sales_Register.Preceding_Invoice_No,

      @EndUserText.label: 'PRECEDING INVOICE DATE'
      Sales_Register.Preceding_Invoice_date,

      @EndUserText.label: 'JOURNAL ENTRY'
      Sales_Register.Accounting_Doc_No,
//not required
//      @EndUserText.label: 'DISTRIBUTION CHANNEL'
//      Sales_Register.Distribution_Channel,
//
//      @EndUserText.label: 'DIST, CHANNEL DESC.'
//      Sales_Register.Dist_Channel_Desc,
//
//      @EndUserText.label: 'DIVISION'
//      @Consumption.valueHelpDefinition: [{entity: {element: 'Division' , name: 'Z_I_DIVISION_VH' }}]
//      Sales_Register.Division,
//
//      @EndUserText.label: 'CUSTOMER GROUP'
//      Sales_Register.Customer_Group,
//not required

      @Consumption.hidden: true
 
      @EndUserText.label: 'CUSTOMER NO.'
      Sales_Register.Customer_No,

      @EndUserText.label: 'CUSTOMER NAME'
      Sales_Register.Customer_Name,

      @EndUserText.label: 'CUSTOMER GSTIN NO.'
      Sales_Register.Customer_GSTIN_No,

//      @EndUserText.label: 'CUSTOMER PAN'
//      Sales_Register.Customer_Pan,

//      @EndUserText.label: 'CUSTOMER TIN'
//      Sales_Register.Customer_Tin,
//not required
//      @EndUserText.label: 'CUSTOMER STATE CODE'
//      Sales_Register.Region,
//not required
//      @EndUserText.label: 'CUSTOMER PO NO.'
//      Sales_Register.Customer_PO_No,
//
//      @EndUserText.label: 'CUSTOMER PO DATE'
//      Sales_Register.Customer_PO_Date,
//
//      @EndUserText.label: 'SALES ORDER NO.'
//      Sales_Register.sales_order_no,
//
//      @EndUserText.label: 'SALES ORDER DATE'
//      Sales_Register.Sales_Order_Date,
//
//      @EndUserText.label: 'DELIVERY NO.'
//      Sales_Register.Delivery_No,
//
//      @EndUserText.label: 'MATERIAL CODE'
//      Sales_Register.Material_COde,
//
//      @EndUserText.label: 'MATERIAL DESCRIPTION'
//      Sales_Register.Material_Description,

      @EndUserText.label: 'HSN CODE'
      Sales_Register.HSN_Code,

//      @EndUserText.label: 'PRICE GROUP'
//      Sales_Register.Price_Group,

      @EndUserText.label: 'INVOICE QUANTITY'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Sales_Register.Invoice_Qty,

      @Consumption.hidden: true

      @EndUserText.label: 'FREE QUANTITY'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      Sales_Register.Free_Quantity,

      @EndUserText.label: 'UOM'
      Sales_Register.Unit,

      @EndUserText.label: 'UNIT RATE'
      Sales_Register.Unit_Rate,

      @EndUserText.label: 'TRANSACTION CURRENCY'
      Sales_Register.transactioncurrency,

      Sales_Register.comp_code_curr,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'
      
      @EndUserText.label: 'BASIC AMOUNT'
      Sales_Register.Basic_Amount,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

//      @EndUserText.label: 'TAXABLE VALUE IN RS.'
//      Sales_Register.Taxable_Value_In_RS,

      @Consumption.hidden: true

      @EndUserText.label: 'GST RATE'
      Sales_Register.GST_RATE,

      @EndUserText.label: 'CGST RATE'
      Sales_Register.CGST_RATE,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

      @EndUserText.label: 'CGST'
      Sales_Register.CGST,

      @EndUserText.label: 'SGST RATE'
      Sales_Register.SGST_Rate,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

      @EndUserText.label: 'SGST'
      Sales_Register.SGST,

      @EndUserText.label: 'IGST RATE'
      Sales_Register.IGST_Rate,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

      @EndUserText.label: 'IGST AMT'
      Sales_Register.IGST,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

      @EndUserText.label: 'TCS'
      Sales_Register.TCS,

      @EndUserText.label: 'VAT RATE'
      Sales_Register.VAT_Rate,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'

      @EndUserText.label: 'VAT'
      Sales_Register.VAT,

      @EndUserText.label: 'CST RATE'
      Sales_Register.CST_Rate,
      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'
      
      @EndUserText.label: 'CST'
      Sales_Register.CST,

      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'
      @EndUserText.label: 'TOTAL TAX'
      Sales_Register.Totaltax,

//      @Semantics.amount.currencyCode: 'comp_code_curr'  //'TransactionCurrency' >> 'comp_code_curr'
//      @EndUserText.label: 'GROSS VALUE'
//      Sales_Register.Gross_Value,

//      @EndUserText.label: 'TRANSPORTER PURCHASE ORDER NO.'
//      Sales_Register.Transporter_Purchase_Doc_No,

//      @EndUserText.label: 'SALES SEASON'
//      Sales_Register.Sales_Office,

//      @EndUserText.label: 'BROKER CODE'
//      Sales_Register.Broker_Code,
//
//      @EndUserText.label: 'BROKER NAME'
//      Sales_Register.Broker_Name,

//      @EndUserText.label: 'TRANSPORTER NAME'
//      Sales_Register.Transporter_Name,

//      @EndUserText.label: 'Ship_To_Prty'
//      Ship_To_Prty,

      @EndUserText.label: 'Tax_Code'
      Tax_Code,

//      @EndUserText.label: 'Ewaybill_no'
//      Ewaybill_no,
//      @EndUserText.label: 'Ewaybill_Date'
//      Ewaybill_Date,
//      @EndUserText.label: 'Ewaybill_Status'
//      Ewaybill_Status,
//      @EndUserText.label: 'Ack_num'
//      Ack_num,
//      @EndUserText.label: 'Ack_date'
//      Ack_date,
      @EndUserText.label: 'Bussiness_area'
      Bussiness_area,
//      @EndUserText.label: 'Einv_Canceldate'
//      Einv_Canceldate,
//      @EndUserText.label: 'Einv_CancelReason'
//      Einv_CancelReason,
//      @EndUserText.label: 'Einv_Status'
//      Einv_Status,
//      @EndUserText.label: 'Einv_City'
//      Einv_City,
//      @EndUserText.label: 'Einv_type'
//      Einv_type,
//      @EndUserText.label: 'IRN'
//      IRN,
      @EndUserText.label: 'GL_Code'
      GL_Code,
      @EndUserText.label: 'GL_Desc'
      GLDesc,
      @EndUserText.label: 'Is_Reversal'
      Is_Reversal,

      @EndUserText.label: 'Fiscal_Year'
      Fiscal_Year,
      
      @EndUserText.label: 'Business Place'
      business_place,
      
      @EndUserText.label: 'Supplier GSTIN'
      SupplierGstin,
      
      @EndUserText.label: 'Reverse_doc'
      Reverse_doc,

      @EndUserText.label: 'AccountingExchangeRate'
      AccountingExchangeRate,

//      @EndUserText.label: 'Product'
//      Product,
//      @EndUserText.label: 'ShipToParty'
//      ShipToParty,
//      @EndUserText.label: 'ShipToPartyName'
//      ShipToPartyName,
//      @EndUserText.label: 'BillToParty'
//      BillToParty,
//      @EndUserText.label: 'BillToPartyName'
//      BillToPartyName,
//      @EndUserText.label: 'BillToPartyRegion'
//      BillToPartyRegion,
//      @EndUserText.label: 'BillToPartyCountry'
//      BillToPartyCountry,
//      @Semantics.amount.currencyCode: 'comp_code_curr'  
//      @EndUserText.label: 'amortisation'
//      amortisation,
      @Semantics.amount.currencyCode: 'comp_code_curr'  
      @EndUserText.label: 'roundoffval'
      roundoffval,
      @EndUserText.label: 'Document Type'
      Doc_type,
      @EndUserText.label: 'customer_number'
      customer_number,
      @EndUserText.label: 'posting_date'
      posting_date
      
}
