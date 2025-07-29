@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for COA Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_COA
  as select distinct from I_InspectionResult as inspection_result
  association [0..1] to I_CharcAttributeCode as charattribute on  inspection_result.CharacteristicAttributeCode    = charattribute.CharacteristicAttributeCode
                                                              and inspection_result.CharacteristicAttributeCodeGrp = charattribute.CharacteristicAttributeCodeGrp
{
  key inspection_result.InspectionLot                                 as InspectionLot,
      inspection_result.InspectionCharacteristic                      as Characteristic,
      case
             when inspection_result.InspectionResultHasMeanValue <> 'X'
             and inspection_result.CharacteristicAttributeCodeGrp =  charattribute.CharacteristicAttributeCodeGrp
             then charattribute.CharacteristicAttributeCodeTxt
             else inspection_result.InspectionResultOriginalValue end as testresult,
      charattribute.CharacteristicAttributeCodeTxt

}
