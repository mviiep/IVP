@AbapCatalog.sqlViewName: 'ZZI_EWAY_CON'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Eway Bill Condition type'
define view ZI_EWAY_CON_TYPE as select from zsd_eway_con_typ
{
    key conditiontype as Conditiontype,
    gstgrp as Gstgrp,
    gstdoc as Gstdoc
}
