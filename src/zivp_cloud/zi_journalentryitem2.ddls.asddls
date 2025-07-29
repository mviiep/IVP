@AbapCatalog.sqlViewName: 'ZI_JOURNALITEM'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journalentry Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_JOURNALENTRYITEM2
  as select distinct from I_JournalEntryItem as JournalItem
  association [0..1] to I_JournalEntryItem as GetSupplier on  JournalItem.CompanyCode          =  GetSupplier.CompanyCode
                                                          and JournalItem.FiscalYear           =  GetSupplier.FiscalYear
                                                          and JournalItem.AccountingDocument   =  GetSupplier.AccountingDocument
                                                          and GetSupplier.FinancialAccountType =  'K'
                                                          and GetSupplier.Supplier             <> ''
  association [0..1] to I_JournalEntry     as jeheader    on  JournalItem.CompanyCode        = jeheader.CompanyCode
                                                          and JournalItem.AccountingDocument = jeheader.AccountingDocument
{
  key JournalItem.AccountingDocument             as AccountingDocument,
  key JournalItem.PurchasingDocument             as PurchasingDocument,
  key JournalItem.FiscalYear                     as FiscalYear,
      JournalItem.PostingDate                    as PostingDate,
      JournalItem.OffsettingAccount              as OffsettingAccount,
      JournalItem.PurchasingDocumentItem         as PurchasingDocumentItem,
      JournalItem.DebitCreditCode                as DebitCreditCode,
      JournalItem.ReferenceDocument              as ReferenceDocumentMIRO,
      JournalItem.ReferenceDocumentItem          as ReferenceDocumentItem,
      JournalItem.TaxCode                        as TaxCode,
      JournalItem.BusinessArea                   as BusinessArea,
      JournalItem.FinancialAccountType           as Acctype,
      JournalItem.GLAccountType                  as GLAcctype,
      JournalItem.Plant                          as plant,
      jeheader.TaxIsCalculatedAutomatically      as tax_amt,
      jeheader.NetAmountIsPosted                 as net_amt,
      jeheader.IsReversal                        as IsReversal,
      jeheader.ReversalReferenceDocument         as Reverse,
      JournalItem.AmountInCompanyCodeCurrency    as amcomp,
      JournalItem.CreditAmountInCoCodeCrcy       as Crdcomp,
      jeheader.AccountingDocumentType            as doctype,
      JournalItem.CompanyCodeCurrency            as ccc,
      JournalItem.BaseUnit                       as baseunit,
      JournalItem.CompanyCodeCurrency            as Comp_currency,
      JournalItem.BillToParty                    as Billtoparty,
      JournalItem.AdditionalQuantity1Unit        as Qty,
      JournalItem.AmountInBalanceTransacCrcy     as Bal,
      JournalItem.TransactionTypeDetermination   as Trans_type,

      case JournalItem.TransactionTypeDetermination
      when 'WRX' then JournalItem.GLAccount end  as GlCode,

      case JournalItem.TransactionTypeDetermination
      when 'JII' then JournalItem.GLAccount end  as IGST_GL,

      case JournalItem.TransactionTypeDetermination
       when 'JIC' then JournalItem.GLAccount end as CGST_GL,

      case JournalItem.TransactionTypeDetermination
      when 'JIS' then JournalItem.GLAccount end  as SGST_GL,

      JournalItem.AmountInCompanyCodeCurrency    as Tot_Invoice,
      GetSupplier.Supplier                       as Supplier,
      GetSupplier.AccountingDocument             as GetSupplierAccountingDocument
}
where
  (
       JournalItem.PurchasingDocument     =  ''
    or JournalItem.PurchasingDocument     <> ''
  )
  and  JournalItem.DebitCreditCode        =  'S'
  //or JournalItem.DebitCreditCode        =  'H' )
  and  JournalItem.OffsettingAccount      <> ''
  and(
       JournalItem.AccountingDocumentType =  'RE'
    or JournalItem.AccountingDocumentType =  'KR'
    or JournalItem.AccountingDocumentType =  'KG'
  )
  and  JournalItem.FinancialAccountType   =  'S'
  and  JournalItem.GLAccountType          =  'P'
  and  JournalItem.GLAccount              <> '0066000130'
  and  JournalItem.GLAccount              <> '0066000120'

group by
  JournalItem.AccountingDocument,
  JournalItem.PurchasingDocument,
  JournalItem.FiscalYear,
  JournalItem.PostingDate,
  JournalItem.OffsettingAccount,
  JournalItem.PurchasingDocumentItem,
  JournalItem.DebitCreditCode,
  JournalItem.ReferenceDocument,
  JournalItem.ReferenceDocumentItem,
  JournalItem.TaxCode,
  GetSupplier.Supplier,
  GetSupplier.AccountingDocument,
  JournalItem.AmountInCompanyCodeCurrency,
  JournalItem.TransactionTypeDetermination,
  JournalItem.GLAccount,
  JournalItem.BusinessArea,
  JournalItem.Plant,
  jeheader.TaxIsCalculatedAutomatically,
  jeheader.NetAmountIsPosted,
  jeheader.AccountingDocumentType,
  JournalItem.CompanyCodeCurrency,
  JournalItem.BaseUnit,
  JournalItem.BillToParty,
  JournalItem.AdditionalQuantity1Unit,
  JournalItem.FinancialAccountType,
  JournalItem.GLAccountType,
  JournalItem.CreditAmountInCoCodeCrcy,
  jeheader.IsReversal,
  jeheader.ReversalReferenceDocument,
  JournalItem.AmountInBalanceTransacCrcy
