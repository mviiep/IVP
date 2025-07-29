@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Kotak bank status inquery log CDS'
define root view entity ZKOTAKBTCHLOGCDS as select from zkotakbatchlog
{
   key documentnumber as Documentnumber,
   key messageid as Messageid,
   utrnumber as Utrnumber,
   tnxstatus as Tnxstatus,
   tnxstatusdesc as Tnxstatusdesc,
   errordesc as Errordesc,
   rejectreason as Rejectreason,
   txndate as Txndate,
   txntime as Txntime 
    
}
