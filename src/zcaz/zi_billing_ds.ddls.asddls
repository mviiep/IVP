@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Billing Document DS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_billing_ds
  as select from I_BillingDocument as billhead
  association to ZI_DS_Plant as billplant on billplant.BillingDocument = billhead.BillingDocument
{


  key billhead.BillingDocument,
      @UI: { lineItem:       [ { position: 20, label: 'BillingDocumentType'}],
           identification: [ { position: 20, label: 'BillingDocumentType'}] }
      billhead.BillingDocumentType,
      @UI: { lineItem:       [ { position: 30, label: 'BillingDocumentDate'}],
       identification: [ { position: 30, label: 'BillingDocumentDate'}] }
      billhead.BillingDocumentDate,
      @UI: { lineItem:       [ { position: 40, label: 'CreatedByUser'}],
       identification: [ { position: 40, label: 'CreatedByUser'}] }
      billhead.CreatedByUser,
      @UI: { lineItem:       [ { position: 50, label: 'CreationDate'}],
       identification: [ { position: 50, label: 'CreationDate'}] }
      billhead.CreationDate,
      @UI: { lineItem:       [ { position: 60, label: 'CompanyCode'}],
       identification: [ { position: 60, label: 'CompanyCode'}] }
      billhead.CompanyCode,
      @UI: { lineItem:       [ { position: 70, label: 'SalesOrganization'}],
       identification: [ { position: 70, label: 'SalesOrganization'}] }
      billhead.SalesOrganization,
      @UI: { lineItem:       [ { position: 80, label: 'DistributionChannel'}],
       identification: [ { position: 80, label: 'DistributionChannel'}] }
      billhead.DistributionChannel,
      @UI: { lineItem:       [ { position: 90, label: 'Division'}],
       identification: [ { position: 90, label: 'Division'}] }
      billhead.Division,

      @UI: { lineItem:       [ { position: 100, label: 'Plant'}],
       identification: [ { position: 100, label: 'Plant'}] }
      billplant.Plant

}
