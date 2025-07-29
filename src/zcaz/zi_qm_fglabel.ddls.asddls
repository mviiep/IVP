@ObjectModel.query.implementedBy: 'ABAP:ZCL_QM_FGLABEL'
@EndUserText.label: 'Interface View for QM FG Label'
define custom entity ZI_QM_FGLABEL
{
  key ManufacturingOrder            : abap.char(12);
      ProductionPlant               : abap.char(4);
      ProductDescription            : abap.char(50);
      ManufacturingOrderHasLongText : abap.char(100);
      Batch                         : abap.char(10);
      ManufactureDate               : abap.dats;
      ShelfLifeExpirationDate       : abap.dats;
      WeightUnit                    : abap.unit( 3 );
      BaseUnit                      : abap.unit( 3 );
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      GrossWeight                   : abap.quan( 10, 2 );
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      NetWeight                     : abap.quan( 10, 2 );
      ProductionOrInspectionMemoTxt : abap.char(100);
      Product                       : abap.char(40);

      // Plant Address
      Plant                         : abap.char(4);
      StreetName                    : abap.char(40);
      AddresseeFullName             : abap.char(40);
      StreetSuffixName1             : abap.char(40);
      StreetSuffixName2             : abap.char(40);
      CityName                      : abap.char(25);
      PostalCode                    : abap.char(6);
      RegionName                    : abap.char(40);
      StreetPrefixName1             : abap.char(40);
      DistrictName                  : abap.char(40);
      AddressPersonID               : abap.char(10);
      EmailAddress                  : abap.char(100);
      InternationalPhoneNumber      : abap.char(20);
      InternationalPhoneNumber1     : abap.char(20);
      CountryName                   : abap.char(40);
      notes                         : abap.char(255);


}
