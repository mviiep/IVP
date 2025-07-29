CLASS zcl_mfgorder_check_before_save DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mfgorder_check_before_save .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MFGORDER_CHECK_BEFORE_SAVE IMPLEMENTATION.


  METHOD if_mfgorder_check_before_save~check_before_save.


*    SELECT SINGLE mfgorderscheduledstartdate
*    FROM i_manufacturingorder WITH PRIVILEGED ACCESS
*    WHERE manufacturingorder = @manufacturingorder-manufacturingorder
*    INTO @DATA(mfgorderscheduledstartdate).
*
*    SELECT SINGLE product,batch,planningplant AS batchidentifyingplant
*    FROM i_manufacturingorder WITH PRIVILEGED ACCESS
*    WHERE manufacturingorder = @manufacturingorder-manufacturingorder
*    INTO @DATA(wa_api_para).
*
*    DATA(zclass) = NEW zcl_batchdatechanges( ).
*    DATA(zmethod) = zclass->patch_method(
*                      api_para        = wa_api_para
*                      manufacturedate = mfgorderscheduledstartdate
*                    ).

  ENDMETHOD.
ENDCLASS.
