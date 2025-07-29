@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'xcel upload vertual account details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZXLUPLD_VA_DTLS as select from zdb_hdfctab
//composition of target_data_source_name as _association_name
{
    key alertsequenceno as Alertsequenceno,
    virtualaccount as Virtualaccount,
    accountnumber as Accountnumber,
    debitcredit as Debitcredit,
    amount as Amount,
    remittername as Remittername,
    remitteraccount as Remitteraccount,
    remitterbank as Remitterbank,
    remitterifsc as Remitterifsc,
    chequeno as Chequeno,
    userreferencenumber as Userreferencenumber,
    mnemoniccode as Mnemoniccode,
    valuedate as Valuedate,
    transactiondescription as Transactiondescription,
    transactiondate as Transactiondate
    //_association_name // Make association public
}
