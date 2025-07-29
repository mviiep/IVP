@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZUSER CDS view'
define root view entity ZUSERCDS as select from zuser
//composition of target_data_source_name as _association_name
{
    key username as Username,
    password as Password,
    firstname as Firstname,
    lastname as Lastname,
    emailid as Emailid,
    contactno as Contactno,
    status as Status,
    createdby as Createdby,
    createdon as Createdon,
    changedby as Changedby,
    changedon as Changedon
    
} 
