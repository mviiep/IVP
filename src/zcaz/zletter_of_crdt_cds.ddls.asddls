@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Letter of Credit CDS Views'
@Metadata.allowExtensions: true
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity zletter_of_crdt_CDS
  as select from zletter_of_crdt
  composition [0..1] of ZLETTER_CRDT_ITM_CDS as _CRDT_ITM_CDS
{
  key lcnum                as Lcnum,
  key bukrs                as Bukrs,
  key businesspartner      as Businesspartner,
  key extlcnum             as Extlcnum,
      businesspartnername  as businesspartnername,
      extlcnumdes          as ExtlcnumDes,
      lctyp                as Lctyp,
      commodity            as Commodity,
      zdomain              as Zdomain,
      statusdate           as Statusdate,
      lcamount             as Lcamount,
      currency             as Currency,
      toleranceul          as ToleranceUl,
      tolerancell          as ToleranceLl,
      paymentmode          as Paymentmode,
      classification       as classification,
      noofdayes            as NoOfDayes,
      incoterms            as IncoTerms,
      banificiarycode      as BanificiaryCode,
      banificiaryname      as BanificiaryName,
      lodingport           as LodingPort,
      dischargingport      as DischargingPort,
      placeofexpiry        as PlaceOfExpiry,
      transshipment        as Transshipment,
      partialshipment      as PartialShipment,
      requestdate          as RequestDate,
      lastshipmentdate     as LastShipmentDate,
      dateofissue          as DateOfIssue,
      dateofexpiry         as DateOfExpiry,
      openingdate          as OpeningDate,
      isbanktype           as IsBankType,
      isbankcode           as IsBankCode,
      isbankname           as IsBankName,
      isrefno              as IsRefNo,
      isrefdate            as IsRefDate,
      adbanktype           as AdBankType,
      adbankcode           as AdBankCode,
      adbankname           as AdBankName,
      adrefno              as AdRefNo,
      adrefdate            as AdRefDate,
      remarks              as Remarks,
      duedate              as Duedate,
      buyerscreditfacility as BuyersCreditFacility,
      creation_date        as Creation_Date,
      created_by           as Created_By,
      changed_date         as Changed_Date,
      changed_by           as Changed_By,
      isdeleted            as isdeleted,
      _CRDT_ITM_CDS

}
