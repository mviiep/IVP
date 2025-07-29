CLASS zcl_lr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA : it_lr TYPE STANDARD TABLE OF zc_sales_register_main WITH DEFAULT KEY.
    it_lr = CORRESPONDING #( it_original_data ).

    SELECT transporterdocno, transdocdate, billingdocument
        FROM ztab_eway_trans
        FOR ALL ENTRIES IN @it_lr
        WHERE billingdocument = @it_lr-bd
        INTO TABLE @DATA(it_data).

    LOOP AT it_lr ASSIGNING FIELD-SYMBOL(<fs_sign_staus>).
      DATA(wa_data) = VALUE #( it_data[ billingdocument = <fs_sign_staus>-bd ] OPTIONAL ).
      <fs_sign_staus>-lrno = wa_data-transporterdocno.
*      <fs_sign_staus>-lrdate = wa_data-transdocdate.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( it_lr ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
