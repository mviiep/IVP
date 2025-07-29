CLASS zcl_einvoicing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*******************LOGIN REsponse*********************************
    TYPES : BEGIN OF it_response,
              token TYPE string,
            END OF it_response.
    DATA: wa_response TYPE it_response.
    DATA:
      username TYPE string,
      pass     TYPE string.
    DATA: lv_id1 TYPE string,
          lv_id2 TYPE string.
******************STructure for importing keys*********************************
    TYPES: BEGIN OF ty_keys,
             billingdocument TYPE c LENGTH 10,
             companycode     TYPE c LENGTH 4,
             fiscalyear      TYPE c LENGTH 4,
*             postingdate     TYPE datn,
*             irn(64),
           END OF ty_keys.
    DATA it_keys TYPE TABLE OF ty_keys.
    DATA : lv_url       TYPE string,
           lv_url1      TYPE string,
           lv_url2      TYPE string,
           lv_tokenresp TYPE string,
           lv_json      TYPE string,
           gstkey       TYPE string.
**************************** SUccess IRN Generation Response*******************************
    TYPES: BEGIN OF ty_msg,
             ackno(20),
             ackdt(20),
             irn(64),
             signedinvoice    TYPE string,
             signedqrcode     TYPE string,
             ewbno(20),
             ewbdt(20),
             ewbvalidtill(30),
             status(3),
             remarks          TYPE string,
             alert            TYPE string,
             error            TYPE string,
           END OF ty_msg.
    TYPES: BEGIN OF ty_result,
             message      TYPE ty_msg,
             errormessage TYPE string,
             infodtls     TYPE string,
             status(10),
             code(3),
             requestid    TYPE string,
           END OF ty_result.
    TYPES: BEGIN OF ty_irnsuccess,
             results TYPE ty_result,
           END OF ty_irnsuccess.
    DATA wa_irnsuccess TYPE ty_irnsuccess.
*******************************************************************************************
************************JSON Structure for IRN Cancel********************************
    TYPES: BEGIN OF ty_irncnc,
             user__gstin(15),
             irn                  TYPE string,
             cancel__reason(1),
             cancel__remarks(20),
             ewaybill__cancel(10),
           END OF ty_irncnc.
    DATA:  wa_irncnc TYPE ty_irncnc.
*************************************************************************************
******************************IRN Cancel Success response**************************
    DATA: lv_date     TYPE datn,
          lv_time(10).
    TYPES : BEGIN OF ty_irncncmsg,
              irn(64),
              canceldate(20),
            END OF ty_irncncmsg.
    TYPES : BEGIN OF ty_irncncresults,
              message      TYPE ty_irncncmsg,
              errormessage TYPE string,
              infodtls     TYPE string,
              status(10),
              code(3),
            END OF ty_irncncresults.
    TYPES : BEGIN OF ty_irncncsuccess,
              results TYPE ty_irncncresults,
            END OF ty_irncncsuccess.
    DATA wa_finirncncsuccess TYPE  ty_irncncsuccess.

    "Eway Structure
*********************************EWAY Importing Structure *************************
    TYPES : BEGIN OF ty_eway,
              billingdocument    TYPE ztab_eway_trans-billingdocument,
              fiscalyear         TYPE ztab_eway_trans-fiscalyear,
              postingdate        TYPE ztab_eway_trans-postingdate,
              companycode        TYPE ztab_eway_trans-companycode,
              trans_id           TYPE ztab_eway_trans-transporterid,
              trans_doc_no       TYPE ztab_eway_trans-transporterdocno,
              trans_dist         TYPE ztab_eway_trans-transdistance,
              supply_typ         TYPE ztab_eway_trans-subsplytyp,
              trans_name         TYPE ztab_eway_trans-transportername,
              trans_doc_date(10),
              vehicle_no         TYPE ztab_eway_trans-vehicleno,
              transmode          TYPE ztab_eway_trans-transportmode,
              vehicletype        TYPE ztab_eway_trans-vehicletype,
            END OF ty_eway.
    DATA : it_eway TYPE TABLE OF ty_eway,
           wa_eway TYPE ty_eway.
***********************************************************************************
**********************Eway with irn generation json structure**********************
    TYPES : BEGIN OF ty_ewaydispatch,
              company__name(100),
              address1(100),
              address2(100),
              location(20),
              pincode(10),
              state__code(2),
            END OF ty_ewaydispatch.
    TYPES : BEGIN OF ty_ewayship,
              address1(100),
              address2(100),
              location(20),
              pincode(10),
              state__code(2),
            END OF ty_ewayship.
    TYPES : BEGIN OF ty_ewayirn,
              user__gstin                     TYPE string,
              irn(64),
              transporter__id                 TYPE  ztab_eway_trans-transporterid,
              transportation__mode            TYPE ztab_eway_trans-transportmode,
              transporter__document__number   TYPE ztab_eway_trans-transporterdocno,
              transporter__document__date(10),
              vehicle__number(10),
              distance(4),
              vehicle__type(1),
              transporter__name(100),
              data__source(3),
*              dispatch__details               TYPE ty_ewaydispatch,
*              ship__details                   TYPE ty_ewayship,
            END OF ty_ewayirn.
    DATA wa_ewayirn TYPE ty_ewayirn.
