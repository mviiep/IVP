@AbapCatalog.sqlViewName: 'ZI_SUBSZWNY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for subsqnt proc flow'
define view ZI_SalesOrdItmSbsqntPrcFlw
  as select from I_SalesOrderItmSubsqntProcFlow as a
  association [1] to I_BillingDocument as b on  a.SubsequentDocument         = b.BillingDocument
                                            and a.SubsequentDocumentCategory = 'M'
{
  key a.SalesOrder,
  key a.SubsequentDocument,
  key b.BillingDocument,
      a.SubsequentDocumentItem,
      a.SubsequentDocumentCategory,
      b.DocumentReferenceID
}
