@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass For Trans App'
@Metadata.allowExtensions: true
define root view entity ZI_GE_TRANS_APP as select from zge_user_trans
{
         key id              as ID,
 userid          as UserId,
      ge1             as GE1,
      ge2             as GE2,
      ge3             as GE3,
      ge4             as GE4,
      ge5             as GE5,
      ge6             as GE6,
      ge7             as GE7,
      ge8             as GE8,
      ge9             as GE9,
      ge10            as GE10,
      ge11            as GE11,
      ge12            as GE12,
      ge13            as GE13,
      ge14            as GE14,
      ge15            as GE15,
      ge16            as GE16,
      ge17            as GE17,
      ge18            as GE18,
      ge19            as GE19,
      ge20            as GE20,
      ge21            as GE21,
      ge22            as GE22,
      ge23            as GE23,
      ge24            as GE24,
      ge25            as GE25,
      ge26 as GE26,

      
      username        as UserName,
      userstatus      as UserStatus,
      postingdate     as PostingDate,
      modulecode      as ModuleCode,
      modulename      as ModuleName,
      modulestatus    as ModuleStatus,


      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt

}
