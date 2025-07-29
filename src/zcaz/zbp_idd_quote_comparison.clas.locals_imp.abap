*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS loc DEFINITION.
    PUBLIC SECTION.
    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   ZIDD_QUOTE_COMPARISON AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

        TYPES tdata TYPE TABLE OF ty_buffer.
        CLASS-DATA mt_data TYPE tdata.

   CLASS-DATA:thead   TYPE TABLE OF ZIDD_QUOTE_COMPARISON,
               tdel   type table of ZIDD_QUOTE_COMPARISON.

ENDCLASS.


CLASS lhc_ZIDD_QUOTE_COMPARISON DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZIDD_QUOTE_COMPARISON RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZIDD_QUOTE_COMPARISON.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZIDD_QUOTE_COMPARISON.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZIDD_QUOTE_COMPARISON.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZIDD_QUOTE_COMPARISON RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZIDD_QUOTE_COMPARISON.

ENDCLASS.

CLASS lhc_ZIDD_QUOTE_COMPARISON IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.
  METHOD create.
  ENDMETHOD.
   METHOD update.

**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-ZIDD_QUOTE_COMPARISON,
          tgdt    LIKE LINE OF loc=>mt_data.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-ZIDD_QUOTE_COMPARISON.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

    METHOD delete.
  data: lwa_line type ZIDD_QUOTE_COMPARISON.
    loop at keys INTO data(lwa_key).
    lwa_line-requestforquotation = lwa_key-RequestForQuotation.
"    lwa_line-rfq_item      = lwa_key-rfq_item.
    append lwa_line to loc=>tdel.
    clear: lwa_line.
    ENDLOOP.
  ENDMETHOD.

*end of delete method

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

"**************************************************************************"
" SAVER Class definition and implementation
"**************************************************************************"
CLASS lsc_ZIDD_QUOTE_COMPARISON DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZIDD_QUOTE_COMPARISON IMPLEMENTATION.

      METHOD finalize.
      ENDMETHOD.

      METHOD check_before_save.
      ENDMETHOD.
"***************************************************************"
" SAVE Method
"***************************************************************"
      METHOD save.
      ENDMETHOD.

      METHOD cleanup.

      ENDMETHOD.

      METHOD cleanup_finalize.
      ENDMETHOD.
  ENDCLASS.
