@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sales Co-ordinator details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_sales_cordinator
  as select from I_BillingDocumentPartner as PARTNER
  //  association [0..1] to I_BillingDocumentItemBasic as billingitem on  billingitem.BillingDocument     = PARTNER.BillingDocument
  //                                                                  and billingitem.BillingDocumentItem = PARTNER.BillingDocumentItem
  //                                                                  and (
  //                                                                     PARTNER.PartnerFunction          = 'VE'
  //                                                                     or PARTNER.PartnerFunction       = 'ZA'
  //                                                                     or PARTNER.PartnerFunction       = 'ZC'
  //                                                                     or PARTNER.PartnerFunction       = 'ZS'
  //                                                                   )

  association [1] to I_PersonWorkAgreement_1 as P_BASIC on P_BASIC.Person = PARTNER.ReferenceBusinessPartner
{
  key PARTNER.BillingDocument,
//  key partner.BillingDocumentItem,
      PARTNER.PartnerFunction,
      PARTNER.ReferenceBusinessPartner,
      P_BASIC.PersonFullName
}
