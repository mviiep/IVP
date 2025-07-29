@AbapCatalog.sqlViewName: 'ZGEBUSPARTROLE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Business Partner Role'
define view ZGE_BUSINESS_PARTNER_ROLE as select from  I_IAMBusinessUserBusinessRole as ZIAMPP

association[0..1] to I_BusinessUserBasic as ZUSER on ZIAMPP.UserID = ZUSER.UserID
{
key UserID,
key BusinessRoleUUID,
BusinessRole,
BusinessRoleGroup,
/* Associations */
_BusinessRole,
_BusinessUser,
ZUSER.PersonFullName
}

where BusinessRole = 'ZBR_ADMIN_ROLE'