*************************EWAY Success Response JSON*******************
    TYPES : BEGIN OF ty_ewayirnsucmsg,
              ewbno(20),
              ewbdt(22),
              ewbvalidtill(22),
              remarks(25),
              qrcodeurl(500),
              einvoicepdf(500),
              ewaybillpdf(500),
            END OF ty_ewayirnsucmsg.
    TYPES : BEGIN OF ty_ewayirnresultsucc,
              message          TYPE ty_ewayirnsucmsg,
              errormessage(20),
              infodtls(50),
              status(20),
              code(3),
            END OF ty_ewayirnresultsucc.
    TYPES : BEGIN OF ty_ewayirnsuccess,
              results TYPE ty_ewayirnresultsucc,
            END OF ty_ewayirnsuccess.
    DATA wa_ewayirnsuccess TYPE ty_ewayirnsuccess.
**********************************************************************
************************Structure for Failure Response**************************************
    TYPES : BEGIN OF ty_failresult,
              message      TYPE string,
              errormessage TYPE string,
              infodtls     TYPE string,
              status       TYPE string,
              code(3),
              requestid    TYPE string,
            END OF ty_failresult.
    TYPES : BEGIN OF ty_irnfail,
              results TYPE ty_failresult,
            END OF ty_irnfail.
    DATA wa_irnfail TYPE ty_irnfail.
*********************************************************************************
******************************Eway IRN Cancel Success response**************************
    TYPES : BEGIN OF ty_ewayirncncmsg,
              ewaybillno(12),
              canceldate(20),
            END OF ty_ewayirncncmsg.
    TYPES : BEGIN OF ty_ewayirncncresults,
              message    TYPE ty_ewayirncncmsg,
              status(10),
              code(3),
            END OF ty_ewayirncncresults.
    TYPES : BEGIN OF ty_ewayirncncsuccess,
              results TYPE ty_ewayirncncresults,
            END OF ty_ewayirncncsuccess.
    DATA wa_finewayirncncsuccess TYPE  ty_ewayirncncsuccess.

****************************EWB Success Response*********************************
    TYPES : BEGIN OF ty_resultewbsuccessresp,
              ewaybillno(20),
              ewaybilldate(25),
              validupto(25),
              alert(10),
              error(10),
              url(100),
            END OF ty_resultewbsuccessresp.
    TYPES: BEGIN OF ty_msgewbsucc,
             message       TYPE ty_resultewbsuccessresp,
             status(10),
             code(3),
             requestid(20),
           END OF ty_msgewbsucc.
    TYPES : BEGIN OF ty_ewbsuccessresp,
              results TYPE ty_msgewbsucc,

            END OF ty_ewbsuccessresp.
    DATA wa_ewbsuccessresp TYPE ty_ewbsuccessresp.
*************************eway cancel json structure******************************
    TYPES : BEGIN OF ty_ewaycnc,
              user_gstin(15),
              eway__bill__number(15),
              reason__of__cancel(15),
              cancel__remark(20),
              data__source(3),
            END OF ty_ewaycnc.
    DATA wa_ewaycnc TYPE ty_ewaycnc.
*********************************************************************************
**data Declaration
    DATA: r_token         TYPE string,
          billingdocument TYPE i_billingdocument-billingdocument,
          textid          TYPE c.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'JNY',
           lv_qas(3) TYPE c VALUE 'JF4',
           lv_prd(3) TYPE c VALUE 'KSZ'.

    CLASS-DATA: lt_irn_result TYPE TABLE OF zi_irn_alv,
                wa_maintab    TYPE ztab_j1ig_invref.
***********************************************************************************
    DATA:
      mo_http_destination TYPE REF TO if_http_destination,
      mv_client           TYPE REF TO if_web_http_client.

