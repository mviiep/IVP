CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zsoapapi AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead TYPE TABLE OF zsoapapi.

ENDCLASS.



CLASS lhc_zsoapapi DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsoapapi RESULT result.

    METHODS create FOR MODIFY
      IMPORTING gdata FOR CREATE zsoapapi.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zsoapapi.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zsoapapi.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsoapapi RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zsoapapi.

ENDCLASS.

CLASS lhc_zsoapapi IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

**data Declaration
    TYPES:BEGIN OF ty_header,
            companycode         TYPE  i_journalentry-companycode,
            documentreferenceid TYPE  i_journalentry-documentreferenceid,
          END OF ty_header.

    DATA:header   TYPE ty_header.

    DATA: mapgen LIKE LINE OF mapped-zsoapapi.
    DATA  tgdt   LIKE LINE OF loc=>mt_data.

    DATA:tl LIKE LINE OF mapped-zsoapapi,
         wi LIKE LINE OF loc=>thead.

**********************************************************************
    LOOP AT gdata INTO DATA(dt).

      dt-accountingdocument = '9999999997'.

      MOVE-CORRESPONDING dt TO mapgen.
      MOVE-CORRESPONDING dt TO tgdt.
      APPEND mapgen TO mapped-zsoapapi.
      APPEND tgdt TO loc=>thead.
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

CLASS lsc_zsoapapi DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsoapapi IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA : lt_data      TYPE STANDARD TABLE OF zsoapapi.

    MOVE-CORRESPONDING loc=>thead TO lt_data.




  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
