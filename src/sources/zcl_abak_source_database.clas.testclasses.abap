*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO ZCL_ABAK_SOURCE_DATABASE.

    METHODS: setup RAISING zcx_abak.
    METHODS: check_table_invalid FOR TESTING.
    METHODS: convert FOR TESTING RAISING zcx_abak.
    METHODS: get_type FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).
  ENDMETHOD.

  METHOD check_table_invalid.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_tablename = gc_tablename-invalid.

        cl_abap_unit_assert=>fail( msg = 'Table is invalid so exception should have happened' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD convert.
    DATA: t_k TYPE zabak_k_t,
          xml TYPE string.

    FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k.

    CREATE OBJECT f_cut
      EXPORTING
        i_tablename = gc_tablename-valid.

    xml = f_cut->zif_abak_source~get( ).

    CALL TRANSFORMATION zabak_copy
    SOURCE XML xml
    RESULT root = t_k.

    cl_abap_unit_assert=>assert_differs(
      exp = 0
      act = lines( t_k ) ).

    READ TABLE t_k ASSIGNING <s_k> INDEX 1.

    cl_abap_unit_assert=>assert_differs(
      exp = 0
      act = lines( <s_k>-t_kv ) ).

  ENDMETHOD.

  METHOD get_type.
    CREATE OBJECT f_cut
      EXPORTING
        i_tablename = gc_tablename-valid.

    cl_abap_unit_assert=>assert_equals(
      exp                  = zif_abak_consts=>source_type-database
      act                  = f_cut->zif_abak_source~get_type( ) ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
