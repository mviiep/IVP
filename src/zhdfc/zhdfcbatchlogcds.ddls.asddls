@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HDFC bank Batch log CDS view'
define root view entity ZHDFCBATCHLOGCDS as select from zhdfcbatchlog
{
    key documentnumber as Documentnumber,
    key referacenumber as Referacenumber,
    utrnumber as Utrnumber,
    tnxstatus as Tnxstatus,
    tnxstatusdesc as Tnxstatusdesc,
    errordesc as Errordesc,
    rejectreason as Rejectreason,
    txndate as Txndate,
    txntime as Txntime
  
}
