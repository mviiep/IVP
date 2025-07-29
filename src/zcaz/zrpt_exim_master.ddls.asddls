@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'fetch data based on material code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRPT_EXIM_MASTER as select distinct from ZEXI_EXPORT_DOC_ITEM as M

association[0..1] to ZEX_DBK_MASTER as a on M.Material = a.MaterialCode
association[0..1] to ZEX_RODTEP_MASTER as R on M.Material = R.MaterialCode



{
    key M.ID as id,
    a.MaterialDescription as materialdescription,
    a.DBKRate as dbkrate,
    R.RODTEPRate as rodrate
    
}
