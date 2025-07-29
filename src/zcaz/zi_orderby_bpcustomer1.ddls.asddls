@AbapCatalog.sqlViewName: 'ZI_ORDERBY_1'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view ZI_OrderBy_BPCustomer1
  as select from ZI_Customer_DetailsSOC1 as _BPSP
{
  key _BPSP.SalesDocument            as SalesDocument,
      case
                when _BPSP.PartnerFunction = 'RE'
                then _BPSP.Name1 end as OrderByName,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.Name2 end         as OrderByAddressName,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.Street end        as OrderBySreet1,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.Street2 end       as OrderByStreet2,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.Street3 end       as OrderByStreet3,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.City end          as OrderByCity,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.PostalCode end    as OrderByPostalCode,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.Region end        as OrderByState,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.PAN end           as OrderByPAN,
      case
      when _BPSP.PartnerFunction = 'RE'
      then _BPSP.RegionName end      as OrderByRegionName,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.FASSAI end        as OrderByFASSAI,
      case
        when _BPSP.PartnerFunction = 'RE'
        then _BPSP.BPTaxNumber end   as OrderByGST
}
