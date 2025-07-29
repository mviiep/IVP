CLASS zcl_billingemailtrigger DEFINITION
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
    "! @parameter p_billingdocument | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter r_val | <p class="shorttext synchronized" lang="en"></p>
    METHODS emailtemplate
      IMPORTING p_billingdocument TYPE i_billingdocument-billingdocument
                pdfxstring        TYPE xstring
      RETURNING VALUE(r_val)      TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BILLINGEMAILTRIGGER IMPLEMENTATION.


  METHOD emailtemplate.

**********************************************************************
**Header Data
**********************************************************************

    SELECT SINGLE *
    FROM i_billingdocumentbasic         AS billingdocument
LEFT JOIN zi_j1ig_invrefnum_form        AS invtable            ON invtable~docno = billingdocument~billingdocument
LEFT JOIN i_billingdocumentpartnerbasic AS billtoparty         ON billtoparty~billingdocument    = billingdocument~billingdocument
                                                              AND billtoparty~partnerfunction    = 'RE'
LEFT JOIN i_billingdocumentpartnerbasic AS shiptoparty         ON shiptoparty~billingdocument    = billingdocument~billingdocument
                                                              AND shiptoparty~partnerfunction    = 'WE'
LEFT JOIN i_billingdocumentpartnerbasic AS salesperson         ON salesperson~billingdocument    = billingdocument~billingdocument
                                                              AND salesperson~partnerfunction    = 'ZS'

LEFT JOIN i_billingdocumentpartnerbasic AS regionalhead        ON regionalhead~billingdocument   = billingdocument~billingdocument
                                                              AND regionalhead~partnerfunction   = 'VE'
LEFT JOIN zi_sd_address                 AS soldtopartydetails  ON soldtopartydetails~customer    = billingdocument~soldtoparty
LEFT JOIN zi_sd_address                 AS billtopartydetails  ON billtopartydetails~customer    = billtoparty~customer

LEFT JOIN i_businesspartner             AS salespersonuuid     ON salespersonuuid~businesspartner    = salesperson~referencebusinesspartner
LEFT JOIN i_businesspartner             AS regionalheaduuid    ON regionalheaduuid~businesspartner   = regionalhead~referencebusinesspartner

LEFT JOIN i_workplaceaddress            AS salespersondetails  ON salespersondetails~businesspartneruuid  = salespersonuuid~businesspartneruuid
LEFT JOIN i_workplaceaddress            AS regionalheaddetails ON regionalheaddetails~businesspartneruuid = regionalheaduuid~businesspartneruuid

LEFT JOIN zi_emailtable                 AS emailtable          ON emailtable~salesorganization   = billingdocument~salesorganization
                                                              AND emailtable~distributionchannel = billingdocument~distributionchannel
                                                              AND emailtable~division            = billingdocument~division
    WHERE billingdocument~billingdocument = @p_billingdocument
    INTO @DATA(wa_header).




**********************************************************************
**Email
**********************************************************************

    TRY.
        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
        DATA(ld_mail_content) = ``.

        DATA : billtopartymail  TYPE cl_bcs_mail_message=>ty_address,
               salespersonemail TYPE cl_bcs_mail_message=>ty_address,
               regionalheadmail TYPE cl_bcs_mail_message=>ty_address,
               addsender        TYPE cl_bcs_mail_message=>ty_address,
               addrecipient     TYPE cl_bcs_mail_message=>ty_address,
               addcc            TYPE cl_bcs_mail_message=>ty_address,
               sender           TYPE cl_bcs_mail_message=>ty_address.


**Sender
        addsender = wa_header-emailtable-senderid.
        lo_mail->set_sender( iv_address = addsender ). "IVP


**Receiver
        billtopartymail = wa_header-billtopartydetails-emailaddress.
        addrecipient = wa_header-emailtable-recipientid.

        IF billtopartymail IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = billtopartymail iv_copy = cl_bcs_mail_message=>to ). "bill to party mail
        ENDIF.

        IF addrecipient IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = addrecipient iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
        ENDIF.



**CC Person
        salespersonemail  = wa_header-salespersondetails-defaultemailaddress.
        regionalheadmail  = wa_header-regionalheaddetails-defaultemailaddress.
        addcc             =  wa_header-emailtable-cc.

        IF salespersonemail IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = salespersonemail iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.

        IF regionalheadmail IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = regionalheadmail iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.

        IF addcc IS NOT INITIAL.
          lo_mail->add_recipient( iv_address = addcc iv_copy = cl_bcs_mail_message=>cc ).
        ENDIF.


**Attachment
        lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
                                   iv_content      = pdfxstring
                                   iv_content_type = 'text/plain'
                                   iv_filename     = 'BillingDocument.pdf'
                                 ) ).


**Subject of Email
        lo_mail->set_subject( | GST invoice for { wa_header-soldtopartydetails-customername } : { wa_header-billingdocument-documentreferenceid } | ).


**Body of Email
        DATA:lv_content TYPE string.

        lv_content = | <p>Dear Customer,</p><p>Greetings from IVP Limited.</p><p>Attached is the GST invoice for your perusal.</p>| &&
    |<p>Request you to make the payment to the VAN Account number given to you or below mentioned designated bank account on or before the due date and kindly share the details of payments/account statements to <a href="mailto:ivpar@ivpindia.com">iv| &&
|par@ivpindia.com</a>.</p>| &&
    |<p><strong>If you are paying through Kotak Mahindra Bank Limited:</strong></p>| &&
    |<p> Bank Name: Kotak Mahindra Bank Limited<br>IFSC Code: KKBK0000958<br>Account No: 2612214806</p>| &&
    |<p><strong>If you are paying through HDFC Bank Limited:</strong></p>| &&
    |<p>Bank Name: HDFC Bank Limited<br>IFSC Code: HDFC0000001<br>Account No: 00010120000316</p>| &&
    |<p>If you are paying through any other bank, you can choose any of the above accounts.</p>| &&
    |<p>In addition, you can also pay by using the prescribed methods under Section 269SU of the Income Tax Act 1961, by using the following URL:</p>| &&
    |<p>Customers are requested to pay the invoices on or before the due date to ensure uninterrupted supply of the materials.</p>| &&
    |<div style="background-color: rgb(242, 240, 240);font-size: 15px; font-family: calibri;" > <p>Steps to Validate the Digital Signature Certificate</p>| &&
    | <p>Follow these steps to validate the Digital Signature Certificate affixed in the invoice (one-time activity):</p>| &&
    | <ul><li>Click or right-click on the Digital Signature and select Signature Properties  > Show Signer’s Certificate .</li><li>A dialogue box will open with tabs:  Summary , Details| &&
    |,  Revocation , Trust ,Policies ,Legal Notice .</li> | &&
    |<li>Click on the Trust tab and then click  Add to Trusted Certificates .</li><li>A dialogue box will open. Check the option  Use this certificate as trusted root . Click  OK  and clos| &&
    |e the box.</li>| &&
    |  <li>Click  Validate Signature . The digital signature will appear with a <strong style="color:green;">green check mark</strong> .</li>| &&
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
