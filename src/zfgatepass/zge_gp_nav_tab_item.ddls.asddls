@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for NAV TAB TABLE'
define  view entity ZGE_GP_NAV_TAB_ITEM as select from zge_user_nav_tab
//association to parent ZGE_GP_USER_TABLE as _ZHEAD on $projection.SapUuid = _ZHEAD.SapUuid and $projection.UserId = _ZHEAD.UserId
{

key zge_user_nav_tab.sap_uuid as SapUuid,
key zge_user_nav_tab.userid as UserId,

zge_user_nav_tab.id as ID,
zge_user_nav_tab.username as UserName,
zge_user_nav_tab.userstatus as UserStatus,
zge_user_nav_tab.screenid as ScreenId,
zge_user_nav_tab.screenname as ScreenName,
zge_user_nav_tab.status as Status,
zge_user_nav_tab.postingdate as PostingDate,
zge_user_nav_tab.created_by as CreatedBy,
zge_user_nav_tab.created_at as CreatedAt,
zge_user_nav_tab.last_changed_by as LastChangedBy,
zge_user_nav_tab.last_changed_at as LastChangedAt,
zge_user_nav_tab.local_last_changed_at as LocalLastChangedAt
//_ZHEAD
}
