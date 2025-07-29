CLASS lhc_ZEXI_EXPORT_RODTEP_DT DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zexi_export_rodtep_dt RESULT result.

ENDCLASS.

CLASS lhc_ZEXI_EXPORT_RODTEP_DT IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
