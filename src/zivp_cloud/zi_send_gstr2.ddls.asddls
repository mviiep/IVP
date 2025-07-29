@AbapCatalog.sqlViewName: 'ZI_SEND_GSTR2_SQ'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define root view ZI_SEND_GSTR2
  as select from ZI_GSTR1_SEND_MI as JournalItem
  association [0..1] to ZI_JOURNALENTRYITEM2           as JournalEntry    on  JournalItem.AccountingDocument    = JournalEntry.AccountingDocument
                                                                          and JournalEntry.Acctype              = 'S'
                                                                          and JournalItem.ReferenceDocumentItem = JournalEntry.ReferenceDocumentItem

  association [1]    to I_OperationalAcctgDocItem      as Acctgdoc        on  JournalItem.AccountingDocument = Acctgdoc.AccountingDocument
                                                                          and Acctgdoc.FinancialAccountType  = 'K'
  //Profit Center
  association [1]    to I_OperationalAcctgDocItem      as ProfitCenter    on  JournalItem.AccountingDocument =  ProfitCenter.AccountingDocument
                                                                          and JournalItem.AccItem            =  ProfitCenter.AccountingDocumentItem
                                                                          and ProfitCenter.ProfitCenter      <> ''

  association [1]    to I_OperationalAcctgDocItem      as Cgst_gl         on  JournalItem.AccountingDocument       = Cgst_gl.AccountingDocument
                                                                          and JournalItem.AMCOMP                   = Cgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and Cgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and Cgst_gl.TransactionTypeDetermination = 'JIC'

  association [1]    to I_OperationalAcctgDocItem      as sgst_gl         on  JournalItem.AccountingDocument       = sgst_gl.AccountingDocument
                                                                          and JournalItem.AMCOMP                   = sgst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and sgst_gl.AccountingDocumentItemType   = 'T'
                                                                          and sgst_gl.TransactionTypeDetermination = 'JIS'

  association [1]    to I_OperationalAcctgDocItem      as igst_gl         on  JournalItem.AccountingDocument       = igst_gl.AccountingDocument
                                                                          and JournalItem.AMCOMP                   = igst_gl.TaxBaseAmountInCoCodeCrcy
                                                                          and igst_gl.AccountingDocumentItemType   = 'T'
                                                                          and igst_gl.TransactionTypeDetermination = 'JII'

  //IS Tax Code
  //  association [1]    to I_OperationalAcctgDocItem      as igst_glis       on  JournalItem.AccountingDocument         = igst_glis.AccountingDocument
  //                                                                          and JournalItem.AMCOMP                     = igst_glis.TaxBaseAmountInCoCodeCrcy
  //                                                                          and igst_glis.AccountingDocumentItemType   = 'T'
  //                                                                          and (
  //                                                                             igst_glis.AccountingDocumentItem        = '003'
  //                                                                             or igst_glis.AccountingDocumentItem     = '005'
  //                                                                             or igst_glis.AccountingDocumentItem     = '007'
  //                                                                             or igst_glis.AccountingDocumentItem     = '009'
  //                                                                             or igst_glis.AccountingDocumentItem     = '011'
  //                                                                             or igst_glis.AccountingDocumentItem     = '013'
  //                                                                             or igst_glis.AccountingDocumentItem     = '015'
  //                                                                             or igst_glis.AccountingDocumentItem     = '017'
  //                                                                             or igst_glis.AccountingDocumentItem     = '019'
  //                                                                             or igst_glis.AccountingDocumentItem     = '021'
  //                                                                             or igst_glis.AccountingDocumentItem     = '023'
  //                                                                             or igst_glis.AccountingDocumentItem     = '025'
  //                                                                             or igst_glis.AccountingDocumentItem     = '027'
  //                                                                             or igst_glis.AccountingDocumentItem     = '029'
  //                                                                             or igst_glis.AccountingDocumentItem     = '031'
  //                                                                             or igst_glis.AccountingDocumentItem     = '033'
  //                                                                             or igst_glis.AccountingDocumentItem     = '035'
  //                                                                             or igst_glis.AccountingDocumentItem     = '037'
  //                                                                             or igst_glis.AccountingDocumentItem     = '039'
  //                                                                             or igst_glis.AccountingDocumentItem     = '041'
  //                                                                             or igst_glis.AccountingDocumentItem     = '043'
  //                                                                             or igst_glis.AccountingDocumentItem     = '045'
  //                                                                             or igst_glis.AccountingDocumentItem     = '047'
  //                                                                             or igst_glis.AccountingDocumentItem     = '049'
  //                                                                             or igst_glis.AccountingDocumentItem     = '051'
  //                                                                             or igst_glis.AccountingDocumentItem     = '053'
  //                                                                             or igst_glis.AccountingDocumentItem     = '055'
  //                                                                             or igst_glis.AccountingDocumentItem     = '057'
  //                                                                             or igst_glis.AccountingDocumentItem     = '059'
  //                                                                             or igst_glis.AccountingDocumentItem     = '061'
  //                                                                             or igst_glis.AccountingDocumentItem     = '063'
  //                                                                             or igst_glis.AccountingDocumentItem     = '065'
  //                                                                             or igst_glis.AccountingDocumentItem     = '067'
  //                                                                             or igst_glis.AccountingDocumentItem     = '069'
  //                                                                             or igst_glis.AccountingDocumentItem     = '071'
  //                                                                             or igst_glis.AccountingDocumentItem     = '073'
  //                                                                             or igst_glis.AccountingDocumentItem     = '075'
  //                                                                             or igst_glis.AccountingDocumentItem     = '077'
  //                                                                             or igst_glis.AccountingDocumentItem     = '079'
  //                                                                             or igst_glis.AccountingDocumentItem     = '081'
  //                                                                             or igst_glis.AccountingDocumentItem     = '083'
  //                                                                             or igst_glis.AccountingDocumentItem     = '085'
  //                                                                             or igst_glis.AccountingDocumentItem     = '087'
  //                                                                             or igst_glis.AccountingDocumentItem     = '089'
  //                                                                             or igst_glis.AccountingDocumentItem     = '091'
  //                                                                             or igst_glis.AccountingDocumentItem     = '093'
  //                                                                             or igst_glis.AccountingDocumentItem     = '095'
  //                                                                             or igst_glis.AccountingDocumentItem     = '097'
  //                                                                             or igst_glis.AccountingDocumentItem     = '099'
  //                                                                             or igst_glis.AccountingDocumentItem     = '101'
  //                                                                             or igst_glis.AccountingDocumentItem     = '103'
  //                                                                           )
  //                                                                          and igst_glis.TransactionTypeDetermination = ''

  association [1]    to ZI_RCM_DETAILS                 as RCM_Cgst_gl     on  JournalItem.AccountingDocument           = RCM_Cgst_gl.AccountingDocument

                                                                          and RCM_Cgst_gl.TaxItem                      = JournalItem.ReferenceDocumentItem
                                                                          and RCM_Cgst_gl.TransactionTypeDetermination = 'JRC'
  association [1]    to ZI_RCM_DETAILS                 as RCM_sgst_gl     on  JournalItem.AccountingDocument           = RCM_sgst_gl.AccountingDocument

                                                                          and RCM_sgst_gl.TaxItem                      = JournalItem.ReferenceDocumentItem
                                                                          and RCM_sgst_gl.TransactionTypeDetermination = 'JRS'
  association [1]    to ZI_RCM_DETAILS                 as RCM_igst_gl     on  JournalItem.AccountingDocument           = RCM_igst_gl.AccountingDocument
                                                                          and RCM_igst_gl.TaxItem                      = JournalItem.ReferenceDocumentItem
                                                                          and RCM_igst_gl.TransactionTypeDetermination = 'JRI'

  association [0..1] to I_JournalEntry                 as Jeheader        on  JournalItem.AccountingDocument = Jeheader.AccountingDocument
  association [1]    to I_JournalEntryItem             as Jeplant         on  JournalItem.AccountingDocument =  Jeplant.AccountingDocument
                                                                          and Jeplant.Plant                  <> ''

  association [1]    to I_JournalEntryItem             as HSN             on  JournalItem.AccountingDocument = HSN.AccountingDocument
                                                                          and HSN.FinancialAccountType       = 'K'

  association [0..1] to ZI_VENDOR_MASTER1              as VendorDetails   on  JournalItem.Supplier    = VendorDetails.Supplier
                                                                          and VendorDetails.Langauage = 'E'
                                                                          and VendorDetails.Country   = 'IN'
  association [0..1] to ZI_PO_MASTER1                  as PO_Master       on  JournalItem.ReferenceDocumentMIRO = PO_Master.SupplierInvoice
                                                                          and JournalItem.ReferenceDocumentItem = PO_Master.SupplierInvoiceItem
                                                                          and JournalItem.FiscalYear            = PO_Master.FiscalYear

  //  association [1..1] to ZGST_ITC_RECO                  as itc_reco        on  itc_reco.Accountingdocument = JournalItem.AccountingDocument
  association [1..1] to ZI_GST_ITC_RECO                as itc_reco        on  itc_reco.Accountingdocument = JournalItem.AccountingDocument

  association [0..1] to I_SupplierInvoiceAPI01         as SupplierInvoice on  SupplierInvoice.SupplierInvoice = JournalItem.ReferenceDocumentMIRO
                                                                          and SupplierInvoice.FiscalYear      = JournalItem.FiscalYear
  association [0..1] to I_PurOrdItmPricingElementAPI01 as POItemPricing   on  JournalItem.PurchasingDocument        = POItemPricing.PurchaseOrder
                                                                          and JournalItem.PurchasingDocumentItem    = POItemPricing.PurchaseOrderItem
                                                                          and (
                                                                             POItemPricing.ConditionType            = 'PMP0'
                                                                             or POItemPricing.ConditionType         = 'PPR0'
                                                                           )
                                                                          and POItemPricing.ConditionInactiveReason = ''
  association [0..1] to Z_Discount                     as Discount        on  JournalItem.ReferenceDocumentMIRO = Discount.ReferenceDocumentMIRO
                                                                          and JournalItem.ReferenceDocumentItem = Discount.ReferenceDocumentItem
                                                                          and JournalItem.FiscalYear            = Discount.FiscalYear

  association [0..1] to zgstr2_st                      as status          on  JournalItem.ReferenceDocumentMIRO = status.referencedocumentmiro

  association [0..1] to ZRECO_ACTION_HELP              as _rrfilter       on  $projection.reco_action = _rrfilter.ReverseResponsefilter

