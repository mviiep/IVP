@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for QM Label FG Product Description'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_qmlabel_fg_productdesc
  as select distinct from I_Product
  association [0..1] to I_ProductDescription_2 on  I_ProductDescription_2.Product  = I_Product.Product
                                               and I_ProductDescription_2.Language = 'E'
{
  key I_Product.Product,
      I_ProductDescription_2.ProductDescription

}
