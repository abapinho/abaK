class ZCL_ABAK_FORMAT_RFC definition
  public
  inheriting from ZCL_ABAK_FORMAT
  final
  create public .

public section.

  methods ZIF_ABAK_FORMAT~CONVERT
    redefinition .
  methods ZIF_ABAK_FORMAT~GET_TYPE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_RFC IMPLEMENTATION.


METHOD zif_abak_format~convert.

  DATA: s_data TYPE zabak_data,
        o_exp  TYPE REF TO cx_root.

  CLEAR: et_k, e_name.

  TRY.
      CALL TRANSFORMATION zabak_content_rfc
      SOURCE XML i_data
      RESULT root = s_data.

      et_k = s_data-t_k.
      e_name = s_data-name.

    CATCH cx_transformation_error INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.


  METHOD ZIF_ABAK_FORMAT~GET_TYPE.
    r_format_type = zif_abak_consts=>format_type-rfc.
  ENDMETHOD.
ENDCLASS.
