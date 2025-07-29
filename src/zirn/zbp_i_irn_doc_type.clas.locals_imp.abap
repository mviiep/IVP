CLASS lhc_ZI_IRN_DOC_TYPE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_irn_doc_type RESULT result.

ENDCLASS.

CLASS lhc_ZI_IRN_DOC_TYPE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