****************Method Declarion****************************
    METHODS:irngen IMPORTING docno LIKE it_keys RETURNING VALUE(lv_json_response) TYPE string.
    METHODS:irncnc IMPORTING docno LIKE it_keys RETURNING VALUE(lv_json_response) TYPE string.
    METHODS:ewaycnc IMPORTING docno LIKE it_keys RETURNING VALUE(lv_json_response) TYPE string.
    METHODS:gen_ewayirn IMPORTING it_eway                 LIKE it_eway
                        EXPORTING lv_json                 TYPE string
                        RETURNING VALUE(lv_json_response) TYPE string.
    METHODS:gen_eway IMPORTING it_eway                 LIKE it_eway
                     EXPORTING lv_json                 TYPE string
                     RETURNING VALUE(lv_json_response) TYPE string.
    METHODS:header_text IMPORTING billingdocument TYPE i_billingdocument-billingdocument
                                  textid          TYPE c
                        RETURNING VALUE(r_val)    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EINVOICING IMPLEMENTATION.


  METHOD ewaycnc.
    DATA(wa_bd) = VALUE #( docno[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
    SELECT SINGLE * FROM i_billingdocumentitem
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_fin).
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
    IF sy-subrc = 0.
      READ TABLE it_jbrch INTO DATA(ls_j_1bbranch) WITH KEY companycode = wa_fin-companycode
                                                            plant = wa_fin-plant.
      READ TABLE it_jbrch1 INTO DATA(ls_j_1bbranch1) WITH KEY companycode = ls_j_1bbranch-companycode
                                                                businessplace = ls_j_1bbranch-businessplace.
      IF sy-subrc = 0.
        gstkey = ls_j_1bbranch1-in_gstidentificationnumber.
      ENDIF.
    ENDIF.
    SELECT SINGLE ewbno FROM ztab_j1ig_invref WHERE docno = @wa_bd-billingdocument INTO @DATA(lv_eway).
    wa_ewaycnc-eway__bill__number = lv_eway.
    wa_ewaycnc-user_gstin = ls_j_1bbranch1-in_gstidentificationnumber.
    wa_ewaycnc-reason__of__cancel = 'Others'.
    wa_ewaycnc-cancel__remark = 'Cancelled the order'.
    wa_ewaycnc-data__source = 'erp'.
    CLEAR lv_json.
    lv_json = /ui2/cl_json=>serialize( data = wa_ewaycnc
                                       compress = abap_false
                                       pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    CONDENSE lv_json.
    DATA(zauthclass) = NEW zcl_irn_auth( ).
    DATA(authjson) = zauthclass->token_gen(
                       EXPORTING
                         gstin    = gstkey
                       IMPORTING
                         wa_response = wa_response
                     ).
    SELECT SINGLE link
        FROM zirn_login
        WHERE systemid = @sy-sysid
        INTO @lv_url1.
    lv_url2 = '/api/v1/ewayBillCancel/'.
    CONCATENATE lv_url1 lv_url2 INTO lv_url.
    DATA: lo_http_client2 TYPE REF TO if_web_http_client.
    TRY.
        lo_http_client2 = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    DATA token TYPE string.
    CONCATENATE 'JWT' wa_response-token INTO token SEPARATED BY space.
    DATA(lo_request2) = lo_http_client2->get_http_request( ).
    lo_request2->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = '*/*' )
                ( name = 'Authorization' value = token )
*               (  name = 'MiplApikey' value  = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9' )
               ) ).
    lo_request2->append_text( EXPORTING data   = lv_json ).
    TRY.
        DATA(lv_response) = lo_http_client2->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    CLEAR lv_json_response.
    lv_json_response = lv_response->get_text( ).
*    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
*    IF sy-subrc EQ 0.
*      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
*                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*                                 CHANGING data = wa_finirncncsuccess ).
*      REPLACE ALL OCCURRENCES OF '-' IN wa_finirncncsuccess-results-message-canceldate WITH ''.
*      SPLIT wa_finirncncsuccess-results-message-canceldate AT space INTO lv_date lv_time.
*      CONDENSE lv_date.
**      DATA(lv) = CONV datn( lv_date ).
*      DATA(lv_ewb) = wa_finewayirncncsuccess-results-message-ewaybillno.
*      CONDENSE lv_ewb.
**      select single irn from ztab_j1ig_invref where ewbno = @lv_ewb into @data(lv_irnew).
*      wa_maintab-ewb_canceled = 'X'.
*      wa_maintab-cancel_date = lv_date.
*      wa_maintab-ewbstatus = 'CNC'.
*      UPDATE ztab_j1ig_invref SET cancel_date = @wa_maintab-cancel_date ,
*      ewb_canceled = @wa_maintab-ewb_canceled,
*      ewbstatus = @wa_maintab-ewbstatus WHERE irn = @lv_irnew.
*      IF sy-subrc EQ 0.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD gen_eway.
    DATA(call_ewb) = NEW zcl_einvoice_data( ).
    DATA(ewb_json) = call_ewb->get_ewb(
                            EXPORTING it_eway = it_eway
                            IMPORTING lv_json = lv_json ).
    DATA(wa_bd) = VALUE #( it_eway[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
    SELECT SINGLE * FROM i_billingdocumentitem
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_fin).
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
    IF sy-subrc = 0.
      READ TABLE it_jbrch INTO DATA(ls_j_1bbranch) WITH KEY companycode = wa_fin-companycode
                                                      plant = wa_fin-plant.
      READ TABLE it_jbrch1 INTO DATA(ls_j_1bbranch1) WITH KEY companycode = ls_j_1bbranch-companycode
                                                        businessplace = ls_j_1bbranch-businessplace.
      IF sy-subrc = 0.
        gstkey = ls_j_1bbranch1-in_gstidentificationnumber.
      ENDIF.
    ENDIF.
    DATA(zauthclass) = NEW zcl_irn_auth( ).
    DATA(authjson) = zauthclass->token_gen(
                       EXPORTING
                         gstin    = gstkey
                       IMPORTING
                         wa_response = wa_response
                     ).
    SELECT SINGLE link
         FROM zirn_login
         WHERE systemid = @sy-sysid
         INTO @lv_url1.
    lv_url2 = '/api/v1/ewayBillsGenerate/'.
    CONCATENATE lv_url1 lv_url2 INTO lv_url.
    DATA: lo_http_client2    TYPE REF TO if_web_http_client,
          token              TYPE string,
          wa_zj1ig_invrefnum TYPE ztab_j1ig_invref.
    TRY.
        lo_http_client2 = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    CONCATENATE 'JWT' wa_response-token INTO token SEPARATED BY space.
    DATA(lo_request2) = lo_http_client2->get_http_request( ).
    lo_request2->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = '*/*' )
                ( name = 'Authorization' value = token )
               ) ).
    lo_request2->append_text( EXPORTING data   = lv_json ).
    TRY.
        DATA(lv_response) = lo_http_client2->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    CLEAR lv_json_response.
    lv_json_response = lv_response->get_text( ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc = 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                     pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                           CHANGING data = wa_ewbsuccessresp ).

      SPLIT wa_ewbsuccessresp-results-requestid AT '_' INTO lv_id1 lv_id2.
      SELECT SINGLE documentreferenceid, billingdocumentdate
        FROM i_billingdocument
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_odn).

      wa_zj1ig_invrefnum-ewbdt = wa_ewbsuccessresp-results-message-ewaybilldate.
      wa_zj1ig_invrefnum-ewbno = wa_ewbsuccessresp-results-message-ewaybillno.
      wa_zj1ig_invrefnum-ewbstatus = 'ACT'." wa_ewbsuccessresp-results-message.
      wa_zj1ig_invrefnum-ewbvalidtill = wa_ewbsuccessresp-results-message-validupto.
      wa_zj1ig_invrefnum-ewb_url = wa_ewbsuccessresp-results-message-url.
      wa_zj1ig_invrefnum-docno = wa_bd-billingdocument.
      wa_zj1ig_invrefnum-doc_year = wa_bd-fiscalyear.
      wa_zj1ig_invrefnum-odn = wa_odn-documentreferenceid.
      wa_zj1ig_invrefnum-odn_date = wa_odn-billingdocumentdate.


