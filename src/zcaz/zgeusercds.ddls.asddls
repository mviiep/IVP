@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User CDS for access'
define root view entity ZGEUSERCDS
  as select from zgeuseraccess

{
  key username  as Username,
      password  as Password,
      firstname as firstname,
      lastname  as lastname,
      emailid   as emailid,
      contact   as contact,
      validfrom as validfrom,
      validto   as validto,
      createdby as CreatedBy,
      createdon as CreatedOn,
      changedby as ChangedBy,
      changedon as ChangedOn

}
