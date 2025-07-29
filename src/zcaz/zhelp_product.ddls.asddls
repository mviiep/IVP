@AbapCatalog.sqlViewName: 'ZPRODUCT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PRODUCT Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]

@ObjectModel.resultSet.sizeCategory: #XS
define view ZHelp_product
  as select from I_BillingDocumentItemBasic as Billingitem
{
  key ltrim(Billingitem.Product,'0') as Product,
  key Billingitem.BillingDocumentItemText

}
group by
  Billingitem.Product,
  Billingitem.BillingDocumentItemText
