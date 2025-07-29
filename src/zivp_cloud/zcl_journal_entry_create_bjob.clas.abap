CLASS zcl_journal_entry_create_bjob DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_apj_dt_exec_object.
  INTERFACES if_apj_rt_exec_object.

  TYPES : BEGIN OF ty_je_doc,
          docnum TYPE string,
          END OF ty_je_doc.

    DATA : it_je_doc TYPE TABLE OF ty_je_doc.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JOURNAL_ENTRY_CREATE_BJOB IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  et_parameter_def = VALUE #( datatype       = 'C'
                                changeable_ind = abap_true
                                ( selname       = 'TEXT'
                                  kind          = if_apj_dt_exec_object=>parameter
                                  param_text    = 'Text'
                                  length        = 250
                                  lowercase_ind = abap_true
*                                  mandatory_ind = abap_true
                                  ) ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

  DATA(obj_je_post) = NEW zcl_journal_entry_create( ).
  obj_je_post->jornalentrycreation(
    IMPORTING
      ex_jepost = it_je_doc
  ).

  clear : it_je_doc.

  ENDMETHOD.
ENDCLASS.
