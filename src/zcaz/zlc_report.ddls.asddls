@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'lc  report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zlc_report
  as select from zletter_of_crdt_CDS as A


{

  key A.Lcnum                                                       as Lcnum,
      A.Statusdate                                                  as zstatusdate,
      A.Extlcnum                                                    as Extlcnum,
      A.Lctyp                                                       as lctyp,
      A.Commodity                                                   as commodity,
      A.Zdomain                                                     as zdomain,
      A.Lcamount                                                    as amount,
      concat(concat(A.Businesspartner,'-') , A.businesspartnername) as partner,
      A.Currency                                                    as currency,
      A.ToleranceUl                                                 as ToleranceUl,
      A.ToleranceLl                                                 as Tolerancel1,
      A.Paymentmode                                                 as paymentmode,
      A.NoOfDayes                                                   as nodays,
      A.IncoTerms                                                   as incoterms,
      A.BanificiaryCode                                             as benecode,
      A.BanificiaryName                                             as benename,
      A.classification                                              as classification,
      A.LodingPort                                                  as loadingport,
      A.DischargingPort                                             as dischargingport,
      A.PlaceOfExpiry                                               as placeofexpiry,
      A.Transshipment                                               as transshipment,
      A.PartialShipment                                             as partialshipment,
      A.RequestDate                                                 as requestdate,
      A.LastShipmentDate                                            as lastshipmentdate,
      A.DateOfIssue                                                 as dateofissue,
      A.DateOfExpiry                                                as dateofexpiry,
      A.OpeningDate                                                 as openingdate,
      A.IsBankCode                                                  as bamkcode,
      A.IsBankName                                                  as bankname,
      A.AdBankCode                                                  as adbankcode,
      A.AdBankName                                                  as adbankname,
      A.Duedate                                                     as Duwdate,
      A.BuyersCreditFacility                                        as buyerscredit


}
where
  A.isdeleted <> 'X'
