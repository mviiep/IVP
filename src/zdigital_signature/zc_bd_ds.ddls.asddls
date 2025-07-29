@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for bd ds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_BD_DS
  as projection on ZI_BD_DS
{
               @EndUserText.label: 'Document Number'
  key          BillingDocument,
               @EndUserText.label: 'Document Type'
               //          @Consumption.valueHelpDefinition: [{entity: {element: 'BillingDocumentType' , name: 'ZI_BD_DS_VH_BDT' }}]
               BillingDocumentType,
               BillingDocumentDate,
               CreatedByUser,
               CreationDate,
               CompanyCode,
               SalesOrganization,
               DistributionChannel,
               Division


}
