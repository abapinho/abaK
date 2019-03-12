class ZCL_ABAK_FORMAT_INTERNAL definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABAK_FORMAT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_INTERNAL IMPLEMENTATION.


METHOD zif_abak_format~convert.
* I_DATA is expected to contain a serialized internal table of type ZABAK_K_T

  CALL TRANSFORMATION zabak_copy
  SOURCE XML i_data
  RESULT root = rt_k.

ENDMETHOD.


METHOD zif_abak_format~get_type.
  r_format_type = zif_abak_consts=>format_type-internal.
ENDMETHOD.
ENDCLASS.
