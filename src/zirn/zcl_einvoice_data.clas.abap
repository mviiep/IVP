CLASS zcl_einvoice_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA : gv_int_num_flag TYPE abap_boolean.
*******************Importing key structure***************
    TYPES: BEGIN OF ty_keys,
             billingdocument TYPE c LENGTH 10,
             companycode     TYPE c LENGTH 4,
             fiscalyear      TYPE c LENGTH 4,
*             postingdate     TYPE datn,
*             irn(64),
           END OF ty_keys.
    DATA : it_keys TYPE TABLE OF ty_keys,
           gt_sel  TYPE TABLE OF ty_keys.

***************DATA Type for range*********************
    DATA : rg_sddct TYPE RANGE OF zfkart,
           rs_sddct LIKE LINE OF rg_sddct,
           rg_sdcnd TYPE RANGE OF zfkart, " KSCHL data element , range and type is same.
           rs_sdcnd LIKE LINE OF rg_sdcnd,
           rs_werks TYPE RANGE OF werks_d.
***************** Complete JSON declarion for IRN******************************
*******************JSON for transaction declaration****************************
    TYPES : BEGIN OF ty_txndet,
              supply__type(10),""Type of Supply: B2B Business to Business, SEZWP - With SEZ payment, SEZWOP - SEZ without payment, EXPWP - Export With Payment, EXPWOP - Export without payment, DEXP -deemed export
              charge__type(1)," Yes or No "Y" or "N"
              igst__on__intra(1)," Yes or No "Y" or "N"
              ecommerce__gstin   TYPE c LENGTH 15,
            END OF ty_txndet.
    DATA : it_txndet TYPE TABLE OF ty_txndet,
           wa_txndet TYPE ty_txndet.
*******************JSON/interal strcure for document details*******************
    TYPES : BEGIN OF ty_docdet,
              document__type(11),
              document__number(16),
              document__date(10),
            END OF ty_docdet.
    DATA : it_docdet TYPE TABLE OF ty_docdet,
           wa_docdet TYPE ty_docdet.
*******************JSON/interal strcure for seller details*******************
    TYPES : BEGIN OF ty_seldet,
              gstin(15),
              legal__name(100),
              trade__name(100),
              address1(100),
              address2(100),
              location(50),
              pincode           TYPE n LENGTH 6,
              state__code(2),
              phone__number(12),
              email(100),
            END OF ty_seldet.
    DATA : it_selldet TYPE TABLE OF ty_seldet,
           wa_selldet TYPE ty_seldet.
*******************JSON/interal strcure for buyer details*******************
    TYPES : BEGIN OF ty_buydet,
              gstin(15),
              legal__name(100),
              trade_name(100),
              address1(100),
              address2(100),
              location(100),
              pincode              TYPE n LENGTH 6,
              place__of__supply(2),
              state__code(50),
              phone__number(12),
              email(100),
            END OF ty_buydet.
    DATA : it_buydet TYPE TABLE OF ty_seldet,
           wa_buydet TYPE ty_seldet.
*******************JSON/interal strcure for dispatch details*******************
    TYPES : BEGIN OF ty_dispdet,
              company__name(60),
              address1(100),
              address2(60),
              location(60),
              pincode(6),
              state__code(2),
            END OF ty_dispdet.
    DATA : it_dsptchdet TYPE TABLE OF ty_dispdet,
           wa_dsptchdet TYPE ty_dispdet.
*******************JSON/interal strcure for ship details******************
    TYPES : BEGIN OF ty_shipdet,
              gstin(15),
              legal__name(100),
              trade__name(100),
              address1(100),
              address2(100),
              location(100),
              pincode(6),
              state__code(2),
            END OF ty_shipdet.
    DATA : it_shiptodet TYPE TABLE OF ty_shipdet,
           wa_shiptodet TYPE ty_shipdet.
*******************JSON/interal strcure for export details******************
    TYPES : BEGIN OF ty_expdet,
              ship__bill__number(20),
              ship__bill__date(10),
              country__code(2),
              foreign__currency(16),
              refund__claim(1),"option for supplier for refund (Y/N)
              port__code(10),
              export__duty           TYPE p LENGTH 12 DECIMALS 2,
            END OF ty_expdet.
*******************JSON/interal strcure for payment details******************
    TYPES : BEGIN OF ty_pymntdet,
              bank__account__number(18),
              paid__balance__amount     TYPE p LENGTH 12 DECIMALS 2,
              credit__days              TYPE n LENGTH 4,
              credit__transfer(100),
              direct__debit(100),
              branch__or__ifsc(11),
              payment__mode(16),
              payee__name(100),
              outstanding__amount       TYPE p LENGTH 10 DECIMALS 2,
              payment__instruction(100),
              payment__term(100),
            END OF ty_pymntdet.
*******************JSON/internal structure for reference details******************
*******************JSON/internal structure for document period details******************
    TYPES : BEGIN OF ty_docperioddet,
              invoice__period__start__date(10),
              invoice__period__end__date(10),
            END OF ty_docperioddet.
    DATA : it_docperioddet TYPE TABLE OF ty_docperioddet,
           wa_docperioddet TYPE ty_docperioddet.
*******************JSON/internal structure for preceding document details******************
    TYPES : BEGIN OF ty_prcddocdet,
              ref__of__original__invoice(16)," should be replace in final json
              preceding__invoice__date(10),
              other__reference(20),
            END OF ty_prcddocdet.
    DATA : it_prcddocdet TYPE TABLE OF ty_prcddocdet,
           wa_prcddocdet TYPE ty_prcddocdet.
*******************JSON/internal structure for contract details******************
    TYPES : BEGIN OF ty_contrctdet,
              receipt__advice__number(20),
              receipt__advice__date(10),
              batch__reference__number(20),
              contract__reference__number(20),
              other__reference(20),
              project__reference__number(20),
              vendor__po__reference__number(16),
              vendor__po__reference__date(10),
            END OF ty_contrctdet.
    DATA : it_contrctdet TYPE TABLE OF ty_contrctdet,
           wa_contrctdet TYPE ty_contrctdet.

    "Reference details JSON
    TYPES : BEGIN OF ty_ref_det,
              invoice__remarks(100),
*              document__period__details    TYPE STANDARD TABLE OF ty_docperioddet WITH EMPTY KEY,      " Not required.
              preceding__document__details TYPE STANDARD TABLE OF ty_prcddocdet WITH EMPTY KEY,
*              contract__details            TYPE STANDARD TABLE OF ty_contrctdet WITH EMPTY KEY,
            END OF ty_ref_det.
    DATA : it_refdet TYPE TABLE OF ty_ref_det,
           wa_refdet TYPE ty_ref_det.
*******************JSON/internal structure for additional document details******************
    TYPES : BEGIN OF ty_adddocdet,
              supporting__document__url(100),
              supporting__document(1000),
              additional__information(1000),
            END OF ty_adddocdet.
*******************JSON/internal structure for value details******************
    TYPES : BEGIN OF ty_valdet,
              total__assessable__value      TYPE p LENGTH 10 DECIMALS 2,
              total__cgst__value            TYPE p LENGTH 10 DECIMALS 2,
              total__sgst__value            TYPE p LENGTH 10 DECIMALS 2,
              total__igst__value            TYPE p LENGTH 10 DECIMALS 2,
              total__cess__value            TYPE p LENGTH 10 DECIMALS 2,
              total__cess__value__of__state TYPE p LENGTH 10 DECIMALS 2,
              total__discount               TYPE p LENGTH 10 DECIMALS 2,
              total__other__charge          TYPE p LENGTH 10 DECIMALS 2,
              total__invoice__value         TYPE p LENGTH 10 DECIMALS 2,
              round__off__amount            TYPE p LENGTH 10 DECIMALS 2,
              tot__inv__value__add__crncy   TYPE p LENGTH 10 DECIMALS 2, " should be replace in final json as total_invoice_value_additional_currency
            END OF ty_valdet.
    DATA : it_valdet TYPE TABLE OF ty_valdet,
           wa_valdet TYPE ty_valdet.
********************JSON Structure for ITEM list*************************
********************JSON Structure for ITEM Batch details****************
    TYPES : BEGIN OF ty_batch,
              name(20),
              expiry__date(10),
              warranty__date(10),
            END OF ty_batch.
********************JSON Structure for ITEM Attributes details****************
    TYPES : BEGIN OF ty_atrbtdet,
              item__attribute__details(300),
              item__attribute__value(300),
            END OF ty_atrbtdet.
    TYPES : BEGIN OF ty_itmjsn,
              item__serial__number          TYPE n LENGTH 6,
              product__description(300),
              is__service(1),
              hsn__code(8),
              bar__code(30),
              quantity(20),
              free__quantity(20),
              unit(8),
              unit__price                   TYPE p LENGTH 10 DECIMALS 2,
              total__amount                 TYPE p LENGTH 10 DECIMALS 2,
              pre__tax__value               TYPE p LENGTH 10 DECIMALS 2,
              discount                      TYPE p LENGTH 10 DECIMALS 2,
              other__charge                 TYPE p LENGTH 10 DECIMALS 2,
              assessable__value             TYPE p LENGTH 10 DECIMALS 2,
              gst__rate                     TYPE p LENGTH 2 DECIMALS 0,
              igst__amount                  TYPE p LENGTH 10 DECIMALS 2,
              cgst__amount                  TYPE p LENGTH 10 DECIMALS 2,
              sgst__amount                  TYPE p LENGTH 10 DECIMALS 2,
              cess__rate                    TYPE p LENGTH 2 DECIMALS 0,
              cess__amount                  TYPE p LENGTH 10 DECIMALS 2,
              cess__nonadvol__amount        TYPE p LENGTH 10 DECIMALS 2,
              state__cess__rate(4),
              state__cess__amount           TYPE p LENGTH 10 DECIMALS 2,
              state__cess__nonadvol__amount TYPE p LENGTH 10 DECIMALS 2,
              total__item__value            TYPE p LENGTH 10 DECIMALS 2,
              country__origin(2),
              order__line__reference(50),
              product__serial__number(15),
              batch__details                TYPE ty_batch,
*              attribute__details            TYPE STANDARD TABLE OF ty_atrbtdet WITH EMPTY KEY,
            END OF ty_itmjsn.
    DATA : it_itmjsn TYPE TABLE OF ty_itmjsn,
           wa_itmjsn TYPE ty_itmjsn.
