@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Sd_Address
  as select from I_Customer as I_Customer

  association [0..*] to I_BuPaIdentification as _I_BuPaIdentification      on  _I_BuPaIdentification.BusinessPartner = I_Customer.Customer

  association [0..1] to I_RegionText         as _I_RegionText              on  _I_RegionText.Region   = I_Customer.Region
                                                                           and _I_RegionText.Country  = I_Customer.Country
                                                                           and _I_RegionText.Language = 'E'
  association [0..*] to ZI_State_Code        as _YY1_J_1ISTATECDM          on  I_Customer.Region = _YY1_J_1ISTATECDM.Region

  association [0..*] to I_BuPaIdentification as _I_BuPaIdentification_1    on  _I_BuPaIdentification_1.BusinessPartner      = I_Customer.Customer
                                                                           and _I_BuPaIdentification_1.BPIdentificationType = 'ZVAT'
  association [0..1] to I_BuPaIdentification as _PAN                       on  _PAN.BusinessPartner      = I_Customer.Customer
                                                                           and _PAN.BPIdentificationType = 'PAN'

  association [0..*] to I_BuPaIdentification as _I_BuPaIdentification_ZINS on  _I_BuPaIdentification_ZINS.BusinessPartner      = I_Customer.Customer
                                                                           and _I_BuPaIdentification_ZINS.BPIdentificationType = 'ZINS'

  association [0..*] to I_BuPaIdentification as _I_BuPaIdentification_ZVAN on  _I_BuPaIdentification_ZVAN.BusinessPartner      = I_Customer.Customer
                                                                           and _I_BuPaIdentification_ZVAN.BPIdentificationType = 'ZVAN'
{
  key I_Customer.Customer                                                 as Customer,

      _PAN.BPIdentificationNumber                                         as PAN,

      _I_BuPaIdentification_ZVAN.BPIdentificationNumber                   as VANNo,

      I_Customer.CustomerName                                             as CustomerName,



      I_Customer.StreetName                                               as StreetName,

      I_Customer.BPAddrStreetName                                         as bpaddrstreetname,

      I_Customer._AddressRepresentation.StreetPrefixName1                 as StreetPrefixName1,


      I_Customer._AddressDefaultRepresentation.StreetPrefixName2          as StreetPrefixName2,


      I_Customer.CityName                                                 as CityName,


      I_Customer.PostalCode                                               as PostalCode,

      I_Customer.BPCustomerName                                           as BPCustomerName,


      I_Customer._AddressDefaultRepresentation.Street                     as Street,

      I_Customer._AddressDefaultRepresentation.Country                    as Country,

      I_Customer.TelephoneNumber1                                         as TelephoneNumber1,


      I_Customer.TelephoneNumber2                                         as TelephoneNumber2,

      I_Customer._CorrespondingSupplier.SupplierPlant                     as SupplierPlant,

      I_Customer._CustomerSalesArea.SupplyingPlant                        as SupplyingPlant,

      I_Customer.CustomerAccountGroup                                     as CustomerAccountGroup,


      I_Customer._CorrespondingSupplier.SupplierAccountGroup              as SupplierAccountGroup,

      I_Customer.CustomerFullName                                         as CustomerFullName,


      I_Customer._AddressDefaultRepresentation.AddresseeFullName          as AddresseeFullName,

      I_Customer.Region                                                   as Region,


      I_Customer._CorrespondingSupplier.BusinessPartnerPanNumber          as BusinessPartnerPanNumber,


      I_Customer.TaxNumberType                                            as TaxNumberType,


      I_Customer._CorrespondingSupplier.TaxNumberType                     as TaxNumberType_1,


      I_Customer.Country                                                  as Country_1,


      I_Customer._CorrespondingSupplier.TaxNumberResponsible              as TaxNumberResponsible,


      I_Customer.AddressID                                                as AddressID,

      I_Customer._GlobalCompany.Company                                   as Company,


      I_Customer._GlobalCompany.CompanyName                               as CompanyName,


      I_Customer._AddressDefaultRepresentation.CompanyPostalCode          as CompanyPostalCode,


      I_Customer._CustomerCompany.CompanyCode                             as CompanyCode,


      I_Customer.FaxNumber                                                as FaxNumber,


      I_Customer._AddressDefaultRepresentation.StreetSuffixName1          as StreetSuffixName1,


      I_Customer._AddressDefaultRepresentation.StreetSuffixName2          as StreetSuffixName2,


      I_Customer._CorrespondingSupplier.BPPanReferenceNumber              as BPPanReferenceNumber,


      I_Customer._AddressDefaultRepresentation.DistrictName               as DistrictName,


      I_Customer.DistrictName                                             as DistrictName_1,


      _I_BuPaIdentification.BPIdentificationNumber                        as BPIdentificationNumber,


      I_Customer.TaxNumber3                                               as TaxNumber3,


      _I_RegionText.RegionName                                            as RegionName,



      //      @Consumption.hidden: false
      //      @Analytics.excludeFromRuntimeExtensibility: false
      //      @Consumption.filter.mandatory: false
      //      @Consumption.filter.multipleSelections: false
      //      @Consumption.filter.selectionType: null
      //      @Aggregation.default: null
      _YY1_J_1ISTATECDM.Statecode                                         as StateCode,



      I_Customer._AddressDefaultRepresentation.AddressID                  as AddressID_1,


      I_Customer._AddressDefaultRepresentation.AddressPersonID            as AddressPersonID,


      I_Customer._AddressDefaultRepresentation.AddressRepresentationCode  as AddressRepresentationCode,


      I_Customer.VATRegistration                                          as VATRegistration,

      I_Customer._CorrespondingSupplier.VATRegistration                   as VATRegistration_1,


      I_Customer.TaxNumber1                                               as TaxNumber1,


      I_Customer.TaxNumber2                                               as TaxNumber2,


      I_Customer.TaxNumber4                                               as TaxNumber4,

      I_Customer.TaxNumber5                                               as TaxNumber5,

      I_Customer.TaxNumber6                                               as TaxNumber6,


      _I_BuPaIdentification_1.BPIdentificationNumber                      as VATNo,

      _I_BuPaIdentification_ZINS.BPIdentificationNumber                   as ZINS,

      //      @EndUserText.label: 'Region'
      //      @ObjectModel.foreignKey.association: null
      //      @ObjectModel.text.association: null
      //      @ObjectModel.text.element: null
      //      @Consumption.hidden: false
      //      @Analytics.excludeFromRuntimeExtensibility: false
      //      @Consumption.filter.mandatory: false
      //      @Consumption.filter.multipleSelections: false
      //      @Consumption.filter.selectionType: null
      //      @Aggregation.default: null
      _YY1_J_1ISTATECDM.Region                                            as Region_1,

      //      @EndUserText.label: 'State Name'
      //      @ObjectModel.foreignKey.association: null
      //      @ObjectModel.text.association: null
      //      @ObjectModel.text.element: null
      //
      //
      //      @Consumption.hidden: false
      //      @Analytics.excludeFromRuntimeExtensibility: false
      //      @Consumption.filter.mandatory: false
      //      @Consumption.filter.multipleSelections: false
      //      @Consumption.filter.selectionType: null
      //      @Aggregation.default: null
      _YY1_J_1ISTATECDM.Statename                                         as StateName,
      //
      //      @EndUserText.label: 'Description'
      //      @ObjectModel.foreignKey.association: null
      //      @ObjectModel.text.association: null
      //      @ObjectModel.text.element: null
      //
      //
      //      @Consumption.hidden: false
      //      @Analytics.excludeFromRuntimeExtensibility: false
      //      @Consumption.filter.mandatory: false
      //      @Consumption.filter.multipleSelections: false
      //      @Consumption.filter.selectionType: null
      //      @Aggregation.default: null
      _YY1_J_1ISTATECDM.Statename                                         as SAP_Description,


      I_Customer._AddressDefaultRepresentation._Street                    as _Street,

      I_Customer._AddressDefaultRepresentation._Country                   as _Country,

      I_Customer._CustomerSalesArea._SupplyingPlant                       as _SupplyingPlant,

      I_Customer._AddressDefaultRepresentation._FaxNumber                 as _FaxNumber,


      I_Customer._AddressDefaultRepresentation._AddressPersonName         as _AddressPersonName,
      
      I_Customer._AddressDefaultRepresentation._EmailAddress.EmailAddress as EmailAddress,


      I_Customer._AddressDefaultRepresentation._AddressRepresentationCode as _AddressRepresentationCode,


      I_Customer.AuthorizationGroup                                       as /SAP/1_AUTHORIZATIONGROUP,


      I_Customer.CustomerAccountGroup                                     as /SAP/1_CUSTOMERACCOUNTGROUP,


      I_Customer.DataController1                                          as /SAP/1_DATACONTROLLER1,

      I_Customer.DataController10                                         as /SAP/1_DATACONTROLLER10,

      I_Customer.DataController2                                          as /SAP/1_DATACONTROLLER2,

      I_Customer.DataController3                                          as /SAP/1_DATACONTROLLER3,

      I_Customer.DataController4                                          as /SAP/1_DATACONTROLLER4,

      I_Customer.DataController5                                          as /SAP/1_DATACONTROLLER5,

      I_Customer.DataController6                                          as /SAP/1_DATACONTROLLER6,

      I_Customer.DataController7                                          as /SAP/1_DATACONTROLLER7,

      I_Customer.DataController8                                          as /SAP/1_DATACONTROLLER8,

      I_Customer.DataController9                                          as /SAP/1_DATACONTROLLER9,

      I_Customer.DataControllerSet                                        as /SAP/1_DATACONTROLLERSET,

      I_Customer.IsBusinessPurposeCompleted                               as /SAP/1_ISBUSIN_HAZPFY_OMPLETED
}
