@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For User Table'
@Metadata.allowExtensions:true
define root view entity ZGE_GP_USER_TABLE as select from zge_user_tabl


{
    key zge_user_tabl.sap_uuid as SapUuid,
    key zge_user_tabl.userid as UserId,
    
    zge_user_tabl.username as UserName,
    zge_user_tabl.status as Status,
    zge_user_tabl.created_by as CreatedBy,
    zge_user_tabl.created_at as CreatedAt,
    zge_user_tabl.last_changed_by as LastChangedBy,
    zge_user_tabl.last_changed_at as LastChangedAt,
    zge_user_tabl.local_last_changed_at as LocalLastChangedAt

}
