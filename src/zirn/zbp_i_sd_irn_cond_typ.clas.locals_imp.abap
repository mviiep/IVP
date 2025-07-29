CLASS lhc_zi_sd_irn_cond_typ DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_sd_irn_cond_typ RESULT result.

ENDCLASS.

CLASS lhc_zi_sd_irn_cond_typ IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