*      wa_zj1ig_invrefnum-
      MODIFY ztab_j1ig_invref FROM @wa_zj1ig_invrefnum.
*          SET ewbno = @wa_ewbsuccessresp-results-ewaybillno,
*            ewbdt = @wa_ewbsuccessresp-results-ewaybilldate,
*            ewbvalidtill = @wa_ewayirnsuccess-results-message-ewbvalidtill,
*            ewbstatus = 'ACT' WHERE docno = @lv_irn.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"No Content"' IN lv_json_response.
    IF sy-subrc = 0.

    ENDIF.
  ENDMETHOD.


  METHOD gen_ewayirn.

***    *    get business place details
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
    SELECT * FROM zgst_region_map INTO TABLE @DATA(gt_gst_region).
***  Ship to detail
    DATA(wa_eway) = VALUE #( it_eway[ 1 ] OPTIONAL ).
    wa_eway-billingdocument = |{ wa_eway-billingdocument ALPHA = IN }|.
    SELECT * FROM i_billingdocumentitem
*             FOR ALL ENTRIES IN @it_eway
             WHERE billingdocument = @wa_eway-billingdocument
             INTO TABLE @DATA(gt_sdinv1).
    SELECT * FROM i_billingdocumentpartner
*               FOR ALL ENTRIES IN @it_eway
               WHERE billingdocument = @wa_eway-billingdocument
                 AND partnerfunction IN ( 'RE', 'WE' )
                INTO TABLE @DATA(it_billdoc).

*    IF gt_vbpa IS NOT INITIAL.
    SELECT customer, country, organizationbpname1, organizationbpname2, cityname, postalcode,
        region, streetname, addressid, districtname, taxnumber3
        FROM i_customer
        FOR ALL ENTRIES IN @it_billdoc
        WHERE customer = @it_billdoc-customer
        INTO TABLE @DATA(gt_kna1).
    SELECT * FROM i_companycode
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE companycode = @gt_sdinv1-companycode
          INTO TABLE @DATA(gt_t001).
    IF gt_kna1 IS NOT INITIAL.
      SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
          FOR ALL ENTRIES IN @gt_kna1
          WHERE addressid = @gt_kna1-addressid
          INTO TABLE @DATA(gt_adrc).
    ENDIF.
****SUpplier details Dispatch from
    SELECT * FROM i_plant
      FOR ALL ENTRIES IN @gt_sdinv1
      WHERE plant = @gt_sdinv1-plant
      INTO TABLE @DATA(gt_t001w).
    IF gt_t001w IS NOT INITIAL.
      SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
        FOR ALL ENTRIES IN @gt_t001w
        WHERE addressid = @gt_t001w-addressid
        APPENDING TABLE @gt_adrc.
    ENDIF.
***ship to detail
    READ TABLE gt_sdinv1 INTO DATA(ls_sdinv) INDEX 1.
    READ TABLE it_billdoc INTO DATA(ls_vbpa) WITH KEY billingdocument = ls_sdinv-billingdocument partnerfunction = 'WE'.
