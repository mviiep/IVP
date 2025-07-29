CLASS zcl_base64_to_bitmap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS decodevalue
      IMPORTING
                !encoded    TYPE string
      RETURNING VALUE(rval) TYPE xstring.



  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_BASE64_TO_BITMAP IMPLEMENTATION.


  METHOD decodevalue.

    rval = cl_web_http_utility=>decode_x_base64( encoded = encoded ).


  ENDMETHOD.
ENDCLASS.
