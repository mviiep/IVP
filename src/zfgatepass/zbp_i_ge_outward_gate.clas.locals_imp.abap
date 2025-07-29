CLASS lhc_ZI_GE_OUTWARD_GATE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ge_outward_gate RESULT result.

ENDCLASS.

CLASS lhc_ZI_GE_OUTWARD_GATE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
