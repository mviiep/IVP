@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address ID for Email'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_address_foremail
  as select from I_BusinessPartner //zi_address_foremail

{
  key I_BusinessPartner.BusinessPartner,
      I_BusinessPartner._CurrentDefaultAddress.AddressID

}
where
  I_BusinessPartner._CurrentDefaultAddress.AddressID <> ''
