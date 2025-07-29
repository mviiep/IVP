@AbapCatalog.sqlViewName: 'ZZI_QM_COA'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for COA Form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view ZI_QM_COA

  as select distinct from I_InspectionCharacteristic as inspect_chars
  association [0..1] to I_InspectionLot         as inspectionlot        on  inspectionlot.InspectionLot = inspect_chars.InspectionLot
  association [0..1] to I_UnitOfMeasureText     as UnitOfMeasureText    on  UnitOfMeasureText.UnitOfMeasure = inspect_chars.InspectionSpecificationUnit
                                                                        and UnitOfMeasureText.Language      = 'E'
  association [0..1] to I_InspectionResult      as inspect_result       on  inspect_chars.InspectionLot            = inspect_result.InspectionLot
                                                                        and inspect_chars.InspectionCharacteristic = inspect_result.InspectionCharacteristic
  association [0..1] to ZI_COA                  as charattribute        on  inspect_chars.InspectionLot            = charattribute.InspectionLot
                                                                        and inspect_chars.InspectionCharacteristic = charattribute.Characteristic
  association [0..1] to I_InspectionResultValue as inspect_result_value on  inspect_chars.InspectionLot            = inspect_result_value.InspectionLot
                                                                        and inspect_chars.InspectionCharacteristic = inspect_result_value.InspectionCharacteristic

{
  key inspectionlot.InspectionLot                                       as InspectionLot,
  key inspect_chars.InspectionCharacteristic                            as chars,
      inspect_chars.InspectionCharacteristicText                        as TestName,
      inspect_chars.InspectionCharacteristicText                        as parameters,
      fltp_to_dec( inspect_chars.InspSpecLowerLimit as abap.dec(10,3) ) as lowerlimit,
      fltp_to_dec( inspect_chars.InspSpecUpperLimit as abap.dec(10,3) ) as upperlimit,
      inspect_chars.InspSpecDecimalPlaces                               as DecimalPlaces,
      inspect_chars.InspSpecUpperLimit                                  as upperlimit1,
      inspect_chars.InspSpecLowerLimit                                  as lowerlimit1,
      UnitOfMeasureText.UnitOfMeasureTechnicalName                      as UOM,
      charattribute.CharacteristicAttributeCodeTxt,
      inspect_chars.InspSpecIsQuantitative,
      inspect_result.InspResultHasVariance,
      inspect_result.InspectionResultMaximumValue,
      inspect_result.InspectionResultMinimumValue,
      inspect_chars.InspSpecInformationField1,
      case inspect_chars.InspSpecIsQuantitative
      when 'X'
      then inspect_result.InspectionResultOriginalValue
      else
      charattribute.CharacteristicAttributeCodeTxt
      end                                                               as InspectionResult
}
