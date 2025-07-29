@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View entity for Supp.Quote compare Head'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_dd_quotcomp_sup 
    as select from I_SupplierQuotation_Api01 as a
    left outer join I_Supplier as b on b.Supplier = a.Supplier
    left outer join I_SupplierQuotationItem_Api01 as c on c.SupplierQuotation   = a.SupplierQuotation
    left outer join I_PaymentTermsText as d on d.Language = $session.system_language
                                           and d.PaymentTerms = a.PaymentTerms
association to parent ZIDD_Quote_Comparison as _RFQhead
    on $projection.RequestForQuotation = _RFQhead.RequestForQuotation    
{
        @EndUserText.label: 'Request For Quotation'  
 key    a.RequestForQuotation,
        @EndUserText.label: 'Supplier Quotation'
  key   a.SupplierQuotation,
// Supplier Name goes here
        a.Supplier,
        b.SupplierName,
        b.SupplierFullName,
        a.DocumentCurrency,
        a.QTNLifecycleStatus as QTNStatus,
        case when a.QTNLifecycleStatus = '01' then 'Created'
             when a.QTNLifecycleStatus = '02' then 'Submitted'
             when a.QTNLifecycleStatus = '03' then 'Awarded'
             when a.QTNLifecycleStatus = '04' then 'Cancelled'
             when a.QTNLifecycleStatus = '05' then 'Completed'
             when a.QTNLifecycleStatus = '06' then 'In Approval'
             when a.QTNLifecycleStatus = '07' then 'Rejected'
            else ' ' end as QTNStatusText,
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        sum(c.NetAmount) as QuotNetValue,
        a.PaymentTerms,
        a.IncotermsClassification,
        d.PaymentTermsName,
 // Association//   
    _RFQhead // Make association public
} group by a.RequestForQuotation, a.SupplierQuotation, a.Supplier, b.SupplierName, b.SupplierFullName,a.DocumentCurrency, a.QTNLifecycleStatus, a.PaymentTerms,
           a.IncotermsClassification, d.PaymentTermsName 
