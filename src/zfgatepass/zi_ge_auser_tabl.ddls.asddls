@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass Auser Table Data Definition'
@Metadata.allowExtensions: true
define root view entity ZI_GE_AUSER_TABL as select from zge_auser_tab

{
 key userid          as UserId,
      username        as UserName,
      status          as Status,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt
}
