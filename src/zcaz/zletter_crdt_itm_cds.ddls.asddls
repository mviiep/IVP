@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds Letter of Credit Item CDS Views'
define view entity ZLETTER_CRDT_ITM_CDS
  as select from zletter_crdt_itm
  association to parent zletter_of_crdt_CDS as _header on  $projection.Lcnum           = _header.Lcnum
                                                       and $projection.Bukrs           = _header.Bukrs
                                                       and $projection.Businesspartner = _header.Businesspartner
                                                       and $projection.Extlcnum        = _header.Extlcnum
{
  key lcnum           as Lcnum,
  key bukrs           as Bukrs,
  key item            as Item,
      extlcnum        as Extlcnum,
      so_po           as So_Po,
      businesspartner as Businesspartner,
      documentdate    as Documentdate,
      creation_date   as CreationDate,
      created_by      as CreatedBy,
      changed_date    as ChangedDate,
      changed_by      as ChangedBy,
      isdeleted       as isdeleted,
      _header

}
