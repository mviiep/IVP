@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Term Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_paymentterm
  as select from I_BillingDocumentBasic as HEADER
  association [0..1] to I_CustomerPaymentTermsText as PAY_TERM  on  PAY_TERM.CustomerPaymentTerms = HEADER.CustomerPaymentTerms
                                                                and PAY_TERM.Language             = 'E'

  association [0..1] to I_CompanyCode              as Comp_name on  Comp_name.CompanyCode = HEADER.CompanyCode


{
  key HEADER.BillingDocument,
      HEADER.CustomerPaymentTerms,
      PAY_TERM.CustomerPaymentTermsName,
      PAY_TERM.Language,
      Comp_name.CompanyCodeName,
      HEADER.CompanyCode
}
