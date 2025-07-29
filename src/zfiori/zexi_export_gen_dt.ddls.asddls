@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim for Export General Details DD'
@Metadata.allowExtensions: true
define root view entity ZEXI_EXPORT_GEN_DT
  as select from zexi_expt_gen_dt

{
  key sap_uuid          as SAP_UUID,
      id                as ID,
      consname          as ConsName,
      consstreet        as ConsStreet,
      consstreet1       as ConsStreet1,
      consstreet2       as ConsStreet2,
      conscity          as ConsCity,
      conspostal        as ConsPostal,
      consregion        as ConsRegion,
      conscountry       as ConsCountry,
      bopname           as BopName,
      bopstreet         as BopStreet,
      bopstreet1        as BopStreet1,
      bopstreet2        as BopStreet2,
      bopcity           as BopCity,
      boppostal         as BopPostal,
      bopregion         as BopRegion,
      bopcountry        as BopCountry,
      status            as Status,
      cobname           as CobName,
      cobstreet         as CobStreet,
      cobstreet1        as CobStreet1,
      cobstreet2        as CobStreet2,
      cobcity           as CobCity,
      cobpostalcode     as CobPostalCode,
      cobregion         as CobRegion,
      cobcounrty        as CobCounrty,
      obname            as OBName,
      obadd1            as OBAdd1,
      obadd2            as OBAdd2,
      obcity            as OBCity,
      obswift           as OBSwift,
      obbankaccount     as OBBankAccount,

      cnname            as CNName,
      cnstreet          as CNStreet,
      cnstreet1         as CNStreet1,
      cnstreet2         as CNStreet2,
      cnpostalcode      as CNPostalCode,
      cnregion          as CNRegion,
      cncountry         as CNCountry,
      cncity            as CNCity,

      oaname            as OAName,
      oastreet          as OAStreet,
      oastreet1         as OAStreet1,
      oastreet2         as OAStreet2,
      oacity            as OACity,
      oapostalcode      as OAPostal,
      oaregion          as OARegion,
      oacountry         as OACountry,

      ianame            as IAName,
      iastreet          as IAStreet,
      iastreet1         as IAStreet1,
      iastreet2         as IAStreet2,
      iacity            as IACity,
      iapostalcode      as IAPostalCode,
      iaregion          as IARegion,
      iacountry         as IACountry,



      created_by        as CreatedBy,
      created_at        as CreatedAt,
      last_changed_by   as LastChangedBy,
      last_changed_at   as LastChangedAt,
      dbk_rodtep_sc     as DBK_RODTEP_SC,

      dbk_acount_doc    as DBKAcountDoc,
      rodtep_acount_doc as RODTEPAcountDoc,
      ship_acount_doc   as ShipAcountDoc,
      invoicetype       as InvoiceType,

      dbkamt            as dbkamt,
      rodtepamt         as rodtepamt,
      postdbk           as PostDBK,
      postrodtep        as PostRODTEP,
      postdbkreceived   as PostDBKReceived



}