{
  key JournalItem.ReferenceDocumentMIRO                                                                                               as ReferenceDocumentMIRO,
  key JournalItem.ReferenceDocumentItem                                                                                               as ReferenceDocumentItem,
  key Jeheader.DocumentReferenceID,
      JournalItem.AccountingDocument                                                                                                  as AccountingDocument,
      JournalItem.PurchasingDocument                                                                                                  as PurchasingDocument,
      JournalItem.FiscalYear                                                                                                          as FiscalYear,
      JournalItem.PurchasingDocumentItem                                                                                              as PurchasingDocumentItem,
      JournalItem.Supplier                                                                                                            as Vendor,
      ProfitCenter.ProfitCenter                                                                                                       as ProftCenter,
      PO_Master.PurchaseOrderItemMaterial                                                                                             as MaterialCode,
      JournalItem.Doc_date                                                                                                            as InvoiceDate,
      JournalItem.PostingDate                                                                                                         as PostingDate,
      case when JournalItem.PurchasingDocument is not initial then
      SupplierInvoice.SupplierInvoiceIDByInvcgParty
      else
      Jeheader.DocumentReferenceID      end                                                                                           as RefDocNo,
      VendorDetails.SupplierName                                                                                                      as VendorName,
      Jeheader.IsReversal                                                                                                             as IsReversal,
      Jeheader.ReversalReferenceDocument                                                                                              as Reverse,
      VendorDetails.Region                                                                                                            as VendorRegion,
      VendorDetails.RegionName                                                                                                        as RegionName,
      VendorDetails.TaxNumber3                                                                                                        as GSTIN,
      VendorDetails.TaxNumber2                                                                                                        as TIN,
      VendorDetails.Panno                                                                                                             as PANNO,
      PO_Master.PurchasingGroup                                                                                                       as Department,
      case when JournalItem.PurchasingDocument is initial then
      Jeplant.Plant
      else
      PO_Master.plant                                                                                                       end       as BusinessArea,
      JournalItem.AMCOMP                                                                                                              as Amount,

      Jeheader.AccountingDocumentType                                                                                                 as Doctype,
      case when JournalItem.PurchasingDocument is initial then
      Jeplant.Plant
      else
      PO_Master.plant                                                                                                             end as Plant,
      JournalItem.GLCode                                                                                                              as GL_Code,
      PO_Master.Trans_Key                                                                                                             as Trans_Key,
      //      case when JournalItem.PurchasingDocument  is initial and JournalItem.TaxCode = 'IS'  then
      //       igst_glis.GLAccount else
      //       case when JournalItem.PurchasingDocument  is initial and JournalItem.TaxCode <> 'V0' then
      //      igst_gl.GLAccount else
      //      case when JournalItem.PurchasingDocument  is not initial and JournalItem.TaxCode <> 'V0' then
      //      igst_gl.GLAccount else
      //      case when JournalItem.TaxCode <> 'V0' then
      igst_gl.GLAccount                                                                                                               as igst_gl,
      case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode <> 'V0' then
      Cgst_gl.GLAccount else
      case when JournalItem.PurchasingDocument is not initial and JournalItem.TaxCode <> 'V0' then
      Cgst_gl.GLAccount else
      case when JournalItem.TaxCode <> 'V0' then
      Cgst_gl.GLAccount   end end end                                                                                                 as cgst_gl,
      case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode <> 'V0' then
      sgst_gl.GLAccount else
      case when JournalItem.PurchasingDocument is not initial and JournalItem.TaxCode <> 'V0' then
      sgst_gl.GLAccount else
      case when JournalItem.TaxCode <> 'V0' then
      sgst_gl.GLAccount   end end end                                                                                                 as sgst_gl,

      case when JournalItem.PurchasingDocument is not initial then
            PO_Master.DocumentCurrency
            else
            JournalItem.Compcurr end                                                                                                  as companycodecurrecy,

      status.status                                                                                                                   as Status,
      itc_reco.Status                                                                                                                 as reco_status,
      itc_reco.RecoAction                                                                                                             as reco_action,
      itc_reco.Reason                                                                                                                 as reason,
      itc_reco.RetenPostDoc                                                                                                           as retensionpostingdocno,
      itc_reco.ReverseRet                                                                                                             as revrseretensionpostingdocno,

      JournalItem.AMCOMP,



      case
        when PO_Master.PurchasingGroup = '001' then 'Group 001'
        when PO_Master.PurchasingGroup = '002' then 'Group 002'
        when PO_Master.PurchasingGroup = '003' then 'Group 003'
        when PO_Master.PurchasingGroup = '005' then 'Transportation Srv'
        when PO_Master.PurchasingGroup = '006' then 'TM – Ext. Planning'
        when PO_Master.PurchasingGroup = '007' then 'TM – Int. Planning'
        when PO_Master.PurchasingGroup = 'Z01' then 'Sales & Marketing'
        when PO_Master.PurchasingGroup = 'Z02' then 'Canteen Dept.'
        when PO_Master.PurchasingGroup = 'Z03' then 'Safety Dept.'
        when PO_Master.PurchasingGroup = 'Z04' then 'General Admin'
        when PO_Master.PurchasingGroup = 'Z05' then 'Accounts & Finance'
        when PO_Master.PurchasingGroup = 'Z06' then 'EDP/IT Dept.'
        when PO_Master.PurchasingGroup = 'Z07' then 'Store Dept.'
        when PO_Master.PurchasingGroup = 'Z08' then 'Purchase Dept.'
        when PO_Master.PurchasingGroup = 'Z09' then 'Civil Dept.'
        when PO_Master.PurchasingGroup = 'Z10' then 'Engineering Dept.'
        when PO_Master.PurchasingGroup = 'Z11' then 'Electrical Dept.'
        when PO_Master.PurchasingGroup = 'Z12' then 'Instrument Dept.'
        when PO_Master.PurchasingGroup = 'Z13' then 'Manufacturing Dept'
        when PO_Master.PurchasingGroup = 'Z14' then 'Sugar Godown'
        when PO_Master.PurchasingGroup = 'Z15' then 'Agriculture Dept.'
        when PO_Master.PurchasingGroup = 'Z16' then 'Cane - Yard'
        when PO_Master.PurchasingGroup = 'Z17' then 'Time Office Dept'
        when PO_Master.PurchasingGroup = 'Z18' then 'Security Dept.'
        when PO_Master.PurchasingGroup = 'Z19' then 'Vehicle Dept'
        when PO_Master.PurchasingGroup = 'Z20' then 'Distillery Dept.'
        when PO_Master.PurchasingGroup = 'Z21' then 'Co-gen Department'
        when PO_Master.PurchasingGroup = 'Z22' then 'WTP Department'
        when PO_Master.PurchasingGroup = 'Z23' then 'Petrol Pump'
        when PO_Master.PurchasingGroup = 'Z24' then 'ETP Department'
        when PO_Master.PurchasingGroup = 'Z25' then 'OHC / Medical Dept'
        when PO_Master.PurchasingGroup = 'Z26' then 'Sanitation Dept'
        when PO_Master.PurchasingGroup = 'Z27' then 'HR Dept.'
        end                                                                                                                           as DepartmentDescreption,
      PO_Master.PurchaseOrderItemText                                                                                                 as MaterialDescription,
      PO_Master.BaseUnit                                                                                                              as UOM,
      case when JournalItem.PurchasingDocument is not initial then
      PO_Master.ConsumptionTaxCtrlCode  else
               HSN.AssignmentReference          end                                                                                   as HSNCode,
      PO_Master.PurchaseOrderDate                                                                                                     as PurchaseOrderDate,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      PO_Master.OrderQuantity                                                                                                         as POrderQuantity,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      PO_Master.QuantityInPurchaseOrderUnit                                                                                           as QuantityInPurchaseOrderUnit,

      PO_Master.DocumentCurrency                                                                                                      as DocumentCurrency,

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.PurchasingDocument is not initial and  PO_Master.DocumentCurrency <> 'INR' and JournalItem.AMCOMP < 0 then
      JournalItem.AMCOMP * -1 else

      case when JournalItem.PurchasingDocument is  initial and JournalItem.AMCOMP < 0 then
      JournalItem.AMCOMP * -1 else

      case when JournalItem.PurchasingDocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.AMCOMP else
      case when JournalItem.PurchasingDocument is  initial   then

      JournalItem.AMCOMP
      else

      JournalItem.AMCOMP end end end end                                                                                              as NetInvoiceAmount,

      PO_Master.NetPriceAmount                                                                                                        as Rate,

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.DocNum = '13' then
      JournalItem.AMCOMP * -1  else
      //start of changes by Krishna 30/09/24
      case when JournalItem.AccountingDocumentType = 'KG' and JournalItem.AMCOMP < 0 then
      JournalItem.AMCOMP * -1 else
      //End of changes by Krishna 30/09/24
      case when JournalItem.PurchasingDocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.AMCOMP else
      case when JournalItem.PurchasingDocument is  initial then
      JournalItem.AMCOMP else
      JournalItem.AMCOMP end end end end                                                                                              as BaseAmount,
      POItemPricing.ConditionRateValue                                                                                                as ConditionRateValue,
      case when JournalItem.PurchasingDocument is not initial then
      PO_Master.TaxCode
      else
           JournalItem.TaxCode                                                                                                   end  as TAXCODE,
      @Semantics.amount.currencyCode: 'companycodecurrecy'
      PO_Master.NetPriceAmount                                                                                                        as amnt_com_curr,

      //******************************************************* sgst******************************************
      // Start of changes by Krishna 30/09/24
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AA' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AB'  or JournalItem.TaxCode = 'AK' or JournalItem.TaxCode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'AI' or JournalItem.TaxCode = 'AL' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AD' then //or JournalItem.taxcode = 'G4' or JournalItem.taxcode = 'AJ' or JournalItem.taxcode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'G4' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AJ' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial and JournalItem.TaxCode = 'AE' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AA' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AB' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AC' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AD' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AE' and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //
      //      and JournalItem.TaxCode = 'AA' then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //
      //      and JournalItem.TaxCode = 'AB'  or JournalItem.TaxCode = 'AK' or JournalItem.TaxCode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //
      //      and JournalItem.TaxCode = 'AC' or JournalItem.TaxCode = 'AI' or JournalItem.TaxCode = 'AL' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //
      //      and JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'AJ' or JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'AJ' or JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      //
      //      and JournalItem.TaxCode = 'AE' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AA' then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AB' then  //or JournalItem.taxcode = 'AK' or JournalItem.taxcode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AC' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AD' then //or JournalItem.taxcode = 'AJ' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AE' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp))
      //
      //        end end end end end end end end end end end end end end end end end end end end end end end end                               as SGST_per,
      case when JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'L1' or JournalItem.TaxCode = 'B1' or JournalItem.TaxCode = 'R1' or
                JournalItem.TaxCode = 'S1' or JournalItem.TaxCode = 'D1' then
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'L2' or JournalItem.TaxCode = 'B2' or JournalItem.TaxCode = 'R2' or
                JournalItem.TaxCode = 'S2' or JournalItem.TaxCode = 'D2' then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'L3' or JournalItem.TaxCode = 'B3' or JournalItem.TaxCode = 'R3' or
                JournalItem.TaxCode = 'S3' or JournalItem.TaxCode = 'D3' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'L4' or JournalItem.TaxCode = 'B4' or JournalItem.TaxCode = 'R4' or
                JournalItem.TaxCode = 'S4' or JournalItem.TaxCode = 'D4' then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'BB' or JournalItem.TaxCode = 'CC' or JournalItem.TaxCode = 'II' or
                JournalItem.TaxCode = 'DD' then
      cast(0 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'F1' then
      cast(0.0005 as abap.fltp) * cast(100 as abap.fltp)

      else
      cast(0 as abap.fltp) * cast(100 as abap.fltp)
      end end end end end end                                                                                                         as SGST_per,
      // End of changes by krishna 30/09/24

      @Semantics.amount.currencyCode: 'companycodecurrecy'
      case when JournalItem.DocNum = '13' and Cgst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      //Start of changes krishna 30/09/24
      case when JournalItem.AccountingDocumentType = 'KG' and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and Cgst_gl.AmountInCompanyCodeCurrency< 0 then
      Cgst_gl.AmountInCompanyCodeCurrency * -1
      else
      // End of changes Krishna 30/09/24

      case when JournalItem.PurchasingDocument is initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.PurchasingDocument is not initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial
      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      Cgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.DocNum = '13' and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      Cgst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.PurchasingDocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial then

      Cgst_gl.AmountInCompanyCodeCurrency else

      case when JournalItem.PurchasingDocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial then //and PO_Master.CGST is not initial then

      Cgst_gl.AmountInCompanyCodeCurrency
      else
      Cgst_gl.AmountInCompanyCodeCurrency
      end end end end end end end                                                                                                     as CGST,

      @Semantics.amount.currencyCode: 'companycodecurrecy'

      case when JournalItem.DocNum = '13' and sgst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else
      //Start of changes krishna 30/09/24
      case when JournalItem.AccountingDocumentType = 'KG' and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and sgst_gl.AmountInCompanyCodeCurrency < 0 then
      sgst_gl.AmountInCompanyCodeCurrency * -1
      else
      // End of changes Krishna 30/09/24

      case when JournalItem.PurchasingDocument is initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.PurchasingDocument is not initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial
      and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.DocNum = '13' and sgst_gl.AmountInCompanyCodeCurrency < 0 then
      sgst_gl.AmountInCompanyCodeCurrency * -1 else

      case when JournalItem.PurchasingDocument is initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial then
            sgst_gl.AmountInCompanyCodeCurrency else

           case when JournalItem.PurchasingDocument is not initial and sgst_gl.AmountInCompanyCodeCurrency is not initial
           and JournalItem.TaxCode <> 'V0' and JournalItem.TaxCode is not initial then   //and PO_Master.SGST is not initial then
                sgst_gl.AmountInCompanyCodeCurrency
          else
          sgst_gl.AmountInCompanyCodeCurrency
          end end end end end end end                                                                                                 as SGST,

      @Semantics.amount.currencyCode: 'companycodecurrecy'

      case when JournalItem.DocNum = '13' and igst_gl.AmountInCompanyCodeCurrency < 0
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      //Start of changes krishna 30/09/24
      case when JournalItem.AccountingDocumentType = 'KG' and igst_gl.AmountInCompanyCodeCurrency is not initial
      and igst_gl.AmountInCompanyCodeCurrency < 0 then
      igst_gl.AmountInCompanyCodeCurrency * -1
      else
      // End of changes Krishna 30/09/24

      //      case when JournalItem.PurchasingDocument is initial and igst_glis.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'IS' and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial  then
      //      igst_glis.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.PurchasingDocument is initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.PurchasingDocument is not initial
      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency * 0 else

      case when JournalItem.DocNum = '13' and igst_gl.AmountInCompanyCodeCurrency < 0 then
      igst_gl.AmountInCompanyCodeCurrency * -1 else

      //      case when JournalItem.PurchasingDocument is initial and igst_glis.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'IS' then
      //      igst_glis.AmountInCompanyCodeCurrency else

      case when JournalItem.PurchasingDocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial
       then

       igst_gl.AmountInCompanyCodeCurrency else

      case when JournalItem.PurchasingDocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial then
          igst_gl.AmountInCompanyCodeCurrency
      else
      igst_gl.AmountInCompanyCodeCurrency
      end end end end end end end                                                                                                     as IGST,
      //******************************************************* sgst******************************************

      //******************************************************* cgst******************************************

      // Start of changes by Krishna 30/09/24
      //      case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode = 'AA'
      //      and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'AK' or JournalItem.TaxCode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AC'  or JournalItem.TaxCode = 'AI' or JournalItem.TaxCode = 'AL' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AD' then //or JournalItem.taxcode = 'G4' or JournalItem.taxcode = 'AJ' or JournalItem.taxcode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'G4' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AJ' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      //      and JournalItem.TaxCode = 'AE' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp)) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AA' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AB' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AC' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AD' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AE' and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial
      //
      //      and JournalItem.TaxCode = 'AA' then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial
      //      and JournalItem.TaxCode = 'AB' or JournalItem.TaxCode = 'AK' or JournalItem.TaxCode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial
      //
      //      and JournalItem.TaxCode = 'AC'  or JournalItem.TaxCode = 'AI' or JournalItem.TaxCode = 'AL' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial
      //
      //      and JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'AJ' or JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is not initial
      //      and JournalItem.TaxCode = 'AD' or JournalItem.TaxCode = 'G4' or JournalItem.TaxCode = 'AJ' or JournalItem.TaxCode = 'AM' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial
      //
      //      and JournalItem.TaxCode = 'AE' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) else
      //
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AA' then
      //      cast(0.015 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AB'  then //JournalItem.taxcode = 'AK' or JournalItem.taxcode = 'AH' then
      //      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AC' then
      //      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AD' then
      //      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when PO_Master.SGST is not null and PO_Master.SupplierInvoiceItemAmount is not null
      //      and JournalItem.TaxCode = 'AE' then //or JournalItem.taxcode = 'AJ' then
      //      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp))
      //      end end end end end end end end end end end end end end end end end end end end end end end end                                 as CGST_per,

      case when JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'L1' or JournalItem.TaxCode = 'B1' or JournalItem.TaxCode = 'R1' or
                JournalItem.TaxCode = 'S1' or JournalItem.TaxCode = 'D1' then
      cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'L2' or JournalItem.TaxCode = 'B2' or JournalItem.TaxCode = 'R2' or
                JournalItem.TaxCode = 'S2' or JournalItem.TaxCode = 'D2' then
      cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'L3' or JournalItem.TaxCode = 'B3' or JournalItem.TaxCode = 'R3' or
                JournalItem.TaxCode = 'S3' or JournalItem.TaxCode = 'D3' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'L4' or JournalItem.TaxCode = 'B4' or JournalItem.TaxCode = 'R4' or
                JournalItem.TaxCode = 'S4' or JournalItem.TaxCode = 'D4' then
      floor(cast(0.14 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'BB' or JournalItem.TaxCode = 'CC' or JournalItem.TaxCode = 'II' or
                JournalItem.TaxCode = 'DD' then
      cast(0 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'F1' then
      cast(0.0005 as abap.fltp) * cast(100 as abap.fltp)

      else
      cast(0 as abap.fltp) * cast(100 as abap.fltp)
      end end end end end end                                                                                                         as CGST_per,
      // End of changes by Krishna 30/09/24

      //******************************************************* cgst******************************************

      //******************************************************* igst******************************************
      // Start of changes by Krishna 30/09/24
      //      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      //      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      //      and JournalItem.TaxCode = 'BA' then
      //      cast(0.05 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      //      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      //      and JournalItem.TaxCode = 'BB' and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.12 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      //      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      //      and JournalItem.TaxCode = 'BC' or JournalItem.TaxCode = 'BL' or JournalItem.TaxCode = 'E1'
      //      or JournalItem.TaxCode = 'E2' or JournalItem.TaxCode = 'E3' or JournalItem.TaxCode = 'F3' then
      //      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      //      and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      //      and JournalItem.TaxCode = 'IS' then
      //      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not null
      //      and JournalItem.TaxCode = 'BD' and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      //      cast(0.28 as abap.fltp) * cast(100 as abap.fltp) * cast(0 as abap.fltp) else
      //
      //      case when PO_Master.IGST is not null and POItemPricing.ConditionAmount is not null
      //      and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not null then
      //      cast( PO_Master.IGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp ) * cast(0 as abap.fltp) else
      //
      //      case when JournalItem.PurchasingDocument is initial
      //      and JournalItem.TaxCode = 'BA' then
      //      cast(0.05 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial
      //      and JournalItem.TaxCode = 'BB' then
      //      cast(0.12 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial
      //      and JournalItem.TaxCode = 'BC' or JournalItem.TaxCode = 'BL' or JournalItem.TaxCode = 'E1'
      //         or JournalItem.TaxCode = 'E2' or JournalItem.TaxCode = 'E3' or JournalItem.TaxCode = 'F3'
      //         or JournalItem.TaxCode = 'IS' then
      //      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when JournalItem.PurchasingDocument is initial
      //      and JournalItem.TaxCode = 'BD' then
      //      cast(0.28 as abap.fltp) * cast(100 as abap.fltp) else
      //      case when PO_Master.IGST is not null and POItemPricing.ConditionAmount is not null then
      //      cast( PO_Master.IGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )
      //      else
      //      case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode = 'IS' then
      //      ceil(cast(0.18 as abap.fltp) * cast(100 as abap.fltp))
      //      end end end end end end end end end end end end                                                                                 as IGST_per,
      case when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'L5' or JournalItem.TaxCode = 'B5' or JournalItem.TaxCode = 'R5' or
                JournalItem.TaxCode = 'S5' or JournalItem.TaxCode = 'D5' then
      cast(0.05 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'L6' or JournalItem.TaxCode = 'B6' or JournalItem.TaxCode = 'R6' or
                JournalItem.TaxCode = 'S6' or JournalItem.TaxCode = 'D6' then
      floor(cast(0.12 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'L7' or JournalItem.TaxCode = 'B7' or JournalItem.TaxCode = 'R7' or
                JournalItem.TaxCode = 'S7' or JournalItem.TaxCode = 'D7' then
      floor(cast(0.18 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'L8' or JournalItem.TaxCode = 'B8' or JournalItem.TaxCode = 'R8' or
                JournalItem.TaxCode = 'S8' or JournalItem.TaxCode = 'D8' then
      floor(cast(0.28 as abap.fltp) * cast(100 as abap.fltp)) else

      case when JournalItem.TaxCode = 'A0' or JournalItem.TaxCode = 'B0' or JournalItem.TaxCode = 'C0' or JournalItem.TaxCode = 'I0' or
                JournalItem.TaxCode = 'D0' or JournalItem.TaxCode = 'E0' then
      cast(0 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'E1' then
      cast(0.001 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.TaxCode = 'E2' then
      floor(cast(0.18 as abap.fltp) * cast(100 as abap.fltp))

      else
      cast(0 as abap.fltp) * cast(100 as abap.fltp)
      end end end end end end end                                                                                                     as IGST_per,
      // End of changes by Krishna 30/09/24

      case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode = 'IS' then
      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) end                                                                            as igst_perc,

      //******************************************************* igst******************************************


      //*******************************************************RSGST******************************************
      case when PO_Master.RSGST is not initial and PO_Master.SupplierInvoiceItemAmount is not initial then
       ceil (cast( PO_Master.RSGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else

      //RCM Percentage

      case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AH' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AI' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AJ' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AK' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AL' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AM' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AH' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AI' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AJ' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AK' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AL' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AM' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp)

          end end end end end end end end end end end end end                                                                         as RSGST_per,

      case when JournalItem.PurchasingDocument is initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.PurchasingDocument is not initial and RCM_sgst_gl.AmountInCompanyCodeCurrency is not initial then
      sgst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RSGST as abap.dec(16,2))
        end end                                                                                                                       as RSGST,

      //*******************************************************RSGST******************************************

      //*******************************************************RCGST******************************************
      case when PO_Master.RCGST is not null and PO_Master.SupplierInvoiceItemAmount is not null then
           ceil (cast( PO_Master.RCGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else

      case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AH' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AI' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AJ' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AK' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AL' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AM' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

      //RCM Percentage
      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AH' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AI' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AJ' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AK' then
       cast(0.025 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AL' then
        cast(0.06 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'AM' then
      cast(0.09 as abap.fltp) * cast(100 as abap.fltp)

          end end end end end end end end end end end end end                                                                         as RCGST_per,


      case when JournalItem.PurchasingDocument is initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
        Cgst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.PurchasingDocument is not initial and RCM_Cgst_gl.AmountInCompanyCodeCurrency is not initial then
        Cgst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RCGST as abap.dec(16,2))
       end end                                                                                                                        as RCGST,

      //*******************************************************RCGST******************************************

      case when JournalItem.PurchasingDocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
      and JournalItem.TaxCode = 'J1' then
      cast(0.18 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
       cast(0.5 as abap.fltp) * cast(100 as abap.fltp) else

      case when PO_Master.RIGST is not null and PO_Master.SupplierInvoiceItemAmount is not null then
           ceil (cast( PO_Master.RIGST as abap.fltp ) / cast( PO_Master.SupplierInvoiceItemAmount as abap.fltp ) * cast( 100 as abap.fltp )) else

       case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial
       and JournalItem.TaxCode = 'J1' then
        cast(0.18 as abap.fltp) * cast(100 as abap.fltp) else

       case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
       cast(0.5 as abap.fltp) * cast(100 as abap.fltp)
          end end end end end                                                                                                         as RIGST_per,

      case when JournalItem.PurchasingDocument is initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency
      else
      case when JournalItem.PurchasingDocument is not initial and RCM_igst_gl.AmountInCompanyCodeCurrency is not initial then
      igst_gl.AmountInCompanyCodeCurrency
      else
      fltp_to_dec (  PO_Master.RIGST as abap.dec(16,2)) end end                                                                       as RIGST,

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      //Start of changes krishna 30/09/24
      case when JournalItem.AccountingDocumentType = 'KG' and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
       +
      ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))

      else
      // End of changes Krishna 30/09/24
      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp) ) else

      case when JournalItem.DocNum = '13' and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))  else

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))  else

      case when JournalItem.DocNum = '13' and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp)) else

      case when JournalItem.PurchasingDocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp)) else

      case when JournalItem.PurchasingDocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp))  else

      //          case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode = 'IS' then
      //          ceil(cast(igst_glis.AmountInCompanyCodeCurrency as abap.fltp)) else

         case
         when Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp)) + ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp)) else

          case when igst_gl.AmountInCompanyCodeCurrency is not initial then
           ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp))

         end end end end end end end end end end end                                                                                  as TotaltaxAmount,

      //******************************************************TOTAL TAX AMOUNT*****************************************************


      //******************************************************TOTAL INVOICE*****************************************************
      @Semantics.amount.currencyCode: 'companycodecurrecy' //DocumentCurrency

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp )) else

      //Start of changes krishna 30/09/24
      case when  JournalItem.AccountingDocumentType = 'KG' and JournalItem.DocNum = '17' and JournalItem.AMCOMP < 0 then
       ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp ))
      else

      case when JournalItem.AccountingDocumentType = 'KG' and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
      ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
       +
      ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp))
       +
      ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp ))
      else
      // End of changes Krishna 30/09/24

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is not initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial and Cgst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp )) else

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ))
        +
        ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp ))  else

      case when JournalItem.DocNum = '13' and JournalItem.PurchasingDocument is not initial and igst_gl.AmountInCompanyCodeCurrency is not initial and igst_gl.AmountInCompanyCodeCurrency < 0 then
        ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp) * cast(-1 as abap.fltp ) )
        +
        ceil(cast(JournalItem.AMCOMP as abap.fltp)  * cast(-1 as abap.fltp ) ) else

      case when JournalItem.PurchasingDocument is initial and JournalItem.DocNum = '13' then
        ceil(cast(JournalItem.AMCOMP as abap.fltp) * cast(-1 as abap.fltp ))
        else

      case when JournalItem.PurchasingDocument is not initial and  PO_Master.DocumentCurrency <> 'INR' then
      JournalItem.AMCOMP else

      case when JournalItem.PurchasingDocument is initial and Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +

         ceil(cast(JournalItem.AMCOMP as abap.fltp)) else

         case when JournalItem.PurchasingDocument is initial and igst_gl.AmountInCompanyCodeCurrency is not initial
         then
          ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp))
          +
          ceil(cast(JournalItem.AMCOMP as abap.fltp))  else

      //          case when JournalItem.PurchasingDocument is initial and JournalItem.TaxCode = 'IS' then
      //          ceil(cast(igst_glis.AmountInCompanyCodeCurrency as abap.fltp))
      //          +
      //          ceil(cast(JournalItem.AMCOMP as abap.fltp))  else

          case when JournalItem.PurchasingDocument is not initial and JournalItem.TaxCode = 'G0' then
          ceil(cast(JournalItem.AMCOMP as abap.fltp))  else

          case when JournalItem.PurchasingDocument is initial
          then
          ceil(cast(JournalItem.AMCOMP as abap.fltp))
          else

         case
         when Cgst_gl.AmountInCompanyCodeCurrency is not initial then
          ceil(cast(Cgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
        ceil(cast(sgst_gl.AmountInCompanyCodeCurrency as abap.fltp))
         +
         ceil(cast(JournalItem.AMCOMP as abap.fltp))

         else
          case when igst_gl.AmountInCompanyCodeCurrency is not initial then
           ceil(cast(igst_gl.AmountInCompanyCodeCurrency as abap.fltp))
          +
          ceil(cast(JournalItem.AMCOMP as abap.fltp))
         end end end end end end end end end end end end end end                                                                      as Tot_Inv,


      //******************************************************TOTAL INVOICE*****************************************************

      PO_Master.ReferenceDocument                                                                                                     as ReferenceDocumentMIGO,

      Acctgdoc.BusinessPlace                                                                                                          as business_place,
      Acctgdoc.DocumentItemText                                                                                                       as Narration,
      Acctgdoc.WithholdingTaxCode                                                                                                     as tds_tax_code,

      case when JournalItem.PurchasingDocument is initial and JournalItem.ReferenceDocumentItem = '000002' then
      Acctgdoc.WithholdingTaxAmount else
      case when JournalItem.PurchasingDocument is not initial and JournalItem.ReferenceDocumentItem = '000001' then
      Acctgdoc.WithholdingTaxAmount
      end end                                                                                                                         as less_TDS

}
where
        JournalItem.Acctype                = 'S'
  and   JournalItem.DebitCreditCode        = 'S'
  or(
        JournalItem.DebitCreditCode        = 'H'
    and JournalItem.AccountingDocumentType = 'KG'
  )

group by
  JournalItem.ReferenceDocumentMIRO,
  JournalItem.ReferenceDocumentItem,
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.PurchasingDocumentItem,
  JournalItem.Supplier,
  PO_Master.PurchaseOrderItemMaterial,
  SupplierInvoice.DocumentDate,
  JournalItem.PostingDate,
  JournalItem.Doc_date,
  JournalItem.AccountingDocumentType,
  SupplierInvoice.SupplierInvoiceIDByInvcgParty,
  VendorDetails.SupplierName,
  VendorDetails.Region,
  VendorDetails.RegionName,
  VendorDetails.TaxNumber3,
  VendorDetails.TaxNumber2,
  VendorDetails.Panno,
  PO_Master.PurchasingGroup,
  status.status,
  itc_reco.Status,
  itc_reco.RecoAction,
  itc_reco.Reason,
  itc_reco.RetenPostDoc,
  itc_reco.ReverseRet,
  PO_Master.PurchaseOrderItemText,
  PO_Master.BaseUnit,
  PO_Master.ConsumptionTaxCtrlCode,
  PO_Master.PurchaseOrderDate,
  PO_Master.OrderQuantity,
  PO_Master.QuantityInPurchaseOrderUnit,
  PO_Master.DocumentCurrency,
  PO_Master.SupplierInvoiceItemAmount,
  PO_Master.NetPriceAmount,
  POItemPricing.ConditionAmount,
  POItemPricing.ConditionRateValue,
  PO_Master.TaxCode,
  HSN.AssignmentReference,
  PO_Master.SGST,
  PO_Master.CGST,
  PO_Master.IGST,
  PO_Master.RSGST,
  PO_Master.RCGST,
  PO_Master.RIGST,
  PO_Master.BusinessArea,
  Jeheader.AccountingDocumentType,
  Jeheader.DocumentReferenceID,
  PO_Master.plant,
  Jeplant.Plant,
  Jeplant.BusinessArea,
  PO_Master.Tot_Inv,
  PO_Master.ReferenceDocument,
  PO_Master.GL_Code,
  PO_Master.Trans_Key,
  PO_Master.IGST_GL,
  PO_Master.CGST_GL,
  PO_Master.SGST_GL,
  PO_Master.com_code_curr,
  JournalEntry.amcomp,
  JournalEntry.Trans_type,
  JournalEntry.TaxCode,
  Acctgdoc.BusinessPlace,
  Acctgdoc.DocumentItemText,
  Acctgdoc.WithholdingTaxCode,
  Acctgdoc.WithholdingTaxAmount,
  JournalEntry.Acctype,
  JournalItem.AMCOMP,
  JournalEntry.IGST_GL,
  JournalEntry.CGST_GL,
  JournalEntry.SGST_GL,
  JournalEntry.PurchasingDocument,
  JournalItem.Acctype,
  igst_gl.GLAccount,
  Cgst_gl.GLAccount,
  sgst_gl.GLAccount,
  Cgst_gl.AmountInCompanyCodeCurrency,
  sgst_gl.AmountInCompanyCodeCurrency,
  igst_gl.AmountInCompanyCodeCurrency,
  RCM_sgst_gl.AmountInCompanyCodeCurrency,
  RCM_Cgst_gl.AmountInCompanyCodeCurrency,
  RCM_igst_gl.AmountInCompanyCodeCurrency,
  //  igst_glis.AmountInCompanyCodeCurrency,
  //  igst_glis.GLAccount,
  JournalItem.TaxCode,
  JournalItem.GLCode,
  JournalEntry.doctype,
  JournalItem.Compcurr,
  ProfitCenter.ProfitCenter,
  Jeheader.IsReversal,
  Jeheader.ReversalReferenceDocument,
  JournalItem.DocNum
