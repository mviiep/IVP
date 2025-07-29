CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zcds_Weighbridge AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead TYPE TABLE OF zcds_Weighbridge,
               titem TYPE TABLE OF zcds_Weighbridge.
ENDCLASS.

CLASS lhc_zcds_weighbridge DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcds_weighbridge RESULT result.

    METHODS create FOR MODIFY
      IMPORTING gdata FOR CREATE zcds_weighbridge.

    METHODS update FOR MODIFY
      IMPORTING gdata FOR UPDATE zcds_weighbridge.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcds_weighbridge.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcds_weighbridge RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcds_weighbridge.

ENDCLASS.

CLASS lhc_zcds_weighbridge IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
**data Declaration
DATA:
          mapgen LIKE LINE OF mapped-zcds_weighbridge.
    DATA  tgdt   LIKE LINE OF loc=>mt_data.
DATA:tl LIKE LINE OF mapped-zcds_weighbridge.

DATA: wa_zweighbridge TYPE zweighbridge.
     LOOP AT gdata INTO DATA(wa_gdata).
     MOVE-CORRESPONDING wa_gdata TO mapgen.
      MOVE-CORRESPONDING wa_gdata TO tgdt.
      APPEND mapgen TO mapped-zcds_weighbridge.
      APPEND tgdt TO loc=>thead.
*     MOVE-CORRESPONDING wa_gdata to wa_zweighbridge.
*       MODIFY zweighbridge FROM @wa_zweighbridge.
   ENDLOOP.

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

CLASS lsc_zcds_weighbridge DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_weighbridge IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
   DATA : lt_data      TYPE STANDARD TABLE OF zweighbridge.
          MOVE-CORRESPONDING loc=>thead TO lt_data.
           MODIFY zweighbridge FROM TABLE @lt_data.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
