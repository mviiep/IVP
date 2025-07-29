//@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HDLR_SUPP_QUOTES'
@EndUserText.label: 'Interface view for Supp.Quot comparison'
//@Search.searchable: true
//@Metadata.ignorePropagatedAnnotations: true

define root custom entity ZIDD_Quote_Comparison
   
{
//Header
  @EndUserText.label: 'Request For Quotation'
  key RequestForQuotation  : ebeln;
//    key rfqno   : ebeln;
  @EndUserText.label: 'RFQ Date'
      rfqdate   : abap.char(10);
  _RFQItem   : composition [*] of zi_dd_quotcomp_item;
  _SupHead  : composition[*] of zi_dd_quotcomp_sup; 
  _SupQtPrice : association[0..*]   to ZI_DD_SUPQTPRICE   on _SupQtPrice.RequestForQuotation = ZIDD_Quote_Comparison.RequestForQuotation; 
//  _QCS_download : association[0..*] to ZCE_QCS_Download   on _QCS_download.RequestForQuotation = ZIDD_Quote_Comparison.RequestForQuotation; 
//    _association_name // Make association public
}
