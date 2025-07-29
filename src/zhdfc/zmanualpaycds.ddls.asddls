@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDFC Manual payment'
define root view entity ZMANUALPAYCDS
  as select distinct from I_JournalEntryItem        as a
    inner join      I_JournalEntryItem        as b on  a.AccountingDocument   = b.AccountingDocument
    //    //                                         and a.LedgerGLLineItem     = b.LedgerGLLineItem
                                                         and a.CompanyCode          = b.CompanyCode
                                                         and a.FiscalYear           = b.FiscalYear
                                                         and b.FinancialAccountType = 'K'
                                                         and b.DebitCreditCode      = 'S'
                                                         and b.Ledger               = '0L'
    left outer join       I_JournalEntryItem        as d on  a.AccountingDocument =  d.AccountingDocument
                                                         and a.CompanyCode          = d.CompanyCode //FR
                                                         and a.FiscalYear           = d.FiscalYear  //FR
                                                         and d.Ledger               = '0L'          //FR
                                                         and d.Supplier           <> ''
    left outer join       I_OperationalAcctgDocItem as f on  a.AccountingDocument =  f.AccountingDocument
                                                          and a.CompanyCode          = f.CompanyCode //FR
                                                         and a.FiscalYear           = f.FiscalYear  //FR
                                                         and f.HouseBank          <> ''
    left outer join       I_BusinessPartnerBank     as c on d.Supplier = c.BusinessPartner
    inner join            I_JournalEntry            as e on a.AccountingDocument = e.AccountingDocument
                                                          and a.CompanyCode          = e.CompanyCode //FR
                                                         and a.FiscalYear           = e.FiscalYear  //FR
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

         d.Supplier                                   as beneficiaryid,
         d._Supplier.SupplierName,
         d._Supplier.AddressID                        as addr,
         d._SupplierCompany.
         PaymentMethodsList                           as Payment_method,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         case when f.AmountInCompanyCodeCurrency < 0
         then f.AmountInCompanyCodeCurrency * -1
         else f.AmountInCompanyCodeCurrency end       as inputdebitamount,
         d.Supplier                                   as supplierd,
         a.TransactionCurrency,
         a.PostingDate                                as inputvaluedate,
//         a.DebitCreditCode,
         cast( ' ' as abap.char(20) )                 as transaction_Type,
         cast( ' ' as abap.char(20) )                 as INPUT_BUSINESS_PROD,
         cast( ' ' as abap.char(20) )                 as beneficiary_Type,
         cast( ' ' as abap.char(20) )                 as payment_category
 
}
where
       a.HouseBank              <> ' '
 and   a.Ledger                 =  '0L'
 //  and a.FinancialAccountType = 'K' //fr
 //   and a.DebitCreditCode      = 'S' //fr
  and  b.Supplier               <> ' '
  and  a.AccountingDocumentType =  'KZ'
  and(
       c.BankIdentification     =  '0001'
    or c.BankIdentification     =  'HC01'
  )
  and  e.IsReversal             =  ''
  and  e.IsReversed             =  ''
//  and a._JournalEntry.DocumentReferenceID          =  ''
//  and a._JournalEntry.AccountingDocumentHeaderText =  ''
//group by
//  a.GLAccount,
//  a.CompanyCode,
//  a.AccountingDocument,
//  a.FiscalYear,
//  a.HouseBank,
//  a.HouseBankAccount,
//  a._JournalEntry.DocumentReferenceID,
//  a.AccountingDocumentType,
//  a._JournalEntry.AccountingDocumentHeaderText,
//  a.PostingDate,
//  c.BankAccount,
//  c.BankName,
//  c.BankNumber,
//  c.BankAccountHolderName,
//  b.Supplier,
//  b._Supplier.SupplierName,
//  b._Supplier.AddressID,
//  b._SupplierCompany.PaymentMethodsList,
//  a.TransactionCurrency,
//  a.PostingDate
