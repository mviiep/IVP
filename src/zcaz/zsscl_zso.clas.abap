class ZSSCL_ZSO definition
  public
  inheriting from ZSSCL_ZSO_BASE
  final
  create public .

public section.

  methods ZSSIF_ZSO_HANDLER~HANDLE_SALESORDER_CREATED_V1
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZSSCL_ZSO IMPLEMENTATION.


METHOD ZSSIF_ZSO_HANDLER~HANDLE_SALESORDER_CREATED_V1.

  " Event Type: sap.s4.beh.salesorder.v1.SalesOrder.Created.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZSS_SalesOrder_Created_v1.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.
ENDCLASS.
