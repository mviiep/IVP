CLASS zcl_ge_billing_doc_vh_sto DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
*  class-METHODS get_billdoc.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GE_BILLING_DOC_VH_STO IMPLEMENTATION.


  METHOD    if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      TYPES : BEGIN OF ty_bill,
                billingdocument         TYPE c LENGTH 10,
                billingdocumenttype     TYPE c LENGTH 10,
                billingdocumentcategory TYPE c LENGTH 10,
                Supplier                TYPE c LENGTH 10,
                suppliername            TYPE c LENGTH 30,
                customer                TYPE c LENGTH 10,
                customername            TYPE c LENGTH 30,
                customeraccountgroup    TYPE c LENGTH 10,
                creationdate            TYPE c LENGTH 10,
                creationbyuser          TYPE c LENGTH 10,


              END OF ty_bill.
      DATA : it_billno TYPE TABLE OF ty_bill,
             wa_billno TYPE ty_bill.

      DATA : it_billno2 TYPE TABLE OF ty_bill.

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_sort)    = io_request->get_sort_elements( ).
      DATA : lv_orderby TYPE string.
      DATA(lv_conditions) =  io_request->get_filter( )->get_as_sql_string( ).
      TRY.
          DATA(it_input) =  io_request->get_filter(  )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option2).
      ENDTRY.
*try.
      SELECT a~billingdocument , a~BillingDocumenttype , a~billingdocumentcategory ,
             b~supplier , c~suppliername , c~supplieraccountgroup , b~customername,
             b~customeraccountgroup, a~creationdate , a~createdbyuser

      FROM I_BillingDocument AS a
      LEFT OUTER JOIN i_customer AS b ON a~SoldToParty = b~Customer
      LEFT OUTER JOIN i_supplier AS c ON b~Supplier = c~Supplier
      WHERE a~BillingDocumentType IN (  'JSTO','F8'  )
       INTO TABLE @DATA(it_billno1).

      SELECT deliverydocumentno FROM zge_ow_head WHERE deliverydocumentno IS NOT NULL INTO TABLE @DATA(gt).

      LOOP AT it_billno1 ASSIGNING FIELD-SYMBOL(<f>).
        IF <f> IS ASSIGNED.
          SHIFT <f>-BillingDocument LEFT DELETING LEADING '0'.
          READ TABLE gt ASSIGNING FIELD-SYMBOL(<g>) WITH KEY deliverydocumentno =  <f>-BillingDocument.
          IF  sy-subrc <> 0.
            wa_billno-billingdocument = <f>-BillingDocument.
            MOVE-CORRESPONDING <f> TO wa_billno.
            APPEND wa_billno TO it_billno.
          ENDIF.
        ENDIF.
      ENDLOOP.

      SELECT * FROM @it_billno AS it_billno             "#EC CI_NOWHERE
                    ORDER BY billingdocument
             INTO TABLE @it_billno2
              OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

      io_response->set_data( it_billno2 ).
      io_response->set_total_number_of_records( 100000 ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
