@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TEST'
define root view entity ZSA_TEST 
  as select from  I_JournalEntry as g 
    inner join             I_JournalEntryItem as a  on  a.AccountingDocument   = g.AccountingDocument 
                                                    and a.CompanyCode          = g.CompanyCode
                                                    and a.FiscalYear           = g.FiscalYear
//                                                    and a.FinancialAccountType = 'K'
//                                                    and a.DebitCreditCode      = 'S'
//                                                    and a.Ledger               = '0L'                                              
                                              
//    inner join       I_OperationalAcctgDocItem as f on  a.AccountingDocument =  f.AccountingDocument
//                                                    and f.HouseBank          <> ''
//    inner join       I_BusinessPartnerBank     as c on a.Supplier = c.BusinessPartner
//    inner join       I_JournalEntry            as e on a.AccountingDocument = e.AccountingDocument
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
//         c.BankAccount                                as BENE_ACC_NO,
//         c.BankAccountReferenceText                   as BENE_ACC_NO_REFNO,
//         c.BankName                                   as BENE_ACC_NAME,
//         c.BankNumber                                 as BENE_IDN_CODE,
//         c.BankAccountHolderName                      as accountholdername,
//         a.Supplier                                   as beneficiaryid,
         a._Supplier.SupplierName,
         a._Supplier.AddressID                        as addr,
         a._SupplierCompany.
         PaymentMethodsList                           as Payment_method,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         case when a.AmountInCompanyCodeCurrency < 0
         then a.AmountInCompanyCodeCurrency * -1
         else a.AmountInCompanyCodeCurrency end       as inputdebitamount,
         a.Supplier                                   as supplierd,
         a.TransactionCurrency,
         a.PostingDate                                as inputvaluedate,
//         a.DebitCreditCode,
         cast( ' ' as abap.char(20) )                 as transaction_Type,
         cast( ' ' as abap.char(20) )                 as INPUT_BUSINESS_PROD,
         cast( ' ' as abap.char(20) )                 as beneficiary_Type,
         cast( ' ' as abap.char(20) )                 as payment_category

}
