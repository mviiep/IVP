CLASS lhc_ZGE_EMPTYSVEHICLE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zge_emptysvehicle RESULT result.

ENDCLASS.

CLASS lhc_ZGE_EMPTYSVEHICLE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
