CLASS ztest1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZTEST1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


*    SELECT SINGLE purchasingdocument, purchasingdocumentitem
*       FROM i_purchaserequisitionitemapi01
*       WHERE purchaserequisition = @purchaseorderitem-purchaserequisition
*       AND purchaserequisitionitem = @purchaseorderitem-purchaserequisitionitem
*       INTO @DATA(lv_purchaseorder).
*
*    DATA temp TYPE c LENGTH 10.
*    temp = lv_purchaseorder.
*
*    SELECT SINGLE supplierquotationexternalid
*      FROM i_purchaseorderapi01
*       WHERE purchaseorder = @temp
*         INTO @DATA(lv_supp).
*
*    SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem,
*      b~netpriceamount , c~awardedquantity
*        FROM i_purchaserequisitionitemapi01 AS a
*       INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchaserequisition = b~purchaserequisition
*                                                     AND a~purchaserequisitionitem = b~purchaserequisitionitem
*                                                     AND b~supplierquotation = @lv_supp
*        INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
*                                                    AND b~supplierquotationitem = c~supplierquotationitem
*        WHERE a~purchaserequisition = @purchaseorderitem-purchaserequisition
*          AND a~purchaserequisitionitem = @purchaseorderitem-purchaserequisitionitem
*        INTO TABLE @DATA(it_rfq).
*
*
*    LOOP AT it_rfq INTO DATA(wa_rfq).
*      IF wa_rfq-purchaserequisition = purchaseorderitem-purchaserequisition
*       AND wa_rfq-purchaserequisitionitem = purchaseorderitem-purchaserequisitionitem.
*        IF wa_rfq-netpriceamount <> purchaseorderitem-netpriceamount.
*          APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
*          messagenumber = '001' messageid = 'MRM_BADI_CLOUD' messagevariable1 = 'Quotation Price mismatch' )
*    TO messages.
*        ELSEIF wa_rfq-awardedquantity <> purchaseorderitem-orderquantity.
*
*          APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
*          messagenumber = '001' messageid = 'MRM_BADI_CLOUD' messagevariable1 = 'Quotation Quantity mismatch' )
*      TO messages.
*        ENDIF.
*
*
*      ENDIF.
*    ENDLOOP.
*
*    out->write( it_rfq ).
*
*
*
*
**select single TaxNumber5 from I_Supplier
**    where supplier = @purchaseorder-supplier
**    into @data(lv_taxnum).
**    if lv_taxnum is not initial.
**         select single paymentterms
**            from I_SupplierPurchasingOrg
**            where supplier = @purchaseorder-supplier
**            into @data(lv_paymentterm).
**       if lv_paymentterm <> purchaseorder-paymentterms.
**            APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
**            MESSAGENUMBER = '001' MESSAGEID = 'MRM_BADI_CLOUD' messagevariable1 = 'MSME:Payment term not match with master record' )
**    TO messages.
**       endif.
**   endif.
*    SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem, b~netpriceamount, c~awardedquantity
*        FROM i_purchaserequisitionitemapi01 AS a
*        INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchasingdocument = b~requestforquotation
*                                                     AND a~purchasingdocumentitem = b~requestforquotationitem
*        INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
*                                                    AND b~supplierquotationitem = c~supplierquotationitem
*        WHERE a~purchaserequisition = @purchaseorderitem-purchaserequisition
*          AND a~purchaserequisitionitem = @purchaseorderitem-purchaserequisitionitem
*        INTO TABLE @DATA(it_rfq).
*    LOOP AT it_rfq INTO DATA(wa_rfq).
*      IF wa_rfq-purchaserequisition = purchaseorderitem-purchaserequisition
*       AND wa_rfq-purchaserequisitionitem = purchaseorderitem-purchaserequisitionitem.
*        IF wa_rfq-netpriceamount <> purchaseorderitem-netpriceamount.
*          APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
*          messagenumber = '001' messageid = 'MRM_BADI_CLOUD' messagevariable1 = 'Quotation Price mismatch' )
*    TO messages.
*        ELSEIF wa_rfq-awardedquantity <> purchaseorderitem-orderquantity.
*
*          APPEND VALUE #( messagetype = if_ex_mrm_check_invoice_cloud=>c_messagetype_error
*          messagenumber = '001' messageid = 'MRM_BADI_CLOUD' messagevariable1 = 'Quotation Quantity mismatch' )
*      TO messages.
*        ENDIF.
*
*
*      ENDIF.
*    ENDLOOP.





*
*   SELECT SINGLE purchasingdocument, purchasingdocumentitem
*       FROM i_purchaserequisitionitemapi01
*       WHERE purchaserequisition = '1100000022'
*       "AND purchaserequisitionitem = '00010'
*       INTO  @DATA(lv_purchaseorder).
*
*    DATA temp TYPE c LENGTH 10.
*    temp = lv_purchaseorder.
*
*    SELECT SINGLE supplierquotationexternalid
*      FROM i_purchaseorderapi01
*       WHERE purchaseorder = @temp
*         INTO @DATA(lv_supp).
*
*out->write( lv_purchaseorder ).
*out->write( lv_supp ).
*
*SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem
*, b~netpriceamount ", c~awardedquantity
*    FROM i_purchaserequisitionitemapi01 AS a
*    INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchasingdocument = b~requestforquotation
*                                                 AND a~purchasingdocumentitem = b~requestforquotationitem
**    INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
**                                                AND b~supplierquotationitem = c~supplierquotationitem
*    WHERE a~purchaserequisition = '1100000022'
*    AND a~purchaserequisitionitem = '00010'
*    INTO TABLE @DATA(it_rfq).

