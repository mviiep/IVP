CLASS lhc_ZEX_RODTEP_MASTER DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zex_rodtep_master RESULT result.

ENDCLASS.

CLASS lhc_ZEX_RODTEP_MASTER IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
