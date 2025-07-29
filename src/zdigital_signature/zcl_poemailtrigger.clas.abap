CLASS zcl_poemailtrigger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************

**Tenant Data
    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'JNY'.
    DATA :lv_qas(3) TYPE c VALUE 'CM4'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.

    DATA:
      username TYPE string,
      pass     TYPE string.

**PDF Strings
    DATA:lv_string1 TYPE string,
         lv_string2 TYPE string,
         lv_string3 TYPE string,
         lv_mat     TYPE string,
         lv_rest    TYPE string.


**********************************************************************

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter p_purchaseorder | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_val | <p class="shorttext synchronized" lang="en"></p>
    METHODS emailtemplate
      IMPORTING p_purchaseorder TYPE i_purchaseorderapi01-purchaseorder
                pdfxstring      TYPE xstring
      RETURNING VALUE(r_val)    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_POEMAILTRIGGER IMPLEMENTATION.


  METHOD emailtemplate.

**********************************************************************
**Header Data
**********************************************************************

    SELECT SINGLE *
    FROM i_purchaseorderapi01         AS purchaseorder
    WHERE purchaseorder~purchaseorder = @p_purchaseorder
    INTO @DATA(wa_header).

    DATA(podate) =  |{ wa_header-purchaseorderdate+6(2) } . { wa_header-purchaseorderdate+4(2) } . { wa_header-purchaseorderdate(4) }|.
    CONDENSE podate NO-GAPS.

    SELECT SINGLE *
    FROM zdb_poemailadd
    INTO @DATA(waemail).

**********************************************************************
**Email
**********************************************************************

    TRY.
        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
        DATA(ld_mail_content) = ``.

        DATA : recipient1 TYPE cl_bcs_mail_message=>ty_address,
               recipient2 TYPE cl_bcs_mail_message=>ty_address,
               recipient3 TYPE cl_bcs_mail_message=>ty_address,
               cc1        TYPE cl_bcs_mail_message=>ty_address,
               cc2        TYPE cl_bcs_mail_message=>ty_address,
               addsender  TYPE cl_bcs_mail_message=>ty_address,
               cc3        TYPE cl_bcs_mail_message=>ty_address,
               sender     TYPE cl_bcs_mail_message=>ty_address.


**Sender
        addsender = waemail-senderid.
        lo_mail->set_sender( iv_address = addsender ). "IVP


**Receiver
        recipient1 = waemail-recipientid1.
        recipient2 = waemail-recipientid2.

        lo_mail->add_recipient( iv_address = recipient1 iv_copy = cl_bcs_mail_message=>to ). "bill to party mail

        IF recipient2 IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = recipient2 iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
        ENDIF.

        IF recipient3 IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = 'bdhenge@ivpindia.com' iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
        ENDIF.

**CC Person
        cc1  = waemail-cc1.
        cc2  = waemail-cc2.
        cc3  = waemail-cc3.

        IF cc1 IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.

        IF cc2 IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = 'jashaikh@ivpindia.com' iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.

        IF cc3 IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = 'rjoshi@ivpindia.com' iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.


**Attachment
        lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
                                   iv_content      = pdfxstring
                                   iv_content_type = 'text/plain'
                                   iv_filename     = 'PurchaseOrder.pdf'
                                 ) ).


**Subject of Email
        lo_mail->set_subject( | PO Number - { wa_header-purchaseorder } Date - { podate } From IVP Limited | ).


**Body of Email
        DATA:lv_content TYPE string.

        lv_content = |<div> <p>Dear Team,</p><p>Kindly forward the attached PDF along with the below content to our business partner.</p><br><p>Please find attached herewith duly Digitally Signed Purchase Order for your perusal.</p><p>In case of any dis|
&&
        |crepancies, please revert immediately on <a href="mailto:ivpap@ivpindia.com">ivpap@ivpindia.com</a></p><p>We value your association with us.</p> </div>| &&
        |<div style="background-color: rgb(242, 240, 240);font-size: 15px; font-family: calibri;" > <p>Steps to Validate the Digital Signature Certificate</p>| &&
        | <p>Follow these steps to validate the Digital Signature Certificate affixed in the invoice (one-time activity):</p>| &&
        | <ul><li>Click or right-click on the Digital Signature and select Signature Properties  > Show Signer’s Certificate .</li><li>A dialogue box will open with tabs:  Summary , Details| &&
        |,  Revocation , Trust ,Policies ,Legal Notice .</li> | &&
        |<li>Click on the Trust tab and then click  Add to Trusted Certificates .</li><li>A dialogue box will open. Check the option  Use this certificate as trusted root . Click  OK  and clos| &&
        |e the box.</li>| &&
        |  <li>Click  Validate Signature . The digital signature will appear with a <strong style="color:green;">green check mark </strong> .</li>| &&
        | </ul> </div>| &&
        |<p>Best Regards,<br>IVP Limited</p>|.


        lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                iv_content      = lv_content
                iv_content_type = 'text/html'
                 ) ).

**Send Mail
        lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
      CATCH cx_bcs_mail INTO DATA(lx_mail).
        "handle exception

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
