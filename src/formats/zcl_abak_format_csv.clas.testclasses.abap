*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_format_csv.

    METHODS: setup.
    METHODS: convert FOR TESTING RAISING zcx_abak.
    METHODS: get_type FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD convert.
    DATA: t_k TYPE zabak_k_t.
    FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k.

    t_k = f_cut->zif_abak_format~convert(
        i_data = |GLOBAL, BUKRS, , , I, EQ, 1234{ cl_abap_char_utilities=>cr_lf }GLOBAL, WAERS, , 1, I, EQ, EUR{ cl_abap_char_utilities=>cr_lf }GLOBAL, WAERS, , 2, I, EQ, USD| ).

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( t_k ) ).

    READ TABLE t_k ASSIGNING <s_k> INDEX 2.

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( <s_k>-t_kv ) ).
  ENDMETHOD.

  METHOD get_type.
    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>format_type-csv
                                        act = f_cut->zif_abak_format~get_type( ) ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
