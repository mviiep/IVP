class ZSSCL_ZSO_BASE definition
  public
  abstract
  create public .

public section.

  interfaces /IWXBE/IF_CONSUMER .
  interfaces ZSSIF_ZSO_HANDLER
      all methods abstract .
protected section.
private section.

  constants:
    GENERATED_AT TYPE STRING VALUE `20240918120857` .
  constants:
    GENERATION_VERSION TYPE I VALUE 1 .
ENDCLASS.



CLASS ZSSCL_ZSO_BASE IMPLEMENTATION.


METHOD /IWXBE/IF_CONSUMER~HANDLE_EVENT.

  " This is a generated class, which might be overwritten in the future.
  " Go to ZSSCL_ZSO to add custom code.

  CASE io_event->get_cloud_event_type( ).
    WHEN 'sap.s4.beh.salesorder.v1.SalesOrder.Created.v1'.
      me->ZSSIF_ZSO_HANDLER~handle_salesorder_created_v1( NEW LCL_SALESORDER_CREATED_V1( io_event ) ).
    WHEN OTHERS.
      RAISE EXCEPTION TYPE /iwxbe/cx_exception
        EXPORTING
          textid = /iwxbe/cx_exception=>not_supported.
  ENDCASE.

ENDMETHOD.
ENDCLASS.
