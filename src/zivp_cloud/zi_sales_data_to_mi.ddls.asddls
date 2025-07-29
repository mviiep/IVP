@AbapCatalog.sqlViewName: 'ZI_SALES_REPORT'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view ZI_SALES_DATA_TO_MI 

  as select distinct from ZI_FI_JOURNAL_ENTRY as jou_entry

  association [0..1] to I_BillingDocumentItemBasic     as BillItem       on  BillItem.BillingDocument     = jou_entry.referencedocno
                                                                         and BillItem.BillingDocumentItem = jou_entry.ReferenceDocumentItem


  association [0..1] to I_BillingDocumentBasic         as BillingHeader  on  BillingHeader.BillingDocument         = jou_entry.referencedocno
                                                                         and BillingHeader.AccountingPostingStatus = 'C'

  association [0..1] to zgstr1_st                      as status         on  status.accounting_doc = jou_entry.AccountingDocument

  association [0..1] to I_BillingDocumentTypeText      as documenttype   on  documenttype.BillingDocumentType = jou_entry.referencedocno
                                                                         and documenttype.Language            = 'E'

  association [1]    to I_IN_ElectronicDocInvoice      as irn            on  irn.IN_EDocEInvcExtNmbr     = jou_entry.originalrefdocno
                                                                         and irn.ElectronicDocSourceType = 'FI_INVOICE'

  association [1]    to I_IN_ElectronicDocInvoice      as irn_bill       on  irn_bill.ElectronicDocSourceKey = jou_entry.referencedocno

  association [0..1] to ZI_PREC_INVNO                  as PrecInv        on  PrecInv.BillingDocument        = jou_entry.referencedocno
                                                                         and PrecInv.SubsequentDocumentItem = jou_entry.ReferenceDocumentItem

  association [0..1] to I_DistributionChannelText      as Distchannel    on  Distchannel.DistributionChannel = jou_entry.Distributionchannel
                                                                         and Distchannel.Language            = 'E'

  association [0..1] to ZI_Customer_Det                as customer       on  customer.Billiing_Doc = jou_entry.referencedocno

  association [0..1] to I_SalesOrder                   as salesdetails   on  salesdetails.SalesOrder = jou_entry.salesdocument

  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg       on  Itemprcg.BillingDocument         =  jou_entry.referencedocno
                                                                         and Itemprcg.BillingDocumentItem     =  jou_entry.ReferenceDocumentItem
                                                                         and Itemprcg.ConditionRateAmount     <> 0
                                                                         and Itemprcg.ConditionType           =  'ZDEV'
                                                                         and Itemprcg.ConditionInactiveReason =  ''

  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg1      on  Itemprcg1.BillingDocument         =  jou_entry.referencedocno
                                                                         and Itemprcg1.BillingDocumentItem     =  jou_entry.ReferenceDocumentItem
                                                                         and Itemprcg1.ConditionRateAmount     <> 0
                                                                         and Itemprcg1.ConditionType           =  'PMP0'
                                                                         and Itemprcg1.ConditionInactiveReason =  ''

  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg2      on  Itemprcg2.BillingDocument         =  jou_entry.referencedocno
                                                                         and Itemprcg2.BillingDocumentItem     =  jou_entry.ReferenceDocumentItem
                                                                         and Itemprcg2.ConditionRateAmount     <> 0
                                                                         and Itemprcg2.ConditionType           =  'PCIP'
                                                                         and Itemprcg2.ConditionInactiveReason =  ''

  //  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg1      on  Itemprcg1.BillingDocument     = jou_entry.referencedocno
  //                                                                         and Itemprcg1.BillingDocumentItem = jou_entry.ReferenceDocumentItem
  //                                                                         and Itemprcg1.ConditionType       = 'YBHD'

  association [1]    to I_BillingDocItemPrcgElmntBasic as CGSTdetails    on  CGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and CGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and CGSTdetails.ConditionType       = 'JOCG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as CGST_usd       on  CGST_usd.BillingDocument     = jou_entry.referencedocno
                                                                         and CGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and CGST_usd.ConditionType       = 'JOCG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as SGSTdetails    on  SGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and SGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and SGSTdetails.ConditionType       = 'JOSG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as SGST_usd       on  SGST_usd.BillingDocument     = jou_entry.referencedocno
                                                                         and SGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and SGST_usd.ConditionType       = 'JOSG'


  association [1]    to I_BillingDocItemPrcgElmntBasic as IGSTdetails    on  IGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and IGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and IGSTdetails.ConditionType       = 'JOIG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as IGST_usd       on  IGST_usd.BillingDocument     = jou_entry.referencedocno
                                                                         and IGST_usd.ConditionBaseAmount = jou_entry.amountintransactioncurrency
                                                                         and IGST_usd.ConditionType       = 'JOIG'

  association [1]    to I_BillingDocItemPrcgElmntBasic as TGSTdetails    on  TGSTdetails.BillingDocument     = jou_entry.referencedocno
                                                                         and TGSTdetails.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and TGSTdetails.ConditionType       = 'ZSCR'

  association [0..1] to I_BillingDocumentPartner       as Vendordetails  on  Vendordetails.BillingDocument = jou_entry.referencedocno
                                                                         and Vendordetails.PartnerFunction = 'U3'

  association [0..1] to ZI_PUR_AND_FREIGHT             as FREIGHTEXP     on  FREIGHTEXP.SettlmtSourceDoc          =  jou_entry.salesdocument
                                                                         and FREIGHTEXP.SettlmtSourceDocItem      =  jou_entry.salesdocitem
                                                                         and FREIGHTEXP.FrtCostAllocItemNetAmount >= 0

  association [0..1] to ZI_Customer_Det_R1             as Broker         on  Broker.Billiing_Doc = jou_entry.referencedocno

  association [0..1] to ZI_JournalEntry_1              as GLAcc

                                                                         on  GLAcc.BillingDocument = jou_entry.referencedocno

  association [1]    to ZGSTR1_ADDITIONAL              as billi_doc_cube on  billi_doc_cube.BillingDocument     = jou_entry.referencedocno
                                                                         and billi_doc_cube.BillingDocumentItem = jou_entry.ReferenceDocumentItem

  association [1]    to I_BillingDocItemPrcgElmntBasic as amortisation   on  amortisation.BillingDocument     = jou_entry.referencedocno
                                                                         and amortisation.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and amortisation.ConditionType       = 'ZAMO'

  association [1]    to I_BillingDocItemPrcgElmntBasic as roundoffvalue  on  roundoffvalue.BillingDocument     = jou_entry.referencedocno
                                                                         and roundoffvalue.BillingDocumentItem = jou_entry.ReferenceDocumentItem
                                                                         and roundoffvalue.ConditionType       = 'DRD1'


  association [0..1] to ZI_TRANS_DETAILS_1             as Trans          on  Trans.BillingDocument = jou_entry.referencedocno
                                                                         and Trans.PartnerFunction = 'U3'

  association [0..1] to Z_I_BILLING_F4HELP             as _HELP          on  $projection.Billing_Type = _HELP.BillingDocumentType
  association [0..1] to Z_I_DIVISION_VH                as _DIV_HELP      on  $projection.Billing_Type = _DIV_HELP.Division

  association [1]    to I_OperationalAcctgDocItem      as Cgst_gl        on  jou_entry.AccountingDocument         = Cgst_gl.AccountingDocument
                                                                         and jou_entry.BaseAmount                 = Cgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                         and Cgst_gl.AccountingDocumentItemType   = 'T'
                                                                         and Cgst_gl.TransactionTypeDetermination = 'JOC'

  association [1]    to I_OperationalAcctgDocItem      as sgst_gl        on  jou_entry.AccountingDocument         = sgst_gl.AccountingDocument
                                                                         and jou_entry.BaseAmount                 = sgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                         and sgst_gl.AccountingDocumentItemType   = 'T'
                                                                         and sgst_gl.TransactionTypeDetermination = 'JOS'

  association [1]    to I_OperationalAcctgDocItem      as igst_gl        on  jou_entry.AccountingDocument         = igst_gl.AccountingDocument
                                                                         and jou_entry.BaseAmount                 = igst_gl.TaxBaseAmountInCoCodeCrcy
                                                                         and igst_gl.AccountingDocumentItemType   = 'T'
                                                                         and igst_gl.TransactionTypeDetermination = 'JOI'
  association [1]    to I_Customer                     as cust           on  jou_entry.customer_name_ = cust.Customer

  //  association [1]    to I_OperationalAcctgDocItem      as bplace         on  jou_entry.AccountingDocument = bplace.AccountingDocument

  association [1]    to ZI_ORG_GSTIN                   as org_gstin      on  jou_entry.businessplace = org_gstin.BusinessPlace
{

      @Consumption.valueHelpDefinition: [{entity: {element: 'Billing_Doc_No' , name: 'Z_I_BILLING_F4HELP'}}]

  key BillItem.BillingDocument                                                                                                                         as Billing_Doc_No,

  key ltrim(jou_entry.itemno,'0')                                                                                                                      as Item_No,
  key jou_entry.originalrefdocno                                                                                                                       as GST_Invoice_No,

      jou_entry.AccountingDocument                                                                                                                     as Accounting_Doc_No, //8
      jou_entry.trasns_curreency,
      jou_entry.transactioncurrency,
      jou_entry.amcomp,
      Cgst_gl.AmountInCompanyCodeCurrency,

      //      case when jou_entry.materialgroup is not initial then
      //      jou_entry.materialgroup
      //      when BillItem.MaterialGroup is not initial then
      //      BillItem.MaterialGroup   end                                                                                                                     as Material_Group,

      jou_entry.FiscalYear                                                                                                                             as Fiscal_Year,
      jou_entry.businessplace                                                                                                                          as business_place,
      org_gstin.Gstin                                                                                                                                  as SupplierGstin,
      case when jou_entry.accdoctype is not initial then
      jou_entry.accdoctype
      when BillItem.BillingDocumentType is not initial then
      BillItem.BillingDocumentType     end                                                                                                             as Doc_type,
      //      case when irn.IN_EDocEInvcEWbillNmbr is not initial then
      //      irn.IN_EDocEInvcEWbillNmbr
      //      when irn_bill.IN_EDocEInvcEWbillNmbr is not initial then
      //      irn_bill.IN_EDocEInvcEWbillNmbr
      //      end                                                                                                                                              as Ewaybill_no,
      //      case when irn.IN_EDocEInvcEWbillCreateDate is not initial then
      //      irn.IN_EDocEInvcEWbillCreateDate
      //      when irn_bill.IN_EDocEInvcEWbillCreateDate is not initial then
      //      irn_bill.IN_EDocEInvcEWbillCreateDate
      //      end                                                                                                                                              as Ewaybill_Date,
      //      case when irn.IN_EDocEWbillStatus is not initial then
      //      irn.IN_EDocEWbillStatus
      //      when irn_bill.IN_EDocEWbillStatus is not initial then
      //      irn_bill.IN_EDocEWbillStatus
      //      end                                                                                                                                              as Ewaybill_Status,
      //      case when irn.IN_ElectronicDocAcknNmbr is not initial then
      //      irn.IN_ElectronicDocAcknNmbr
      //      when irn_bill.IN_ElectronicDocAcknNmbr is not initial then
      //      irn_bill.IN_ElectronicDocAcknNmbr
      //      end                                                                                                                                              as Ack_num,
      //      case when irn.IN_ElectronicDocAcknDate is not initial then
      //      irn.IN_ElectronicDocAcknDate
      //      when irn_bill.IN_ElectronicDocAcknDate is not initial then
      //      irn_bill.IN_ElectronicDocAcknDate
      //      end                                                                                                                                              as Ack_date,
      //      case when irn.IN_ElectronicDocCancelDate is not initial then
      //      irn.IN_ElectronicDocCancelDate
      //      when irn_bill.IN_ElectronicDocCancelDate is not initial then
      //      irn_bill.IN_ElectronicDocCancelDate
      //      end                                                                                                                                              as Einv_Canceldate,
      //      case when irn.IN_EDocCancelRemarksTxt is not initial then
      //      irn.IN_EDocCancelRemarksTxt
      //      when irn_bill.IN_EDocCancelRemarksTxt is not initial then
      //      irn_bill.IN_EDocCancelRemarksTxt
      //      end                                                                                                                                              as Einv_CancelReason,
      //      case when irn.ElectronicDocProcessStatus is not initial then
      //      irn.ElectronicDocProcessStatus
      //      when irn_bill.ElectronicDocProcessStatus is not initial then
      //      irn_bill.ElectronicDocProcessStatus
      //      end                                                                                                                                              as Einv_Status,
      //      case when irn.ElectronicDocCountry is not initial then
      //      irn.ElectronicDocCountry
      //      when irn_bill.ElectronicDocCountry is not initial then
      //      irn_bill.ElectronicDocCountry
      //      end                                                                                                                                              as Einv_City,
      //      case when irn.ElectronicDocType is not initial then
      //      irn.ElectronicDocType
      //      when irn_bill.ElectronicDocType is not initial then
      //      irn_bill.ElectronicDocType
      //      end                                                                                                                                              as Einv_type,
      //      case when irn.IN_ElectronicDocInvcRefNmbr is not initial then
      //      irn.IN_ElectronicDocInvcRefNmbr
      //      when irn_bill.IN_ElectronicDocInvcRefNmbr is not initial then
      //      irn_bill.IN_ElectronicDocInvcRefNmbr
      //      end                                                                                                                                              as IRN,
      jou_entry.gl_account                                                                                                                             as GL_Code,
      jou_entry.GLDesc                                                                                                                                 as GLDesc,
      jou_entry.is_reversed                                                                                                                            as Is_Reversal,
      jou_entry.reversedocument                                                                                                                        as Reverse_doc,

      case when BillItem.Plant is not initial then
      BillItem.Plant
      when jou_entry.plant is not initial then
      jou_entry.plant end                                                                                                                              as Bussiness_area,
      billi_doc_cube.AccountingExchangeRate                                                                                                            as AccountingExchangeRate,
      //      billi_doc_cube.Product                                                                                                                           as Product,
      //      case when billi_doc_cube.ShipToParty is not initial then
      //      billi_doc_cube.ShipToParty
      //      when jou_entry.shiptoparty is not initial then
      //      jou_entry.shiptoparty  end                                                                                                                       as ShipToParty,
      //
      //      billi_doc_cube.ShipToPartyName                                                                                                                   as ShipToPartyName,
      //      billi_doc_cube.BillToParty                                                                                                                       as BillToParty,
      //      billi_doc_cube.BillToPartyName                                                                                                                   as BillToPartyName,
      //      billi_doc_cube.BillToPartyRegion                                                                                                                 as BillToPartyRegion,
      //      billi_doc_cube.BillToPartyCountry                                                                                                                as BillToPartyCountry,
      //            amortisation.ConditionAmount                                                                                                                     as amortisation,
      roundoffvalue.ConditionAmount                                                                                                                    as roundoffval,

      case when BillItem.BillingDocumentDate is not initial then
      BillItem.BillingDocumentDate
      when jou_entry.DocumentDate is not initial then
      jou_entry.DocumentDate         end                                                                                                               as Billing_date,

      jou_entry.PostingDate                                                                                                                            as posting_date,

      BillItem.BillingDocumentType                                                                                                                     as Billing_Type, //3
      //      documenttype.BillingDocumentTypeName                                                                                                             as Billing_Description, //4
      ltrim(PrecInv.SubsequentDocument,'0')                                                                                                            as Preceding_Invoice_No,
      case PrecInv.CreationDate

      when '0000-00-00' then ' '
      else
      cast(
          concat(
            concat(
              concat(substring(PrecInv.CreationDate, 7, 2), '.' ),
              concat(substring(PrecInv.CreationDate, 5, 2), '.' )
            ),
            substring(PrecInv.CreationDate, 1, 4)
          )
        as char10 preserving type) end                                                                                                                 as Preceding_Invoice_date,
      //not required
      //      case when jou_entry.Distributionchannel is not initial then
      //      jou_entry.Distributionchannel
      //      when BillItem.SalesOrderDistributionChannel is not initial then
      //      BillItem.SalesOrderDistributionChannel end                                                                                                       as Distribution_Channel, //9
      //
      //
      //      Distchannel.DistributionChannelName                                                                                                              as Dist_Channel_Desc, //10
      //      BillItem.Division                                                                                                                                as Division, //11
      //not required
      //      BillItem.SalesOrderCustomerPriceGroup                                                                                                            as Price_Group,
      //not required      BillItem.CustomerGroup                                                                                                                           as Customer_Group, //16

      ltrim(BillingHeader.PayerParty,'0')                                                                                                              as Customer_No, //17

      cast(status.status as abap.char(300))                                                                                                            as status,
      //
      //      ltrim(BillItem.Product,'0')                                                                                                                      as Material_COde, //34
      //      BillItem.BillingDocumentItemText                                                                                                                 as Material_Description, //35

      case when customer.Customer is not initial then
      customer.Customer
      when jou_entry.Customer is not initial then
      jou_entry.Customer end                                                                                                                           as customer_number,


      case when customer.CustomerName is not initial then
      customer.CustomerName
      when jou_entry.custo_name is not initial then
      jou_entry.custo_name    end                                                                                                                      as Customer_Name, //18

      case when customer.TaxNumber3 is not initial then
      customer.TaxNumber3
      when cust.TaxNumber3 is not initial then
      cust.TaxNumber3 end                                                                                                                              as Customer_GSTIN_No, //19

      //not required      case when customer.Customer_Pan is not initial then
      //not required      customer.Customer_Pan   end                                                                                                                      as Customer_Pan,


      //      customer.TaxNumber2                                                                                                                              as Customer_Tin, //21

      //      case when customer.Region is not initial then
      //      customer.Region
      //      when jou_entry.region is not initial then
      //      jou_entry.region end                                                                                                                             as Region, //22
      //
      //      ltrim(BillItem.SalesDocument,'0')                                                                                                                as sales_order_no,
      //      salesdetails.PurchaseOrderByCustomer                                                                                                             as Customer_PO_No, // 26
      //
      //      cast(
      //         concat(
      //           concat(
      //             concat(substring(salesdetails.CustomerPurchaseOrderDate, 7, 2), '.' ),
      //             concat(substring(salesdetails.CustomerPurchaseOrderDate, 5, 2), '.' )
      //           ),
      //           substring(salesdetails.CustomerPurchaseOrderDate, 1, 4)
      //         )
      //       as char10 preserving type)                                                                                                                      as Customer_PO_Date,
      //
      //      cast(
      //           concat(
      //             concat(
      //               concat(substring(salesdetails.CreationDate, 7, 2), '.' ),
      //               concat(substring(salesdetails.CreationDate, 5, 2), '.' )
      //             ),
      //             substring(salesdetails.CreationDate, 1, 4)
      //           )
      //         as char10 preserving type)                                                                                                                    as Sales_Order_Date,
      //
      //      ltrim(BillItem.ReferenceSDDocument,'0')                                                                                                          as Delivery_No,
      case when jou_entry.HSN_Code is not initial then
      jou_entry.HSN_Code else
      jou_entry.hsncode end                                                                                                                            as HSN_Code,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      BillItem.BillingQuantity                                                                                                                         as Invoice_Qty, //Invoice_Qty ,       //40
      BillItem.BillingQuantityUnit                                                                                                                     as Unit,
      case BillItem.SalesDocumentItemCategory
        when 'TANN' then floor(BillItem.BillingQuantity)
        end                                                                                                                                            as Free_Quantity,

      case BillItem.BillingQuantityUnit
        when 'ZQT' then 'QTL'
        else BillItem.BillingQuantityUnit
        end                                                                                                                                            as UOM,

      cast((Itemprcg.ConditionRateAmount) as abap.dec(15,2))                                                                                           as Unit_Rate,
      @DefaultAggregation:#NONE
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr
      //      Itemprcg1.ConditionAmount                                                                                                                        as Freight_Amount,
      GLAcc.CompanyCodeCurrency                                                                                                                        as comp_code_curr,

      case when Itemprcg.TransactionCurrency <> 'INR' then
      cast(BillItem.TaxAmount as abap.fltp ) + cast( BillItem.NetAmount as abap.fltp ) * cast( BillingHeader.AccountingExchangeRate as abap.fltp ) end as TESTCURRENCY,
      //      Itemprcg.ConditionAmount                                                                                                                         as Insurance_Amount, //45 needs to be comment
      //      Itemprcg.ConditionAmount                                                                                                                         as Packaging_Cost, //46  needs to be comment
      @Semantics.amount.currencyCode: 'comp_code_curr' //TransactionCurrency >> comp_code_curr

      case when jou_entry.amcomp is not initial then
            abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

            case when Itemprcg.TransactionCurrency <> 'INR' then
            abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) else
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(jou_entry.absoexchrate as abap.dec( 16, 2 ))) else
            abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )))
             end end                                                                                                                                   as Basic_Amount,

      cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 ))                                                             as Basic_Amount_test,

      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr

      //      case when jou_entry.amcomp is not initial and amortisation.ConditionAmount is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else

      //      case when jou_entry.amcomp is not initial then
      //      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else
      //
      //      case when Itemprcg.TransactionCurrency <> 'INR' and amortisation.ConditionAmount is not initial then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else
      //
      //      case when Itemprcg.TransactionCurrency = 'INR' and amortisation.ConditionAmount is not initial then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) +
      //      cast(amortisation.ConditionAmount as abap.dec(16 , 2)) else
      //
      //      case when Itemprcg.TransactionCurrency <> 'INR' then
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )) * cast(BillingHeader.AccountingExchangeRate as abap.dec( 16, 2 ))) else
      //      abs(cast((Itemprcg.ConditionRateAmount * BillItem.BillingQuantity) as abap.dec( 16, 2 )))
      //      end end end end end                                                                                                                              as Taxable_Value_In_RS,

      case when CGSTdetails.ConditionRateValue is not initial
      then
      cast((CGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.CGST_PERC is not initial
      then
      fltp_to_dec (jou_entry.CGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as CGST_RATE,

      case when SGSTdetails.ConditionRateValue is not initial
      then
      cast((SGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.SGST_PERC is not initial
      then
      fltp_to_dec (jou_entry.SGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as SGST_Rate, //52

      case when IGSTdetails.ConditionRateValue is not initial
      then
      cast((IGSTdetails.ConditionRateValue) as abap.dec(5,2))
      when jou_entry.IGST_PERC is not initial then
      fltp_to_dec (jou_entry.IGST_PERC as abap.dec( 16, 2 ) )
      end                                                                                                                                              as IGST_Rate, //54
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr

      //    *****CGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' //+Add 26/8/24 Krishna
      then
      abs(Cgst_gl.AmountInCompanyCodeCurrency) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      then
      abs(cast((CGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' then
      abs(CGSTdetails.ConditionAmount) end end end                                                                                                     as CGST,
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr

      //    *****SGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' //+Add 26/8/24 Krishna
      then
      abs(sgst_gl.AmountInCompanyCodeCurrency) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      then
      abs(cast((SGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' then
      abs(SGSTdetails.ConditionAmount) end end end                                                                                                     as SGST,
      @Semantics.amount.currencyCode: 'comp_code_curr' //'TransactionCurrency' >> comp_code_curr

      //      *****IGST Amount*****
      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' then //+Add 26/8/24 Krishna
      abs(igst_gl.AmountInCompanyCodeCurrency) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.trasns_curreency <> 'INR' then
      abs(cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 ))) else
      abs(IGSTdetails.ConditionAmount) end end                                                                                                         as IGST,

      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as TCS_Rate, //56
      TGSTdetails.ConditionAmount                                                                                                                      as TCS, //57
      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as VAT_Rate, //58 needs to be commented
      TGSTdetails.ConditionAmount                                                                                                                      as VAT, //59   needs to be commented
      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                          as CST_Rate, //60  needs to be commented
      TGSTdetails.ConditionAmount                                                                                                                      as CST, //61  needs to be commented


      cast(CGSTdetails.ConditionRateValue as abap.fltp )
               +
      cast( SGSTdetails.ConditionRateValue as abap.fltp )
               +
      cast( IGSTdetails.ConditionRateValue as abap.fltp  )                                                                                             as GST_RATE,

      @Semantics.amount.currencyCode: 'comp_code_curr'
      case when ( jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' ) and  //+Add 26/8/24 Krishna
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      ( igst_gl.AmountInCompanyCodeCurrency * -1 ) else

      case when ( jou_entry.accdoctype = 'DG' or jou_entry.accdoctype = 'DR'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' ) and //+Add 26/8/24 Krishna
      igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency else

      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' and //+Add 26/8/24 Krishna
      Cgst_gl.AmountInCompanyCodeCurrency is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      then
      abs(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) + cast(sgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial then
      cast(IGST_usd.ConditionAmount * ( jou_entry.absoexchrate ) as abap.dec( 16, 2 )) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial then

      abs(cast((((CGST_usd.ConditionAmount) + (SGST_usd.ConditionAmount)) * (jou_entry.absoexchrate) ) as abap.dec( 16, 2 )))  else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) + cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial then
        abs(IGSTdetails.ConditionAmount)
      end end end end end end end                                                                                                                      as Totaltax,

      case when BillItem.TaxCode is not initial then
      BillItem.TaxCode
      when jou_entry.TaxCode is not initial then
      jou_entry.TaxCode end                                                                                                                            as Tax_Code,

      //      BillItem.ShipToParty                                                                                                                             as Ship_To_Prty,
      // 06/11/24 krishna
      //07/11/24 krishna
      case when jou_entry.accdoctype = 'RV' and ( BillItem.TaxCode = 'JG' or  BillItem.TaxCode = 'D0' or  BillItem.TaxCode = 'E0' )then
      cast(jou_entry.amcomp as abap.dec( 16, 2 )) else
      //                  igst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency + Cgst_gl.AmountInCompanyCodeCurrency + jou_entry.amcomp else

      case when jou_entry.accdoctype = 'DG' and jou_entry.TaxCode = 'DD' then
      cast(jou_entry.amcomp as abap.dec( 16, 2 )) else
      //                  cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2) +
      //                  else
      //           cast(((((igst_gl.AmountInCompanyCodeCurrency) + (sgst_gl.AmountInCompanyCodeCurrency) +
      //           (Cgst_gl.AmountInCompanyCodeCurrency) + (jou_entry.amcomp)))) as abap.dec( 16, 2 )) else

      case when jou_entry.accdoctype = 'DG' and jou_entry.TaxCode = 'D2' then
      cast(jou_entry.amcomp as abap.dec( 16, 2 )) else

      //07/11/24 krishna

      case when jou_entry.accdoctype = 'RV' and
      BillItem.TaxCode is initial and jou_entry.TaxCode is initial  then
      abs((cast((jou_entry.amcomp) as abap.dec( 16, 2 )))  ) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial then
      abs((cast(((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate)) + jou_entry.amcomp ) as abap.dec( 16, 2 ))) ) else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial then
      abs((cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 )) ) ) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial then
      abs((cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) ) else

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial then
      abs((cast(IGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) ) else

      case when jou_entry.accdoctype = 'DR'  // or jou_entry.accdoctype = 'DG' )
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else

      case when jou_entry.accdoctype = 'DG'  // or jou_entry.accdoctype = 'DG' )
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else

      //      case when jou_entry.accdoctype = 'DG'  // or jou_entry.accdoctype = 'DG' )
      //      and jou_entry.TaxCode is not initial then
      //      jou_entry.amcomp + Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency +
      //      igst_gl.AmountInCompanyCodeCurrency else

      //+Add 26/8/24 Krishna
      case when jou_entry.accdoctype = 'Z1'
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else

      case when jou_entry.accdoctype = 'Z2'
      and jou_entry.TaxCode is initial then
      jou_entry.amcomp else
      //+Add 26/8/24 Krishna

      case when jou_entry.accdoctype = 'RV' and
      BillItem.TaxCode is initial and jou_entry.TaxCode is initial then
      abs(cast((jou_entry.amcomp) as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'DR' and //or jou_entry.accdoctype = 'DG' ) and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then //and CGSTdetails.ConditionRateValue is initial and jou_entry.CGST_PERC is initial then
      jou_entry.amcomp else

      case when jou_entry.accdoctype = 'DG' and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then //and CGSTdetails.ConditionRateValue is initial and jou_entry.CGST_PERC is initial then
      jou_entry.amcomp else

      //+Add 26/8/24 Krishna
      case when jou_entry.accdoctype = 'Z1' and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then
      jou_entry.amcomp else

      case when jou_entry.accdoctype = 'Z2' and
      ( jou_entry.TaxCode = 'F0' or jou_entry.TaxCode = 'OZ' ) then
      jou_entry.amcomp else
      //+Add 26/8/24 Krishna

      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial // and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DR' //or jou_entry.AccountingDocumentType = 'DG' ) and
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then //and sgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'DG'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      jou_entry.amcomp else

      //+Add 26/8/24 Krishna
      case when jou_entry.AccountingDocumentType = 'Z1'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'Z1'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'Z2'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ( Cgst_gl.AmountInCompanyCodeCurrency * -1 ) + ( sgst_gl.AmountInCompanyCodeCurrency * -1 ) +
      jou_entry.amcomp else

      case when jou_entry.AccountingDocumentType = 'Z2'
      and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency + sgst_gl.AmountInCompanyCodeCurrency  +
      jou_entry.amcomp else
      //+Add 26/8/24 Krishna

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR' and
      CGST_usd.ConditionAmount is not initial and SGST_usd.ConditionAmount is not initial then
      abs(cast(((((CGSTdetails.ConditionAmount) + (SGSTdetails.ConditionAmount)) * (jou_entry.absoexchrate)) + jou_entry.amcomp ) as abap.dec( 16, 2 )))  else

      case when jou_entry.accdoctype = 'RV' and jou_entry.transactioncurrency <> 'INR'
      and IGST_usd.ConditionAmount is not initial then
      abs(cast((IGST_usd.ConditionAmount  * jou_entry.absoexchrate) as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial and
      SGSTdetails.ConditionAmount < 0 then
      abs(cast(CGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      CGSTdetails.ConditionAmount is not initial and SGSTdetails.ConditionAmount is not initial then
      abs(cast(CGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(SGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      //                  case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      //                  or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' and //+Add 26/8/24 Krishna
      //                  igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      //                  abs(cast(igst_gl.AmountInCompanyCodeCurrency * -1 as abap.dec( 16, 2 )) +
      //                  cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'DR' or jou_entry.accdoctype = 'DG'
      or jou_entry.accdoctype = 'Z1' or jou_entry.accdoctype = 'Z2' and //+Add 26/8/24 Krishna
      igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
      abs(cast(igst_gl.AmountInCompanyCodeCurrency as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial and IGSTdetails.ConditionAmount < 0 then
      abs(cast(IGSTdetails.ConditionAmount * -1 as abap.dec( 16, 2 )) +
      cast(jou_entry.amcomp as abap.dec( 16, 2 ))) else

      case when jou_entry.accdoctype = 'RV' and
      IGSTdetails.ConditionAmount is not initial then
      abs(cast(IGSTdetails.ConditionAmount as abap.dec( 16, 2 )) +   //igst_gl.AmountInCompanyCodeCurrency >> igstdetails.conditionamount
      cast(jou_entry.amcomp as abap.dec( 16, 2 )))

      end end end end end end end end end end end end end end end end end end end end end end end end end end end end end end end end                  as Gross_Value,
      // 06/11/24 krishna
      //      case when jou_entry.accdoctype = 'RV' and jou_entry.TaxCode = 'JG' then
      //      cast(jou_entry.amcomp as abap.dec( 16, 2 ))      end                                       as Gross_Value,
      //      FREIGHTEXP.PurchaseOrder                                                                                                                         as Transporter_Purchase_Doc_No, //64

      //      ltrim(Vendordetails.Supplier, '0')                                                                                                               as Freight_vendor, //65
      //
      //      FREIGHTEXP.FrtCostAllocItemNetAmount                                                                                                             as Freight_Exp, //69
      //      //      case when ( FREIGHTEXP.FrtCostAllocItemNetAmount is null and Itemprcg1.ConditionAmount is not null ) then Itemprcg1.ConditionAmount
      //      //
      //      //      else
      //      //      Itemprcg1.ConditionAmount - FREIGHTEXP.FrtCostAllocItemNetAmount end                                                                             as Freight_Margin,
      //      BillItem.SalesOffice                                                                                                                             as Sales_Office,

      //      ltrim(BillingHeader.SoldToParty,'0')                                                                                                             as Broker_Code, //72
      //      Broker.CustomerName                                                                                                                              as Broker_Name, //73
      //      Trans.SupplierName                                                                                                                               as Transporter_Name,
      jou_entry.ReversalDocument,
      _HELP,
      _DIV_HELP,
      BillingHeader.CustomerGroup as customergroup,
      igst_gl.AmountInCompanyCodeCurrency                                                                                                              as IGHT_TST,
      Cgst_gl.AmountInCompanyCodeCurrency                                                                                                              as CGS,
      sgst_gl.AmountInCompanyCodeCurrency                                                                                                              as SGS
}
where
           jou_entry.ReversalDocument <> 'Yes'
  and(
    (
           jou_entry.Qty              =  'BaseAmt'
      and(
           jou_entry.Billingtype      =  'G2'
        or jou_entry.Billingtype      =  'L2'
        or jou_entry.Billingtype      =  'F2'
        or jou_entry.Billingtype      =  'CBRE'
        or jou_entry.Billingtype      =  'JSTO'
      )
    )
    or(
           jou_entry.Qty              =  'JOURNALENTRY_AMOUNT'
      and(
           jou_entry.accdoctype       =  'DR'
        or jou_entry.accdoctype       =  'DG'
        or jou_entry.accdoctype       =  'RV'
        or jou_entry.accdoctype       =  'Z1'
        or jou_entry.accdoctype       =  'Z2'
      )
    )
  )
group by
  BillItem.BillingDocument,
  BillItem.MaterialGroup,
  BillingHeader.FiscalYear,
  BillingHeader.AccountingExchangeRate,
  irn.IN_EDocEInvcEWbillNmbr,
  irn_bill.IN_EDocEInvcEWbillNmbr,
  irn.IN_EDocEInvcEWbillCreateDate,
  irn_bill.IN_EDocEInvcEWbillCreateDate,
  irn.IN_EDocEWbillStatus,
  irn_bill.IN_EDocEWbillStatus,
  irn.IN_ElectronicDocAcknNmbr,
  irn_bill.IN_ElectronicDocAcknNmbr,
  irn.IN_ElectronicDocAcknDate,
  irn_bill.IN_ElectronicDocAcknDate,
  irn.IN_ElectronicDocCancelDate,
  irn_bill.IN_ElectronicDocCancelDate,
  irn.IN_EDocCancelRemarksTxt,
  irn_bill.IN_EDocCancelRemarksTxt,
  irn.ElectronicDocProcessStatus,
  irn_bill.ElectronicDocProcessStatus,
  irn.ElectronicDocCountry,
  irn_bill.ElectronicDocCountry,
  irn.ElectronicDocType,
  irn_bill.ElectronicDocType,
  irn.IN_ElectronicDocInvcRefNmbr,
  irn_bill.IN_ElectronicDocInvcRefNmbr,
  GLAcc.GLAccount,
  jou_entry.GLDesc,
  GLAcc.IsReversal,
  GLAcc.ReversalReferenceDocument,
  BillItem.Plant,
  BillItem.BillingDocumentDate,
  BillItem.BillingDocumentType,
  BillItem.NetAmount,
  documenttype.BillingDocumentTypeName,
  PrecInv.SubsequentDocument,
  PrecInv.CreationDate,
  BillingHeader.DocumentReferenceID,
  BillItem.SalesOrderDistributionChannel,
  Distchannel.DistributionChannelName,
  BillItem.Division,
  BillItem.SalesOrderCustomerPriceGroup,
  BillItem.CustomerGroup,
  BillingHeader.PayerParty,
  status.status,
  BillItem.BillingDocumentItem,
  BillItem.Product,
  BillItem.BillingDocumentItemText,
  customer.CustomerName,
  customer.TaxNumber3,
  customer.Customer_Pan,
  customer.TaxNumber2,
  customer.Region,
  BillItem.SalesDocument,
  salesdetails.PurchaseOrderByCustomer,
  salesdetails.CustomerPurchaseOrderDate,
  salesdetails.CreationDate,
  BillItem.ReferenceSDDocument,
  jou_entry.HSN_Code,
  BillItem.BillingQuantity,
  BillItem.BillingQuantityUnit,
  BillItem.SalesDocumentItemCategory,
  Itemprcg.ConditionRateAmount,
  //  Itemprcg1.ConditionAmount,
  //  Itemprcg1.TransactionCurrency,
  Itemprcg.TransactionCurrency,
  GLAcc.CompanyCodeCurrency,
  BillItem.NetAmount,
  BillItem.TaxAmount,
  Itemprcg.ConditionAmount,
  CGSTdetails.ConditionRateValue,
  CGSTdetails.ConditionAmount,
  SGSTdetails.ConditionRateValue,
  SGSTdetails.ConditionAmount,
  IGSTdetails.ConditionRateValue,
  IGSTdetails.ConditionAmount,
  TGSTdetails.ConditionRateValue,
  TGSTdetails.ConditionAmount,
  BillItem.TaxCode,
  BillItem.ShipToParty,
  Vendordetails.Supplier,
  FREIGHTEXP.PurchaseOrder,
  FREIGHTEXP.FrtCostAllocItemNetAmount,
  BillItem.SalesOffice,

  BillingHeader.SoldToParty,

  Broker.CustomerName,
  Trans.SupplierName,
  billi_doc_cube.AccountingExchangeRate,
  billi_doc_cube.Product,
  billi_doc_cube.ShipToParty,
  billi_doc_cube.ShipToPartyName,
  billi_doc_cube.BillToParty,
  billi_doc_cube.BillToPartyName,
  billi_doc_cube.BillToPartyRegion,
  billi_doc_cube.BillToPartyCountry,
  amortisation.ConditionAmount,
  roundoffvalue.ConditionAmount,
  jou_entry.AccountingDocument,
  jou_entry.FiscalYear,
  jou_entry.businessplace,
  org_gstin.Gstin,
  jou_entry.referencedocno,
  Cgst_gl.AmountInCompanyCodeCurrency,
  jou_entry.SGST,
  jou_entry.CGST,
  jou_entry.doccumentadate,
  jou_entry.DocumentDate,
  jou_entry.PostingDate,
  jou_entry.TaxCode,
  jou_entry.IGST,
  jou_entry.CGST_PERC,
  jou_entry.SGST_PERC,
  jou_entry.IGST_PERC,
  jou_entry.AccountingDocumentType,
  jou_entry.accdoctype,
  jou_entry.Distributionchannel,
  jou_entry.materialgroup,
  jou_entry.amcomp,
  Cgst_gl .AccountingDocumentType,
  sgst_gl.AmountInCompanyCodeCurrency,
  igst_gl.AmountInCompanyCodeCurrency,
  sgst_gl.AccountingDocumentType,
  igst_gl.AccountingDocumentType,
  jou_entry.BaseAmount,
  jou_entry.originalrefdocno,
  customer.Customer,
  jou_entry.Customer,
  jou_entry.gl_account,
  jou_entry.is_reversal,
  jou_entry.shiptoparty,
  jou_entry.customer_name,
  jou_entry.region,
  jou_entry.plant,
  jou_entry.trasns_curreency,
  jou_entry.transactioncurrency,
  jou_entry.absoexchrate,
  jou_entry.hsncode,
  cust.TaxNumber3,
  jou_entry.ReferenceDocumentItem,
  jou_entry.reversedocument,
  jou_entry.customer_name_,
  jou_entry.custo_name,
  jou_entry.is_reversed,
  CGST_usd.ConditionAmount,
  SGST_usd.ConditionAmount,
  jou_entry.itemno,
  igst_gl.AmountInTransactionCurrency,
  IGST_usd.ConditionAmount,
  jou_entry.ReversalDocument,
  BillingHeader.CustomerGroup