*    IF sy-subrc = 0.
*      READ TABLE gt_kna1 INTO DATA(ls_knas) WITH KEY customer = ls_vbpa-customer.
*      IF sy-subrc = 0.
*        READ TABLE gt_adrc INTO DATA(ls_shpto) WITH KEY addressid = ls_knas-addressid.
*        IF sy-subrc = 0.
*          CONCATENATE ls_shpto-building ls_shpto-housenumber ls_shpto-housenumbersupplementtext ls_shpto-streetname
*              INTO wa_ewayirn-ship__details-address1 SEPARATED BY ''.
*          CONDENSE wa_ewayirn-ship__details-address1.
*          CONCATENATE ls_shpto-floor ls_shpto-streetprefixname1 ls_shpto-streetprefixname2 ls_shpto-cityname
*              INTO wa_ewayirn-ship__details-address2 SEPARATED BY space.
*          CONDENSE wa_ewayirn-ship__details-address2.
*          wa_ewayirn-ship__details-location = ls_shpto-cityname.
*          READ TABLE gt_gst_region INTO DATA(ls_shipto_region) WITH KEY regio = ls_shpto-region.
*          IF sy-subrc = 0.
*            wa_ewayirn-ship__details-state__code = ls_shipto_region-zgstr.
*          ENDIF.
*          wa_ewayirn-ship__details-pincode = ls_shpto-postalcode.
*        ENDIF.
*      ENDIF.
*    ENDIF.

*****dispatch from
    READ TABLE gt_t001 INTO DATA(ls_t001) WITH KEY companycode = ls_sdinv-companycode.
    READ TABLE gt_adrc INTO DATA(wa_adr) WITH KEY addressid = ls_t001-addressid.


    READ TABLE gt_t001w INTO DATA(ls_t001w) WITH KEY plant = ls_sdinv-plant.

    READ TABLE it_jbrch INTO DATA(ls_j_1bbranch) WITH KEY companycode = ls_sdinv-companycode
                                                    plant = ls_t001w-plant.
    READ TABLE it_jbrch1 INTO DATA(ls_j_1bbranch1) WITH KEY companycode = ls_j_1bbranch-companycode
                                                      businessplace = ls_j_1bbranch-businessplace.
    IF sy-subrc = 0.
      wa_ewayirn-user__gstin = ls_j_1bbranch1-in_gstidentificationnumber.
    ENDIF.
*    READ TABLE gt_adrc INTO DATA(ls_sellr) WITH KEY addressid = ls_t001w-addressid.
*    IF sy-subrc = 0.
*      wa_ewayirn-dispatch__details-company__name = ls_sellr-organizationname1.
*
*      CONCATENATE ls_sellr-building ls_sellr-housenumber ls_sellr-housenumbersupplementtext ls_sellr-streetname
*          INTO wa_ewayirn-dispatch__details-address1 SEPARATED BY ''.
*      CONDENSE wa_ewayirn-dispatch__details-address1.
*      CONCATENATE ls_sellr-floor ls_sellr-streetprefixname1 ls_sellr-streetprefixname2 ls_sellr-cityname
*          INTO wa_ewayirn-dispatch__details-address2 SEPARATED BY space.
*      CONDENSE wa_ewayirn-dispatch__details-address2.
*      READ TABLE gt_gst_region INTO DATA(ls_seller_region) WITH KEY regio = ls_sellr-region.
*      IF sy-subrc = 0.
*        wa_ewayirn-dispatch__details-state__code = ls_seller_region-zgstr.
*      ENDIF.
*      wa_ewayirn-dispatch__details-location = ls_sellr-cityname.
*      wa_ewayirn-dispatch__details-pincode = ls_sellr-postalcode.
*    ENDIF.
    DATA(wa_irn) = VALUE #( it_eway[ 1 ] OPTIONAL ).
    wa_irn-billingdocument = |{ wa_irn-billingdocument ALPHA = IN }|.
    SELECT SINGLE irn
        FROM ztab_j1ig_invref
        WHERE docno = @wa_irn-billingdocument
        INTO @DATA(lv_irn).
    wa_ewayirn-irn = lv_irn.
    "Trannsporter details fetching from standard
**    IF wa_irn-trans_id IS INITIAL.
**      SELECT SINGLE supplier
**          FROM i_billingdocumentpartner
**          WHERE billingdocument = @wa_irn-billingdocument
**            AND partnerfunction = 'U3'
**          INTO @DATA(lv_suppl).
**      SELECT SINGLE supplier, suppliername ,taxnumber3
**            FROM i_supplier	
**            WHERE supplier = @lv_suppl
**            INTO @DATA(wa_transporterdet).
**      SELECT SINGLE referencesddocument
**        FROM i_billingdocumentitembasic
**        WHERE billingdocument = @wa_irn-billingdocument
**        INTO @DATA(lv_deldoc).
**      SELECT SINGLE shippingtype
**        FROM i_deliverydocument
**        WHERE deliverydocument = @lv_deldoc
**        INTO @DATA(lv_shipptype).
**      SHIFT lv_shipptype LEFT DELETING LEADING '0'.
**      wa_ewayirn-transportation__mode = lv_shipptype.
**      wa_ewayirn-transporter__id = wa_transporterdet-taxnumber3.
**      wa_ewayirn-transporter__name = wa_transporterdet-suppliername.
**      wa_ewayirn-vehicle__type = 'R'.
**      wa_ewayirn-distance = '0'.
**      wa_ewayirn-data__source = 'erp'.
**      wa_ewayirn-vehicle__number = me->header_text(
**                                     billingdocument = wa_irn-billingdocument
**                                     textid          = 'JGVN'
**                                   ).
**      wa_ewayirn-transporter__document__date = me->header_text(
**                                     billingdocument = wa_irn-billingdocument
**                                     textid          = 'JGTD'
**                                   ).
**      REPLACE ALL OCCURRENCES OF '.' IN wa_ewayirn-transporter__document__date WITH '/'.
**    ELSE.
    wa_ewayirn-transportation__mode = wa_irn-transmode.
    wa_ewayirn-transporter__id = wa_irn-trans_id.
    wa_ewayirn-transporter__document__number = wa_irn-trans_doc_no.
    wa_ewayirn-transporter__name = wa_irn-trans_name.
    wa_ewayirn-vehicle__type = 'R'.
    wa_ewayirn-distance = wa_irn-trans_dist.
    wa_ewayirn-data__source = 'erp'.
    wa_ewayirn-vehicle__number = wa_irn-vehicle_no.
    wa_ewayirn-transporter__document__date = wa_irn-trans_doc_date.
