@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'kotak incoming payment cds view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZKMB_INC_PAY_CDS
  as select from zcollection_dtls
  association [0..1] to zkmb_jvpost_tab_cds as jvpost on jvpost.Utrno = zcollection_dtls.utr_no
  //composition of target_data_source_name as _association_name
{
// @UI.facet: [{ id: 'DS',
//                purpose: #STANDARD,
//                type: #IDENTIFICATION_REFERENCE,
//                label: 'Incoming Payment Upload',
//                position: 01 }]

      @UI.lineItem: [{ position: 10,label: 'UTR Number' }, { type: #FOR_ACTION , dataAction: 'createaccdoc' , label: 'Post Accounting Document' } ]
      @UI.identification: [{ position: 10 }]
  key utr_no            as Utr_no,
      @UI: { lineItem:       [ { position: 20, label: 'TxnRefNumber'}],
         identification: [ { position: 20, label: 'TxnRefNumber'}] }
      txn_ref_no        as Txn_ref_no,
      @UI: { lineItem:       [ { position: 30, label: 'MasterACCNumber'}],
               identification: [ { position: 30, label: 'MasterACCNumber'}] }
      master_acc_no     as Master_acc_no,

      @UI: { lineItem:       [ { position: 40, label: 'RemittInfo'}],
      identification: [ { position: 40, label: 'RemittInfo'}] }
      remitt_info       as Remitt_info,
      @UI: { lineItem:       [ { position: 50, label: 'RemitName'}],
      identification: [ { position: 50, label: 'RemitName'}] }
      remit_name        as Remit_name,
      @UI: { lineItem:       [ { position: 60, label: 'RemitIfsc'}],
      identification: [ { position: 60, label: 'RemitIfsc'}] }
      remit_ifsc        as Remit_ifsc,
      @UI: { lineItem:       [ { position: 70, label: 'Referace1'}],
      identification: [ { position: 70, label: 'Referace1'}] }
      ref1              as Ref1,
      @UI: { lineItem:       [ { position: 80, label: 'Referace2'}],
      identification: [ { position: 80, label: 'Referace2'}] }
      ref2              as Ref2,
      @UI: { lineItem:       [ { position: 90, label: 'Referace3'}],
      identification: [ { position: 90, label: 'Referace3'}] }
      ref3              as Ref3,
      @UI: { lineItem:       [ { position: 100, label: 'Amount'}],
      identification: [ { position: 100, label: 'Amount'}] }
      amount            as Amount,
      @UI: { lineItem:       [ { position: 110, label: 'PayMode'}],
      identification: [ { position: 110, label: 'PayMode'}] }
      pay_mode          as Pay_mode,
      @UI: { lineItem:       [ { position: 110, label: 'ECollAccNo'}],
      identification: [ { position: 110, label: 'ECollAccNo'}] }
      e_coll_acc_no     as E_Coll_Acc_No,
      @UI: { lineItem:       [ { position: 120, label: 'RemitAcNmbr'}],
      identification: [ { position: 110, label: 'RemitAcNmbr'}] }
      remit_ac_nmbr     as Remit_Ac_Nmbr,
      @UI: { lineItem:       [ { position: 130, label: 'Creditdateandtime'}],
      identification: [ { position: 130, label: 'Creditdateandtime'}] }
      creditdateandtime as Creditdateandtime,
      @UI: { lineItem:       [ { position: 140, label: 'TxnDate'}],
      identification: [ { position: 140, label: 'TxnDate'}] }
      txn_date          as Txn_date,
      @UI: { lineItem:       [ { position: 150, label: 'BeneCustAcname'}],
      identification: [ { position: 150, label: 'BeneCustAcname'}] }
      bene_cust_acname  as Bene_Cust_Acname,
      
        @UI: { lineItem:       [ { position: 160, label: 'Accounting Document'}],
      identification: [ { position: 160, label: 'Accounting Document'}] }
      jvpost.Acountingdocument,
      
       @UI: { lineItem:       [ { position: 190, label: 'Status'}],
         identification: [ { position: 190, label: 'Status'}] }
      case
      when jvpost.Acountingdocument <> ''
      then 'Posted'
      else  'Not Posted'
      end                    as accdoccreated,

      @UI: { selectionField: [ { position:2  } ]}
      @EndUserText.label: 'Date'
      cast ( concat(
      concat( substring(txn_date, 1, 4), substring(txn_date, 6, 2) ),
      substring(txn_date, 9, 2)
      )  as abap.dats )      as valedate1



      // _association_name // Make association public
}
