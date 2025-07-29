@EndUserText.label: 'Abstract Entity for EWAY Parameters'
define abstract entity ZA_EWAY_TRANS
{
  @EndUserText.label: 'Transporter ID'
  trans_id        : abap.char(15);
  @EndUserText.label: 'Transporter Doc No'
  trans_doc_no    : abap.char(15);
  @EndUserText.label: 'Transport Distance'
  trans_dist      : abap.numc(4);
//  @EndUserText.label: 'Supply Type'
//  supply_typ      : abap.char(20);
  @EndUserText.label: 'Transporter Name'
  trans_name      : abap.char(100);
  @EndUserText.label: 'Transporter Doc Date'
  trans_doc_date  : abap.dats;
  @EndUserText.label: 'Vehicle No'
  vehicle_no      : abap.char(10);
  @EndUserText.label: 'Transport Mode'
  modeoftransport : abap.char(1);

}
