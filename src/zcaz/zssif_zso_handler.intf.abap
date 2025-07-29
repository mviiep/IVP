interface ZSSIF_ZSO_HANDLER
  public .


  methods HANDLE_SALESORDER_CREATED_V1
    importing
      !IO_EVENT type ref to ZSSIF_SALESORDER_CREATED_V1
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.
