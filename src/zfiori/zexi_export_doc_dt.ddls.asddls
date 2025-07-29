@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Export Document Details DD'
@Metadata.allowExtensions: true

define root view entity ZEXI_EXPORT_DOC_DT as select from zexi_expt_doc_dt

{
    key sap_uuid as SAP_UUID,
    id as ID,
    modbilldate as ModbillDate,
    paymentterms as PaymentTerms,
    paymenttermsdesc as PaymentTermsDesc,
    companycode as CompanyCode,
    incoterms as IncoTerms,
    incotermscode as IncoTermsCode,
    billingdate as BillingDate,
    quantity as Quantity,
    quantityuom as QuantityUOM,
    netweight as NetWeight,
    netnetweight as NetNetWeight,
    netweightuom as NetWeightUOM,
    invoiceamount as InvoiceAmount,
    invoiceamountcurrency as InvoiceAmountCurrency,
    billingtype as BillingType,
    grossweight as GrossWeight,
    grossweightuom as GrossWeightUOM,
    otherref as OtherRef,
    volume as Volume,
    volumedesc as VolumeDesc,
    cartonlength as CartonLength,
    cartonwidth as CartonWidth,
    cartonheight as CartonHeight,
    status as Status,
    cbm as CBM,
    volwtinch as VolWTInch,
    volwtcms as VolWTCMS,
    lcfdnumber as LcfdNumber,
    lclcnumber as LCLCNumber,
    lcopeningdate as LCOpeningDate,
    lcvalidtyenddate as LCValidtyEndDate,
    printresult as PrintResult,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
}
