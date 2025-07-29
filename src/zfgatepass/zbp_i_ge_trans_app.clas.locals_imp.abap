CLASS lhc_ZI_GE_TRANS_APP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ge_trans_app RESULT result.

ENDCLASS.

CLASS lhc_ZI_GE_TRANS_APP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
