class ZCL_ABAK_FORMAT_XML definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABAK_FORMAT .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_XML IMPLEMENTATION.


METHOD zif_abak_format~convert.
  DATA: o_exp     TYPE REF TO cx_st_error,
        t_xml_k   TYPE zabak_xml_k_t,
        o_k_table TYPE REF TO zcl_abak_k_table.

  TRY.
      CALL TRANSFORMATION zabak_format_xml
       SOURCE XML i_data
       RESULT constants = t_xml_k.

      CREATE OBJECT o_k_table.
      o_k_table->add_xml_k_t( t_xml_k ).
      rt_k = o_k_table->get_k_t( ).

    CATCH cx_st_error INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.


METHOD ZIF_ABAK_FORMAT~GET_TYPE.
  r_format_type = zif_abak_consts=>format_type-xml.
ENDMETHOD.
ENDCLASS.
