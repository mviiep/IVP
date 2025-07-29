@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Direct FI for sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_FI_JOURNAL_ENTRY 
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem         as GetSupplier on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                                  and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                                  and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                                  and GetSupplier.FinancialAccountType =  'D'
                                                                  and GetSupplier.Customer             <> ''

  association [1]    to I_OperationalAcctgDocItem  as cgst_amo    on  JournalItem.AccountingDocument          = cgst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = cgst_amo.AmountInCompanyCodeCurrency
                                                                  and cgst_amo.AccountingDocumentItemType     = 'T'
                                                                  and cgst_amo.TransactionTypeDetermination   = 'JOC'

  association [1]    to I_OperationalAcctgDocItem  as sgst_amo    on  JournalItem.AccountingDocument          = sgst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = sgst_amo.AmountInCompanyCodeCurrency
                                                                  and sgst_amo.AccountingDocumentItemType     = 'T'
                                                                  and sgst_amo.TransactionTypeDetermination   = 'JOS'

  association [1]    to I_OperationalAcctgDocItem  as igst_amo    on  JournalItem.AccountingDocument          = igst_amo.AccountingDocument
                                                                  and JournalItem.AmountInCompanyCodeCurrency = igst_amo.AmountInCompanyCodeCurrency
                                                                  and igst_amo.AccountingDocumentItemType     = 'T'
                                                                  and igst_amo.TransactionTypeDetermination   = 'JOI'

  association [1]    to I_OperationalAcctgDocItem  as customer    on  JournalItem.AccountingDocument = customer.AccountingDocument
                                                                  and customer.FinancialAccountType  = 'D'

  association [0..1] to I_ProductPlantBasic        as HSNcode     on  HSNcode.Product = JournalItem.Product
                                                                  and HSNcode.Plant   = JournalItem.Plant

  association [0..1] to I_OperationalAcctgDocItem  as HSN         on  JournalItem.AccountingDocument     = HSN.AccountingDocument
                                                                  and JournalItem.FiscalYear             = HSN.FiscalYear
                                                                  and JournalItem.AccountingDocumentItem = HSN.AccountingDocumentItem

  association [1]    to I_JournalEntry             as jeheader    on  JournalItem.AccountingDocument = jeheader.AccountingDocument

  association [1]    to I_Customer                 as custo       on  JournalItem.OffsettingAccount = custo.Customer
                                                                  and custo.Language                = 'E'

  association [0..1] to I_BillingDocumentItemBasic as BillItem    on  BillItem.BillingDocument     = JournalItem.ReferenceDocument
                                                                  and BillItem.BillingDocumentItem = JournalItem.ReferenceDocumentItem

  association [0..1] to I_GLAccountText            as GLDesc      on  $projection.GLAccount = GLDesc.GLAccount
                                                                  and GLDesc.Language       = $session.system_language
{
  key JournalItem.AccountingDocument                            as AccountingDocument,
  key JournalItem.AccountingDocumentItem                        as AccountingDocumentItem,
  key JournalItem.PurchasingDocument                            as PurchasingDocument,
  key JournalItem.FiscalYear                                    as FiscalYear,
      BillItem.BillingDocumentType                              as Billingtype,

      jeheader.OriginalReferenceDocument                        as Oiginalreferencedocumentno,
      JournalItem.ReferenceDocument                             as referencedocno,
      jeheader.DocumentReferenceID                              as originalrefdocno,
      JournalItem.DocumentDate                                  as DocumentDate,
      JournalItem.PostingDate                                   as PostingDate,
      JournalItem.OffsettingAccount                             as OffsettingAccount,
      JournalItem.PurchasingDocumentItem                        as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                               as DebitCreditCode,
      JournalItem.ReferenceDocument                             as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem                         as ReferenceDocumentItem,
      JournalItem.TaxCode                                       as TaxCode,
      JournalItem.GLAccount                                     as GLAccount,
      GLDesc.GLAccountLongName                                  as GLDesc,
      substring( HSNcode.ConsumptionTaxCtrlCode , 1 , 8 )       as HSN_Code,
      HSN.IN_HSNOrSACCode                                       as hsncode,
      HSN.BusinessPlace                                         as businessplace,
      JournalItem.DebitCreditCode                               as debitcredetcode,
      JournalItem.TransactionCurrency                           as trasns_curreency,

      case when JournalItem.TransactionCurrency <> 'INR' and JournalItem.AmountInTransactionCurrency is not initial then
      cast((JournalItem.AmountInTransactionCurrency) as abap.dec( 16, 2 )) *
      jeheader.AbsoluteExchangeRate
      when JournalItem.TransactionCurrency = 'INR' and JournalItem.AmountInTransactionCurrency is not initial then
      cast((JournalItem.AmountInTransactionCurrency) as abap.dec( 16, 2 ))

      end                                                       as BaseAmount,
      JournalItem.GLAccountType                                 as GLAccountType,
      JournalItem.IsReversal                                    as IsReversal,
      JournalItem.CompanyCodeCurrency                           as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'trasns_curreency'
      case when JournalItem.DebitCreditCode = 'H' then
      abs(JournalItem.AmountInTransactionCurrency) else
      JournalItem.AmountInTransactionCurrency end               as amountintransactioncurrency,

      JournalItem.DistributionChannel                           as Distributionchannel,

      JournalItem.SalesOrder                                    as salesorder,
      JournalItem.SalesOrderItem                                as salorderitem,
      JournalItem.SalesDocument                                 as salesdocument,
      JournalItem.SalesDocumentItem                             as salesdocitem,
      JournalItem.Product                                       as product,

      case when JournalItem.AccountingDocumentType = 'RV' then
      JournalItem.Plant
      when JournalItem.AccountingDocumentType = 'DR' or JournalItem.AccountingDocumentType = 'DG' then
      substring( JournalItem.ProfitCenter , 7 ,  4 ) end        as plant,

      JournalItem.DocumentDate                                  as doccumentadate,
      
      JournalItem.IsReversal                                    as is_reversal,
      JournalItem.IsReversed                                    as is_reversed,
      JournalItem.ReversalReferenceDocument                     as reversedocument, //added
      JournalItem.GLAccount                                     as gl_account, //added
      JournalItem.Customer                                      as customer_name, //added
      customer.Customer                                         as customer_name_,
      customer.CustomerGroup                                    as customer_group_,
      customer.Region                                           as region,
      JournalItem.CustomerGroup                                 as customer_group, //added
      custo.CustomerName                                        as custo_name,
      custo.Customer                                            as custo_number,

      case when JournalItem.IsReversal = 'X' and JournalItem.ReversalReferenceDocument <> ' ' then
      'Yes' else
      case when JournalItem.IsReversal = ' ' and JournalItem.ReversalReferenceDocument <> ' ' then
      'No'
      else 'Null'
      end end                                                   as ReversalDocument,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when JournalItem.AmountInCompanyCodeCurrency < 0 then
      ( JournalItem.AmountInCompanyCodeCurrency ) * ( -1 ) else
      ( JournalItem.AmountInCompanyCodeCurrency ) * (  1 )  end as amcomp,
      JournalItem.MaterialGroup                                 as materialgroup,
      JournalItem.AccountingDocumentType                        as accdoctype,
      JournalItem.ShipToParty                                   as shiptoparty,
      JournalItem.TransactionCurrency                           as transactioncurrency,
      jeheader.AbsoluteExchangeRate                             as absoexchrate,
      BillItem.BillingDocumentItem                              as itemno,

      //*************SGST
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sgst_amo.AmountInCompanyCodeCurrency                      as SGST,

      //*************SGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'BB'
      or JournalItem.TaxCode = 'CC' or JournalItem.TaxCode = 'II'
      then cast(0 as abap.fltp) 

      when JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'I1'
      or JournalItem.TaxCode = 'R1' or JournalItem.TaxCode = 'B1'
      or JournalItem.TaxCode = 'S1' or JournalItem.TaxCode = 'D1'
      then (cast(100 as abap.fltp)*0.025)

      when JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'I2'
      or JournalItem.TaxCode = 'R2' or JournalItem.TaxCode = 'B2'
      or JournalItem.TaxCode = 'S2' or JournalItem.TaxCode = 'D2'
      then (cast(100 as abap.fltp)*0.06)

      when JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'I3'
      or JournalItem.TaxCode = 'R3' or JournalItem.TaxCode = 'B3'
      or JournalItem.TaxCode = 'S3' or JournalItem.TaxCode = 'D3'
      then (cast(100 as abap.fltp)*0.09)

      when JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'I4'
      or JournalItem.TaxCode = 'R4' or JournalItem.TaxCode = 'B4'
      or JournalItem.TaxCode = 'S4' or JournalItem.TaxCode = 'D4'
      then (cast(100 as abap.fltp)*0.14)     
      end                                                       as SGST_PERC,

      //*************CGST
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cgst_amo.AmountInCompanyCodeCurrency                      as CGST,

      //*************CGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'AA' or JournalItem.TaxCode = 'BB'
      or JournalItem.TaxCode = 'CC' or JournalItem.TaxCode = 'II'
      or JournalItem.TaxCode = 'DD'
      then cast(0 as abap.fltp) 

      when JournalItem.TaxCode = 'A1' or JournalItem.TaxCode = 'I1'
      or JournalItem.TaxCode = 'R1' or JournalItem.TaxCode = 'B1'
      or JournalItem.TaxCode = 'S1' or JournalItem.TaxCode = 'D1'
      then (cast(100 as abap.fltp)*0.025)

      when JournalItem.TaxCode = 'A2' or JournalItem.TaxCode = 'I2'
      or JournalItem.TaxCode = 'R2' or JournalItem.TaxCode = 'B2'
      or JournalItem.TaxCode = 'S2' or JournalItem.TaxCode = 'D2'
      then (cast(100 as abap.fltp)*0.06)

      when JournalItem.TaxCode = 'A3' or JournalItem.TaxCode = 'I3'
      or JournalItem.TaxCode = 'R3' or JournalItem.TaxCode = 'B3'
      or JournalItem.TaxCode = 'S3' or JournalItem.TaxCode = 'D3'
      then (cast(100 as abap.fltp)*0.09)

      when JournalItem.TaxCode = 'A4' or JournalItem.TaxCode = 'I4'
      or JournalItem.TaxCode = 'R4' or JournalItem.TaxCode = 'B4'
      or JournalItem.TaxCode = 'S4' or JournalItem.TaxCode = 'D4'
      then (cast(100 as abap.fltp)*0.14)    
       end                                                      as CGST_PERC,

      //*************IGST
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      igst_amo.AmountInCompanyCodeCurrency                      as IGST,

      //*************IGST PERCENTAGE
      case
      when JournalItem.TaxCode = 'A5' or JournalItem.TaxCode = 'I5'
      or JournalItem.TaxCode = 'B5' or JournalItem.TaxCode = 'R5'
      or JournalItem.TaxCode = 'S5' or JournalItem.TaxCode = 'D5'
      then (cast(100 as abap.fltp)*0.05)

      when JournalItem.TaxCode = 'A6' or JournalItem.TaxCode = 'I6'
      or JournalItem.TaxCode = 'B6' or JournalItem.TaxCode = 'R6'
      or JournalItem.TaxCode = 'S6' or JournalItem.TaxCode = 'D6'
      then (cast(100 as abap.fltp)*0.12)

      when JournalItem.TaxCode = 'A7' or JournalItem.TaxCode = 'I7'
      or JournalItem.TaxCode = 'B7' or JournalItem.TaxCode = 'R7'
      or JournalItem.TaxCode = 'S7' or JournalItem.TaxCode = 'D7'
      then (cast(100 as abap.fltp)*0.18)

      when JournalItem.TaxCode = 'A8' or JournalItem.TaxCode = 'I8'
      or JournalItem.TaxCode = 'B8' or JournalItem.TaxCode = 'R8'
      or JournalItem.TaxCode = 'S8' or JournalItem.TaxCode = 'D8'
      then (cast(100 as abap.fltp)*0.28)
      end                                                       as IGST_PERC,

      case
      when JournalItem.TaxCode = 'F5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
        end                                                     as UTGST,

      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
        end                                                     as RSGST,
      case
      when JournalItem.TaxCode = 'R0'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.015)
      when JournalItem.TaxCode = 'J1' or JournalItem.TaxCode = 'R1'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.025)
      when JournalItem.TaxCode = 'J2' or JournalItem.TaxCode = 'R2'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.06)
      when JournalItem.TaxCode = 'J3' or JournalItem.TaxCode = 'R3'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.09)
      when JournalItem.TaxCode = 'J4' or JournalItem.TaxCode = 'R4'
      then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.14)
       end                                                      as RCGST,
      case
      when JournalItem.TaxCode = 'R5'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.03)
      when JournalItem.TaxCode = 'J5' or JournalItem.TaxCode = 'R6'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.05)
      when JournalItem.TaxCode = 'J6' or JournalItem.TaxCode = 'R7'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.12)
      when JournalItem.TaxCode = 'J7' or JournalItem.TaxCode = 'H7'
        or JournalItem.TaxCode = 'J8' or JournalItem.TaxCode = 'R8'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.18)
      when JournalItem.TaxCode = 'R9'
       then (cast(JournalItem.AmountInTransactionCurrency  as abap.fltp)*0.28)
        end                                                     as RIGST,

      case when JournalItem.Quantity is not initial and JournalItem.ReferenceDocumentType = 'VBRK' then
      'BaseAmt' else
      case when JournalItem.ReferenceDocumentType = 'BKPF' then
      'JOURNALENTRY_AMOUNT'
       end end                                                  as Qty,
      JournalItem.AccountingDocumentType                        as AccountingDocumentType,
      GetSupplier.Customer                                      as Customer,
      GetSupplier.Supplier                                      as supplier,
      JournalItem.OffsettingAccount                             as offsetting
}
where
       JournalItem.OffsettingAccount           <> ''
  and  JournalItem.Ledger                      =  '0L'
  and  JournalItem.AmountInCompanyCodeCurrency <> 0
  and  JournalItem.FinancialAccountType        =  'S'
  and  JournalItem.ReferenceDocumentItem       <> '000000'
  and(
       JournalItem.AccountingDocumentType      =  'DR'
    or JournalItem.AccountingDocumentType      =  'DG'
    or JournalItem.AccountingDocumentType      =  'RV'
    or JournalItem.AccountingDocumentType      =  'Z1'
    or JournalItem.AccountingDocumentType      =  'Z2'
  )
  and  JournalItem.GLAccount                   <> '0010504010'
  and  JournalItem.GLAccount                   <> '0010504020'
  and  JournalItem.GLAccount                   <> '0010504030'
