CLASS lhc_ZI_GE_OW_HEAD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ge_ow_head RESULT result.

ENDCLASS.

CLASS lhc_ZI_GE_OW_HEAD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
