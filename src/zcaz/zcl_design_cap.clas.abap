CLASS zcl_design_cap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: l_stmp1 TYPE timestamp,
          l_stmp2 TYPE timestamp.

    DATA : l_stmp TYPE timestamp,
           date   TYPE d,
           time   TYPE t.
    DATA : lv_hours   TYPE i,
           lv_minutes TYPE i,
           lv_sec     TYPE i,
           lv_seconds TYPE i.
    DATA: lv_hrs(5)  TYPE c,
          lv_mins(2) TYPE n,
          lv_secs(2) TYPE n.


    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DESIGN_CAP IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA : it_sign_status TYPE STANDARD TABLE OF zc_dpr WITH DEFAULT KEY.
    it_sign_status = CORRESPONDING #( it_original_data ).
    GET TIME STAMP FIELD l_stmp.
    SELECT DISTINCT *
      FROM zi_daily_breakdown
      FOR ALL ENTRIES IN @it_sign_status
      WHERE processorder = @it_sign_status-manufacturingorder
        AND milestoneisconfirmed = ''
*      AND datep  = @it_sign_status-postingdate
*      AND ordertype = @it_sign_status-manufacturingordertype
*      AND plant = @it_sign_status-plant
      INTO TABLE @DATA(it_item).
    SELECT * FROM ztb_resource_cap
        FOR ALL ENTRIES IN @it_sign_status
        WHERE resrce = @it_sign_status-workcenter
        INTO TABLE @DATA(it_designcap).
    LOOP AT it_sign_status ASSIGNING FIELD-SYMBOL(<fs_sign_staus>).
*      <fs_sign_staus>-designcap = 'test'.
      DATA(wa_itm) = VALUE #( it_item[ processorder = <fs_sign_staus>-manufacturingorder ] OPTIONAL ).

      CONCATENATE wa_itm-confirmedexecutionstartdate wa_itm-confirmedexecutionstarttime INTO DATA(startdateandtime).
      CONCATENATE wa_itm-confirmedexecutionenddate wa_itm-confirmedexecutionendtime INTO DATA(enddateandtime).

      l_stmp1 = startdateandtime.
      l_stmp2 = enddateandtime.

      DATA(difference) = cl_abap_tstmp=>subtract(
                           tstmp1 = l_stmp2
                           tstmp2 = l_stmp1
                         ).
      lv_sec = difference.
      lv_seconds = lv_sec.
      lv_hours = lv_seconds / 3600.
      lv_seconds = lv_sec - lv_hours * 3600.
      lv_minutes = lv_seconds / 60.
      lv_seconds = lv_seconds - lv_minutes * 60.

      lv_hrs  = lv_hours.
      lv_mins = lv_minutes.
      lv_secs = lv_seconds.

      DATA(wa_designcap) = VALUE #( it_designcap[ resrce = <fs_sign_staus>-workcenter ] OPTIONAL ).
      IF lv_hours < 1.
        lv_hours = 1.
      ENDIF.
      <fs_sign_staus>-designcap = wa_designcap-design_cap * ( 24 / lv_hours ).


    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( it_sign_status ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
