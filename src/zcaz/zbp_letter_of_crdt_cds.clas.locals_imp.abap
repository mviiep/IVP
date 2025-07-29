CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zletter_of_crdt_cds AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead    TYPE TABLE OF zletter_of_crdt_cds,
               tdelhead TYPE TABLE OF zletter_of_crdt_cds,
               titem    TYPE TABLE OF zletter_crdt_itm_cds,
               tdelitem TYPE TABLE OF zletter_crdt_itm_cds.
ENDCLASS.



CLASS lhc_zletter_crdt_itm_cds DEFINITION INHERITING FROM cl_abap_behavior_handler.


  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING gdata FOR CREATE zletter_crdt_itm_cds.

    METHODS update FOR MODIFY
      IMPORTING item_entity FOR UPDATE zletter_crdt_itm_cds.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zletter_crdt_itm_cds.

    METHODS read FOR READ
      IMPORTING keys FOR READ zletter_crdt_itm_cds RESULT result.

    METHODS rba_header FOR READ
      IMPORTING keys_rba FOR READ zletter_crdt_itm_cds\_header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zletter_crdt_itm_cds IMPLEMENTATION.

  METHOD create.


**********************************************************************
**data Declaration
    DATA:tl LIKE LINE OF mapped-zletter_crdt_itm_cds,
         wi LIKE LINE OF loc=>titem.

    TYPES:BEGIN OF ty_so_po,
            so_po(10)    TYPE c,
            so_poitem(6) TYPE c,
          END OF ty_so_po.

    DATA:so_po_item TYPE STANDARD TABLE OF ty_so_po.

**********************************************************************


    LOOP AT gdata INTO DATA(tl1).
      MOVE-CORRESPONDING tl1 TO tl.
      MOVE-CORRESPONDING tl1 TO wi.


      READ TABLE loc=>thead INTO DATA(hd) INDEX 1.

      tl1-so_po = |{ tl1-so_po ALPHA = IN }|.

      SELECT *
      FROM zletter_crdt_itm_cds
      WHERE lcnum =  @tl1-lcnum
      ORDER BY item DESCENDING
      INTO TABLE @DATA(itemtab).

      IF itemtab[] IS NOT INITIAL.
        READ TABLE itemtab INTO DATA(wa_itemtab) INDEX 1.
        wi-item = wa_itemtab-item + 10.
        CONDENSE wi-item.
        wi-item = |{ wi-item ALPHA = IN }|.
      ELSE.
        wi-item = 10.
        wi-item = |{ wi-item ALPHA = IN }|.

      ENDIF.


      MOVE-CORRESPONDING wi TO tl.
      APPEND tl TO mapped-zletter_crdt_itm_cds.
      APPEND wi TO loc=>titem.
    ENDLOOP.


  ENDMETHOD.

  METHOD update.

**********************************************************************
**data Declaration
    DATA:tl LIKE LINE OF mapped-zletter_crdt_itm_cds,
         wi TYPE zletter_crdt_itm.

    TYPES:BEGIN OF ty_so_po,
            so_po(10)    TYPE c,
            so_poitem(6) TYPE c,
          END OF ty_so_po.

    DATA:so_po_item TYPE STANDARD TABLE OF ty_so_po.

**********************************************************************


    LOOP AT item_entity INTO DATA(dt).
      MOVE-CORRESPONDING dt TO wi.

      READ TABLE loc=>thead INTO DATA(hd) INDEX 1.

      IF hd IS INITIAL.
        SELECT SINGLE *
        FROM zletter_of_crdt_cds
        WHERE lcnum = @wi-lcnum
        INTO @hd.
      ENDIF.


      SELECT  *
      FROM zletter_crdt_itm
      WHERE lcnum = @dt-lcnum
      AND item = @dt-item
      INTO TABLE @DATA(itab).

      SELECT SINGLE *
      FROM zletter_crdt_itm
      WHERE lcnum = @dt-lcnum
      AND item = @dt-item
      INTO @DATA(wa).

      MODIFY itab FROM wi INDEX 1.
      MODIFY itab FROM wa INDEX 1 TRANSPORTING creation_date
                                               created_by
                                               changed_date
                                               changed_by.

      MODIFY zletter_crdt_itm FROM TABLE @itab.


    ENDLOOP.

  ENDMETHOD.

  METHOD delete.

    DATA: lwa_line TYPE zletter_crdt_itm_cds.

    LOOP AT keys INTO DATA(lwa_key).
      lwa_line-lcnum           = lwa_key-lcnum.
      lwa_line-bukrs           = lwa_key-bukrs.
      lwa_line-item            = lwa_key-item.
      APPEND lwa_line TO loc=>tdelitem.
      CLEAR: lwa_line.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_header.
  ENDMETHOD.

ENDCLASS.



CLASS lhc_zletter_of_crdt_cds DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zletter_of_crdt_cds RESULT result.

    METHODS create FOR MODIFY
      IMPORTING gdata FOR CREATE zletter_of_crdt_cds.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zletter_of_crdt_cds.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zletter_of_crdt_cds.

    METHODS read FOR READ
      IMPORTING keys FOR READ zletter_of_crdt_cds RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zletter_of_crdt_cds.
    METHODS rba_crdt_itm_cds FOR READ
      IMPORTING keys_rba FOR READ zletter_of_crdt_cds\_crdt_itm_cds FULL result_requested RESULT result LINK association_links.

    METHODS cba_crdt_itm_cds FOR MODIFY
      IMPORTING entities_cba FOR CREATE zletter_of_crdt_cds\_crdt_itm_cds.

