*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_format_json,
      t_k TYPE zabak_k_t.

    METHODS: setup.
    METHODS: get_inline_value FOR TESTING RAISING zcx_abak.
    METHODS: get_value FOR TESTING RAISING zcx_abak.
    METHODS: get_name FOR TESTING RAISING zcx_abak.
    METHODS: get_range_line FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD get_inline_value.
    FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k,
                   <s_kv> LIKE LINE OF <s_k>-t_kv.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = `{ "abak": {"name": "test1", "k": [{ "scope": "a", "fieldname": "bukrs", "value": "4321" }]}}`
      IMPORTING
        et_k   = t_k ).

    READ TABLE t_k ASSIGNING <s_k> INDEX 1.               "#EC CI_SUBRC
    READ TABLE <s_k>-t_kv ASSIGNING <s_kv> INDEX 1.       "#EC CI_SUBRC

    cl_abap_unit_assert=>assert_equals( exp = '4321'
                                        act = <s_kv>-low ).

  ENDMETHOD.

  METHOD get_value.

    FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k,
                   <s_kv> LIKE LINE OF <s_k>-t_kv.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = `{ "abak": {"name": "test1", "k": [{ "scope": "a", "fieldname": "bukrs", "v": [{"low": "1234"}] }]}}`
      IMPORTING
        et_k   = t_k ).

    READ TABLE t_k ASSIGNING <s_k> INDEX 1.               "#EC CI_SUBRC
    READ TABLE <s_k>-t_kv ASSIGNING <s_kv> INDEX 1.       "#EC CI_SUBRC

    cl_abap_unit_assert=>assert_equals( exp = '1234'
                                        act = <s_kv>-low ).

  ENDMETHOD.

  METHOD get_name.
    DATA: name TYPE string.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = `{ "abak": {"name": "test1", "k": [{ "scope": "a", "fieldname": "bukrs", "value": "4321" }]}}`
      IMPORTING
        e_name = name ).

    cl_abap_unit_assert=>assert_equals( exp = 'test1'
                                        act = name ).

  ENDMETHOD.

  METHOD get_range_line.

    FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k,
                   <s_kv> LIKE LINE OF <s_k>-t_kv.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = `{ "abak": {"name": "test1", "k": [{ "scope": "a", "fieldname": "bukrs", "v": [{"sign": "I", "option": "BT", "low": "1234", "high": "9999"}] }]}}`
      IMPORTING
        et_k   = t_k ).

    READ TABLE t_k ASSIGNING <s_k> INDEX 1.               "#EC CI_SUBRC
    READ TABLE <s_k>-t_kv ASSIGNING <s_kv> INDEX 1.       "#EC CI_SUBRC

    cl_abap_unit_assert=>assert_equals( exp = '1234'
                                        act = <s_kv>-low ).
    cl_abap_unit_assert=>assert_equals( exp = '9999'
                                        act = <s_kv>-high ).
    cl_abap_unit_assert=>assert_equals( exp = 'I'
                                        act = <s_kv>-sign ).
    cl_abap_unit_assert=>assert_equals( exp = 'BT'
                                        act = <s_kv>-option ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
