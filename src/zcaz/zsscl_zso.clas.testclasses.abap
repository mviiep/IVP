CLASS LTC_CONSUMER DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    DATA:
      MO_CUT TYPE REF TO ZSSCL_ZSO.

    METHODS:
      SETUP,
      HANDLE_SALESORDER_CREATED_V1 FOR TESTING
        RAISING
          CX_STATIC_CHECK.
ENDCLASS.

CLASS LTC_CONSUMER IMPLEMENTATION.
  METHOD SETUP.
  mo_cut = NEW #( ).
  ENDMETHOD.
  METHOD HANDLE_SALESORDER_CREATED_V1.
*    DATA: lo_event_dbl TYPE REF TO ZSSIF_SALESORDER_CREATED_V1.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZSSIF_SALESORDER_CREATED_V1' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZSSIF_SALESORDER_CREATED_V1=>ty_s_salesorder_created_v1( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salesorder_created_v1 is called
*    mo_cut->ZSSIF_ZSO_HANDLER~handle_salesorder_created_v1( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
ENDCLASS.
