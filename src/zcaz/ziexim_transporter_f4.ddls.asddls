@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Exim transporter'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ziexim_transporter_f4
  as select from I_BusinessPartner
{
  key BusinessPartner,
      BusinessPartnerName,
      BusinessPartnerType
}
where
  BusinessPartnerType = 'ZTRD'