ENDCLASS.

CLASS lhc_zletter_of_crdt_cds IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: number TYPE cl_numberrange_runtime=>nr_number,
          mapgen LIKE LINE OF mapped-zletter_of_crdt_cds.
    DATA  tgdt   LIKE LINE OF loc=>mt_data.


    LOOP AT gdata INTO DATA(dt).

      SELECT SINGLE extlcnum
      FROM zletter_of_crdt_cds
      WHERE extlcnum = @dt-%key-extlcnum
      INTO @DATA(lv_extlcnum).


      IF lv_extlcnum IS NOT INITIAL.

        APPEND VALUE #( %key = dt-%key )
                  TO failed-zletter_of_crdt_cds.

        APPEND VALUE #( %key = dt-%key
                        %state_area = 'mandatory_check'
                        %msg = new_message(
                                 id       = 'ZMC_LOC'
                                 number   = 001
                                 severity = if_abap_behv_message=>severity-error
                               ) )
               TO reported-zletter_of_crdt_cds.

      ELSE.

        TRY.
            cl_numberrange_runtime=>number_get(  EXPORTING nr_range_nr = '01' object = 'ZLC_NR' IMPORTING number = number ).
          CATCH: cx_number_ranges.
            "handle exception
        ENDTRY.
        IF dt-lcnum IS INITIAL.
          dt-lcnum = number+10(10).
        ENDIF.


        MOVE-CORRESPONDING dt TO mapgen.
        MOVE-CORRESPONDING dt TO tgdt.
        APPEND mapgen TO mapped-zletter_of_crdt_cds.
        APPEND tgdt TO loc=>thead.

      ENDIF.

    ENDLOOP.





  ENDMETHOD.

  METHOD update.

    DATA:tl LIKE LINE OF mapped-zletter_of_crdt_cds,
         wi TYPE zletter_of_crdt.

    DATA: mapgen LIKE LINE OF mapped-zletter_of_crdt_cds.
    DATA  tgdt   LIKE LINE OF loc=>mt_data.

**********************************************************************

    LOOP AT entities INTO DATA(dt).
      MOVE-CORRESPONDING dt TO wi.

      SELECT  *
      FROM zletter_of_crdt
      WHERE lcnum = @dt-lcnum
      INTO TABLE @DATA(itab).

      SELECT SINGLE *
      FROM zletter_of_crdt
      WHERE lcnum = @dt-lcnum
      INTO @DATA(wa).

      MODIFY itab FROM wi INDEX 1.
      MODIFY itab FROM wa INDEX 1 TRANSPORTING creation_date
                                               created_by
                                               changed_date
                                               changed_by.

      MODIFY zletter_of_crdt FROM TABLE @itab.



    ENDLOOP.




  ENDMETHOD.

  METHOD delete.

    DATA: lwa_line TYPE zletter_of_crdt_cds.

    LOOP AT keys INTO DATA(lwa_key).
      lwa_line-lcnum           = lwa_key-lcnum.
      lwa_line-bukrs           = lwa_key-bukrs.
      lwa_line-businesspartner = lwa_key-businesspartner.
      lwa_line-extlcnum        = lwa_key-extlcnum.
      APPEND lwa_line TO loc=>tdelhead.
      CLEAR: lwa_line.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_crdt_itm_cds.
  ENDMETHOD.

  METHOD cba_crdt_itm_cds.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zletter_of_crdt_cds DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zletter_of_crdt_cds IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA : lt_data      TYPE STANDARD TABLE OF zletter_of_crdt,
           lt_data_item TYPE STANDARD TABLE OF zletter_crdt_itm.

    "If Delete is Requested Header
    IF loc=>tdelhead IS NOT INITIAL.
      LOOP AT loc=>tdelhead INTO DATA(lwa_delhead).
*        DELETE FROM zletter_of_crdt WHERE lcnum          = @lwa_delhead-lcnum
*                                     AND bukrs           = @lwa_delhead-bukrs
*                                     AND businesspartner = @lwa_delhead-businesspartner
*                                     AND extlcnum        = @lwa_delhead-extlcnum.

        UPDATE zletter_of_crdt
        SET isdeleted = 'X'
        WHERE lcnum           = @lwa_delhead-lcnum
          AND bukrs           = @lwa_delhead-bukrs
          AND businesspartner = @lwa_delhead-businesspartner.


      ENDLOOP.
      CLEAR: loc=>tdelhead.
      RETURN.
    ENDIF.

    "If Delete is Requested Header
    IF loc=>tdelitem IS NOT INITIAL.
      LOOP AT loc=>tdelitem INTO DATA(lwa_delitem).
*        DELETE FROM zletter_crdt_itm WHERE lcnum          = @lwa_delitem-lcnum
*                                     AND bukrs            = @lwa_delitem-bukrs
*                                     AND item             = @lwa_delitem-item.

        UPDATE zletter_crdt_itm SET isdeleted = 'X'
          WHERE lcnum          = @lwa_delitem-lcnum
            AND bukrs          = @lwa_delitem-bukrs
            AND item           = @lwa_delitem-item.

      ENDLOOP.
      CLEAR: loc=>tdelitem.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING loc=>thead TO lt_data.
    MOVE-CORRESPONDING loc=>titem TO lt_data_item.

    MODIFY zletter_of_crdt FROM TABLE @lt_data.
    MODIFY zletter_crdt_itm FROM TABLE @lt_data_item.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