*********************************************Main IRN  JSON Declare*************************************
    TYPES : BEGIN OF ty_json,
              user__gstin          TYPE c LENGTH 15, "GSTIN of the entity initiating E-Invoice"FLD1
              data__source(5),
              transaction__details TYPE ty_txndet,
              document__details    TYPE ty_docdet,
              seller__details      TYPE  ty_seldet,
              buyer__details       TYPE  ty_buydet,
              dispatch__details    TYPE ty_dispdet,
              ship__details        TYPE ty_shipdet,
              export__details      TYPE  ty_expdet,
*              payment__details            TYPE STANDARD TABLE OF ty_pymntdet WITH EMPTY KEY,
              reference__details   TYPE ty_ref_det,
*              additional_document_details TYPE STANDARD TABLE OF ty_adddocdet WITH EMPTY KEY,
              value__details       TYPE ty_valdet,
              item__list           TYPE STANDARD TABLE OF ty_itmjsn WITH EMPTY KEY,
            END OF ty_json.
*********************************************************************
    DATA: lt_final TYPE TABLE OF ty_json,
          wa_final TYPE ty_json.
    DATA: wa_sdinvb      TYPE i_billingdocument,
          ls_sdinv       TYPE i_billingdocumentitem,
          ls_sdinvt      TYPE i_billingdocumentitem,
          ls_final       TYPE ty_json,
          ls_tcurx       TYPE i_currency,
          ls_vbpa        TYPE i_billingdocumentpartner,
*          ls_kna1        TYPE ty_kna1,
*          ls_knab        TYPE ty_kna1,
*          ls_knas        TYPE ty_kna1,
          ls_konv        TYPE i_billingdocitemprcgelmntbasic,
          ls_knvi        TYPE i_custsalesareatax,
          ls_t001w       TYPE i_plant,
          ls_t001        TYPE i_companycode,
*          ls_mch1        TYPE ty_mch1,
*          ls_marc        TYPE ty_marc,
*          ls_vbfa        TYPE ty_vbfa,
*          ls_vbfa1       TYPE ty_vbfa,
*          ls_vbrk        TYPE ty_vbrk,
          ls_adr6        TYPE i_workplaceaddress,
          ls_buyer       TYPE i_address_2,
          ls_shpto       TYPE i_address_2,
          ls_sellr       TYPE i_address_2,
          ls_j_1bbranch  TYPE i_in_plantbusinessplacedetail,
          ls_j_1bbranch1 TYPE i_in_businessplacetaxdetail,
          ls_sddc        TYPE zsd_irn_doc_typ,
          ls_sdcd        TYPE zsd_irn_cond_typ.
*****************************local variables.*******************************************
    DATA: lv_auth_flag    TYPE abap_boolean,
          lv_cgst         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_sgst         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_igst         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_pr00         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_disc         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_insu         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_frei         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_otch         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_cess         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_sces         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_nacs         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_assv         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_ttax         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_ittt         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_diff         TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_round        TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_slno         TYPE n LENGTH 3,
          lv_buyercountry TYPE i_address_2-country,
          lv_emerr.

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
**************************E-way final json structure*******************************
    TYPES: BEGIN OF ty_itmewb,
             product__name(50),
             product__description(100),
             hsn__code(10),
             quantity(20),
             unit__of__product(3),
             cgst__rate                TYPE p LENGTH 10 DECIMALS 2,
             sgst__rate                TYPE p LENGTH 10 DECIMALS 2,
             igst__rate                TYPE p LENGTH 10 DECIMALS 2,
             cess__rate                TYPE p LENGTH 10 DECIMALS 2,
             cess_non_advol            TYPE p LENGTH 10 DECIMALS 2,
             taxable__amount           TYPE p LENGTH 10 DECIMALS 2,
           END OF ty_itmewb.
    DATA : it_itmewb TYPE TABLE OF ty_itmewb,
           wa_itmewb TYPE ty_itmewb.
    TYPES: BEGIN OF ty_ewb,
             user_gstin(15),
             supply__type(10),
             sub__supply__type(30),
             sub__supply__description(30),
             document__type(30),
             document__number(20),
             document__date(10),
             gstin__of__consignor(15),
             legal__name__of__consignor(100),
             address1__of__consignor(100),
             address2__of__consignor(100),
             place__of__consignor(20),
             pincode__of__consignor(10),
             state__of__consignor(20),
             actual__from__state__name(20),
             gstin__of__consignee(15),
             legal__name__of__consignee(100),
             address1__of__consignee(100),
             address2__of__consignee(100),
             place__of__consignee(20),
             pincode__of__consignee(10),
             state__of__supply(20),
             actual__to__state__name(20),
             transaction__type(20),
             other__value                      TYPE p LENGTH 10 DECIMALS 2,
             total__invoice__value             TYPE p LENGTH 10 DECIMALS 2,
             taxable__amount                   TYPE p LENGTH 10 DECIMALS 2,
             cgst__amount                      TYPE p LENGTH 10 DECIMALS 2,
             sgst__amount                      TYPE p LENGTH 10 DECIMALS 2,
             igst__amount                      TYPE p LENGTH 10 DECIMALS 2,
             cess__amount                      TYPE p LENGTH 10 DECIMALS 2,
             cess__nonadvol__value             TYPE p LENGTH 10 DECIMALS 2,
             transporter__id(15),
             transporter__name(100),
             transporter__document__number(20),
             transporter__document__date(10),
             transportation__mode(5),
             transportation__distance(10),
             vehicle__number(10),
             vehicle__type(10),
             generate__status(5),
             data__source(5),
             user__ref(10),
             location__code(10),
             eway__bill__status(10),
             auto__print(10),
             email(20),
             delete__record(10),
             item_list                         TYPE TABLE OF ty_itmewb WITH EMPTY KEY,
           END OF ty_ewb.
    DATA wa_ewb TYPE ty_ewb.
***********************************************************************************

*          ls_irunit      TYPE zirn_unit_mapng.
    METHODS irn_data IMPORTING docno        LIKE it_keys
                     EXPORTING lv_json      TYPE string
*                                   gt_jfn       LIKE gt_jfn
                     RETURNING VALUE(r_val) TYPE string.
    METHODS get_ewb IMPORTING it_eway      LIKE it_eway
                    EXPORTING lv_json      TYPE string
                    RETURNING VALUE(r_val) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EINVOICE_DATA IMPLEMENTATION.


  METHOD get_ewb.
** Range TABLES, work area declaration.
    DATA: rg_sddct TYPE RANGE OF zfkart,
          rs_sddct LIKE LINE OF rg_sddct,
          rg_sdcnd TYPE RANGE OF zfkart,
          rs_sdcnd LIKE LINE OF rg_sdcnd.

** Work area declarations.
    DATA:
*          ls_txcd TYPE zirn_tax_code,
*          ls_jdp  TYPE zirn_fm_export,
*          ls_sel  TYPE zirn_fm_sd_import,
      ls_sddc TYPE zsd_eway_doc_typ,
      ls_sdcd TYPE zsd_eway_con_typ. "not created yet

    DATA: wa_sdinv  TYPE i_billingdocument,
          wa_sdinv1 TYPE i_billingdocumentitem.
    DATA: i_budat TYPE i_journalentry-postingdate,
          i_bukrs TYPE i_companycode-companycode,
          e_gjahr TYPE i_journalentry-fiscalyear.

