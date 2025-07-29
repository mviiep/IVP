@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for HDFC Json'
define root view entity zi_hdfcjson_cds
  as select from zdb_hdfctab
  association [0..1] to zi_hdfctab_ad    as withaccdoc on  withaccdoc.Alertsequenceno = zdb_hdfctab.alertsequenceno
  association [0..1] to zi_hdfc_customer as _customer  on  _customer.alertsequenceno = zdb_hdfctab.alertsequenceno
                                                       and _customer.virtualaccount  = zdb_hdfctab.virtualaccount
{

//      @UI.facet: [{ id: 'DS',
//                purpose: #STANDARD,
//                type: #IDENTIFICATION_REFERENCE,
//                label: 'Incoming Payment Upload',
//                position: 01 }]

      @UI.lineItem: [{ position: 10,label: 'Alert Sequence No' }, { type: #FOR_ACTION , dataAction: 'createaccdoc' , label: 'Post Accounting Document' } ]
      @UI.identification: [{ position: 10 }]
  key alertsequenceno        as AlertSequenceNo,

      @UI: { lineItem:       [ { position: 20, label: 'VirtualAccount'}],
          identification: [ { position: 20, label: 'VirtualAccount'}] }
      virtualaccount         as VirtualAccount,

      @UI: { lineItem:       [ { position: 30, label: 'Customer'}],
                identification: [ { position: 30, label: 'Customer'}] }
      _customer.customer     as Customer,

      @UI: { lineItem:       [ { position: 40, label: 'Customer Name'}],
          identification: [ { position: 40, label: 'Customer Name'}] }
      _customer.CustomerName,

      @UI: { lineItem:       [ { position: 50, label: 'Accountnumber'}],
          identification: [ { position: 50, label: 'Accountnumber'}] }
      accountnumber          as Accountnumber,

      @UI: { lineItem:       [ { position: 60, label: 'DebitCredit'}],
          identification: [ { position: 60, label: 'DebitCredit'}] }
      debitcredit            as DebitCredit,

      @UI: { lineItem:       [ { position: 70, label: 'Amount'}],
      identification: [ { position: 70, label: 'Amount'}] }
      amount                 as Amount,

      @UI: { lineItem:       [ { position: 80, label: 'RemitterName'}],
      identification: [ { position: 80, label: 'RemitterName'}] }
      remittername           as RemitterName,

      @UI: { lineItem:       [ { position: 90, label: 'RemitterAccount'}],
      identification: [ { position: 90, label: 'RemitterAccount'}] }
      remitteraccount        as RemitterAccount,

      @UI: { lineItem:       [ { position: 100, label: 'RemitterBank'}],
      identification: [ { position: 100, label: 'RemitterBank'}] }
      remitterbank           as RemitterBank,

      @UI: { lineItem:       [ { position: 110, label: 'RemitterIFSC'}],
      identification: [ { position: 110, label: 'RemitterIFSC'}] }
      remitterifsc           as RemitterIFSC,

      @UI: { lineItem:       [ { position: 120, label: 'ChequeNo'}],
      identification: [ { position: 120, label: 'ChequeNo'}] }
      chequeno               as ChequeNo,

      @UI: { lineItem:       [ { position: 130, label: 'UserReferenceNumber'}],
      identification: [ { position: 130, label: 'UserReferenceNumber'}] }
      userreferencenumber    as UserReferenceNumber,

      @UI: { lineItem:       [ { position: 140, label: 'MnemonicCode'}],
      identification: [ { position: 140, label: 'MnemonicCode'}] }
      mnemoniccode           as MnemonicCode,

      @UI: { lineItem:       [ { position: 150, label: 'ValueDate'}],
      identification: [ { position: 150, label: 'ValueDate'}] }
      valuedate              as ValueDate,

      @UI: { lineItem:       [ { position: 160, label: 'TransactionDescription'}],
      identification: [ { position: 160, label: 'TransactionDescription'}] }
      transactiondescription as TransactionDescription,

      @UI: { lineItem:       [ { position: 170, label: 'TransactionDate'}],
      identification: [ { position: 170, label: 'TransactionDate'}] }
      transactiondate        as TransactionDate,

      @UI: { lineItem:       [ { position: 180, label: 'Accounting Document'}],
      identification: [ { position: 180, label: 'Accounting Document'}] }
      withaccdoc.Acountingdocument,

      @UI: { lineItem:       [ { position: 190, label: 'Status'}],
         identification: [ { position: 190, label: 'Status'}] }
      case
      when withaccdoc.Acountingdocument <> ''
      then 'Posted'
      else  'Not Posted'
      end                    as accdoccreated,

      @UI: { selectionField: [ { position:2  } ]}
      @EndUserText.label: 'Date'
      cast ( concat(
      concat( substring(valuedate, 1, 4), substring(valuedate, 6, 2) ),
      substring(valuedate, 9, 2)
      )  as abap.dats )      as valedate1

}
