@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Nav Tab'
@Metadata.allowExtensions: true
define root view entity ZI_GE_MODULE_NAV as select from zge_module_nav
{
      key id as ID,
      userid as UserId,
      username        as UserName,
      userstatus      as UserStatus,
      screenid        as ScreenId,
      screenname      as ScreenName,
      status          as Status,
      postingdate     as PostingDate,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt



}
