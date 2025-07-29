CLASS zcl_vendor_einv_advance_vali DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_badi_interface .
  INTERFACES if_ex_mrm_att_read_only_cloud.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VENDOR_EINV_ADVANCE_VALI IMPLEMENTATION.


  METHOD if_ex_mrm_att_read_only_cloud~set_attachments_to_read_only.



  DATA(supplier_inv) = supplierinvoice.

  ENDMETHOD.
ENDCLASS.
