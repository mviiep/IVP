CLASS lhc_buffer DEFINITION.
* 1) define the data buffer
  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zletter_of_crdt_cds AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer .

    CLASS-DATA mt_data TYPE tdata.


ENDCLASS.

CLASS lhc_zletter_crdt_itm_cds DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zletter_crdt_itm_cds RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zletter_crdt_itm_cds.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zletter_crdt_itm_cds.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zletter_crdt_itm_cds.

    METHODS read FOR READ
      IMPORTING keys FOR READ zletter_crdt_itm_cds RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zletter_crdt_itm_cds.

ENDCLASS.

CLASS lhc_zletter_crdt_itm_cds IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zletter_crdt_itm_cds DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zletter_crdt_itm_cds IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
