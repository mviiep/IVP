@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Email Address'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view entity Zi_emailaddress
  as select from I_AddressEmailAddress_2 as address
  association to zi_address_foremail as businesspartner on address.AddressID = businesspartner.AddressID
{
  key businesspartner.BusinessPartner,
      address.AddressID,
      address.EmailAddress
}
where
  businesspartner.BusinessPartner <> ''
