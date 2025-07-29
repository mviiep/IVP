@AbapCatalog.sqlViewName: 'ZZMANUALPAY_NEW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CdS for sum'
define view ZMANUALPAYCDS_NEW
  as select from ZMANUALPAYCDS
{
  key CompanyCode,
  key PAYMENT_REF_NO,
  key FiscalYear,
  key HouseBank,
  key Accountid,
      GLAccount,
      DocumentReferenceID,
      AccountingDocumentType,
      UTR_number,
      PostingDate,
      concat(BENE_ACC_NO , BENE_ACC_NO_REFNO ) as BENE_ACC_NO,
 //   BENE_ACC_NO,
    BENE_ACC_NO_REFNO,
   BENE_ACC_NAME,
    BENE_IDN_CODE,
    accountholdername,
      beneficiaryid,
      SupplierName,
      addr,
      Payment_method,
      sum(inputdebitamount) as inputdebitamount,
      TransactionCurrency,
      inputvaluedate,
      transaction_Type,
      INPUT_BUSINESS_PROD,
      beneficiary_Type,
      payment_category
}
group by
  GLAccount,
  CompanyCode,
  PAYMENT_REF_NO,
  DocumentReferenceID,
  FiscalYear,
  HouseBank,
  Accountid,
  UTR_number,
  AccountingDocumentType,
  UTR_number,
  PostingDate,
  BENE_ACC_NAME,
 BENE_ACC_NO,
 BENE_ACC_NO_REFNO,
  BENE_IDN_CODE,
  accountholdername,
  beneficiaryid,
  SupplierName,
  addr,
  Payment_method,
  TransactionCurrency,
  PostingDate,
  inputvaluedate,
  transaction_Type,
  INPUT_BUSINESS_PROD,
  beneficiary_Type,
  payment_category
