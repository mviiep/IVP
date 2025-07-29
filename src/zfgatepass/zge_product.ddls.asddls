@AbapCatalog.sqlViewName: 'ZGEPRODUCT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Product'
define view ZGE_PRODUCT as select distinct from I_Product as PRD

association [0..*] to I_ProductText as PRDTEXT on PRD.Product = PRDTEXT.Product
association [0..*] to I_ProductValuationBasic as PRDVB on PRD.Product = PRDVB.Product
association [0..*] to I_ProductPlantBasic as PRDPB on PRD.Product = PRDPB.Product
{
    key PRD.Product,
        PRDTEXT.ProductName,
        PRD.ProductType,
        PRD.BaseUnit,    
          @Semantics.amount.currencyCode: 'Currency'
        PRDVB.StandardPrice,
     PRDVB.Currency,
        PRDPB.ConsumptionTaxCtrlCode
        
}
