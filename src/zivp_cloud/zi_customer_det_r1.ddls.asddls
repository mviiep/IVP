@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Personal Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Customer_Det_R1 as select from I_BillingDocumentBasic as BillingHeader
association [0..1] to  I_Customer as Customer
 on  Customer.Customer = BillingHeader.SoldToParty 
 and Customer.Language = 'E'


association [0..1] to I_BuPaIdentification as Pan
on Pan.BusinessPartner = BillingHeader.SoldToParty
and Pan.BPIdentificationType = 'ZPAN'
{
    key BillingHeader.SoldToParty as Payer,
     BillingHeader.BillingDocument as Billiing_Doc,
     Customer.CustomerName    ,
     Customer.CreationDate,
     Customer.TaxNumber3      ,
      Pan.BPIdentificationNumber as Customer_Pan,
     Customer.TaxNumber2         ,
     Customer.Region   
}
