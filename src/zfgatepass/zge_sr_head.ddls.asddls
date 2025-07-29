@AbapCatalog.sqlViewName: 'ZGESRHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Sale Return Head'
define view ZGE_SR_HEAD as select distinct from I_CustomerReturn as ZCUSTRET


/*  Association           */

association [0..*]  to ZGE_CUSTOMER as ZCUST on $projection.SoldToParty = ZCUST.Customer
association [0..*]  to ZGE_SR_ITEM as ZSRITEM on $projection.CustomerReturn = ZCUSTRET.CustomerReturn
{
    key ZCUSTRET.CustomerReturn as CustomerReturn ,
        ZCUSTRET.CustomerReturnType as CustomerReturnType,
        ZCUSTRET.SoldToParty as SoldToParty, 
        ZCUST.CustomerName as CustomerName,
        ZCUST.CustomerAccountGroup as CustomerAccountGroup,
        ZCUSTRET.CreationDate,
        ZCUSTRET.CreatedByUser,
        ZCUSTRET.LastChangeDateTime,
        ZCUSTRET.LastChangedByUser,
        ZSRITEM
}