** Get Business place details
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(gt_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(gt_jbrch1).

    DATA(wa_bd) = VALUE #( it_eway[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
** Billing type Invoice type mapping
    SELECT *
      FROM zsd_irn_doc_typ    "zsd_eway_doc_typ
      WHERE gstdoc IN ('INV','BIL','BOE','CNT','CHL','OTH')
      INTO TABLE @DATA(gt_sddc).
***************** SOC by madhuri givrn by onkar ***************
SELECT SINGLE bill~billingdocument, bill~billingdocumenttype,
       bill~soldtoparty, cust~customer, cust~taxnumber3
       from i_billingdocument as bill  inner join I_Customer as cust on bill~soldtoparty = cust~customer
       where bill~billingdocument = @wa_bd-billingdocument
       into @data(wa_valid).
if wa_valid-TaxNumber3 is INITIAL and wa_valid-billingdocumenttype = 'F2'.
clear: gt_sddc.
data: wa_f2 TYPE zsd_irn_doc_typ.
wa_f2-gstdoc = 'INV'.
wa_f2-fkart = 'F2'.
append wa_f2 to gt_sddc.
clear: wa_f2.

endif.
***************** EOC by madhuri given by onkar.
    IF gt_sddc IS NOT INITIAL.
** Condition type Invoice type mapping
      SELECT *
        FROM zsd_irn_cond_typ      "irn doc type table replaced by zsd_eway_con_typ
        FOR ALL ENTRIES IN @gt_sddc
        WHERE gstdoc = @gt_sddc-gstdoc
        INTO TABLE @DATA(gt_sdcd).


      LOOP AT gt_sddc INTO ls_sddc.
        rs_sddct-sign = 'I'.
        rs_sddct-option = 'EQ'.
        rs_sddct-low = ls_sddc-billingtype.
        APPEND rs_sddct TO rg_sddct.
      ENDLOOP.
    ENDIF.
    LOOP AT gt_sdcd INTO ls_sdcd.
      rs_sdcnd-sign = 'I'.
      rs_sdcnd-option = 'EQ'.
      rs_sdcnd-low = ls_sdcd-conditiontype.
      APPEND rs_sdcnd TO rg_sdcnd.
    ENDLOOP.
*    DATA(wa_bd) = VALUE #( it_eway[ 1 ] OPTIONAL ).
*    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
    IF rg_sddct[] IS NOT INITIAL AND it_eway IS NOT INITIAL.
      SELECT * FROM i_billingdocument
*             FOR ALL ENTRIES IN @it_eway
             WHERE billingdocument = @wa_bd-billingdocument
               AND billingdocumenttype IN @rg_sddct
*               AND creationdate = @it_imp-postingdate
               AND companycode = @wa_bd-companycode
               AND accountingtransferstatus = 'D'
               AND billingdocumentiscancelled = ''
             INTO TABLE @DATA(gt_sdinv).
    ENDIF.

*    if gt_sdinv is INITIAL.
******** SOC by madhuri given by onkar.
*SELECT SINGLE bill~billingdocument, bill~billingdocumenttype,
*       bill~soldtoparty, cust~customer, cust~taxnumber3
*       from i_billingdocument as bill  inner join I_Customer as cust on bill~soldtoparty = cust~customer
*       where bill~billingdocument = @wa_bd-billingdocument
*       into @data(wa_valid).
*
if wa_valid-TaxNumber3 is INITIAL and wa_valid-billingdocumenttype = 'F2'.
    SELECT * FROM i_billingdocument
*             FOR ALL ENTRIES IN @it_eway
             WHERE billingdocument = @wa_bd-billingdocument
               AND billingdocumenttype = 'F2'
*               AND creationdate = @it_imp-postingdate
               AND companycode = @wa_bd-companycode
               AND accountingtransferstatus = 'C'
               AND billingdocumentiscancelled = ''
             INTO TABLE @gt_sdinv.
     endif.
*
*    endif.
******* EOC by madhuri given by onkar.
    IF gt_sdinv[] IS NOT INITIAL.
      SELECT * FROM i_billingdocumentitem
             FOR ALL ENTRIES IN @gt_sdinv
             WHERE billingdocument = @gt_sdinv-billingdocument
               AND billingdocumenttype IN @rg_sddct
*               AND creationdate = @docno-postingdate
*               AND companycode = @docno-companycode
               AND billingquantity GT 0
             INTO TABLE @DATA(gt_sdinv1).
    ENDIF.
    IF gt_sdinv1[] IS NOT INITIAL.
      SELECT * FROM i_billingdocitemprcgelmntbasic
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE billingdocument = @gt_sdinv1-billingdocument
            AND billingdocumentitem = @gt_sdinv1-billingdocumentitem
            AND conditiontype IN @rg_sdcnd
            AND conditioninactivereason = ''
          INTO TABLE @DATA(gt_konv).
      SELECT * FROM i_custsalesareatax
              FOR ALL ENTRIES IN @gt_sdinv1
              WHERE customer = @gt_sdinv1-soldtoparty
                AND customertaxcategory IN ( 'JOCG', 'JOSG', 'JOIG' )
              INTO TABLE @DATA(gt_knvi).
      SELECT * FROM i_billingdocumentpartner
               FOR ALL ENTRIES IN @gt_sdinv1
               WHERE billingdocument = @gt_sdinv1-billingdocument
                 AND partnerfunction IN ( 'RE', 'WE' )
                INTO TABLE @DATA(gt_vbpa).
      SELECT subsqntdocitmprecdgdocument, subsqntdocitmprecdgdocitem, subsqntdocitmprecdgdoccategory,
             subsequentdocument, subsequentdocumentitem, subsequentdocumentcategory
               FROM i_salesdocitmsubsqntprocflow
               FOR ALL ENTRIES IN @gt_sdinv1
               WHERE subsequentdocument = @gt_sdinv1-billingdocument
                 AND subsequentdocumentcategory IN ( 'O', 'P' )
                 AND subsqntdocitmprecdgdoccategory IN ( 'K', 'L' )
                INTO TABLE @DATA(gt_vbfa).
      IF gt_vbfa IS NOT INITIAL.
        SELECT subsqntdocitmprecdgdocument, subsqntdocitmprecdgdocitem, subsqntdocitmprecdgdoccategory,
             subsequentdocument, subsequentdocumentitem, subsequentdocumentcategory
               FROM i_salesdocitmsubsqntprocflow
               FOR ALL ENTRIES IN @gt_vbfa
               WHERE subsequentdocument = @gt_vbfa-subsqntdocitmprecdgdocument
                 AND subsequentdocumentcategory IN ( 'K', 'L' )
                 AND subsqntdocitmprecdgdoccategory IN ( 'M' )
                INTO TABLE @DATA(gt_vbfa1).
      ENDIF.
      IF gt_vbfa1 IS NOT INITIAL.
        SELECT billingdocument, billingdocumentdate, documentreferenceid
                FROM i_billingdocument
                FOR ALL ENTRIES IN @gt_vbfa1
                WHERE billingdocument = @gt_vbfa1-subsqntdocitmprecdgdocument
                 INTO TABLE @DATA(gt_vbrk).
      ENDIF.
      SELECT * FROM zirn_unit_mapng
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE vrkme_i = @gt_sdinv1-baseunit
              INTO TABLE @DATA(gt_irun).
      SELECT customer, country, organizationbpname1, organizationbpname2, cityname, postalcode,
             region, streetname, addressid, districtname, taxnumber3
          FROM i_customer
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE customer = @gt_sdinv1-soldtoparty
          INTO TABLE @DATA(gt_kna1).
      IF gt_vbpa IS NOT INITIAL.
        SELECT customer, country, organizationbpname1, organizationbpname2, cityname, postalcode,
           region, streetname, addressid, districtname, taxnumber3
            FROM i_customer
            FOR ALL ENTRIES IN @gt_vbpa
            WHERE customer = @gt_vbpa-customer
            APPENDING TABLE @gt_kna1.

        SORT: gt_kna1.
        DELETE ADJACENT DUPLICATES FROM gt_kna1.
      ENDIF.
      SELECT * FROM i_companycode
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE companycode = @gt_sdinv1-companycode
          INTO TABLE @DATA(gt_t001).
      IF gt_t001 IS NOT INITIAL.
        SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @gt_t001
            WHERE addressid = @gt_t001-addressid
            INTO TABLE @DATA(gt_adrc).
      ENDIF.
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
      IF gt_kna1 IS NOT INITIAL.
        SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @gt_kna1
            WHERE addressid = @gt_kna1-addressid
            APPENDING TABLE @gt_adrc.
      ENDIF.
      SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE product = @gt_sdinv1-material
            AND plant = @gt_sdinv1-plant
          INTO TABLE @DATA(gt_marc).
      SELECT material, batch, shelflifeexpirationdate
          FROM i_batch
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE material = @gt_sdinv1-material
          AND   batch = @gt_sdinv1-batch
          INTO TABLE @DATA(gt_mch1).
    ENDIF.
    IF gt_adrc IS NOT INITIAL.
      SELECT * FROM i_workplaceaddress
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_adr6).
      SELECT * FROM i_addressemailaddress_2 WITH PRIVILEGED ACCESS
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_email).
      SELECT * FROM i_addressphonenumber_2 WITH PRIVILEGED ACCESS
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_phone).
    ENDIF.
    IF gt_sdinv1 IS NOT INITIAL.
      SELECT * FROM i_currency
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE currency = @gt_sdinv1-transactioncurrency
          INTO TABLE @DATA(gt_tcurx).
      SELECT * FROM i_custsalesareatax
              FOR ALL ENTRIES IN @gt_sdinv1
              WHERE customer = @gt_sdinv1-soldtoparty
                AND customertaxcategory IN ( 'JOCG', 'JOIG', 'JOUG' )
              INTO TABLE @DATA(it_knvi).
    ENDIF.
    SELECT * FROM zgst_region_map INTO TABLE @DATA(gt_gst_region).

*    SELECT * FROM zgst_gstin_map INTO TABLE @gt_gstin_map.

    LOOP AT gt_sdinv1 INTO ls_sdinvt.
      CLEAR:ls_sdinv,ls_vbpa,ls_buyer,ls_adr6,
      ls_shpto,ls_j_1bbranch,ls_t001w,ls_sellr,
      ls_knvi,ls_sdcd,ls_sddc, ls_konv.
      MOVE-CORRESPONDING ls_sdinvt TO ls_sdinv.
      READ TABLE gt_sel INTO DATA(ls_sel) WITH KEY billingdocument = ls_sdinv-billingdocument.
      IF sy-subrc = 0.
*        CLEAR:lv_acc_rate.
        SELECT SINGLE exchangerate FROM i_journalentry
          WHERE companycode = @ls_sel-companycode AND
                fiscalyear = @ls_sel-fiscalyear AND
                originalreferencedocument = @ls_sel-billingdocument
                INTO @DATA(lv_acc_rate).
        IF lv_acc_rate IS NOT INITIAL.
          ls_sdinv-pricedetnexchangerate = lv_acc_rate.
        ENDIF.
      ENDIF.
      wa_ewb-supply__type = 'outward'.
      wa_ewb-sub__supply__type =  'Supply'.
      wa_ewb-sub__supply__description = ''.
      SELECT SINGLE documentreferenceid
        FROM i_billingdocumentbasic
        WHERE billingdocument = @ls_sdinv-billingdocument
        INTO @wa_ewb-document__number.
*      wa_ewb-document__type = ''.               "Logic is pending
*      wa_ewb-document__number = ''.
      wa_ewb-document__date = ls_sdinv-billingdocumentdate.
      CONCATENATE wa_ewb-document__date+6(2) '/' wa_ewb-document__date+4(2) '/' wa_ewb-document__date+0(4)  INTO wa_ewb-document__date.
      READ TABLE gt_t001 INTO ls_t001 WITH KEY companycode = ls_sdinv-companycode.
      READ TABLE gt_t001w INTO ls_t001w WITH KEY plant = ls_sdinv-plant.
      IF sy-subrc = 0.
*        wa_ewb-legal__name__of__consignor = ls_t001w-plantname.
        READ TABLE gt_jbrch INTO ls_j_1bbranch WITH KEY companycode = ls_sdinv-companycode
                                                        plant = ls_t001w-plant.
        READ TABLE gt_jbrch1 INTO ls_j_1bbranch1 WITH KEY companycode = ls_j_1bbranch-companycode
                                                          businessplace = ls_j_1bbranch-businessplace.
        IF sy-subrc = 0.
          wa_ewb-gstin__of__consignor = ls_j_1bbranch1-in_gstidentificationnumber.
          wa_ewb-user_gstin = ls_j_1bbranch1-in_gstidentificationnumber.
        ENDIF.

        READ TABLE gt_adrc INTO ls_sellr WITH KEY addressid = ls_t001w-addressid.
        IF sy-subrc = 0.
          wa_ewb-legal__name__of__consignor = ls_sellr-organizationname1.
          wa_ewb-address1__of__consignor = ls_sellr-streetname.
          IF ls_sellr-streetprefixname1 IS NOT INITIAL.
            wa_ewb-address2__of__consignor = ls_sellr-streetprefixname1.
          ELSE.
            wa_ewb-address2__of__consignor = ls_sellr-cityname.
          ENDIF.
          READ TABLE gt_gst_region INTO DATA(ls_seller_region) WITH KEY regio = ls_sellr-region.
          IF sy-subrc = 0.
            wa_ewb-state__of__consignor = ls_seller_region-bezei.
            wa_ewb-actual__from__state__name = ls_seller_region-bezei.
          ENDIF.
          wa_ewb-place__of__consignor = ls_sellr-cityname.
          wa_ewb-pincode__of__consignor = ls_sellr-postalcode.
        ENDIF.
      ENDIF.
      "ship to details.
      READ TABLE gt_vbpa INTO ls_vbpa WITH KEY billingdocument = ls_sdinv-billingdocument
                                                   partnerfunction = 'WE'.
      IF sy-subrc = 0.
        READ TABLE gt_kna1 INTO DATA(ls_knas) WITH KEY customer = ls_vbpa-customer.
        IF sy-subrc = 0.
          READ TABLE gt_adrc INTO ls_shpto WITH KEY addressid = ls_knas-addressid.
          IF sy-subrc = 0.
            wa_ewb-gstin__of__consignee = ls_knas-taxnumber3.
            CONCATENATE ls_shpto-organizationname1 ls_shpto-streetprefixname1  INTO wa_ewb-address1__of__consignee SEPARATED BY space.
            CONCATENATE ls_shpto-streetprefixname2 ls_shpto-streetname INTO wa_ewb-address2__of__consignee SEPARATED BY space.
