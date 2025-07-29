@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Customer Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Customer_Details
  as select from I_BillingDocumentPartnerBasic as BillingHeader
  association [0..1] to I_Customer                 as Customer   on  Customer.Customer = BillingHeader.Customer
  //                                                         and Customer.Language = 'E'


  association [0..1] to I_BuPaIdentification       as Pan        on  Pan.BusinessPartner      = BillingHeader.Customer
                                                                 and Pan.BPIdentificationType = 'PAN'

  association [1..1] to I_Businesspartnertaxnumber as _taxnumber on  _taxnumber.BusinessPartner = BillingHeader.Customer

  association [0..1] to I_BuPaIdentification       as VAN        on  VAN.BusinessPartner      = BillingHeader.Customer
                                                                 and VAN.BPIdentificationType = 'ZVAN'
{
  key BillingHeader.Customer                                                                  as Payer,
      BillingHeader.PartnerFunction                                                           as PartnerFunction,
      BillingHeader.BillingDocument                                                           as Billiing_Doc,
      Customer.CustomerName,
      Customer.CreationDate,
      _taxnumber.BPTaxNumber                                                                  as TaxNumber3,
      Customer.Language,
      //     Customer.OrganizationBPName1,
      Pan.BPIdentificationNumber                                                              as Customer_Pan,
      VAN.BPIdentificationNumber                                                              as Customer_VAN,
      Customer.TaxNumber2,
      Customer.Region,
      Customer._AddressDefaultRepresentation._Region._RegionText[ Language = 'E' ].RegionName as RegionName
}
where
  Customer.Language = 'E'
