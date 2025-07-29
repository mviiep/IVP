@AbapCatalog.sqlViewName: 'ZSQEXPRODUCT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Product'
define view ZEX_Product as select from  I_Product as ZPRDT
association [0..*]  to I_ProductText as ZPRDTXT on ZPRDTXT.Product = ZPRDT.Product
association[0..*] to I_Producttype as ZPRDTYPE on ZPRDTYPE.ProductType = ZPRDT.ProductType
{
   key ZPRDT.Product as Product,
   ZPRDT.ProductUUID as ProductUUID,
    ZPRDT.ProductType as ProductType,
   ZPRDTXT.ProductName as ProductName,
   ZPRDTXT.Language as Language
 // ZPRDTYPE.ProductTypeCode as ProductTypeCode  
}
