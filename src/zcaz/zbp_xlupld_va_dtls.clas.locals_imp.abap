CLASS lhc_zxlupld_va_dtls DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zxlupld_va_dtls RESULT result.

ENDCLASS.

CLASS lhc_zxlupld_va_dtls IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
