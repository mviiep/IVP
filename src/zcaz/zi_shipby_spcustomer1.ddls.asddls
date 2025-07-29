@AbapCatalog.sqlViewName: 'ZI_SHIPBY_1'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view ZI_ShipBy_SPCustomer1
  as select from ZI_Customer_DetailsSOC1 as _BPSP
{
  key _BPSP.SalesDocument         as SalesDocument,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Name1 end      as SPCustomer,
      case
        when _BPSP.PartnerFunction =  'WE'
        then _BPSP.Name1 end      as ShipToName,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Name2 end      as ShipToAddressName,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Street end     as ShipToSreet1,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Street2 end    as ShipToStreet2,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Street3 end    as ShipToStreet3,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.City end       as ShipToCity,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.PostalCode end as ShipToPostalCode,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.Region end     as ShipToState,
      case
        when _BPSP.PartnerFunction = 'WE'
        then _BPSP.PAN end        as ShipToPAN,
      case
      when _BPSP.PartnerFunction = 'WE'
      then _BPSP.RegionName end   as ShiptoRegionName,
      case
      when _BPSP.PartnerFunction = 'WE'
      then _BPSP.FASSAI end       as ShipToFASSAI,
      case
      when _BPSP.PartnerFunction = 'WE'
      then _BPSP.BPTaxNumber end  as ShipToGST
}
