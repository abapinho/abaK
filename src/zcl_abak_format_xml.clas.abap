class ZCL_ABAK_FORMAT_XML definition
  public
  inheriting from ZCL_ABAK_FORMAT_XSLT
  final
  create public .

public section.

  methods CONSTRUCTOR
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_FORMAT~GET_TYPE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_XML IMPLEMENTATION.


METHOD constructor.
  super->constructor( 'ZABAK_FORMAT_XML' ).
ENDMETHOD.


METHOD ZIF_ABAK_FORMAT~GET_TYPE.
  r_format_type = zif_abak_consts=>format_type-xml.
ENDMETHOD.
ENDCLASS.
