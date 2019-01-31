*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_format_db.

    METHODS: setup RAISING zcx_abak.
    METHODS: check_table_invalid FOR TESTING.
    METHODS: convert FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).
  ENDMETHOD.

  METHOD check_table_invalid.
    TRY.
        CREATE OBJECT f_cut.

        f_cut->zif_abak_format~convert( gc_tablename-invalid ).

        cl_abap_unit_assert=>fail( msg = 'Table is invalid so exception should have happened' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD convert.
    data: t_k type zabak_k_t.

    CREATE OBJECT f_cut.

    f_cut->zif_abak_format~convert(
      EXPORTING
        i_data = gc_tablename-valid
      IMPORTING
        et_k   = t_k ).

    cl_abap_unit_assert=>assert_differs(
      exp = 0
      act = lines( t_k )
      msg = 'Resulting table should not have zero lines' ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
