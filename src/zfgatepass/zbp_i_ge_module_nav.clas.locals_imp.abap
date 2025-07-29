CLASS lhc_ZI_GE_MODULE_NAV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ge_module_nav RESULT result.

ENDCLASS.

CLASS lhc_ZI_GE_MODULE_NAV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
