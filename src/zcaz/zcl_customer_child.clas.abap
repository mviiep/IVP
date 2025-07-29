CLASS zcl_customer_child DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_final1,
              supplier_code     TYPE c LENGTH 10,
              fiscal_year       TYPE c LENGTH 4,
              document_no       TYPE c LENGTH 10,
              days_0_to_30      TYPE  p DECIMALS 2 LENGTH 10,
              days_31_to_60     TYPE  p DECIMALS 2 LENGTH 10,
              days_61_to_90     TYPE p DECIMALS 2 LENGTH 10,
              days_91_to_120    TYPE p DECIMALS 2 LENGTH 10,
              days_121_to_150   TYPE p DECIMALS 2 LENGTH 10,
              days_151_to_180   TYPE p DECIMALS 2 LENGTH 10,
              days_181_to_365   TYPE p DECIMALS 2 LENGTH 10,
              days_366_to_999   TYPE p DECIMALS 2 LENGTH 10,
              days_999          TYPE p DECIMALS 2 LENGTH 10,
              unadjusted_debits TYPE p DECIMALS 2 LENGTH 10,
              msme              TYPE p DECIMALS 2 LENGTH 10,
              totalamount       TYPE p DECIMALS 2 LENGTH 10,
              not_due           TYPE p DECIMALS 2 LENGTH 10,
              over_due          TYPE p DECIMALS 2 LENGTH 10,
            END OF ty_final1.

    DATA: it_final1    TYPE TABLE OF ty_final1,
          imp_itab     TYPE TABLE OF ty_final1,
          it_final2    TYPE TABLE OF ty_final1,
          it_mat_final TYPE TABLE OF ty_final1,
          it_val       TYPE TABLE OF ty_final1,
          wa_final1    TYPE ty_final1,
          wa_val       TYPE ty_final1.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMER_CHILD IMPLEMENTATION.
ENDCLASS.
