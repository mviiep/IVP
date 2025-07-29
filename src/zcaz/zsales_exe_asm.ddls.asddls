@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Sales Executive and Sales-ASM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zsales_exe_ASM
  as select from I_BillingDocumentPartnerBasic as PARTNER
  association [1] to I_PersonWorkAgreement_1 as P_BASIC on P_BASIC.Person = PARTNER.ReferenceBusinessPartner
{
  key PARTNER.BillingDocument,
      PARTNER.PartnerFunction,
      PARTNER.ReferenceBusinessPartner,
      P_BASIC.PersonFullName,
      PARTNER._DfltAddrRprstn._AddressPersonName.PersonFullName as PersonFullName1
}
