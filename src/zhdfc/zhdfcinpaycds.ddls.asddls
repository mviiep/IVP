@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDFC incoming payment cds'
define root view entity ZHDFCINPAYCDS as select from zhdfcincomingpay
//composition of target_data_source_name as _association_name
{
   key alrtsequenceno as Alrtsequenceno,
   key virtualaccno as Virtualaccno,
   key accountno as Accountno,
   debitcredeit as Debitcredeit,
   amount as Amount,
   remittername as Remittername,
   remitteraccount as Remitteraccount,
   remitterbank as Remitterbank,
   remitterifsc as Remitterifsc,
   chequeno as Chequeno,
   userrefno as Userrefno,
   mnemoniccode as Mnemoniccode,
   valuedate as Valuedate,
   transactiondesc as Transactiondesc,
   transactiondate as Transactiondate 
  
}
