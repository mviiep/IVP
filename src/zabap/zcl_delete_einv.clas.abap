CLASS zcl_delete_einv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DELETE_EINV IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  SELECT * FROM zvendor_einv_tab INTO TABLE @DATA(it_del).

  LOOP AT it_del INTO DATA(wa_del).
  DELETE zvendor_einv_tab FROM @wa_del.
  ENDLOOP.

  ENDMETHOD.
ENDCLASS.