**    ENDIF.
*      CONCATENATE wa_ewayirn-transporter__document__date+6(2) '/' wa_ewayirn-transporter__document__date+4(2) '/' ls_final-dt+0(4)  INTO ls_final-dt.
    CLEAR lv_json.
    lv_json = /ui2/cl_json=>serialize( data = wa_ewayirn
                                     compress = abap_false
                                     pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    CONDENSE lv_json.
    DATA(zauthclass) = NEW zcl_irn_auth( ).
    DATA(authjson) = zauthclass->token_gen(
                       EXPORTING
                         gstin    = wa_ewayirn-user__gstin
                       IMPORTING
                         wa_response = wa_response
                     ).
    SELECT SINGLE link
        FROM zirn_login
        WHERE systemid = @sy-sysid
        INTO @lv_url1.
    lv_url2 = '/api/v1/gen-ewb-by-irn/'.
    CONCATENATE lv_url1 lv_url2 INTO lv_url.
    DATA: lo_http_client2 TYPE REF TO if_web_http_client.
    TRY.
        lo_http_client2 = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    DATA token TYPE string.
    CONCATENATE 'JWT' wa_response-token INTO token SEPARATED BY space.
    DATA(lo_request2) = lo_http_client2->get_http_request( ).
    lo_request2->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = '*/*' )
                ( name = 'Authorization' value = token )
               ) ).
    lo_request2->append_text( EXPORTING data   = lv_json ).
    TRY.
        DATA(lv_response) = lo_http_client2->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    CLEAR lv_json_response.
    lv_json_response = lv_response->get_text( ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               CHANGING data = wa_ewayirnsuccess ).
      DATA: lv_string1 TYPE string,
            lv_string2 TYPE string.
      SPLIT wa_ewayirnsuccess-results-message-ewbvalidtill AT space INTO lv_string1 lv_string2 .
      CONCATENATE lv_string1+8(2) '/' lv_string1+5(2) '/' lv_string1+0(4)  INTO lv_string1.
      wa_ewayirnsuccess-results-message-ewbvalidtill = | { lv_string1 } | & | | & | { lv_string2 } |.
      CONDENSE wa_ewayirnsuccess-results-message-ewbvalidtill.
      UPDATE ztab_j1ig_invref
          SET ewbno = @wa_ewayirnsuccess-results-message-ewbno,
            ewbdt = @wa_ewayirnsuccess-results-message-ewbdt,
            ewbvalidtill = @wa_ewayirnsuccess-results-message-ewbvalidtill,
            ewb_url = @wa_ewayirnsuccess-results-message-ewaybillpdf,
            ewbstatus = 'ACT' WHERE irn = @lv_irn.
    ENDIF.

  ENDMETHOD.


  METHOD header_text.
    CASE sy-sysid.
      WHEN lv_dev.
        lv_tenent = 'my413043'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_qas.
        lv_tenent = 'my412469'.
        username =  'IVP'.
        pass = 'Password@#0987654321'.
      WHEN lv_prd.
        lv_tenent = 'my416089'.
        username = 'IVP'.
        pass = 'Password@#0987654321'.
    ENDCASE.
    DATA: lv_url TYPE string.
    lv_url = |https://{ lv_tenent }-api.s4hana.cloud.sap/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/A_BillingDocumentText| &
             |(BillingDocument=' { billingdocument }',Language='EN',LongTextID=' { textid } ')|.
    CONDENSE: lv_url NO-GAPS.
    DATA: token_http_client TYPE REF TO if_web_http_client,
          gt_return         TYPE STANDARD TABLE OF bapiret2.

    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lv_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.

    DATA(token_request) = token_http_client->get_http_request( ).
    token_request->set_header_fields(  VALUE #(
               (  name = 'Accept' value = '*/*' )
                ) ).

    token_request->set_authorization_basic(
      EXPORTING
           i_username = username
           i_password = pass
    ).

    TRY.
        DATA(lv_token_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>get )->get_text(  ).

      CATCH cx_web_http_client_error cx_web_message_error.
        "handle exception
    ENDTRY.
    DATA:lv_string1 TYPE string,
         lv_string2 TYPE string,
         lv_string3 TYPE string,
         lv_mat     TYPE string,
         lv_rest    TYPE string.

    SPLIT lv_token_response AT '<d:LongText>' INTO lv_string2 lv_string3.

    SPLIT lv_string3 AT '</d:LongText>' INTO lv_mat lv_rest.

    r_val = lv_mat.
  ENDMETHOD.


  METHOD irncnc.
    DATA(wa_bd) = VALUE #( docno[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
    SELECT SINGLE * FROM i_billingdocumentitem
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_fin).
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
    IF sy-subrc = 0.
      READ TABLE it_jbrch INTO DATA(ls_j_1bbranch) WITH KEY companycode = wa_fin-companycode
                                                      plant = wa_fin-plant.
      READ TABLE it_jbrch1 INTO DATA(ls_j_1bbranch1) WITH KEY companycode = ls_j_1bbranch-companycode
                                                        businessplace = ls_j_1bbranch-businessplace.
      IF sy-subrc = 0.
        gstkey = ls_j_1bbranch1-in_gstidentificationnumber.
      ENDIF.
    ENDIF.
    SELECT SINGLE irn FROM ztab_j1ig_invref WHERE docno = @wa_bd-billingdocument INTO @DATA(lv_irn).
    wa_irncnc-irn = lv_irn.
    wa_irncnc-user__gstin = ls_j_1bbranch1-in_gstidentificationnumber.
    wa_irncnc-cancel__reason = '1'.
    wa_irncnc-cancel__remarks = 'Wrong Entry'.
    wa_irncnc-ewaybill__cancel = ''.
    CLEAR lv_json.
    lv_json = /ui2/cl_json=>serialize( data = wa_irncnc
                                       compress = abap_false
                                       pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    CONDENSE lv_json.
    DATA(zauthclass) = NEW zcl_irn_auth( ).
    DATA(authjson) = zauthclass->token_gen(
                       EXPORTING
                         gstin    = gstkey
                       IMPORTING
                         wa_response = wa_response
                     ).
    SELECT SINGLE link
        FROM zirn_login
        WHERE systemid = @sy-sysid
        INTO @lv_url1.
    lv_url2 = '/api/v1/cancel-einvoice/'.
    CONCATENATE lv_url1 lv_url2 INTO lv_url.
    DATA: lo_http_client2 TYPE REF TO if_web_http_client.
    TRY.
        lo_http_client2 = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    DATA token TYPE string.
    CONCATENATE 'JWT' wa_response-token INTO token SEPARATED BY space.
    DATA(lo_request2) = lo_http_client2->get_http_request( ).
    lo_request2->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = '*/*' )
                ( name = 'Authorization' value = token )
