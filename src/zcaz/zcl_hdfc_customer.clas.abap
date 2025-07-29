CLASS zcl_hdfc_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HDFC_CUSTOMER IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CHECK NOT it_original_data IS INITIAL.

    DATA : lt_data TYPE STANDARD TABLE OF zi_hdfc_customer WITH DEFAULT KEY.

    lt_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<customer>).

      DATA(customer) = <customer>-virtualaccount.
      SHIFT customer BY ( strlen( customer ) - 6 ) PLACES LEFT.
      customer = |{ customer ALPHA = IN }|.


      SELECT SINGLE customer,customername
      FROM i_customer
      WHERE customer = @customer
      INTO @DATA(wa_customer).

      <customer>-customer     =  wa_customer-customer.
      <customer>-customername = wa_customer-customername.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    et_requested_orig_elements = VALUE #( BASE et_requested_orig_elements
                                              ( CONV #( 'CUSTOMER' ) )
                                              ( CONV #( 'CUSTOMERNAME' ) )
                                            ).

  ENDMETHOD.
ENDCLASS.
