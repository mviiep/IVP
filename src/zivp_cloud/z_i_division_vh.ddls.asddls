@AbapCatalog.sqlViewName: 'ZI_DIV_VHELP'
//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Division'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
@ObjectModel.resultSet.sizeCategory: #XS
define view Z_I_DIVISION_VH as select from I_BillingDocumentBasic as Billingheader
{
    //    key Billingheader.BillingDocument as BillingDocument,
//    key Billingheader.BillingDocumentType as BillingDocumentType
       key Billingheader.Division
    
}

where Billingheader.AccountingPostingStatus = 'C' 
and   Billingheader.BillingDocumentIsCancelled <> 'X'
and   Billingheader.BillingDocumentType <> 'S1'
and   Billingheader.BillingDocumentType <> 'S2' 
group by Billingheader.Division //Billingheader.BillingDocumentType //, Billingheader.Division
