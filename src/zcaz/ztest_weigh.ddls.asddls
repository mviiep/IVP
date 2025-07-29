@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for TEST weigh bridge API'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZTEST_WEIGH as select from zwb_detailstest

{
key plant as Plant,
key wbno as Wbno,
weight as Weight,
zdate as Zdate,
time as Time
}
