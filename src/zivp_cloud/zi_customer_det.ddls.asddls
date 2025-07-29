@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Customer_Det as select from I_BillingDocumentBasic as BillingHeader
association [0..1] to  I_Customer as Customer
 on  Customer.Customer = BillingHeader.PayerParty 
 and Customer.Language = 'E'


association [0..1] to I_BuPaIdentification as Pan
on Pan.BusinessPartner = BillingHeader.PayerParty
//and Pan.BPIdentificationType = 'ZPAN'
//association [0..1] to yy1_YY1_I_Customer as _customer
//on _customer.Customer = BillingHeader.PayerParty
//and _customer.Language = 'EN'
//and _customer.Country_4 = 'IN'


{
 
 key BillingHeader.PayerParty as Payer,
     BillingHeader.BillingDocument as Billiing_Doc,
     Customer.Customer,
     Customer.CustomerName    ,
     Customer.CreationDate,
     Customer.TaxNumber3      ,
    // pan.
  //  Customer.
//     Customer.OrganizationBPName1,
      Pan.BPIdentificationNumber as Customer_Pan,
     Customer.TaxNumber2         ,
     Customer.Region   
//     customer.          

   //  Customer.RegionName              as Region_Name
 //  key  
    
} //where BillingHeader.PayerParty = '0002500019'
