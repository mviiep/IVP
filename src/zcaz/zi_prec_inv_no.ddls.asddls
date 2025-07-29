@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Preceding Invoice Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PREC_INV_NO
  as select distinct from I_SalesOrderItmSubsqntProcFlow as Procflow1
    left outer join       I_BillingDocumentItemBasic     as Billingitem on Procflow1.SubsequentDocument = Billingitem.SalesDocument
    left outer join       I_SalesOrderItmSubsqntProcFlow as Procflow2   on  Procflow2.SalesOrder                 = Procflow1.SalesOrder
                                                                        and Procflow2.SubsequentDocumentItem     = Procflow1.SubsequentDocumentItem
                                                                        and Procflow2.SubsequentDocumentCategory = 'M'
    left outer join       I_BillingDocument              as _bd         on  Procflow2.SubsequentDocument   = _bd.BillingDocument
                                                                        and _bd.BillingDocumentIsCancelled = ''
                                                                        
    left outer join I_CustomerReturnItem as CR on  CR.CustomerReturn                 = Procflow1.SubsequentDocument
                                         and CR.CustomerReturnItem     = Procflow1.SubsequentDocumentItem
                                   
//                                                                        and Procflow2.SubsequentDocumentCategory = 'M'                                                                   
  //                                                                  and Procflow1.SubsequentDocumentCategory = 'M'
  //  association [1] to I_BillingDocumentItemBasic     as Billingitem on  Procflow1.SubsequentDocument = Billingitem.SalesDocument
  //  association [1] to I_SalesOrderItmSubsqntProcFlow as Procflow2   on  Procflow2.SalesOrder                 = Procflow1.SalesOrder
  //                                                                   and Procflow2.SubsequentDocumentItem     = Procflow1.SubsequentDocumentItem
  //                                                                   and Procflow2.SubsequentDocumentCategory = 'M'
  //    association [1] to I_BillingDocument              as _bd         on  Procflow1.SubsequentDocument         = _bd.BillingDocument
  //                                                                     and Procflow1.SubsequentDocumentCategory = 'M'
  //    association [1] to ZI_SalesOrdItmSbsqntPrcFlw     as _b          on  Procflow1.SubsequentDocument = _b.SubsequentDocument
  //                                                                     and Procflow1.SubsequentDocumentItem = _b.SubsequentDocumentItem
    left outer join       I_BillingDocumentBasic         as check       on Billingitem.BillingDocument = check.BillingDocument
    left outer join       I_CreditMemoRequestItem        as _cd         on  Billingitem.ReferenceSDDocument     = _cd.CreditMemoRequest
                                                                        and Billingitem.ReferenceSDDocumentItem = _cd.CreditMemoRequestItem //Added to check multiple line items
    left outer join       I_BillingDocument              as _bd1        on _cd.ReferenceSDDocument = _bd1.BillingDocument
 
    left outer join       I_DebitMemoRequestItem         as _dd         on  Billingitem.ReferenceSDDocument     = _dd.DebitMemoRequest
                                                                        and Billingitem.ReferenceSDDocumentItem = _dd.DebitMemoRequestItem //Added to check multiple line items
    left outer join       I_BillingDocument              as _bd2        on _dd.ReferenceSDDocument = _bd1.BillingDocument
     left outer join       I_BillingDocument              as CR2 on CR.ReferenceSDDocument =   CR2.BillingDocument
                                                                and CR2.BillingDocumentIsCancelled = ''   
{
  key Billingitem.BillingDocument,
  key Procflow1.SalesOrder              as Sal_ord,
  key Procflow1.SubsequentDocument      as Sub_1,
 
  key Procflow2.SubsequentDocumentItem,
      Procflow2.SubsequentDocumentCategory,
      //      Procflow2.SubsequentDocument,       "Reference inv no commented and instead of this we pass reference gstin inv no
      //      Procflow2.CreationDate,
      ////      _bd.DocumentReferenceID      as GSTINVNO,
      //              _b.DocumentReferenceID       as GSTINVNO2
      // for G2 gstinvno
      //     Billingitem1.BillingDocumentCategory,
      //      Billingitem1.ReferenceSDDocument,
      //      _cd.ReferenceSDDocument      as c_refdocument,
      ////      _bd1.DocumentReferenceID     as GSTINVNOG2
      case
      when check.BillingDocumentType = 'G2'
      then _bd1.CreationDate
      when check.BillingDocumentType = 'CBRE'
//      then _bd.CreationDate
then CR2.CreationDate
      when check.BillingDocumentType = 'L2'
      then _bd2.CreationDate end        as CreationDate,
      case
      when check.BillingDocumentType = 'G2'
      then _bd1.DocumentReferenceID
      when check.BillingDocumentType = 'CBRE'
//      then _bd.DocumentReferenceID
then CR2.DocumentReferenceID
      when check.BillingDocumentType = 'L2'
      then _bd2.DocumentReferenceID end as GSTINVNO
}
where
  _bd.BillingDocumentIsCancelled = ''
