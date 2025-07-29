@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'root cds view for Weighbridge'
@Metadata.allowExtensions: true
define root view entity zcds_Weighbridge as select from zweighbridge
//composition of target_data_source_name as _association_name
{
    key plant as Plant,
    key wb_no as Wb_No,
    weight as Weight,
    zdate as Zdate,
    time as Time
//   _association_name // Make association public
}
