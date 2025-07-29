CLASS zcl_fi_pur_reg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FI_PUR_REG IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA:final    TYPE STANDARD TABLE OF zce_fipur_reg,
         it_final TYPE STANDARD TABLE OF zce_fipur_reg,
         wa_final LIKE LINE OF  final,
         accdoc   TYPE RANGE OF i_journalentry-accountingdocument,
         post     TYPE RANGE OF i_journalentry-postingdate,
         vendor1  TYPE RANGE OF i_journalentryitem-supplier.

    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
    DATA(lsort) = io_request->get_sort_elements( ) .
*    data(page) = io_request->
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).  "#EC NO_HANDLER
    ENDTRY.

    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA(set) = io_request->get_requested_elements( )."  --> could be used for optimizations
    DATA(lvs) = io_request->get_search_expression( ).
    DATA(filter1) = io_request->get_filter(  ).
    DATA(p1) = io_request->get_parameters(  ).
    DATA(p2) = io_request->get_requested_elements(  ).
*    DATA(rng) = filter1->get_as_ranges(   ).

    DATA(str) = filter1->get_as_sql_string(  ).

    READ TABLE lt_filter_cond INTO DATA(filter) WITH KEY name = 'ACCOUNTINGDOCUMENT'.
    MOVE-CORRESPONDING filter-range TO accdoc.
    READ TABLE lt_filter_cond INTO DATA(filterpd) WITH KEY name = 'POSTINGDATE'.
    MOVE-CORRESPONDING filterpd-range TO post.
    READ TABLE lt_filter_cond INTO DATA(filtervendr) WITH KEY name = 'VENDOR'.
    MOVE-CORRESPONDING filtervendr-range TO vendor1.

    SELECT * FROM zc_fipur_reg WHERE
    (  accountingdocumenttype = 'KG' AND debitcreditcode = 'H' )
     OR ( accountingdocumenttype = 'KR' AND debitcreditcode = 'S' )
    ORDER BY accountingdocument  INTO CORRESPONDING FIELDS OF TABLE @final.
    SELECT * FROM @final AS final
        WHERE (str)
        ORDER BY accountingdocument
        INTO CORRESPONDING FIELDS OF TABLE @it_final
        OFFSET @off UP TO @lv_max_rows ROWS .
*    DELETE final WHERE accountingdocument NOT IN accdoc OR postingdate NOT IN post OR vendor NOT IN vendor1." '1700000003'.

    io_response->set_data( it_final ).
    io_response->set_total_number_of_records( 100000 ).
  ENDMETHOD.
ENDCLASS.
