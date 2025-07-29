CLASS lhc_ZTB_RESOURCE_CAP1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ztb_resource_cap1 RESULT result.

ENDCLASS.

CLASS lhc_ZTB_RESOURCE_CAP1 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
