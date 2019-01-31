*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_format_csv.

    METHODS: convert FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD convert.
    data: t_k type zabak_k_t.
    FIELD-SYMBOLS: <s_k> like line of t_k.

    CREATE OBJECT f_cut.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = |GLOBAL, BUKRS, , , I, EQ, 1234{ cl_abap_char_utilities=>cr_lf }GLOBAL, WAERS, , 1, I, EQ, EUR{ cl_abap_char_utilities=>cr_lf }GLOBAL, WAERS, , 2, I, EQ, USD|
      IMPORTING
        et_k   = t_k ).

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( t_k ) ).

    read table t_k ASSIGNING <s_k> index 2.

    cl_abap_unit_assert=>assert_equals( exp = 2
                                        act = lines( <s_k>-t_kv ) ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
