@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' FI Purchase Register root entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_fipur_reg
  as select from zi_fipur_register as Purchase_Register
{
  key     Purchase_Register.ReferenceDocumentItem,
  key     Purchase_Register.ReferenceDocumentMIRO,
  key     Purchase_Register.AccountingDocument,
          Purchase_Register.AccountingDocumentItem,
          Purchase_Register.BusinessPlace,
          Purchase_Register.PostingDate,
          Purchase_Register.RefDocNo,
          Purchase_Register.InvoiceDate,
          Purchase_Register.Vendor,
          Purchase_Register.VendorName,
          Purchase_Register.VendorRegion,
          Purchase_Register.RegionName,
          Purchase_Register.GSTIN,
          Purchase_Register.TIN,
          Purchase_Register.UOM,
          Purchase_Register.TaxRate,
          Purchase_Register.HSN,
          Purchase_Register.DocumentCurrency,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          Purchase_Register.BaseAmount,
          Purchase_Register.TaxCode,

          case
          when
                Purchase_Register.TaxCode = 'S1' or Purchase_Register.TaxCode = 'S2' or Purchase_Register.TaxCode = 'S3' or Purchase_Register.TaxCode = 'S4'
             or Purchase_Register.TaxCode = 'S5' or Purchase_Register.TaxCode = 'S6' or Purchase_Register.TaxCode = 'S7' or Purchase_Register.TaxCode = 'S8'
             then Purchase_Register.SGST * -1
             else Purchase_Register.SGST
             end                                                             as SGST,
          case
          when
               Purchase_Register.TaxCode = 'S1' or Purchase_Register.TaxCode = 'S2' or Purchase_Register.TaxCode = 'S3' or Purchase_Register.TaxCode = 'S4'
            or Purchase_Register.TaxCode = 'S5' or Purchase_Register.TaxCode = 'S6' or Purchase_Register.TaxCode = 'S7' or Purchase_Register.TaxCode = 'S8'
            then Purchase_Register.CGST * -1
            else Purchase_Register.CGST end                                  as CGST,
          case
          when
             Purchase_Register.TaxCode = 'S1' or Purchase_Register.TaxCode = 'S2' or Purchase_Register.TaxCode = 'S3' or Purchase_Register.TaxCode = 'S4'
          or Purchase_Register.TaxCode = 'S5' or Purchase_Register.TaxCode = 'S6' or Purchase_Register.TaxCode = 'S7' or Purchase_Register.TaxCode = 'S8'
          then Purchase_Register.IGST * -1
          else Purchase_Register.IGST end                                    as IGST,
          
          Purchase_Register.RCGST,
          Purchase_Register.RSGST,
          Purchase_Register.RIGST,
          Purchase_Register.RCGSTO,
          Purchase_Register.RSGSTO,
          Purchase_Register.RIGSTO,
          Purchase_Register.AccountingDocumentType,
          case
            when
                   Purchase_Register.TaxCode = 'S1' or Purchase_Register.TaxCode = 'S2' or Purchase_Register.TaxCode = 'S3' or Purchase_Register.TaxCode = 'S4'
                or Purchase_Register.TaxCode = 'S5' or Purchase_Register.TaxCode = 'S6' or Purchase_Register.TaxCode = 'S7' or Purchase_Register.TaxCode = 'S8'
            then
                cast(Purchase_Register.BaseAmount as abap.dec( 10, 2 )) - cast( coalesce( Purchase_Register.CGST,0) + coalesce(Purchase_Register.SGST,0) +
                     coalesce(Purchase_Register.IGST,0)  as abap.dec( 13, 2 ) )
            when
                    Purchase_Register.TaxCode = 'R1'or Purchase_Register.TaxCode = 'R2'or Purchase_Register.TaxCode = 'R3'or Purchase_Register.TaxCode = 'R4'
                or Purchase_Register.TaxCode = 'R5'or Purchase_Register.TaxCode = 'R6'or Purchase_Register.TaxCode = 'R7'or Purchase_Register.TaxCode = 'R8'
            then
                cast(Purchase_Register.BaseAmount as abap.dec( 10, 2 ))
            when
                    Purchase_Register.TaxCode <> 'S1' and Purchase_Register.TaxCode <> 'S2' and Purchase_Register.TaxCode <> 'S3' and Purchase_Register.TaxCode <> 'S4'
                    and Purchase_Register.TaxCode <> 'S5' and Purchase_Register.TaxCode <> 'S6' and Purchase_Register.TaxCode <> 'S7' and Purchase_Register.TaxCode <> 'S8'
                    and Purchase_Register.CGST > 0 or Purchase_Register.IGST > 0
            then
                    cast( coalesce( Purchase_Register.CGST,0) + coalesce(Purchase_Register.SGST,0) +
                    coalesce(Purchase_Register.IGST,0) + cast(Purchase_Register.BaseAmount as abap.dec( 10, 2 )) as abap.dec( 13, 2 ) )
            when
                    Purchase_Register.AccountingDocumentType = 'KG' and
                    Purchase_Register.TaxCode <> 'S1' and Purchase_Register.TaxCode <> 'S2' and Purchase_Register.TaxCode <> 'S3' and Purchase_Register.TaxCode <> 'S4'
                    and Purchase_Register.TaxCode <> 'S5' and Purchase_Register.TaxCode <> 'S6' and Purchase_Register.TaxCode <> 'S7' and Purchase_Register.TaxCode <> 'S8'
          //            and Purchase_Register.CGST > 0 or Purchase_Register.IGST > 0
            then (
          //            cast(
                    coalesce( Purchase_Register.CGST * -1 ,0) + coalesce(Purchase_Register.SGST * -1 ,0) +
                     coalesce(Purchase_Register.IGST * -1 ,0) + cast(Purchase_Register.BaseAmount as abap.dec( 10, 2 )) * -1
          //                     as abap.curr( 13, 2 ) )
                     * -1)
            when
                Purchase_Register.RCGST is not null or Purchase_Register.RIGST is not null
            then
                cast( Purchase_Register.BaseAmount as abap.dec( 13, 2 ) )
            else cast(Purchase_Register.BaseAmount as abap.dec( 13, 2 )) end as GrossAmount,
          Purchase_Register.GLAccount,
          Purchase_Register.GLAccountLongName,
          Purchase_Register.DebitCreditCode,

          Purchase_Register.DocumentItemText
}
