class ZCL_ABAK_FORMAT_CUSTOM definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_ABAK_FORMAT
      abstract methods CONVERT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_CUSTOM IMPLEMENTATION.


METHOD zif_abak_format~get_type.
  r_format_type = zif_abak_consts=>format_type-custom.
ENDMETHOD.
ENDCLASS.
