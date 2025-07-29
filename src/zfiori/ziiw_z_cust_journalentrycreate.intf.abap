interface ZIIW_Z_CUST_JOURNALENTRYCREATE
  public .


  methods JOURNAL_ENTRY_CREATE_REQUEST_C
    importing
      !INPUT type ZJOURNAL_ENTRY_BULK_CREATE_REQ
    exporting
      !OUTPUT type ZJOURNAL_ENTRY_BULK_CREATE_CON .
endinterface.
