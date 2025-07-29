@AbapCatalog.sqlViewName: 'ZDIVISION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Division Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]

@ObjectModel.resultSet.sizeCategory: #XS
define view ZH_DIVISION as select from I_BillingDocumentBasic as Billingheader
{
       key Billingheader.Division
    
}
where Billingheader.AccountingPostingStatus = 'C' 
and   Billingheader.BillingDocumentIsCancelled <> 'X'
and   Billingheader.BillingDocumentType <> 'S1'
and   Billingheader.BillingDocumentType <> 'S2' 
group by Billingheader.Division //Billingheader.BillingDocumentType //, Billingheader.Division
