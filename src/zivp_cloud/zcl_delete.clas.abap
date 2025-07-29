CLASS zcl_delete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DELETE IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.
SELECT * FROM ZGSTR2_RECO_ST WHERE ret_flag = 'X' INTO TABLE @DATA(it_delete).

LOOP AT it_delete INTO DATA(wa_delete).
wa_delete-reten_post_doc = ''.
wa_delete-reten_post = ''.
wa_delete-ret_flag = ''.
wa_delete-reverse_ret = ''.
wa_delete-reverse_ret = ''.
MODIFY zgstr2_reco_st FROM @wa_delete.
ENDLOOP.

ENDMETHOD.
ENDCLASS.