" out->write( it_rfq ).



* SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem, b~netpriceamount, c~awardedquantity,
*  c~supplierquotation, c~supplierquotationitem
*
* FROM i_purchaserequisitionitemapi01 AS a
* INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchasingdocument = b~requestforquotation
*                                              AND a~purchasingdocumentitem = b~requestforquotationitem
* INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
*                                             AND b~supplierquotationitem = c~supplierquotationitem
* WHERE a~purchaserequisition = '1100000051'
*   AND a~purchaserequisitionitem = '00010'
* INTO TABLE @data(it_rfq).
*
* select from I_PurchaseOrderAPI01 as p inner join @it_rfq as i  on p~SupplierQuotationExternalID = i~SupplierQuotation
* FIELDS DISTINCT p~SupplierQuotationExternalID "WHERE PurchaseOrder = @temp-SupplierQuotation
* into table @data(it_supplier).
*
*  SELECT SINGLE purchasingdocument, purchasingdocumentitem
*      FROM i_purchaserequisitionitemapi01
**      WHERE purchaserequisition = @ls_requisitions-purchaserequisition
**    "  AND purchaserequisitionitem = @ls_requisitions-purchaserequisitionitem
*
*      WHERE purchaserequisition = '1100000051'
*      AND purchaserequisitionitem = '00010'
*      INTO @DATA(lv_purchaseorder).



*  SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem ", b~netpriceamount ", c~awardedquantity,
* " c~supplierquotation, c~supplierquotationitem
*
* FROM i_purchaserequisitionitemapi01 AS a
* "INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchasingdocument = b~requestforquotation
*  "                                            AND a~purchasingdocumentitem = b~requestforquotationitem
* "INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
*  "                                           AND b~supplierquotationitem = c~supplierquotationitem
* WHERE a~purchaserequisition = '1100000051'
*   AND a~purchaserequisitionitem = '00010'
* INTO TABLE @data(it_rfq).

*  SELECT a~purchaserequisition, a~purchaserequisitionitem, b~purchaseorder, b~purchaseorderitem , b~netpriceamount,
*  d~requestforquotation, d~requestforquotationitem,
*  c~awardedquantity,
*  e~supplierquotation, e~supplierquotationitem
*
* FROM i_purchaserequisitionitemapi01 AS a
* inner JOIN I_PurchaseOrderItemAPI01 AS b ON a~purchaserequisition = b~purchaserequisition
*                                             AND a~purchaserequisitionitem = b~purchaserequisitionitem
*  inner join I_RfqItem_Api01 as d on a~purchaserequisition = d~PurchaseRequisition
*                                   and a~PurchaseRequisitionItem = d~PurchaseRequisitionItem
*  inner join I_SupplierQuotationItem_Api01 as e on e~RequestForQuotation = d~RequestForQuotation
*                                                and e~RequestForQuotationitem = d~RequestForQuotationitem
* INNER JOIN i_suplrqtnscheduleline_api01 AS c ON e~supplierquotation = c~supplierquotation
*                                             AND e~supplierquotationitem = c~supplierquotationitem
* WHERE a~purchaserequisition = '1100000051'
*  AND a~purchaserequisitionitem = '00010'
* INTO TABLE @data(it_rfq).


*  SELECT a~purchaserequisition, a~purchaserequisitionitem, a~purchasingdocument, a~purchasingdocumentitem, b~netpriceamount, c~awardedquantity,
*  c~supplierquotation, c~supplierquotationitem
*
* FROM i_purchaserequisitionitemapi01 AS a
* INNER JOIN i_supplierquotationitem_api01 AS b ON a~purchasingdocument = b~requestforquotation
*                                              AND a~purchasingdocumentitem = b~requestforquotationitem
* INNER JOIN i_suplrqtnscheduleline_api01 AS c ON b~supplierquotation = c~supplierquotation
*                                             AND b~supplierquotationitem = c~supplierquotationitem
* WHERE a~purchaserequisition = '1100000051'
*   AND a~purchaserequisitionitem = '00020'
* INTO TABLE @DATA(it_rfq).


  SELECT FROM i_purchaseorderitemapi01 as item inner join i_purchaseorderapi01 as h
  on item~PurchaseOrder = h~PurchaseOrder
  and h~SupplierQuotationExternalID = '8000000049'
    FIELDS item~purchaseorder, item~purchaseorderitem, item~orderquantity
  WHERE
  " "purchaseorder = @purchaseorderitem-purchaseorder
  "and purchaseorderitem = @purchaseorderitem-purchaseorderitem
  purchaserequisition = '1100000051'
  AND purchaserequisitionitem = '00010'
  INTO TABLE @DATA(it_item).

  data(a) = it_item[ PurchaseOrder = '2100000052' PurchaseOrderItem = '00010' ]-PurchaseOrder.
data(b) = it_item[ PurchaseOrder = '2100000052' PurchaseOrderItem = '00010' ]-PurchaseOrderItem.


out->write( it_item ).
out->write( a ).
out->write( b ).
*out->write( it_supplier ).
*out->write( lv_purchaseorder ).




  ENDMETHOD.
ENDCLASS.