*            READ TABLE gt_gstin_map INTO DATA(ls_shpto_gstin) WITH KEY sap_gstin = ls_knas-taxnumber3.
*            IF sy-subrc = 0.
*              ls_finewb-to_gstin = ls_shpto_gstin-gst_gstin.
*              CONDENSE ls_finewb-to_gstin NO-GAPS.
*            ENDIF.
*            IF ls_finewb-to_gstin IS INITIAL.
*              ls_finewb-to_gstin = 'URP'.
*            ENDIF.
            CONCATENATE ls_shpto-organizationname1 ls_shpto-organizationname2 INTO wa_ewb-legal__name__of__consignee SEPARATED BY space.
            wa_ewb-address1__of__consignee = ls_shpto-streetname.
            wa_ewb-address2__of__consignee = ls_shpto-streetprefixname1.
            wa_ewb-place__of__consignee = ls_shpto-cityname.
            READ TABLE gt_gst_region INTO DATA(ls_shipto_region) WITH KEY regio = ls_shpto-region.
            IF sy-subrc = 0.
              wa_ewb-state__of__supply = ls_shipto_region-bezei.
              wa_ewb-actual__to__state__name = ls_shipto_region-bezei.
            ENDIF.
            wa_ewb-pincode__of__consignee = ls_shpto-postalcode.
          ENDIF.
        ENDIF.
      ENDIF.
************** Added by madhuri
      if wa_ewb-gstin__of__consignee is INITIAL.

      wa_ewb-gstin__of__consignee = 'URP'.

      endif.
      wa_ewb-transaction__type = '1'.
      CASE ls_sdinv-billingdocumenttype.
        WHEN 'JSN'.
*          IF wa_ewb-actual__from__state_name EQ wa_ewb-actual__to__state__name.
*            wa_ewb-document__type = 'CHL'.
*          ELSE.
          wa_ewb-sub__supply__description = 'Challan'.
          wa_Ewb-sub__supply__type = 'Job Work'.
          wa_ewb-document__type = 'CHL'.
*          ENDIF
        when 'F8' OR 'F5' or 'JVR'.
          wa_ewb-sub__supply__description = 'Others'.
          wa_Ewb-sub__supply__type = 'Others'.
          wa_ewb-document__type = 'CHL'.
        WHEN OTHERS.
          wa_ewb-document__type = 'INV'.
      ENDCASE.
      "Transporter details
      DATA(wa_irn) = VALUE #( it_eway[ 1 ] OPTIONAL ).
*      IF wa_irn-trans_id IS INITIAL.
*        SELECT SINGLE supplier
*            FROM i_billingdocumentpartner
*            WHERE billingdocument = @wa_irn-billingdocument
*              AND partnerfunction = 'U3'
*            INTO @DATA(lv_suppl).
*        SELECT SINGLE supplier, suppliername ,taxnumber3
*              FROM i_supplier
*              WHERE supplier = @lv_suppl
*              INTO @DATA(wa_transporterdet).
*        SELECT SINGLE referencesddocument
*          FROM i_billingdocumentitembasic
*          WHERE billingdocument = @wa_irn-billingdocument
*          INTO @DATA(lv_deldoc).
*        SELECT SINGLE shippingtype
*          FROM i_deliverydocument
*          WHERE deliverydocument = @lv_deldoc
*          INTO @DATA(lv_shipptype).
*        SHIFT lv_shipptype LEFT DELETING LEADING '0'.
*        wa_ewb-transportation__mode = lv_shipptype.
*        wa_ewb-transporter__id = wa_transporterdet-taxnumber3.
*        wa_ewb-transporter__name = wa_transporterdet-suppliername.
*        wa_ewb-vehicle__type = 'R'.
**      wa_ewb-distance = '0'.
*        wa_ewb-data__source = 'erp'.
*        DATA(header_text) =  NEW zcl_einvoicing( ).
*        wa_ewb-vehicle__number = header_text->header_text(
*                                       billingdocument = wa_irn-billingdocument
*                                       textid          = 'JGVN'
*                                     ).
*        wa_ewb-transporter__document__date = header_text->header_text(
*                                       billingdocument = wa_irn-billingdocument
*                                       textid          = 'JGTD'
*                                     ).
*        REPLACE ALL OCCURRENCES OF '.' IN wa_ewb-transporter__document__date WITH '/'.
*      ELSE.
        wa_ewb-transportation__mode = wa_irn-transmode.
        wa_ewb-transporter__id = wa_irn-trans_id.
        wa_ewb-transporter__name = wa_irn-trans_name.
        wa_ewb-vehicle__type = 'R'.
        wa_ewb-transportation__distance = wa_irn-trans_dist.
        wa_ewb-data__source = 'erp'.
        wa_ewb-vehicle__number = wa_irn-vehicle_no.
        wa_ewb-transporter__document__date = wa_irn-trans_doc_date.
*      ENDIF.
      wa_ewb-generate__status = '1'.
      wa_ewb-data__source = 'erp'.
      wa_ewb-auto__print = 'N'.
      wa_ewb-delete__record = 'N'.



      " Item details
      LOOP AT gt_sdinv1 INTO DATA(wa_sdinve).
        wa_itmewb-product__name = wa_sdinve-material.
        SELECT SINGLE productdescription FROM i_productdescriptiontp_2
            WHERE product = @wa_sdinve-material
            AND language = 'E'
            INTO @wa_itmewb-product__description.
        wa_itmewb-quantity = wa_sdinve-billingquantity.
        READ TABLE gt_irun INTO DATA(ls_irunit) WITH KEY vrkme_i = wa_sdinve-baseunit.
        IF sy-subrc = 0.
          wa_itmewb-unit__of__product = ls_irunit-irnut.
        ELSE.
          wa_itmewb-unit__of__product     = 'OTH'.
        ENDIF.
        READ TABLE gt_marc INTO DATA(ls_marc) WITH KEY product = wa_sdinve-material
                                               plant = wa_sdinve-plant.
        IF sy-subrc = 0.
          CONDENSE: ls_marc-consumptiontaxctrlcode NO-GAPS.
          wa_itmewb-hsn__code = ls_marc-consumptiontaxctrlcode.
        ENDIF.
        LOOP AT gt_konv INTO ls_konv WHERE billingdocument = wa_sdinve-billingdocument
                                       AND billingdocumentitem = wa_sdinve-billingdocumentitem.
          CLEAR ls_sdcd.
          READ TABLE gt_sdcd INTO ls_sdcd WITH KEY kschl = ls_konv-conditiontype
                                                   gstdoc = wa_ewb-document__type.
          CHECK sy-subrc EQ 0.
          DATA(wa_sdinvh) = VALUE #( gt_sdinv[ billingdocument = wa_sdinve-billingdocument ] OPTIONAL ).
          CASE ls_sdcd-gstgrp.
            WHEN 'CGST'." Rate
              wa_itmewb-cgst__rate = ls_konv-conditionratevalue .
*            ls_finewb-itcamt = ls_konv-conditionamount * wa_sdinvh-accountingexchangerate.
              lv_cgst =  lv_cgst + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'SGST' OR 'UGST'." Rate
              wa_itmewb-sgst__rate = ls_konv-conditionratevalue .
*            ls_finewb-itsamt = ls_konv-conditionamount * wa_sdinvh-accountingexchangerate .
              lv_sgst =  lv_sgst + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'IGST'. " Rate
              wa_itmewb-igst__rate = ls_konv-conditionratevalue  .
*            ls_finewb-itiamt = ls_konv-conditionamount * wa_sdinvh-accountingexchangerate .
              lv_igst =  lv_igst + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'PPR0'."unit price KBETR
**            IF ls_konv-conditiontype = 'ZPR0' OR ls_konv-conditiontype = 'ZPR1'.
              wa_itmewb-taxable__amount = ls_konv-conditionamount * wa_sdinvh-accountingexchangerate.
*              wa_itmjsn-unit__price = wa_itmjsn-total__amount / wa_itmjsn-quantity.
**            ELSE.
**              DATA : zf30 TYPE i_billingdocitemprcgelmntbasic-conditiontype.
**              zf30 = ls_konv-conditionamount / ls_finewb-quantity.
**              ls_finewb-itunit_price = ls_finewb-itunit_price + zf30.
**              ls_finewb-itsval = ls_finewb-itsval + ls_konv-conditionamount.
**              CLEAR zf30.
**            ENDIF.
            WHEN 'DISC'." Amount
