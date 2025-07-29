@AbapCatalog.sqlViewName: 'ZGEMDHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Pass- Material Document for Head'
define view ZGE_MD_HEAD as select distinct  from I_MaterialDocumentHeader_2 as ZMD

association [0..*]  to ZGE_MD_ITEM as ZMDITEM on $projection.MaterialDocumentYear = ZMDITEM.MaterialDocumentYear and 
                                    
                                                 $projection.MaterialDocument = ZMDITEM.MaterialDocument

{
        key ZMD.MaterialDocumentYear as  MaterialDocumentYear,
        key ZMD.MaterialDocument as MaterialDocument ,
            ZMD.PostingDate as PostingDate,
            ZMD.DocumentDate as DocumentDate,
            ZMD.DeliveryDocument as DeliveryDocument,
            ZMD.ReferenceDocument as ReferenceDocument,
            ZMD.BillOfLading as BillOfLading,
            ZMD.MaterialDocumentHeaderText as MaterialDocumentHeaderText,
            ZMD.AccountingDocumentType as AccountingDocumentType ,
            ZMD.CreationDate,
            ZMD.CreatedByUser,
            ZMDITEM
  
    
}
