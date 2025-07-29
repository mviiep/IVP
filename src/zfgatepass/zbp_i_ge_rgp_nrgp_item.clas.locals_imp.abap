CLASS lhc_ZI_GE_RGP_NRGP_ITEM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ge_rgp_nrgp_item RESULT result.

ENDCLASS.

CLASS lhc_ZI_GE_RGP_NRGP_ITEM IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