*               (  name = 'MiplApikey' value  = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9' )
               ) ).
    lo_request2->append_text( EXPORTING data   = lv_json ).
    TRY.
        DATA(lv_response) = lo_http_client2->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    CLEAR lv_json_response.
    lv_json_response = lv_response->get_text( ).
    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING data = wa_finirncncsuccess ).
      REPLACE ALL OCCURRENCES OF '-' IN wa_finirncncsuccess-results-message-canceldate WITH ''.
      SPLIT wa_finirncncsuccess-results-message-canceldate AT space INTO lv_date lv_time.
      CONDENSE lv_date.
*      DATA(lv) = CONV datn( lv_date ).
      UPDATE ztab_j1ig_invref SET cancel_date = @lv_date ,
      irn_canceled = 'X',
      irn_status = 'CNC' WHERE irn = @wa_finirncncsuccess-results-message-irn.
    ENDIF.
  ENDMETHOD.


  METHOD irngen.
    "user gstin for useid and passowrd.
    DATA(wa_bd) = VALUE #( docno[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
    SELECT SINGLE * FROM i_billingdocumentitem
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_fin).
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
    IF sy-subrc = 0.
      READ TABLE it_jbrch INTO DATA(ls_j_1bbranch) WITH KEY companycode = wa_fin-companycode
                                                      plant = wa_fin-plant.
      READ TABLE it_jbrch1 INTO DATA(ls_j_1bbranch1) WITH KEY companycode = ls_j_1bbranch-companycode
                                                        businessplace = ls_j_1bbranch-businessplace.
      IF sy-subrc = 0.
        gstkey = ls_j_1bbranch1-in_gstidentificationnumber.
      ENDIF.
    ENDIF.
    DATA(zauthclass) = NEW zcl_irn_auth( ).
    DATA(authjson) = zauthclass->token_gen(
                       EXPORTING
                         gstin    = gstkey
                       IMPORTING
                         wa_response = wa_response
                     ).
    SELECT SINGLE link
        FROM zirn_login
        WHERE systemid = @sy-sysid
        INTO @lv_url1.
    lv_url2 = '/api/v1/einvoice/'.
    CONCATENATE lv_url1 lv_url2 INTO lv_url.
    DATA: lo_http_client2 TYPE REF TO if_web_http_client.
    TRY.
        lo_http_client2 = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error.
        "handle exception
    ENDTRY.
    DATA token TYPE string.
    CONCATENATE 'JWT' wa_response-token INTO token SEPARATED BY space.
    DATA(lo_request2) = lo_http_client2->get_http_request( ).
    lo_request2->set_header_fields(  VALUE #(
               (  name = 'Content-Type' value = 'application/json' )
               (  name = 'Accept' value = '*/*' )
                ( name = 'Authorization' value = token )
*               (  name = 'MiplApikey' value  = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9' )
               ) ).
    DATA(call_meth) = NEW zcl_einvoice_data( ).
    DATA(it_final2) = call_meth->irn_data(
                       EXPORTING
                         docno = docno
                       IMPORTING
                         lv_json   = lv_json
                     ).
    CONDENSE lv_json.
    lo_request2->append_text( EXPORTING data   = lv_json ).
    TRY.
        DATA(lv_response) = lo_http_client2->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_http_client_error.
    ENDTRY.
    lv_json_response = lv_response->get_text( ).

    FIND FIRST OCCURRENCE OF '"status":"Success"' IN lv_json_response.
    IF sy-subrc EQ 0.
      /ui2/cl_json=>deserialize( EXPORTING json = lv_json_response
                                             pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                   CHANGING data = wa_irnsuccess ).
