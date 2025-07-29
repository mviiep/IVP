@AbapCatalog.sqlViewName: 'ZGEBUSINESSROLE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass for Business Role'
define view ZGE_BUSINESS__ROLE as select from I_BusinessUserBasic
{
    key BusinessPartner,
    BusinessPartnerUUID,
    LastName,
    FirstName,
    PersonFullName,
    FormOfAddress,
    AcademicTitle,
    AcademicSecondTitle,
    CorrespondenceLanguage,
    MiddleName,
    AdditionalLastName,
    BirthName,
    NickName,
    Initials,
    LastNamePrefix,
    LastNameSecondPrefix,
    NameSupplement,
    UserID,
    IsMarkedForArchiving,
    BusinessPartnerIsBlocked,
    CreatedByUser,
    CreationDate,
    CreationTime,
    LastChangedByUser,
    LastChangeDate,
    LastChangeTime,
    IsBusinessPurposeCompleted,
    AuthorizationGroup,
    DataControllerSet,
    DataController1,
    DataController2,
    DataController3,
    DataController4,
    DataController5,
    DataController6,
    DataController7,
    DataController8,
    DataController9,
    DataController10,
    /* Associations */
    _BusinessPartnerExternalID,
    _BusinessPartnerRole,
    _User,
    _WorkplaceAddress
}
