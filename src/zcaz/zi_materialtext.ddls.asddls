@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Text for Label PM and PM'
define view entity ZI_Materialtext
  as select from I_Product
  association [0..1] to I_ProductText on  I_Product.Product      = I_ProductText.Product
                                      and I_ProductText.Language = 'E'
{
  key Product,
      I_ProductText.ProductName
}
