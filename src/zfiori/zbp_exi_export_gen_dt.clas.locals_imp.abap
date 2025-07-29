CLASS lhc_ZEXI_EXPORT_GEN_DT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zexi_export_gen_dt RESULT result.

ENDCLASS.

CLASS lhc_ZEXI_EXPORT_GEN_DT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
