@AbapCatalog.sqlViewName: 'ZI_CUST_DETSOC1'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'so'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view ZI_Customer_DetailsSOC1
  as select from I_Customer as Customer
  association [0..1] to I_RegionText               as _regiondescp on  _regiondescp.Region   = Customer.Region
                                                                   and _regiondescp.Country  = Customer.Country
                                                                   and _regiondescp.Language = 'E'
  association [0..1] to I_SalesDocumentPartner     as _SDPartner   on  _SDPartner.Customer = Customer.Customer
  association [0..1] to I_Supplier                 as _Supplier    on  Customer.Supplier = _Supplier.Supplier
  association [0..1] to I_BuPaIdentification       as _Fassai      on  Customer.Customer            = _Fassai.BusinessPartner
                                                                   and _Fassai.BPIdentificationType = 'ZFFSAI'
  association [0..1] to I_BuPaIdentification       as _PAN         on  Customer.Customer         = _PAN.BusinessPartner
                                                                   and _PAN.BPIdentificationType = 'PAN'
  association [0..1] to I_Businesspartnertaxnumber as _GSTIN       on  Customer.Customer = _GSTIN.BusinessPartner
                                                                   and _GSTIN.BPTaxType  = 'IN3'
{
  key _SDPartner.SalesDocument                                 as SalesDocument,
      _SDPartner.Customer                                      as Customer,
      Customer.CustomerName                                    as CustomerName,
      Customer.StreetName                                      as Street,
      Customer._AddressDefaultRepresentation.StreetPrefixName1 as Street2,
      Customer._AddressDefaultRepresentation.StreetPrefixName2 as Street3,
      Customer._AddressDefaultRepresentation.StreetSuffixName1,
      Customer._AddressDefaultRepresentation.StreetSuffixName2,
      Customer.CityName                                        as City,
      Customer._AddressDefaultRepresentation.AddresseeFullName,
      Customer.PostalCode                                      as PostalCode,
      Customer.CustomerFullName                                as CustomerFUllName,
      //      _Address.Street                as StreetCode,
      Customer.TelephoneNumber1                                as TelephoneNumber1,
      _regiondescp.RegionName,
      Customer.DistrictName                                    as District,
      Customer.Region                                          as Region,
      Customer._AddressDefaultRepresentation.AddresseeName1    as Name1,
      Customer._AddressDefaultRepresentation.AddresseeName2    as Name2,
      _PAN.BPIdentificationNumber                              as PAN,
      _SDPartner.PartnerFunction                               as PartnerFunction,
      _Fassai.BPIdentificationNumber                           as FASSAI,
      _GSTIN.BPTaxNumber                                       as BPTaxNumber
}