*      DATA wa_zirn_trans_det TYPE zirn_trans_det.
*      wa_zirn_trans_det-invoice_no = wa_ty_irssc-response-no.
*      wa_zirn_trans_det-irn = wa_ty_irssc-response-irn.
*      wa_zirn_trans_det-message = wa_ty_irssc-message.
*      wa_zirn_trans_det-status = wa_ty_irssc-status.
*      wa_zirn_trans_det-qrcode = wa_ty_irssc-response-qr_code.
******Main Table Update start from here
      DATA wa_zj1ig_invrefnum  TYPE  ztab_j1ig_invref.
*      READ TABLE docno INTO DATA(wa_docno) INDEX 1.
      SELECT SINGLE documentreferenceid, billingdocumentdate
        FROM i_billingdocument
        WHERE billingdocument = @wa_bd-billingdocument
        INTO @DATA(wa_odn).
      wa_zj1ig_invrefnum-odn =  wa_odn-documentreferenceid.
      wa_zj1ig_invrefnum-odn_date = wa_odn-billingdocumentdate.
      wa_zj1ig_invrefnum-docno = |{ wa_bd-billingdocument ALPHA = IN }|.
      wa_zj1ig_invrefnum-bukrs = wa_bd-companycode.
      wa_zj1ig_invrefnum-doc_year = wa_bd-fiscalyear.
      wa_zj1ig_invrefnum-irn = wa_irnsuccess-results-message-irn.
      wa_zj1ig_invrefnum-msg_irn = ''.
      wa_zj1ig_invrefnum-irn_status = wa_irnsuccess-results-message-status.
      wa_zj1ig_invrefnum-ack_no = wa_irnsuccess-results-message-ackno.
      wa_zj1ig_invrefnum-ack_date = wa_irnsuccess-results-message-ackdt.

      "storing requestid into normal qrcode
      wa_zj1ig_invrefnum-qrcode = wa_irnsuccess-results-requestid."storing requestid into normal qrcode
      wa_zj1ig_invrefnum-signed_inv = wa_irnsuccess-results-message-signedinvoice.
      wa_zj1ig_invrefnum-signed_qrcode = wa_irnsuccess-results-message-signedqrcode.
      SELECT * FROM ztab_j1ig_invref WHERE docno = @wa_zj1ig_invrefnum-docno INTO TABLE @DATA(it_check).
      IF sy-subrc EQ 0.
*        DATA(it_status) = it_check[ 1 ].
        READ TABLE it_check INTO DATA(wa_check) INDEX 1.
        IF wa_check-irn IS INITIAL.
          UPDATE ztab_j1ig_invref
              SET irn = @wa_zj1ig_invrefnum-irn,
                  msg_irn = @wa_zj1ig_invrefnum-msg_irn,
                  irn_status = @wa_zj1ig_invrefnum-irn_status,
                  ack_no = @wa_zj1ig_invrefnum-ack_no,
                  ack_date = @wa_zj1ig_invrefnum-ack_date,
                  qrcode = @wa_zj1ig_invrefnum-qrcode,
                  signed_inv = @wa_zj1ig_invrefnum-signed_inv,
                  signed_qrcode = @wa_zj1ig_invrefnum-signed_qrcode
              WHERE docno = @wa_zj1ig_invrefnum-docno.
        ENDIF.
      ELSE.
        MODIFY ztab_j1ig_invref FROM @wa_zj1ig_invrefnum.
      ENDIF.
*
**      tgen-invoice_no = wa_ty_irssc-response-no.
**      tgen-irn = wa_ty_irssc-response-irn.
**      tgen-message = wa_ty_irssc-message.
**      tgen-qrcode = wa_ty_irssc-response-qr_code.
**      tgen-status = wa_ty_irssc-status.
*      MODIFY  zirn_trans_det FROM @wa_zirn_trans_det.
    ENDIF.
    FIND FIRST OCCURRENCE OF '"status":"Failed"' IN lv_json_response.
    IF sy-subrc EQ 0.
      SELECT * FROM ztab_j1ig_invref WHERE  docno = @wa_bd-billingdocument INTO TABLE @DATA(it_irncheck).
      IF it_irncheck IS INITIAL.
        wa_maintab-docno = wa_bd-billingdocument.
        wa_maintab-bukrs = wa_bd-companycode.
        wa_maintab-doc_year = wa_bd-fiscalyear.
        wa_maintab-msg_irn = 'Error While Generating IRN'.
        MODIFY ztab_j1ig_invref FROM @wa_maintab.
      ELSE.
        UPDATE ztab_j1ig_invref SET msg_irn = 'Error While Generating IRN'
           WHERE docno = @wa_bd-billingdocument.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
