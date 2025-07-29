@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDFC Manual payment'
define root view entity ZMANUALPAYCDS_AP
  as select distinct from I_JournalEntryItem        as a
    left outer join       I_JournalEntryItem        as b on  a.AccountingDocument   = b.AccountingDocument
    //    //                                         and a.LedgerGLLineItem     = b.LedgerGLLineItem
                                                         and a.CompanyCode          = b.CompanyCode
                                                         and a.FiscalYear           = b.FiscalYear
                                                         and b.FinancialAccountType = 'K'
                                                         and b.DebitCreditCode      = 'S'
                                                         and b.Ledger               = '0L'
    left outer join       I_JournalEntryItem        as d on  a.AccountingDocument =  d.AccountingDocument
                                                         and d.Supplier           <> ''
    left outer join       I_OperationalAcctgDocItem as f on  a.AccountingDocument =  f.AccountingDocument
                                                         and f.HouseBank          <> ''
    left outer join       I_BusinessPartnerBank     as c on b.Supplier = c.BusinessPartner
    left outer join            I_JournalEntry            as e on a.AccountingDocument = e.AccountingDocument
                                                            and a.FiscalYear = e.FiscalYear
  //composition of target_data_source_name as _association_name
{

  key    a.CompanyCode,
  key    a.AccountingDocument                         as PAYMENT_REF_NO,
  key    a.FiscalYear,
  key    a.HouseBank,
  key    a.HouseBankAccount                           as Accountid,
  key    a.AccountingDocumentItem,
         a.GLAccount,
         a._JournalEntry.DocumentReferenceID,
         a.AccountingDocumentType,
         a._JournalEntry.AccountingDocumentHeaderText as UTR_number,
         a.PostingDate,
         c.BankAccount                                as BENE_ACC_NO,
         c.BankAccountReferenceText                   as BENE_ACC_NO_REFNO,
         c.BankName                                   as BENE_ACC_NAME,
         c.BankNumber                                 as BENE_IDN_CODE,
         c.BankAccountHolderName                      as accountholdername,
         b.Supplier                                   as beneficiaryid,
         b._Supplier.SupplierName,
         b._Supplier.AddressID                        as addr,
         b._SupplierCompany.
         PaymentMethodsList                           as Payment_method,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         case when f.AmountInCompanyCodeCurrency < 0
         then f.AmountInCompanyCodeCurrency * -1
         else f.AmountInCompanyCodeCurrency end       as inputdebitamount,
         b.Supplier                                   as supplierd,
         a.TransactionCurrency,
         a.PostingDate                                as inputvaluedate,
//         a.DebitCreditCode,
         cast( ' ' as abap.char(20) )                 as transaction_Type,
         cast( ' ' as abap.char(20) )                 as INPUT_BUSINESS_PROD,
         cast( ' ' as abap.char(20) )                 as beneficiary_Type,
         cast( ' ' as abap.char(20) )                 as payment_category,
         f.FiscalYear as backfisyear,
         e.IsReversed as isreversed

}
where
       a.HouseBank              <> ' '
  and  a.Ledger                 =  '0L'
  and  b.Supplier               <> ' '
  and  a.AccountingDocumentType =  'KZ'
  and(
       c.BankIdentification     =  '0001'
    or c.BankIdentification     =  'HC01'
  )
  and  e.IsReversal             =  ''
  //and  e.IsReversed             <>  'X'
