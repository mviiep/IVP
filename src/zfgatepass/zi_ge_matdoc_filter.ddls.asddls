@AbapCatalog.sqlViewName: 'ZIGEMATDOCFILTER'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ThefilterforReferenceDocumentNoisempty'
define view ZI_GE_MATDOC_FILTER as select from I_MaterialDocumentHeader_2 as MATDOCHEAD

association [0..1] to I_MaterialDocumentItem_2 as ZMATDOCITEM on MATDOCHEAD.MaterialDocument = ZMATDOCITEM.MaterialDocument 
                                                                and MATDOCHEAD.MaterialDocumentYear = ZMATDOCITEM.MaterialDocumentYear 
                                                          

{     
    key MATDOCHEAD.MaterialDocument,
        MATDOCHEAD.MaterialDocumentYear,
        MATDOCHEAD.MaterialDocumentHeaderText,
        MATDOCHEAD.VersionForPrintingSlip
       // ZMATDOCITEM.GoodsMovementType
        
} 

where ZMATDOCITEM.GoodsMovementIsCancelled = '' and ZMATDOCITEM.GoodsMovementType = '101'
