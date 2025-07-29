@EndUserText.label: 'Vendor E-Invoice Pop Up'
define abstract entity ZPOPUP_VENDOR_EINV
//  with parameters parameter_name : parameter_type
{
//    @Search.defaultSearchElement: true
    @EndUserText.label: 'Acknowledgement From Date DD/MM/YYYY'
//    @UI.defaultValue : #( 'DD/MM/YYYY' )
    Ack_date_from : abap.char(10); 
    @EndUserText.label: 'Acknowledgement To Date DD/MM/YYYY'
//    @UI.defaultValue : #( 'DD/MM/YYYY')
    Ack_date_to   : abap.char(10);
    @EndUserText.label: 'Buyer GSTIN'
    gstin         : stcd3;
    
}
