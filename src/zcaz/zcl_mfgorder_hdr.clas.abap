CLASS zcl_mfgorder_hdr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_cobadicfl_mfgorder_hdr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MFGORDER_HDR IMPLEMENTATION.


  METHOD if_cobadicfl_mfgorder_hdr~modify_header.

    DATA(zclass) = NEW zcl_batchdatechanges( ).


*    DATA(zmethod) = zclass->patch_method(
*                      api_para        =
*                      manufacturedate =
*                    ).

  ENDMETHOD.
ENDCLASS.