*            ls_finewb-itdisc  =  ls_finewb-itdisc + abs( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
*            ls_finewb-itdisc  = abs( ls_finewb-itdisc ).
*            lv_disc =  lv_disc + abs( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
*            lv_disc = abs( lv_disc ).
              CLEAR wa_itmjsn-discount.
              wa_itmjsn-discount  =  wa_itmjsn-discount + abs( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
              wa_itmjsn-discount  = abs( wa_itmjsn-discount ).
              lv_disc =  lv_disc + abs( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
              lv_disc = abs( lv_disc ).
            WHEN 'ZFIN'." Amount
              lv_insu =  lv_insu + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'FRIT'." Amount
              lv_frei =  lv_frei + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'OTCH'." Amount
              wa_itmjsn-other__charge  =  wa_itmjsn-other__charge + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
              lv_otch =  lv_otch + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'CESS'." Rate
              wa_itmewb-cess__rate = ls_konv-conditionratevalue.
*            ls_finewb-itcsamt = ls_konv-conditionamount * wa_sdinvh-accountingexchangerate .
              lv_cess =  lv_cess + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'NACS'." Amount.
              wa_itmewb-cess_non_advol  =  ls_konv-conditionamount * wa_sdinvh-accountingexchangerate .
              lv_nacs =  lv_nacs + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
            WHEN 'DIFF'." Amount.
              lv_diff =  lv_diff  + ( ls_konv-conditionamount * wa_sdinvh-accountingexchangerate ).
          ENDCASE.
          CLEAR:ls_konv.
*        wa_itmjsn-assessable__value = wa_itmjsn-total__amount - wa_itmjsn-discount .
*        lv_assv = lv_assv + wa_itmjsn-assessable__value.
        ENDLOOP.
        wa_itmewb-taxable__amount = wa_itmewb-taxable__amount - wa_itmjsn-discount .
        lv_assv = lv_assv + wa_itmewb-taxable__amount.
        wa_itmjsn-total__item__value = wa_itmjsn-assessable__value + wa_itmjsn-sgst__amount + wa_itmjsn-cgst__amount +
                                       wa_itmjsn-igst__amount + wa_itmjsn-state__cess__amount + wa_itmjsn-cess__amount +
                                       wa_itmjsn-other__charge + wa_itmjsn-cess__nonadvol__amount + lv_insu + lv_frei .
        APPEND wa_itmewb TO it_itmewb.
        CLEAR wa_itmewb.
      ENDLOOP.
      wa_ewb-item_list = it_itmewb.
      wa_ewb-other__value = lv_otch.
      wa_ewb-taxable__amount = lv_assv.
      wa_ewb-cgst__amount = lv_cgst.
      wa_ewb-sgst__amount = lv_sgst.
      wa_ewb-igst__amount = lv_igst.
      wa_ewb-cess__amount = lv_cess.
      wa_ewb-cess__nonadvol__value = lv_nacs.
      wa_ewb-total__invoice__value = lv_otch + lv_assv + lv_cgst + lv_sgst + lv_igst + lv_cess + lv_nacs + lv_diff.

      lv_json = /ui2/cl_json=>serialize( data = wa_ewb
                                   compress = abap_false
                                pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
      exit.

    ENDLOOP.
  ENDMETHOD.


  METHOD irn_data.
    MOVE-CORRESPONDING docno TO gt_sel.
    DATA(wa_bd) = VALUE #( docno[ 1 ] OPTIONAL ).
    wa_bd-billingdocument = |{ wa_bd-billingdocument ALPHA = IN }|.
** Get eligible tax codes
*    SELECT * FROM zirn_tax_code INTO TABLE @it_txcd.
** Get user-id GSTIN mapping
    SELECT * FROM ztab_gstin_user INTO TABLE @DATA(it_usr).
*    Get Business place details
    SELECT * FROM i_in_plantbusinessplacedetail INTO TABLE @DATA(it_jbrch)."usergstin
    SELECT * FROM i_in_businessplacetaxdetail INTO TABLE @DATA(it_jbrch1).
** Billing type Invoice type mapping
    SELECT * FROM zsd_irn_doc_typ WHERE gstdoc IN ( 'RI','EI','SI','C','D' ) INTO TABLE @DATA(it_sddc).
    IF it_sddc IS NOT INITIAL.
** Condition type Invoice type mapping
      SELECT * FROM zsd_irn_cond_typ FOR ALL ENTRIES IN @it_sddc WHERE gstdoc = @it_sddc-gstdoc INTO TABLE @DATA(it_sdcd).
    ENDIF.
    LOOP AT it_sddc INTO DATA(wa_sddc).
      rs_sddct-sign = 'I'.
      rs_sddct-option = 'EQ'.
      rs_sddct-low = wa_sddc-fkart.
      APPEND rs_sddct TO rg_sddct.
    ENDLOOP.
    LOOP AT it_sdcd INTO DATA(wa_sdcd).
      rs_sdcnd-sign = 'I'.
      rs_sdcnd-option = 'EQ'.
      rs_sdcnd-low = wa_sdcd-kschl.
      APPEND rs_sdcnd TO rg_sdcnd.
    ENDLOOP.
    IF rg_sddct[] IS NOT INITIAL AND docno IS NOT INITIAL.
      SELECT * FROM i_billingdocument
*               FOR ALL ENTRIES IN @docno
               WHERE billingdocument = @wa_bd-billingdocument
                 AND billingdocumenttype IN @rg_sddct
                 AND companycode = @wa_bd-companycode
                 AND accountingtransferstatus = 'C'
                 AND billingdocumentiscancelled = ''
               INTO TABLE @DATA(gt_sdinv).
    ENDIF.
    IF gt_sdinv[] IS NOT INITIAL.
      SELECT * FROM i_billingdocumentitem
             FOR ALL ENTRIES IN @gt_sdinv
             WHERE billingdocument = @gt_sdinv-billingdocument
               AND billingdocumenttype IN @rg_sddct
*               AND creationdate = @docno-postingdate
*               AND companycode = @docno-companycode
               AND billingquantity GT 0
             INTO TABLE @DATA(gt_sdinv1).
    ENDIF.
    IF gt_sdinv1[] IS NOT INITIAL.
      SELECT * FROM i_billingdocitemprcgelmntbasic
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE billingdocument = @gt_sdinv1-billingdocument
            AND billingdocumentitem = @gt_sdinv1-billingdocumentitem
            AND conditiontype IN @rg_sdcnd
            AND conditioninactivereason = ''
            AND conditionisforstatistics = ' '
          INTO TABLE @DATA(gt_konv).

      SELECT * FROM i_custsalesareatax
              FOR ALL ENTRIES IN @gt_sdinv1
              WHERE customer = @gt_sdinv1-soldtoparty
                AND customertaxcategory IN ( 'JOCG', 'JOSG', 'JOIG' )
              INTO TABLE @DATA(gt_knvi).
      SELECT * FROM i_billingdocumentpartner
               FOR ALL ENTRIES IN @gt_sdinv1
               WHERE billingdocument = @gt_sdinv1-billingdocument
                 AND partnerfunction IN ( 'RE', 'WE', 'ZL' )
                INTO TABLE @DATA(gt_vbpa).
**********logic for deemed export supplier or sez************
      SELECT customer, customertaxclassification
        FROM i_custsalesareatax
        FOR ALL ENTRIES IN @gt_vbpa
        WHERE customer = @gt_vbpa-customer
        INTO TABLE @DATA(it_taxclass).
***********************************************
      SELECT subsqntdocitmprecdgdocument, subsqntdocitmprecdgdocitem, subsqntdocitmprecdgdoccategory,
             subsequentdocument, subsequentdocumentitem, subsequentdocumentcategory
               FROM i_salesdocitmsubsqntprocflow
               FOR ALL ENTRIES IN @gt_sdinv1
               WHERE subsequentdocument = @gt_sdinv1-billingdocument
                 AND subsequentdocumentcategory IN ( 'O', 'P' )
                 AND subsqntdocitmprecdgdoccategory IN ( 'K', 'L' )
                INTO TABLE @DATA(gt_vbfa).
      IF gt_vbfa IS NOT INITIAL.
        SELECT subsqntdocitmprecdgdocument, subsqntdocitmprecdgdocitem, subsqntdocitmprecdgdoccategory,
             subsequentdocument, subsequentdocumentitem, subsequentdocumentcategory
               FROM i_salesdocitmsubsqntprocflow
               FOR ALL ENTRIES IN @gt_vbfa
               WHERE subsequentdocument = @gt_vbfa-subsqntdocitmprecdgdocument
                 AND subsequentdocumentcategory IN ( 'K', 'L' )
                 AND subsqntdocitmprecdgdoccategory IN ( 'M' )
                INTO TABLE @DATA(gt_vbfa1).
      ENDIF.
      IF gt_vbfa1 IS NOT INITIAL.
        SELECT billingdocument, billingdocumentdate, documentreferenceid
                FROM i_billingdocument
                FOR ALL ENTRIES IN @gt_vbfa1
                WHERE billingdocument = @gt_vbfa1-subsqntdocitmprecdgdocument
                 INTO TABLE @DATA(gt_vbrk).
      ENDIF.
      SELECT * FROM zirn_unit_mapng                   " logic for unit mapping
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE vrkme_i = @gt_sdinv1-BillingQuantityUnit
              INTO TABLE @DATA(gt_irun).

      SELECT customer, country, organizationbpname1, organizationbpname2, cityname, postalcode,
             region, streetname, addressid, districtname, taxnumber3
          FROM i_customer
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE customer = @gt_sdinv1-soldtoparty
          INTO TABLE @DATA(gt_kna1).

      IF gt_vbpa IS NOT INITIAL.
        SELECT customer, country, organizationbpname1, organizationbpname2, cityname, postalcode,
                region, streetname, addressid, districtname, taxnumber3
            FROM i_customer
            FOR ALL ENTRIES IN @gt_vbpa
            WHERE customer = @gt_vbpa-customer
            APPENDING TABLE @gt_kna1.

        SORT: gt_kna1.
        DELETE ADJACENT DUPLICATES FROM gt_kna1.
      ENDIF.

      SELECT * FROM i_companycode
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE companycode = @gt_sdinv1-companycode
          INTO TABLE @DATA(gt_t001).
      IF gt_t001 IS NOT INITIAL.
        SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @gt_t001
            WHERE addressid = @gt_t001-addressid
            INTO TABLE @DATA(gt_adrc).
      ENDIF.

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
      IF gt_kna1 IS NOT INITIAL.
        SELECT * FROM i_address_2 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @gt_kna1
            WHERE addressid = @gt_kna1-addressid
            APPENDING TABLE @gt_adrc.
      ENDIF.
      SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE product = @gt_sdinv1-material
            AND plant = @gt_sdinv1-plant
          INTO TABLE @DATA(gt_marc).
      SELECT material, batch, shelflifeexpirationdate
          FROM i_batch
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE material = @gt_sdinv1-material
          AND   batch = @gt_sdinv1-batch
          INTO TABLE @DATA(gt_mch1).
    ENDIF.
    IF gt_adrc IS NOT INITIAL.
      SELECT * FROM i_workplaceaddress
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_adr6).
      SELECT * FROM i_addressemailaddress_2 WITH PRIVILEGED ACCESS
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_email).
      SELECT * FROM i_addressphonenumber_2 WITH PRIVILEGED ACCESS
          FOR ALL ENTRIES IN @gt_adrc
          WHERE addressid = @gt_adrc-addressid
          INTO TABLE @DATA(gt_phone).
    ENDIF.
    IF gt_sdinv1 IS NOT INITIAL.
      SELECT * FROM i_currency
          FOR ALL ENTRIES IN @gt_sdinv1
          WHERE currency = @gt_sdinv1-transactioncurrency
          INTO TABLE @DATA(gt_tcurx).
    ENDIF.
    SELECT * FROM zgst_region_map INTO TABLE @DATA(gt_gst_region).
    SORT:gt_sdinv1, gt_sdinv.
******* Field symbols
    FIELD-SYMBOLS: <fs_fin> TYPE ty_json.
*    SELECT * FROM zgst_gstin_map INTO TABLE @gt_gstin_map.\
    LOOP AT gt_sdinv1 INTO DATA(ls_sdinvt).
      CLEAR:ls_sdinv,ls_vbpa,ls_buyer,ls_adr6,"ls_knab,ls_knas,
      ls_shpto,ls_j_1bbranch,ls_t001w,ls_sellr,
      ls_knvi,ls_sdcd,ls_sddc,",ls_irunit,ls_marc,ls_mch1,
      ls_konv,ls_final.
      MOVE-CORRESPONDING ls_sdinvt TO ls_sdinv.
      ls_final-data__source = 'erp'.
      wa_final-data__source = 'erp'.
      "it_txndet pendng and


      "Seller Details and dispatch details.
      READ TABLE gt_t001 INTO ls_t001 WITH KEY companycode = ls_sdinv-companycode.
      READ TABLE gt_adrc INTO DATA(wa_adr) WITH KEY addressid = ls_t001-addressid.

*      IF sy-subrc = 0.
**        wa_selldet-trade__name = wa_adr-organizationname1.
**        wa_selldet-legal__name = wa_adr-OrganizationName1.
**        wa_selldet-address1 = wa_Adr-StreetName.
**        wa_selldet-address1 = wa_Adr-
*      ENDIF.
      READ TABLE gt_t001w INTO ls_t001w WITH KEY plant = ls_sdinv-plant.
      IF sy-subrc = 0.
*        wa_final-dispatch__details-company__name = ls_t001w-plantname.
        READ TABLE it_jbrch INTO ls_j_1bbranch WITH KEY companycode = ls_sdinv-companycode
                                                        plant = ls_t001w-plant.
        READ TABLE it_jbrch1 INTO ls_j_1bbranch1 WITH KEY companycode = ls_j_1bbranch-companycode
                                                          businessplace = ls_j_1bbranch-businessplace.
        IF sy-subrc = 0.
          wa_final-user__gstin = ls_j_1bbranch1-in_gstidentificationnumber.
          wa_final-seller__details-gstin = ls_j_1bbranch1-in_gstidentificationnumber.
        ENDIF.
      ENDIF.
      READ TABLE gt_adrc INTO ls_sellr WITH KEY addressid = ls_t001w-addressid.
      IF sy-subrc = 0.
        wa_final-seller__details-trade__name = ls_sellr-organizationname1.
        CONCATENATE ls_sellr-organizationname2 ls_sellr-organizationname3 ls_sellr-organizationname4
              INTO wa_final-seller__details-legal__name SEPARATED BY space.
        IF wa_final-seller__details-legal__name IS INITIAL.
          wa_final-seller__details-legal__name = wa_final-seller__details-trade__name.
        ENDIF.
        CONCATENATE ls_sellr-building ls_sellr-housenumber ls_sellr-housenumbersupplementtext ls_sellr-streetname
            INTO wa_final-seller__details-address1 SEPARATED BY ''.
        CONDENSE wa_final-seller__details-address1.
*        wa_final-dispatch__details-address1 = wa_final-seller__details-address1.
        CONCATENATE ls_sellr-floor ls_sellr-StreetSuffixName1 ls_sellr-streetprefixname1 ls_sellr-streetprefixname2 ls_sellr-cityname ls_sellr-DistrictName
            INTO wa_final-seller__details-address2 SEPARATED BY space.
        CONDENSE wa_final-seller__details-address2.
*        wa_final-dispatch__details-address2 = wa_final-seller__details-address2.
        READ TABLE gt_gst_region INTO DATA(ls_seller_region) WITH KEY regio = ls_sellr-region.
        IF sy-subrc = 0.
          wa_final-seller__details-state__code = ls_seller_region-zgstr.
*          wa_final-dispatch__details-state__code = ls_seller_region-zgstr.
*          ls_final-dstcd = ls_seller_region-zgstr.            here we can add dispatch code
        ENDIF.
        wa_final-seller__details-location = ls_sellr-cityname.
        wa_final-seller__details-pincode = ls_sellr-postalcode.
*        wa_final-dispatch__details-location = ls_sellr-cityname.
*        wa_final-dispatch__details-pincode = ls_sellr-postalcode.
        READ TABLE gt_email INTO DATA(wa_emailsup) WITH KEY addressid = ls_sellr-addressid.
        IF sy-subrc = 0.
          wa_final-seller__details-email = wa_emailsup-emailaddress.
        ENDIF.
        READ TABLE gt_phone INTO DATA(wa_phonesup) WITH KEY addressid = ls_sellr-addressid.
        IF sy-subrc = 0.
*          wa_final-seller__details-phone__number = wa_phonesup-internationalphonenumber.  "As confirm from OSuroshe 28/08
*          REPLACE '+91' IN wa_final-seller__details-phone__number WITH space.

        ENDIF.                              "CATCH cx_sy_itab_line_not_found.
      ENDIF.
*      APPEND wa_selldet TO wa_final-seller__details.                    "Appended Seller data to final json work area
*      APPEND wa_dsptchdet TO wa_final-dispatch__details.

      "Buyer Details
      READ TABLE gt_vbpa INTO ls_vbpa WITH KEY billingdocument = ls_sdinv-billingdocument partnerfunction = 'RE'.
      IF sy-subrc = 0.
        READ TABLE it_taxclass INTO DATA(wa_taxclass) WITH KEY customer = ls_vbpa-customer.
        READ TABLE gt_kna1 INTO DATA(ls_knab) WITH KEY customer = ls_vbpa-customer.
*        data(wa_taxclass) = VALUE#( it_taxclass [ Customer = ls_vbpa-Customer ]-optional).
        IF sy-subrc = 0.
          READ TABLE gt_adrc INTO ls_buyer WITH KEY addressid = ls_knab-addressid.
          IF sy-subrc = 0.
            wa_final-buyer__details-gstin = ls_knab-taxnumber3.
            CONDENSE wa_final-buyer__details-gstin NO-GAPS.
*            READ TABLE gt_gstin_map INTO DATA(ls_buyer_gstin) WITH KEY sap_gstin = ls_knab-taxnumber3.
*            IF sy-subrc = 0.
*              ls_final-bgstin = ls_buyer_gstin-gst_gstin.
*              CONDENSE ls_final-bgstin NO-GAPS.
*            ENDIF.
            CONCATENATE ls_buyer-building ls_buyer-housenumber ls_buyer-housenumbersupplementtext ls_buyer-streetname
                INTO wa_final-buyer__details-address1 SEPARATED BY ''.
            CONDENSE wa_final-buyer__details-address1.
            CONCATENATE ls_buyer-floor ls_buyer-StreetSuffixName1 ls_buyer-streetprefixname1 ls_buyer-streetprefixname2 ls_buyer-cityname ls_buyer-DistrictName
                INTO wa_final-buyer__details-address2 SEPARATED BY space.
            CONDENSE wa_final-buyer__details-address2.
            wa_final-buyer__details-location = ls_buyer-cityname.
            lv_buyercountry = ls_buyer-country.
*            ls_final-bdst = ls_buyer-districtname.
*            IF ls_final-bdst IS INITIAL.
*              ls_final-bdst = ls_buyer-cityname.
*            ENDIF.
            wa_final-buyer__details-pincode = ls_buyer-postalcode.
            READ TABLE gt_gst_region INTO DATA(ls_buyer_region) WITH KEY regio = ls_buyer-region.
            IF sy-subrc = 0.
              wa_final-buyer__details-state__code = ls_buyer_region-zgstr.
              wa_final-buyer__details-place__of__supply = ls_buyer_region-zgstr.
            ENDIF.
            wa_final-buyer__details-legal__name = ls_buyer-organizationname1.
            CONCATENATE ls_buyer-organizationname2 ls_buyer-organizationname3 ls_buyer-organizationname4
                INTO wa_final-buyer__details-trade_name SEPARATED BY space.
            IF wa_final-buyer__details-legal__name IS INITIAL.
              wa_final-buyer__details-legal__name = wa_selldet-trade__name.
            ENDIF.
*            READ TABLE gt_adr6 INTO ls_adr6 WITH KEY addressid = ls_buyer-addressid.
            READ TABLE gt_email INTO DATA(wa_email) WITH KEY addressid = ls_buyer-addressid.
            IF sy-subrc = 0.
              wa_final-buyer__details-email = wa_email-emailaddress.
            ENDIF.
            READ TABLE gt_phone INTO DATA(wa_phone) WITH KEY addressid = ls_buyer-addressid.
            IF sy-subrc = 0.
*              wa_final-buyer__details-phone__number = wa_phone-phoneareacodesubscribernumber .
*              REPLACE '+91' IN wa_final-buyer__details-phone__number WITH space.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*      APPEND wa_buydet TO wa_Final-buyer__details.                  "Append Buyer details to FINAL JSON

      " Ship-to Details
      CASE lv_buyercountry.
        WHEN 'IN'.
          READ TABLE gt_vbpa INTO ls_vbpa WITH KEY billingdocument = ls_sdinv-billingdocument partnerfunction = 'WE'.
          IF sy-subrc = 0.

            READ TABLE gt_kna1 INTO DATA(ls_knas) WITH KEY customer = ls_vbpa-customer.
            IF sy-subrc = 0.
*          wa_shiptodet-cntcd = ls_knas-country.
              READ TABLE gt_adrc INTO ls_shpto WITH KEY addressid = ls_knas-addressid.
              IF sy-subrc = 0.
                wa_final-ship__details-gstin = ls_knas-taxnumber3.
                CONDENSE wa_final-ship__details-gstin NO-GAPS.
*            READ TABLE gt_gstin_map INTO DATA(ls_shpto_gstin) WITH KEY sap_gstin = ls_knas-taxnumber3.
*            IF sy-subrc = 0.
*              ls_final-togstin = ls_shpto_gstin-gst_gstin.
*              CONDENSE ls_final-togstin NO-GAPS.
*            ENDIF.
                wa_final-ship__details-trade__name = ls_shpto-organizationname1.
                CONCATENATE ls_shpto-organizationname2 ls_shpto-organizationname3 ls_shpto-organizationname4
                    INTO wa_final-ship__details-legal__name SEPARATED BY space.
                IF wa_final-ship__details-legal__name IS INITIAL.
                  wa_final-ship__details-legal__name = wa_final-ship__details-trade__name.
                ENDIF.
                CONCATENATE ls_shpto-building ls_shpto-housenumber ls_shpto-housenumbersupplementtext ls_shpto-streetname
                    INTO wa_final-ship__details-address1 SEPARATED BY ''.
                CONDENSE wa_final-ship__details-address1.
                CONCATENATE ls_shpto-floor ls_shpto-streetprefixname1 ls_shpto-streetprefixname2 ls_shpto-cityname
                    INTO wa_final-ship__details-address2 SEPARATED BY space.
                CONDENSE wa_final-ship__details-address2.
                wa_final-ship__details-location = ls_shpto-cityname.
*            wa_shiptodet-todst = ls_shpto-districtname.
*            IF ls_final-todst IS INITIAL.
*              ls_final-todst = ls_final-toloc.
*            ENDIF.
                READ TABLE gt_gst_region INTO DATA(ls_shipto_region) WITH KEY regio = ls_shpto-region.
                IF sy-subrc = 0.
                  wa_final-ship__details-state__code = ls_shipto_region-zgstr.
                ENDIF.
*            IF ls_shpto-country NE 'IN'.
*              ls_final-pos = '96'.
*            ELSE.
*              ls_final-pos = ls_final-tostcd.
*            ENDIF.
                wa_final-ship__details-pincode = ls_shpto-postalcode.
*            READ TABLE gt_email INTO DATA(wa_emailsh) WITH KEY addressid = ls_shpto-addressid.
*            IF sy-subrc = 0.
*              wa_shiptodet- = wa_emailsh-emailaddress.
*            ENDIF.
*            READ TABLE gt_phone INTO DATA(wa_phonesh) WITH KEY addressid = ls_shpto-addressid.
*            IF sy-subrc = 0.
*              ls_final-toph = wa_phonesh-phoneareacodesubscribernumber.
*            ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN OTHERS.
          READ TABLE gt_vbpa INTO ls_vbpa WITH KEY billingdocument = ls_sdinv-billingdocument partnerfunction = 'ZL'.
          IF sy-subrc = 0.

            READ TABLE gt_kna1 INTO ls_knas WITH KEY customer = ls_vbpa-customer.
            IF sy-subrc = 0.
*          wa_shiptodet-cntcd = ls_knas-country.
              READ TABLE gt_adrc INTO ls_shpto WITH KEY addressid = ls_knas-addressid.
              IF sy-subrc = 0.
                wa_final-ship__details-gstin = ls_knas-taxnumber3.
                CONDENSE wa_final-ship__details-gstin NO-GAPS.
*            READ TABLE gt_gstin_map INTO DATA(ls_shpto_gstin) WITH KEY sap_gstin = ls_knas-taxnumber3.
*            IF sy-subrc = 0.
*              ls_final-togstin = ls_shpto_gstin-gst_gstin.
*              CONDENSE ls_final-togstin NO-GAPS.
*            ENDIF.
                wa_final-ship__details-trade__name = ls_shpto-organizationname1.
                CONCATENATE ls_shpto-organizationname2 ls_shpto-organizationname3 ls_shpto-organizationname4
                    INTO wa_final-ship__details-legal__name SEPARATED BY space.
                IF wa_final-ship__details-legal__name IS INITIAL.
                  wa_final-ship__details-legal__name = wa_final-ship__details-trade__name.
                ENDIF.
                CONCATENATE ls_shpto-building ls_shpto-housenumber ls_shpto-housenumbersupplementtext ls_shpto-streetname
                    INTO wa_final-ship__details-address1 SEPARATED BY ''.
                CONDENSE wa_final-ship__details-address1.
                CONCATENATE ls_shpto-floor ls_shpto-streetprefixname1 ls_shpto-streetprefixname2 ls_shpto-cityname
                    INTO wa_final-ship__details-address2 SEPARATED BY space.
                CONDENSE wa_final-ship__details-address2.
                wa_final-ship__details-location = ls_shpto-cityname.
*            wa_shiptodet-todst = ls_shpto-districtname.
*            IF ls_final-todst IS INITIAL.
*              ls_final-todst = ls_final-toloc.
*            ENDIF.
                READ TABLE gt_gst_region INTO ls_shipto_region WITH KEY regio = ls_shpto-region.
                IF sy-subrc = 0.
                  wa_final-ship__details-state__code = ls_shipto_region-zgstr.
                ENDIF.
*            IF ls_shpto-country NE 'IN'.
*              ls_final-pos = '96'.
*            ELSE.
*              ls_final-pos = ls_final-tostcd.
*            ENDIF.
                wa_final-ship__details-pincode = ls_shpto-postalcode.
*            READ TABLE gt_email INTO DATA(wa_emailsh) WITH KEY addressid = ls_shpto-addressid.
*            IF sy-subrc = 0.
*              wa_shiptodet- = wa_emailsh-emailaddress.
*            ENDIF.
*            READ TABLE gt_phone INTO DATA(wa_phonesh) WITH KEY addressid = ls_shpto-addressid.
*            IF sy-subrc = 0.
*              ls_final-toph = wa_phonesh-phoneareacodesubscribernumber.
*            ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
      ENDCASE.
      CASE wa_final-buyer__details-address1.
        WHEN wa_final-ship__details-address1.
          CLEAR wa_final-ship__details.
      ENDCASE.
*      APPEND wa_shiptodet TO wa_Final-ship__details.                  "Append Buyer details to FINAL JSON

      "reference_details starts here.
      wa_final-reference__details-invoice__remarks = 'Invoice Remarks'.
*      wa_docperioddet                   not required
      IF wa_docdet-document__type EQ 'C' OR wa_docdet-document__type EQ 'DBN'.
        READ TABLE gt_vbfa INTO DATA(ls_vbfa) WITH KEY subsequentdocument = ls_sdinv-billingdocument subsequentdocumentitem = ls_sdinv-billingdocumentitem.
        IF sy-subrc = 0.
          READ TABLE gt_vbfa1 INTO DATA(ls_vbfa1) WITH KEY subsequentdocument = ls_vbfa-subsqntdocitmprecdgdocument.
          wa_prcddocdet-ref__of__original__invoice = ls_vbfa1-subsqntdocitmprecdgdocument.
          READ TABLE gt_vbrk INTO DATA(ls_vbrk) WITH KEY billingdocument = ls_vbfa1-subsqntdocitmprecdgdocument.
          IF sy-subrc = 0.
            IF gv_int_num_flag NE 'X'.
              wa_prcddocdet-ref__of__original__invoice = ls_vbrk-documentreferenceid.
              SHIFT wa_prcddocdet-ref__of__original__invoice LEFT DELETING LEADING '0'.
            ENDIF.
            wa_prcddocdet-preceding__invoice__date = ls_vbrk-billingdocumentdate.
            CONCATENATE wa_prcddocdet-preceding__invoice__date+6(2) '/' wa_prcddocdet-preceding__invoice__date+4(2) '/' wa_prcddocdet-preceding__invoice__date+0(4) INTO wa_prcddocdet-preceding__invoice__date.
          ENDIF.
        ENDIF.
      ENDIF." end of code to get reference inv number & date

      wa_prcddocdet-other__reference = ''.
      APPEND wa_prcddocdet TO wa_final-reference__details-preceding__document__details.
*      APPEND wa_refdet to wa_final-reference__details.
*      APPEND wa_refdet TO wa_final-reference__details.

      READ TABLE gt_sdinv INTO wa_sdinvb WITH KEY billingdocument = ls_sdinv-billingdocument.
      ""ITEM DETAILS
      LOOP AT gt_sdinv1 INTO DATA(wa_sdinv).
        lv_slno = lv_slno + 001.
        wa_itmjsn-item__serial__number = lv_slno.
*        wa_itmjsn-product__serial__number = wa_sdinv-material.
        SHIFT wa_itmjsn-product__serial__number LEFT DELETING LEADING '0'.

        wa_itmjsn-product__description = wa_sdinv-billingdocumentitemtext.
        wa_itmjsn-quantity = wa_sdinv-billingquantity.
        READ TABLE gt_irun INTO DATA(ls_irunit) WITH KEY vrkme_i = ls_sdinv-billingquantityunit.
        IF sy-subrc = 0.
          wa_itmjsn-is__service = 'N'.
          wa_itmjsn-unit = ls_irunit-irnut.
        ELSE.
          wa_itmjsn-unit     = 'OTH'.
          wa_itmjsn-is__service = 'Y'.
        ENDIF.
        READ TABLE gt_marc INTO DATA(ls_marc) WITH KEY product = wa_sdinv-material
                                                       plant = wa_sdinv-plant.
        IF sy-subrc = 0.
          wa_itmjsn-hsn__code = ls_marc-consumptiontaxctrlcode.
        ENDIF.
*******************LOGIC FOR BATCH DETAILS******************************
        READ TABLE gt_mch1 INTO DATA(ls_mch1) WITH KEY material = wa_sdinv-material
                                                         batch = wa_sdinv-batch.
        IF sy-subrc = 0.
          wa_itmjsn-batch__details-name = ls_mch1-batch.
          wa_itmjsn-batch__details-expiry__date = ls_mch1-shelflifeexpirationdate.
          IF ls_mch1-shelflifeexpirationdate IS NOT INITIAL.
            CONCATENATE wa_itmjsn-batch__details-expiry__date+6(2) '-'
                        wa_itmjsn-batch__details-expiry__date+4(2) '-'
                        wa_itmjsn-batch__details-expiry__date+0(4)
              INTO wa_itmjsn-batch__details-expiry__date.
          ENDIF.
        ENDIF.
***************************************************************************
*        IF ls_final-trn_typ = 'REG' .
*          CLEAR:ls_final-tolgl_nm,ls_final-totrd_nm,ls_final-tobnm,ls_final-toflno,
*                ls_final-togstin,ls_final-toloc,ls_final-todst,ls_final-todst,
*                ls_final-topin,ls_final-tostcd,ls_final-toem,ls_final-toph,
*                ls_final-dstcd,ls_final-dpin,ls_final-dtrd_nm.
*        ELSEIF  ls_final-trn_typ = 'SHP'.
*          CLEAR:ls_final-dstcd,ls_final-dpin,ls_final-dtrd_nm.
*        ENDIF.
        wa_itmjsn-bar__code = ''.
        wa_itmjsn-free__quantity = ''.
        READ TABLE gt_tcurx INTO ls_tcurx WITH KEY currency = ls_sdinv-transactioncurrency.
        IF sy-subrc = 0 AND ls_tcurx-decimals GT 2.
          ls_tcurx-decimals = ls_tcurx-decimals - 2.
        ENDIF.
        READ TABLE it_sddc INTO ls_sddc WITH KEY fkart = ls_sdinv-billingdocumenttype.
        " Item TAX COnd Details. wa_itmjsn
        LOOP AT gt_konv INTO ls_konv WHERE billingdocument = wa_sdinv-billingdocument
                                 AND billingdocumentitem = wa_sdinv-billingdocumentitem.
          CLEAR:ls_sdcd.
          READ TABLE it_sdcd INTO ls_sdcd WITH KEY kschl = ls_konv-conditiontype
                                                   gstdoc = ls_sddc-gstdoc.
          CHECK sy-subrc EQ 0.

          CASE ls_sdcd-gstgrp.
            WHEN 'CGST'." Rate
              wa_itmjsn-gst__rate = ls_konv-conditionratevalue * 2.
              wa_itmjsn-cgst__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate.
              lv_cgst =  lv_cgst + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'SGST' OR 'UGST'." Rate
              wa_itmjsn-gst__rate = ls_konv-conditionratevalue * 2.
              wa_itmjsn-sgst__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate.
              lv_sgst =  lv_sgst + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'IGST'. " Rate
              wa_itmjsn-gst__rate = ls_konv-conditionratevalue.
              wa_itmjsn-igst__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate .
              lv_igst =  lv_igst + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'PPR0'."unit price KBETR
              wa_itmjsn-total__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate.
              wa_itmjsn-unit__price = wa_itmjsn-total__amount / wa_itmjsn-quantity.
*              wa_itmjsn-unit__price = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate.
*              wa_itmjsn-total__amount = wa_itmjsn-unit__price * wa_itmjsn-quantity.
            WHEN 'DISC'." Amount
              wa_itmjsn-discount  =  wa_itmjsn-discount + abs( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
              wa_itmjsn-discount  = abs( wa_itmjsn-discount ).
              lv_disc =  lv_disc + abs( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
              lv_disc = abs( lv_disc ).
            WHEN 'INSU'." Amount
              lv_insu =  lv_insu + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'FRIT'." Amount
              lv_frei =  lv_frei + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'OTCH'." Amount
              wa_itmjsn-other__charge  = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate .
              lv_otch =  lv_otch + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'CESS'." Rate
              wa_itmjsn-cess__rate = ls_konv-conditionratevalue.
              wa_itmjsn-cess__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate .
              lv_cess =  lv_cess + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'SCES'." Rate
              wa_itmjsn-state__cess__rate = ls_konv-conditionratevalue.
              wa_itmjsn-state__cess__amount = ls_konv-conditionamount * wa_sdinvb-accountingexchangerate .
              lv_sces =  lv_sces + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'NACS'." Amount.
              wa_itmjsn-cess__nonadvol__amount =  ls_konv-conditionamount * wa_sdinvb-accountingexchangerate .
              lv_nacs =  lv_nacs + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
            WHEN 'DIFF'." Amount.
              lv_diff =  lv_diff  + ( ls_konv-conditionamount * wa_sdinvb-accountingexchangerate ).
          ENDCASE.
          CLEAR:ls_konv.
        ENDLOOP.
*        IF ls_sdinv-transactioncurrency NE 'INR'.
*          DO ls_tcurx-decimals TIMES.
*            wa_itmjsn-cess__nonadvol__amount = wa_itmjsn-cess__nonadvol__amount / 10.
*            wa_itmjsn-state__cess__amount = wa_itmjsn-state__cess__amount / 10.
*            wa_itmjsn-cess__amount = wa_itmjsn-cess__amount / 10.
*            wa_itmjsn-other__charge = wa_itmjsn-other__charge / 10.
*            wa_itmjsn-discount = wa_itmjsn-discount / 10.
*            wa_itmjsn-unit__price = wa_itmjsn-unit__price / 10.
*            wa_itmjsn-total__amount = wa_itmjsn-total__amount / 10.
*            wa_itmjsn-igst__amount = wa_itmjsn-igst__amount / 10.
*            wa_itmjsn-sgst__amount = wa_itmjsn-sgst__amount / 10.
*            wa_itmjsn-cgst__amount = wa_itmjsn-cgst__amount / 10.
*          ENDDO.
*        ENDIF.
        wa_itmjsn-assessable__value = wa_itmjsn-total__amount - wa_itmjsn-discount .
        lv_assv = lv_assv + wa_itmjsn-assessable__value.
        wa_itmjsn-total__item__value = wa_itmjsn-assessable__value + wa_itmjsn-sgst__amount + wa_itmjsn-cgst__amount +
                                       wa_itmjsn-igst__amount + wa_itmjsn-state__cess__amount + wa_itmjsn-cess__amount +
                                       wa_itmjsn-other__charge + wa_itmjsn-cess__nonadvol__amount + lv_insu + lv_frei .
        APPEND wa_itmjsn TO wa_final-item__list.
        CLEAR wa_itmjsn.
      ENDLOOP.

      "Value Details.
      wa_final-value__details-total__assessable__value = lv_assv.
      wa_final-value__details-total__cgst__value = lv_cgst.
      wa_final-value__details-total__sgst__value = lv_sgst.
      wa_final-value__details-total__igst__value = lv_igst.
      wa_final-value__details-total__cess__value = lv_cess.
      wa_final-value__details-total__cess__value__of__state = lv_sces.
*      wa_final-value__details-total__discount = lv_disc.
*      wa_final-value__details-total__other__charge = lv_otch.
      wa_final-value__details-round__off__amount = lv_diff.
      wa_final-value__details-total__invoice__value = lv_assv + lv_cgst + lv_sgst + lv_igst + lv_cess + lv_sces + lv_disc + lv_otch + lv_insu + lv_insu .
*      APPEND wa_valdet TO wa_final-value_details.

      " Transaction Details.
      READ TABLE gt_kna1 INTO DATA(ls_kna1) WITH KEY customer = ls_sdinv-soldtoparty.
      IF sy-subrc = 0.
        CLEAR ls_knvi.
        READ TABLE gt_knvi INTO ls_knvi WITH KEY customer = ls_sdinv-soldtoparty.
        IF sy-subrc = 0.
          IF ls_kna1-taxnumber3 IS NOT INITIAL AND ls_knvi-customertaxclassification EQ '0'.
            wa_final-transaction__details-supply__type = 'B2B'.
          ELSEIF ls_knvi-customertaxclassification EQ '7' AND lv_buyercountry NE 'IN' AND wa_final-value__details-total__igst__value <= '0' .
            wa_final-transaction__details-supply__type = 'EXPWOP'.
            wa_final-buyer__details-pincode = '999999'.
            wa_final-buyer__details-state__code = '96'.
            wa_final-buyer__details-gstin = 'URP'.
*            wa_final-ship__details-pincode = '999999'.
*            wa_final-ship__details-state__code = '96'.
            wa_final-buyer__details-gstin = 'URP'.
            wa_final-export__details-country__code = lv_buyercountry.
          ELSEIF wa_final-value__details-total__igst__value > '0' AND ls_knvi-customertaxclassification EQ '8' AND lv_buyercountry NE 'IN'.
            wa_final-transaction__details-supply__type = 'EXPWP'.
            wa_final-buyer__details-pincode = '999999'.
            wa_final-buyer__details-state__code = '96'.
            wa_final-buyer__details-gstin = 'URP'.
*            wa_final-ship__details-pincode = '999999'.
*            wa_final-ship__details-state__code = '96'.
            wa_final-buyer__details-gstin = 'URP'.
            wa_final-export__details-country__code = lv_buyercountry.
          ELSEIF ls_knvi-customertaxclassification EQ '3' AND lv_buyercountry EQ 'IN' AND ( wa_final-value__details-total__igst__value <= '0' OR wa_final-value__details-total__cgst__value <= '0' ).
            wa_final-transaction__details-supply__type = 'SEZWOP'.
          ELSEIF ls_knvi-customertaxclassification EQ '4'.
            wa_final-transaction__details-supply__type = 'DEXP'.
          ENDIF.
        ENDIF.
      ENDIF.
*      IF ls_final-sstcd EQ ls_final-bstcd AND ls_final-sstcd EQ ls_final-tostcd.
*        ls_final-trn_typ = 'REG'.
*      ELSE.
*        ls_final-trn_typ = 'SHP'.
*      ENDIF.
*      IF ls_final-sstcd EQ ls_final-bstcd.
*        ls_final-ntr    = 'INTRA'.
*      ELSE.
*        ls_final-ntr    = 'INTER'.
*      ENDIF.

      "Document details  logic
      READ TABLE it_sddc INTO ls_sddc WITH KEY fkart = ls_sdinv-billingdocumenttype.
      IF sy-subrc = 0.
        IF ls_sddc-gstdoc = 'C'.
          wa_final-document__details-document__type = 'CRN'.
        ELSEIF ls_sddc-gstdoc = 'D'.
          wa_final-document__details-document__type = 'DBN'.
        ELSEIF ls_sddc-gstdoc = 'RI'.
          wa_final-document__details-document__type = 'INV'.
        ELSEIF ls_sddc-gstdoc = 'EI'.
          wa_final-document__details-document__type = 'INV'.
*          ls_final-trn_typ = 'REG'.
*          ls_final-ntr    = 'INTER'.
*          ls_final-catg   = 'EXWOP'.
*          wa_final- = 'URP'.
*          ls_final-bstcd  = '96'.
*          ls_final-bpin   = '999999'.
        ELSEIF ls_sddc-gstdoc = 'SI'.
          wa_final-document__details-document__type = 'INV'.
*          ls_final-trn_typ = 'REG'.
*          IF ls_buyer-country NE 'IN' OR ls_final-bgstin EQ space.
*            ls_final-bgstin = 'URP'.
*            ls_final-bstcd  = '96'.
*            ls_final-bpin   = '999999'.
*          ENDIF.
*          ls_final-ntr    = 'INTER'.
*          ls_final-catg   = 'SEWP'.
        ENDIF.
      ENDIF.
      wa_final-document__details-document__number = wa_sdinvb-documentreferenceid.
      SHIFT wa_final-document__details-document__number LEFT DELETING LEADING '0'.
      wa_final-document__details-document__date = ls_sdinv-billingdocumentdate.
      CONCATENATE wa_final-document__details-document__date+6(2) '/' wa_final-document__details-document__date+4(2) '/' wa_final-document__details-document__date+0(4)  INTO wa_final-document__details-document__date.
*      APPEND wa_docdet TO wa_final-document__details.

*      MOVE-CORRESPONDING ls_final TO wa_final.
      APPEND ls_final TO lt_final.
      EXIT.
    ENDLOOP.
    lv_json = /ui2/cl_json=>serialize( data = wa_final
                                       compress = abap_false
                                       pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    REPLACE  'ref__of__original__invoice' IN lv_json WITH 'reference_of_original_invoice'.
    REPLACE  'tot__inv__value__add__crncy' IN lv_json WITH 'total_invoice_value_additional_currency'.

  ENDMETHOD.
ENDCLASS.
