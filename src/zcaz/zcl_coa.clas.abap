CLASS zcl_coa DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA:
      lv_fcd(1)           TYPE c,
      lv_pu(1)            TYPE c,
      lv_isro(1)          TYPE c,
      lv_plant            TYPE i_plant-plant,
      lv_deliverydocument TYPE i_deliverydocument-DeliveryDocument,
      lv_InspectionLot    TYPE i_inspectionlot-InspectionLot.



    METHODS  coa_fcd
      RETURNING VALUE(r_fcdbase64) TYPE string.

    METHODS  coa_pu
      RETURNING VALUE(r_pubase64) TYPE string.

    METHODS  coa_isro
      RETURNING VALUE(r_isrobase64) TYPE string.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COA IMPLEMENTATION.


  METHOD coa_fcd.

    DATA(zcl_coa_fcd) = NEW zcl_coa_fcd( ).
    r_fcdbase64 = zcl_coa_fcd->coa_fcd(
                    p_inspectionlot = lv_inspectionlot
                    p_plant         = lv_plant
                  ).

  ENDMETHOD.


  METHOD coa_isro.

  ENDMETHOD.


  METHOD coa_pu.

    DATA(zcl_coa_pu) = NEW zcl_coa_pu( ).
    r_pubase64 = zcl_coa_pu->coa_pu(
                    p_deliverydocument = lv_deliverydocument
                    p_plant            = lv_plant
                  ).

  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    DATA(lt_params) = request->get_form_fields( ).
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'inspectionlot'.
    lv_inspectionlot = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'plant'.
    lv_plant = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'deliveryno'.
    lv_deliverydocument = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'fcd'.
    lv_fcd = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'pu'.
    lv_pu = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'isro'.
    lv_isro = ls_params-value.

    IF lv_fcd = 'X' .
      TRY.
          response->set_text( coa_fcd( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

    ELSEIF lv_pu = 'X'.
      TRY.
          response->set_text( coa_pu( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

    ELSEIF lv_pu = 'X'.
      TRY.
          response->set_text( coa_isro( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
