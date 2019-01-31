class ZCL_ABAK_CONTENT_CUSTOM definition
  public
  inheriting from ZCL_ABAK_CONTENT
  abstract
  create public .

public section.

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_CUSTOM IMPLEMENTATION.


METHOD zif_abak_content~get_type.
  r_type = zif_abak_consts=>content_type-custom.
ENDMETHOD.
ENDCLASS.
