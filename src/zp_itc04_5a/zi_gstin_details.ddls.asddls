@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for GSTIN Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//define view entity ZI_GSTIN_DETAILS as select from ZI_BASIC_DETAILS as _businessplace
//inner join I_IN_BusinessPlaceTaxDetail as gstin on gstin.BusinessPlace = _businessplace.businessplace
//{
//    key _businessplace.billingdocument,
//    key _businessplace.billingdocumentitem,
//    key _businessplace.businessplace,
//    gstin.IN_GSTIdentificationNumber as businessplacegstin
//}

define view entity ZI_GSTIN_DETAILS as select from I_Plant as _plant
inner join I_IN_BusinessPlaceTaxDetail as _gstin on _plant.BusinessPlace = _gstin.BusinessPlace
{
key _plant.Plant,
key _gstin.CompanyCode,
key _gstin.IN_GSTIdentificationNumber,
key _gstin.BusinessPlace,
_gstin.BusinessPlaceDescription,
_gstin.AddressID,

_gstin.IN_IsBizPlaceGSTSpclEconomicZn,
_gstin.IN_GSTTxDdctdAtSrceRegn,
_gstin.IN_GSTBizPlaceClassfctn,
_gstin._Address,
_gstin._CompanyCode
}
