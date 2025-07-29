@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Sales Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SALES_REGISTER
  as select distinct from I_BillingDocumentItemBasic as billingitem

  association [0..1] to I_BillingDocumentBasic         as BillingHeader on  BillingHeader.BillingDocument         = billingitem.BillingDocument
                                                                        and BillingHeader.AccountingPostingStatus = 'C'
  association [0..1] to I_BillingDocumentTypeText      as documenttype  on  documenttype.BillingDocumentType = billingitem.BillingDocumentType
                                                                        and documenttype.Language            = 'E'

  association [0..1] to ZI_PREC_INV_NO                 as PrecInv       on  PrecInv.BillingDocument        = billingitem.BillingDocument
  //                                                                        and PrecInv.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and PrecInv.SubsequentDocumentItem = billingitem.BillingDocumentItem
  association [0..1] to I_DistributionChannelText      as Distchannel   on  Distchannel.DistributionChannel = billingitem.DistributionChannel
                                                                        and Distchannel.Language            = 'E'

  association [0..1] to I_DivisionText                 as Division      on  Division.Division = billingitem.Division
                                                                        and Division.Language = 'E'

  association [0..1] to I_BillingDocumentItemBasic     as billingitem1  on  billingitem1.BillingDocument     = billingitem.BillingDocument
                                                                        and billingitem1.BillingDocumentItem = billingitem.BillingDocumentItem
  association [0..1] to ZI_Customer_Details            as customer      on  customer.Billiing_Doc    = billingitem.BillingDocument
                                                                        and customer.PartnerFunction = 'RE'
  //24,
  association [0..1] to I_SalesOrderItmPrecdgProcFlow  as itemflow1     on  billingitem.SalesDocument           = itemflow1.SalesOrder
                                                                        and billingitem.SalesDocumentItem       = itemflow1.SalesOrderItem
                                                                        and itemflow1.PrecedingDocumentCategory = 'G'

  //26,27,28,29
  association [0..1] to I_SalesOrder                   as salesdetails  on  salesdetails.SalesOrder = billingitem.SalesDocument
  association [0..1] to I_DeliveryDocument             as Delivery      on  Delivery.DeliveryDocument = billingitem.ReferenceSDDocument


  //32
  association [0..1] to I_AdditionalMaterialGroup1Text as Mattext       on  Mattext.AdditionalMaterialGroup1 = billingitem.AdditionalMaterialGroup1

  //36
  association [0..1] to I_ProductPlantBasic            as HSNcode       on  HSNcode.Product = billingitem.Product
                                                                        and HSNcode.Plant   = billingitem.Plant

  association [0..1] to I_AdditionalCustomerGroup1Text as Custgrp       on  Custgrp.AdditionalCustomerGroup1 = billingitem.CustomerGroup
                                                                        and Custgrp.Language                 = 'E'


  //37,38,39,40
  // association [0..1] to I_Batch as Batchdetails
  //  on Batchdetails.Batch = billingitem.Batch
  association [0..1] to I_DeliveryDocumentItem         as batchdetails // commented on 19.12.2023
                                                                        on  batchdetails.DeliveryDocument         = billingitem.ReferenceSDDocument
                                                                        and batchdetails.HigherLvlItmOfBatSpltItm = billingitem.ReferenceSDDocumentItem
                                                                        and batchdetails.Product                  = billingitem.Product
  //41,42
  // association [0..1] to
  //
  // //43,44,45,46
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg      on  Itemprcg.BillingDocument     =  billingitem.BillingDocument
                                                                        and Itemprcg.BillingDocumentItem =  billingitem.BillingDocumentItem
                                                                        and Itemprcg.ConditionRateAmount <> 0
                                                                        and Itemprcg.ConditionType       =  'ZDEV'
  //44
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg1     on  Itemprcg1.BillingDocument     = billingitem.BillingDocument
                                                                        and Itemprcg1.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and Itemprcg1.ConditionType       = 'YBHD'
  //45
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg2     on  Itemprcg2.BillingDocument     = billingitem.BillingDocument
                                                                        and Itemprcg2.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and Itemprcg2.ConditionType       = 'FIN1'
  //46
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Itemprcg3     on  Itemprcg3.BillingDocument     = billingitem.BillingDocument
                                                                        and Itemprcg3.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and Itemprcg3.ConditionType       = 'FPA1'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as unitrate      on  unitrate.BillingDocument     =  billingitem.BillingDocument
                                                                        and unitrate.BillingDocumentItem =  billingitem.BillingDocumentItem
                                                                        and unitrate.ConditionRateAmount <> 0
                                                                        and (
                                                                           unitrate.ConditionType        =  'ZDEV'
                                                                           or unitrate.ConditionType     =  'PMP0'
                                                                         )
  //50-61                                                                       START  //GST Details
  association [0..1] to I_BillingDocItemPrcgElmntBasic as CGSTdetails   on  CGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and CGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and CGSTdetails.ConditionType       = 'JOCG'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as SGSTdetails   on  SGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and SGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and SGSTdetails.ConditionType       = 'JOSG'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as IGSTdetails   on  IGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and IGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and IGSTdetails.ConditionType       = 'JOIG'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as UGSTdetails   on  UGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and UGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and UGSTdetails.ConditionType       = 'JOUG'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as TGSTdetails   on  TGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and TGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and (
                                                                           TGSTdetails.ConditionType        = 'JTC1'
                                                                           or TGSTdetails.ConditionType     = 'JTC2'
                                                                         )

  association [0..1] to I_BillingDocItemPrcgElmntBasic as VGSTdetails   on  VGSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and VGSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and VGSTdetails.ConditionType       = 'ZVAT'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as CSTdetails    on  CSTdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and CSTdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and CSTdetails.ConditionType       = 'ZCST'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as MRPdetails    on  MRPdetails.BillingDocument     = billingitem.BillingDocument
                                                                        and MRPdetails.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and MRPdetails.ConditionType       = 'ZMRP'

  association [0..1] to I_BillingDocItemPrcgElmntBasic as CRDNote       on  CRDNote.BillingDocument     = billingitem.BillingDocument
                                                                        and CRDNote.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and CRDNote.ConditionType       = 'ZCRN'
  //  END  //GST Details
  //Total Tax
  association [0..1] to I_BillingDocItemPrcgElmntBasic as Total         on  Total.BillingDocument = billingitem.BillingDocument


  //64
  // association [0..1] to  I_FrtCostAllocItm as PONo
  // on PONo.SettlmtSourceDoc = billingitem.SalesDocument
  //65
  association [0..1] to I_BillingDocumentPartner       as Vendordetails on  Vendordetails.BillingDocument = billingitem.BillingDocument
                                                                        and Vendordetails.PartnerFunction = 'U3'

  //69
  association [0..1] to I_FrtCostAllocItm              as Freightexp1   on  Freightexp1.SettlmtPrecdgDoc     = billingitem.ReferenceSDDocument
                                                                        and Freightexp1.SettlmtPrecdgDocItem = billingitem.ReferenceSDDocumentItem
  //                                                                          and Freightexp1.FrtCostAllocItemNetAmount >= 0
  //ADDED ON 11.10.2023
  association [0..1] to ZI_PUR_AND_FREIGHT1            as FREIGHTEXP    on  FREIGHTEXP.SettlmtSourceDoc          =  billingitem.SalesDocument
                                                                        and FREIGHTEXP.SettlmtSourceDocItem      =  billingitem.BillingDocumentItem
                                                                        and FREIGHTEXP.FrtCostAllocItemNetAmount >= 0
  //ADDED ON 11.10.2023

  //70
  association [0..1] to ZI_Customer_Details_R1         as Broker        on  Broker.Billiing_Doc = billingitem.BillingDocument

  // 74
  //association [0..1] to  I_JournalEntryItem as GLAcc
  association [0..1] to ZI_JournalEntry                as GLAcc

                                                                        on  GLAcc.BillingDocument = billingitem.BillingDocument // and
  //   GLAcc.PostingKey   = '50' and
  //   GLAcc.DebitCreditCode = 'H'
  //
  ////75
  association [0..1] to ZGLACCOUNTDATA                 as GLName        on  GLName.BillingDocument = billingitem.BillingDocument

  association [0..1] to ZI_TRANS_DETAILS               as Trans         on  Trans.BillingDocument = billingitem.BillingDocument
                                                                        and Trans.PartnerFunction = 'U3'
  association [0..1] to I_SalesDistrictText            as Salestxt      on  Salestxt.SalesDistrict = billingitem.SalesDistrict
                                                                        and Salestxt.Language      = 'E'
  association [0..1] to I_BillingDocumentItemPrcgElmnt as Disc          on  Disc.BillingDocument     = billingitem.BillingDocument
                                                                        and Disc.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and (
                                                                           Disc.ConditionType        = 'YK07'
                                                                           or Disc.ConditionType     = 'DM01'
                                                                           or Disc.ConditionType     = 'ZK07'
                                                                         )
  association [0..1] to I_BillingDocumentItemPrcgElmnt as Rebate        on  Rebate.BillingDocument     = billingitem.BillingDocument
                                                                        and Rebate.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and Rebate.ConditionType       = 'RES1'
  association [0..1] to ZI_paymentterm                 as PAY_TEXT      on  PAY_TEXT.BillingDocument = billingitem.BillingDocument

  association [0..1] to Zsales_exe_ASM                 as EXE_details   on  EXE_details.BillingDocument = billingitem.BillingDocument
  //                                                                        and EXE_details.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and EXE_details.PartnerFunction = 'VE'

  association [0..1] to zi_sales_cordinator            as ASM_details   on  ASM_details.BillingDocument = billingitem.BillingDocument
  //                                                                          and ASM_details.BillingDocumentItem = billingitem.BillingDocumentItem
                                                                        and (
                                                                           ASM_details.PartnerFunction  = 'ZS'
                                                                         )

  association [0..1] to I_BillingDocumentItem          as conversion    on  conversion.BillingDocument     = billingitem.BillingDocument
                                                                        and conversion.BillingDocumentItem = billingitem.BillingDocumentItem

  association [0..1] to I_SalesOfficeText              as Salestext     on  Salestext.SalesOffice = billingitem.SalesOffice
                                                                        and Salestext.Language    = 'E'

  association [0..1] to I_CustomerGroupText            as custtext      on  custtext.CustomerGroup = billingitem.CustomerGroup
                                                                        and custtext.Language      = 'E'

  ////////////////////////////////////////////////////////////////
  // Value Help logic
  association [0..1] to ZH_BILLINGType                 as _BT_HELP      on  $projection.Billing_Type = _BT_HELP.BillingDocumentType
  association [0..1] to ZH_DIVISION                    as _DIV_HELP     on  $projection.Division = _DIV_HELP.Division
  association [0..1] to ZHelp_product                  as _PDT_HELP     on  $projection.Product = _PDT_HELP.Product
  association [0..1] to ZI_PLant_SR                    as _plant        on  $projection.Plant = _plant.Plant
  //logic for irn
  association [0..1] to I_IN_ElectronicDocInvoice      as IRN           on  billingitem.BillingDocument = IRN.ElectronicDocSourceKey
  association [0..1] to ZI_BILLINGDOCUMENTPARTNER      as _shipto       on  billingitem.BillingDocument = _shipto.BillingDocument
                                                                        and _shipto.PartnerFunction     = 'WE'
  association [0..1] to ZI_BILLINGDOCUMENTPARTNER      as _billto       on  billingitem.BillingDocument = _billto.BillingDocument
                                                                        and _billto.PartnerFunction     = 'RE'
  association [0..1] to ZI_BILLINGDOCUMENTPARTNER      as _payer        on  billingitem.BillingDocument = _payer.BillingDocument
                                                                        and _payer.PartnerFunction      = 'RG'
  association [0..1] to ZI_BILLINGDOCUMENTPARTNER      as _trnsprtNm    on  billingitem.BillingDocument = _trnsprtNm.BillingDocument
                                                                        and _trnsprtNm.PartnerFunction  = 'U3'
  association [0..1] to ZI_Commission_Agent            as _CmmsnAgnt    on  billingitem.BillingDocument = _CmmsnAgnt.BillingDocument
                                                                        and _CmmsnAgnt.PartnerFunction  = 'ES'
  association [0..1] to I_ProductGroupText_2           as _PrdctgrpTxt  on  billingitem.ProductGroup = _PrdctgrpTxt.ProductGroup
                                                                        and _PrdctgrpTxt.Language    = 'E'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _InsAmnt      on  billingitem.BillingDocument     = _InsAmnt.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _InsAmnt.BillingDocumentItem
                                                                        and _InsAmnt.ConditionType          = 'FIN1'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _RndOffAmnt   on  billingitem.BillingDocument     = _RndOffAmnt.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _RndOffAmnt.BillingDocumentItem
                                                                        and _RndOffAmnt.ConditionType       = 'DRD1'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _CmmsnPrnct   on  billingitem.BillingDocument     = _CmmsnPrnct.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _CmmsnPrnct.BillingDocumentItem
                                                                        and _CmmsnPrnct.ConditionType       = 'ZCMR'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _CmmsnValue   on  billingitem.BillingDocument     = _CmmsnValue.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _CmmsnValue.BillingDocumentItem
                                                                        and _CmmsnValue.ConditionType       = 'ZCMP'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _AggrdValue   on  billingitem.BillingDocument         =  _AggrdValue.BillingDocument
                                                                        and billingitem.BillingDocumentItem     =  _AggrdValue.BillingDocumentItem
                                                                        and _AggrdValue.ConditionType           =  'ZAGR'
                                                                        and _AggrdValue.ConditionInactiveReason <> 'M'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _CustFrght    on  billingitem.BillingDocument     = _CustFrght.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _CustFrght.BillingDocumentItem
                                                                        and _CustFrght.ConditionType        = 'ZFRT'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _TrnsfrFrght  on  billingitem.BillingDocument     = _TrnsfrFrght.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _TrnsfrFrght.BillingDocumentItem
                                                                        and _TrnsfrFrght.ConditionType      = 'ZTFT'
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _ListPrice    on  billingitem.BillingDocument     = _ListPrice.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _ListPrice.BillingDocumentItem
                                                                        and _ListPrice.ConditionType        = 'PPR0'
  association [0..1] to I_ProductSalesDelivery         as _AvgCntPckgs  on  billingitem.Product                     = _AvgCntPckgs.Product
                                                                        and billingitem.DistributionChannel         = _AvgCntPckgs.ProductDistributionChnl
                                                                        and billingitem.SalesOrderSalesOrganization = _AvgCntPckgs.ProductSalesOrg
  association [0..1] to I_BillingDocItemPrcgElmntBasic as _curncy       on  billingitem.BillingDocument     = _curncy.BillingDocument
                                                                        and billingitem.BillingDocumentItem = _curncy.BillingDocumentItem
                                                                        and (
                                                                           _curncy.ConditionType            = 'PPR0'
                                                                           or _curncy.ConditionType         = 'PMP0'
                                                                         )
  association [0..1] to I_Plant                        as _plantdet     on  billingitem.Plant = _plantdet.Plant
  association [0..1] to I_IN_PlantBusinessPlaceDetail  as _plantgst     on  billingitem.Plant = _plantgst.Plant
  association [0..1] to ztab_j1ig_invref               as _einv         on  billingitem.BillingDocument = _einv.docno
  association [0..1] to ztab_eway_trans                as _einv1        on  billingitem.BillingDocument = _einv1.billingdocument
  //  association [0..1] to zplant_details                 as _plantgst     on  billingitem.Plant = _plantgst.plant
{
      //   @Consumption.valueHelpDefinition: [{entity: {element: 'Billing_Doc_No' , name: 'Z_I_BILLING_F4HELP'}}]
  key ltrim(billingitem.BillingDocument,'0')                                                                                                                                     as Invoice_No, //1
      billingitem.BillingDocument                                                                                                                                                as bd,
      billingitem.BillingDocumentDate                                                                                                                                            as Billing_date,
      billingitem.BillingDocumentType                                                                                                                                            as Billing_Type, //3
      documenttype.BillingDocumentTypeName                                                                                                                                       as Billing_Description, //4
      ltrim(PrecInv.GSTINVNO,'0')                                                                                                                                                as Ref_Invoice_No,
      case PrecInv.CreationDate
      when '0000-00-00' then ' '
      else
      //  PrecInv.CreationDate //as Preceding_Invoice_date,
      cast(
          concat(
            concat(
              concat(substring(PrecInv.CreationDate, 7, 2), '.' ),
              concat(substring(PrecInv.CreationDate, 5, 2), '.' )
            ),
            substring(PrecInv.CreationDate, 1, 4)
          )
        as abap.char( 10 ) )
        end                                                                                                                                                                      as Ref_Invoice_date,

      BillingHeader.DocumentReferenceID                                                                                                                                          as GST_Invoice_No, //7
      BillingHeader.AccountingDocument                                                                                                                                           as Accounting_Doc_No, //8
      billingitem.SalesOrderDistributionChannel                                                                                                                                  as Distribution_Channel, //9
      Distchannel.DistributionChannelName                                                                                                                                        as Dist_Channel_Desc, //10
      billingitem.Division                                                                                                                                                       as Division, //11
      Division.DivisionName                                                                                                                                                      as Division_Desc, //12
      billingitem.CustomerGroup                                                                                                                                                  as Customer_Group, //16
      //  Custgrp.AdditionalCustomerGroup1Name      as Customer_Group_Desc,
      custtext.CustomerGroupName                                                                                                                                                 as Cust_Group_Desc,
      ltrim(BillingHeader.PayerParty,'0')                                                                                                                                        as Customer_No, //17
      customer.CustomerName                                                                                                                                                      as Customer_Name, //18
      _shipto.Customer                                                                                                                                                           as ShipTo,                  //VISEN Rqrmnt
      _shipto.CustomerName                                                                                                                                                       as ShipToName,              //VISEN Rqrmnt
      _shipto.CustomerCIty                                                                                                                                                       as CustomerCity,
      _billto.Customer                                                                                                                                                           as BillTo,                  //VISEN Rqrmnt
      _billto.CustomerName                                                                                                                                                       as BillToName,              //VISEN Rqrmnt
      _payer.Customer                                                                                                                                                            as Payer,                   //VISEN Rqrmnt
      _payer.CustomerName                                                                                                                                                        as PayerName,               //VISEN Rqrmnt
      _trnsprtNm.SupplierName                                                                                                                                                    as TransporterName,         //VISEN Rqrmnt
      _CmmsnAgnt.Supplier                                                                                                                                                        as CommissionAgent,         //VISEN Rqrmnt
      _CmmsnAgnt.SupplierName                                                                                                                                                    as CommissionAgentName,     //VISEN Rqrmnt
      BillingHeader.IncotermsClassification                                                                                                                                      as IncotermsClassification, //VISEN Rqrmnt
      BillingHeader.CustomerPaymentTerms                                                                                                                                         as CustomerPaymentTerms,    //VISEN Rqrmnt
      _PrdctgrpTxt.ProductGroupName                                                                                                                                              as ProductGroupName,        //VISEN Rqrmnt
      billingitem.ProductHierarchyNode                                                                                                                                           as PrdctHrchy, //VISEN Rqrmnt
      billingitem.Batch                                                                                                                                                          as Batch,      //VISEN Rqrmnt
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(_InsAmnt.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 15, 2 ))                                           as InsuranceAmount, //VISEN Rqrmnt
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(_RndOffAmnt.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 15, 2 ))                                        as RoundOffAmount, //VISEN Rqrmnt
      cast(billingitem.NetAmount as abap.fltp) *
      cast(BillingHeader.AccountingExchangeRate  as abap.fltp)                                                                                                                   as SalesValueinLC, //VISEN Rqrmnt
      cast(billingitem.NetAmount as abap.fltp) *
      cast(BillingHeader.AccountingExchangeRate as abap.fltp)                                                                                                                    as TaxableValue,    //VISEN Rqrmnt
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _CmmsnPrnct.ConditionAmount                                                                                                                                                as CommisionPrcntg, //VISEN Rqrmnt
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _CmmsnValue.ConditionAmount                                                                                                                                                as CommisionValue,  //VISEN Rqrmnt
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _CmmsnPrnct.ConditionAmount + _CmmsnValue.ConditionAmount                                                                                                                  as TotCmsnAmnt,
      _AvgCntPckgs.DeliveryQuantityUnit                                                                                                                                          as DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      _AvgCntPckgs.DeliveryQuantity                                                                                                                                              as AvgCntPckgs,
      //  _FrghtAmnt.ConditionAmount                              as FreightAmount,
      billingitem._CreatedByUser.UserDescription                                                                                                                                 as CreatedByUser,
      billingitem.CreationDate                                                                                                                                                   as CreationDate,
      BillingHeader.AccountingExchangeRate                                                                                                                                       as AccountingExchangeRate,
      customer.CreationDate                                                                                                                                                      as Customer_creation_Date,
      //  case
      //  when ( billingitem.BillingDocumentDate =  customer.CreationDate ) then 'OLD Cust'
      //  else 'NEW Cust'
      //  end as Creation_Date,
      customer.TaxNumber3                                                                                                                                                        as Customer_GSTIN_No, //19
      //customer.OrganizationBPName1             as Customer_Pan,         //20
      customer.Customer_Pan                                                                                                                                                      as Customer_Pan,
      customer.TaxNumber2                                                                                                                                                        as Customer_Tin, //21
      //customer.Region                                      as Customer_State_Code,
      customer.Region                                                                                                                                                            as Region, //22
      //  customer.RegionName                                     as RegionName,
      salesdetails.PurchaseOrderByCustomer                                                                                                                                       as Customer_PO_No, // 26
      //salesdetails.CustomerPurchaseOrderDate as Customer_PO_Date,  // 27
      cast(
         concat(
           concat(
             concat(substring(salesdetails.CustomerPurchaseOrderDate, 7, 2), '.' ),
             concat(substring(salesdetails.CustomerPurchaseOrderDate, 5, 2), '.' )
           ),
           substring(salesdetails.CustomerPurchaseOrderDate, 1, 4)
         )
       as abap.char( 10 ))                                                                                                                                                       as Customer_PO_Date,
      ltrim(billingitem.SalesDocument,'0')                                                                                                                                       as sales_order_no,
      cast(
           concat(
             concat(
               concat(substring(salesdetails.CreationDate, 7, 2), '.' ),
               concat(substring(salesdetails.CreationDate, 5, 2), '.' )
             ),
             substring(salesdetails.CreationDate, 1, 4)
           )
         as abap.char( 10 ))                                                                                                                                                     as Sales_Order_Date,
      //case salesdetails.CreationDate
      //when '0000-00-00' then ' '
      //  else
      //  salesdetails.CreationDate end  as  Sales_Order_Date,
      ltrim(billingitem.BillingDocumentItem,'0')                                                                                                                                 as Item_No, //33
      @Semantics.quantity.unitOfMeasure: 'unit'
      case billingitem.SalesDocumentItemCategory
        when 'TANN' then (billingitem.BillingQuantity)
      //  else '000000'
        end                                                                                                                                                                      as Free_Quantity,
      billingitem.BillingQuantityUnit                                                                                                                                            as unit,
      //     case billingitem.BillingQuantityUnit
      //     when 'KI' then 'CRT'
      //     else   billingitem.BillingQuantityUnit             end  as      Units,
      ltrim(billingitem.ReferenceSDDocument,'0')                                                                                                                                 as Delivery_No,
      cast(
       concat(
         concat(
           concat(substring(Delivery.CreationDate, 7, 2), '.' ),
           concat(substring(Delivery.CreationDate, 5, 2), '.' )
         ),
         substring(Delivery.CreationDate, 1, 4)
       )
      as abap.char( 10 ))                                                                                                                                                        as Delivery_Date,
      BillingHeader.SalesDistrict                                                                                                                                                as Sales_District,
      Salestxt.SalesDistrictName                                                                                                                                                 as Sales_district_Desc,
      EXE_details.PersonFullName                                                                                                                                                 as Sales_Executive,
      ASM_details.PersonFullName                                                                                                                                                 as Sales_ASM,
      HSNcode.ConsumptionTaxCtrlCode                                                                                                                                             as HSN_Code, //36
      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      //   @Semantics.amount.currencyCode: 'ConditionRateAmount'

      case billingitem.SalesDocumentItemCategory
      when 'TAN' then
      cast(cast((unitrate.ConditionRateAmount) as abap.fltp ) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 15, 2 ))
      end                                                                                                                                                                        as Unit_Rate, //43
      ltrim(billingitem1.Product,'0')                                                                                                                                            as Product, //34
      billingitem1.BillingDocumentItemText                                                                                                                                       as Product_Name, //35
      GLAcc.GLAccount                                                                                                                                                            as GL_Account,
      GLName.GLAccountName                                                                                                                                                       as GL_Description,
      ltrim(batchdetails.Batch,'0')                                                                                                                                              as Batch_NO, //37
      //    batchdetails.batch
      @Semantics.quantity.unitOfMeasure: 'Unit'
      case billingitem.SalesDocumentItemCategory
      when 'TAN' then
      billingitem.BillingQuantity
      when 'TAD' then
      billingitem.BillingQuantity
      when 'G2N' then
      billingitem.BillingQuantity
      when 'L2N' then
      billingitem.BillingQuantity
      when 'JNLN' then
      billingitem.BillingQuantity
      when 'CBEN' then
      billingitem.BillingQuantity
      when 'CBXN' then
      billingitem.BillingQuantity
      when 'RENV' then
      billingitem.BillingQuantity                         end                                                                                                                    as Invoice_Qty, //40
      billingitem.BillingQuantityUnit                                                                                                                                            as Sales_Unit,
      PAY_TEXT.CustomerPaymentTermsName                                                                                                                                          as PAYMENT_TERM_TEXT,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Disc.ConditionAmount                                                                                                                                                       as Discount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Rebate.ConditionAmount                                                                                                                                                     as Rebate_discount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(billingitem.NetAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                              as Net_Amount, //48
      cast((CGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                                                    as CGST_RATE,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(CGSTdetails.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                        as CGST, //51
      cast((SGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                                                    as SGST_Rate, //52
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(SGSTdetails.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                        as SGST, //53
      cast((IGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                                                    as IGST_Rate, //54
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(IGSTdetails.ConditionAmount as abap.fltp)   * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                      as IGST, //55
      cast((UGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                                                    as UGST_Rate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(UGSTdetails.ConditionAmount as abap.fltp)   * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                      as UGST,
      cast((TGSTdetails.ConditionRateValue) as abap.dec(5,2))                                                                                                                    as TCS_Rate, //56
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(TGSTdetails.ConditionAmount as abap.fltp)   * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                      as TCS, //57
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(billingitem.TaxAmount as abap.fltp)   * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                            as Totaltax,
      @Semantics.amount.currencyCode: 'TransactionCurrency' //62
      MRPdetails.ConditionRateAmount                                                                                                                                             as MRP,
      //  billingitem.SalesOrderCustomerPriceGroup  as Price_Group,
      billingitem.MaterialPricingGroup                                                                                                                                           as Material_Pricing_Group,
      billingitem.ProductGroup                                                                                                                                                   as Material_Group,
      //    Mattext.AdditionalMaterialGroup1Name                    as Material_Group,
      @DefaultAggregation:#NONE
      //  @Semantics.amount.currencyCode: 'TransactionCurrency'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(Itemprcg1.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 15, 2 ))                                          as Freight_Amount, //44

      case billingitem.TaxAmount
      when 0.00000000000 then 'Exempted'
      else 'Taxable' end                                                                                                                                                         as Type,

      case billingitem.TaxAmount
      when 0.00000000000 then 'B2C'
      else 'B2B' end                                                                                                                                                             as Type_1,


      case customer.Region
      when 'MH' then 'MS'
      else 'OMS' end                                                                                                                                                             as region_type,

      conversion.BaseUnit                                                                                                                                                        as Base_unit1,
      case conversion.BaseUnit
      when 'EA' then 'CRT'
      else
      conversion.BaseUnit end                                                                                                                                                    as Base_unit,
      @Semantics.quantity.unitOfMeasure: 'unit'
      conversion.BillingQuantityInBaseUnit                                                                                                                                       as Conversion_Quantity,
      billingitem.SalesOffice                                                                                                                                                    as Sales_Office,
      Salestext.SalesOfficeName                                                                                                                                                  as Sales_office_Name,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      batchdetails.ActualDeliveryQuantity                                                                                                                                        as Batch_Qty,

      //   cast((Itemprcg.ConditionRateAmount * billingitem.BillingQuantity) as abap.dec(15,2)) as Basic_Amount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast((cast(billingitem.TaxAmount as abap.fltp) + cast(billingitem.NetAmount as abap.fltp)) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 )) as Billing_Amount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(Itemprcg.ConditionAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                           as Gross_value,
      PAY_TEXT.CompanyCode                                                                                                                                                       as Company_Code,
      PAY_TEXT.CompanyCodeName                                                                                                                                                   as Company_Name,

      billingitem.Plant,
      billingitem._Plant.PlantName,

      _plantgst._BusinessPlace.IN_GSTIdentificationNumber                                                                                                                        as plantgstin,
      _plantgst.BusinessPlace                                                                                                                                                    as BusinessPlace,
      _plantdet._StandardOrganizationAddress.CityName                                                                                                                            as PlantCity,
      //  CityName
      //  _plantdet._Customer.TaxNumber3                            as plantgstin,
      _plantdet._Supplier.TaxNumber3                                                                                                                                             as SuplPlantGSTIN,
      IRN.IN_ElectronicDocInvcRefNmbr                                                                                                                                            as IRN_No,
      IRN.IN_EDocEInvcEWbillNmbr                                                                                                                                                 as Eway_Bill,
      IRN.IN_EDocEInvcEWbillCreateDate                                                                                                                                           as Eway_BillDate,
      _einv1.transporterdocno                                                                                                                                                    as LRNo, //VISEN Rqrmnt
      IRN.IN_EDocEInvcTransptDocDate                                                                                                                                             as LRDate, //VISEN Rqrmnt
      cast(cast(CRDNote.ConditionRateValue as abap.fltp ) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as  abap.dec(10, 2))                                         as CRDNoteRate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(CRDNote.ConditionAmount as abap.fltp ) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as  abap.dec(15, 2))                                            as CRDNote,
      BillingHeader.SalesDistrict                                                                                                                                                as SalesDistrict,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(cast(_AggrdValue.ConditionAmount as abap.fltp ) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as  abap.dec(10, 2))                                        as AGRRED_PRICE,
      cast(cast((_CustFrght.ConditionRateAmount) as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                   as Customer_Freight,
      cast(cast(_TrnsfrFrght.ConditionRateAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                   as Transfer_Freight,
      cast(cast(_ListPrice.ConditionRateAmount as abap.fltp) * cast(BillingHeader.AccountingExchangeRate as abap.fltp) as abap.dec( 10, 2 ))                                     as List_Amount,
      customer.Customer_VAN                                                                                                                                                      as Customer_VAN,
      _einv.irn                                                                                                                                                                  as IRN,
      _einv.ewbno                                                                                                                                                                as EWB,
      _einv.ewbvalidtill                                                                                                                                                         as EWBVALIDITY,
      _einv.ewbdt                                                                                                                                                                as EWBDT,
      ltrim(Freightexp1.FreightOrder, '0')                                                                                                                                       as FreightOrdNo,
      _curncy.TransactionCurrency,
      _BT_HELP,
      _DIV_HELP,
      _PDT_HELP,
      _plant

}
where
      billingitem.BillingQuantity              is not initial
  and BillingHeader.AccountingPostingStatus    =  'C'
  and BillingHeader.BillingDocumentIsCancelled <> 'X'
  and BillingHeader.BillingDocumentType        <> 'S1'
  and BillingHeader.BillingDocumentType        <> 'S2'
