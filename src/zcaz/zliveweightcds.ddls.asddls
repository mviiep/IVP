@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Live weight cds view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZLIVEWEIGHTCDS as select from zliveweight
//composition of target_data_source_name as _association_name
{
   @UI.lineItem: [{ position: 10,label: 'Plant' }, { type: #FOR_ACTION , dataAction: 'weightupdate' , label: 'Plant' } ]
   @UI.identification: [{ position: 10 }]
   key plant as Plant,
    @UI: { lineItem:       [ { position: 20, label: 'WeightBridege Code'}],
    identification: [ { position: 20, label: 'WeightBridege Code'}] }
   key wbcode as Wbcode,
    @UI: { lineItem:       [ { position: 30, label: 'Weight'}],
    identification: [ { position: 30, label: 'Weight'}] }
   weight as Weight,
   @UI: { lineItem:       [ { position: 40, label: 'Date'}],
   identification: [ { position: 40, label: 'Date'}] }
   updateddt as Updateddt,
   @UI: { lineItem:       [ { position: 50, label: 'Time'}],
   identification: [ { position: 50, label: 'Time'}] }
   updatedtm as Updatedtm 
    //_association_name // Make association public
}
