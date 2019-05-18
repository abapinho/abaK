*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_source_database.

    METHODS: check_table_invalid FOR TESTING.
    METHODS: get_type FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD check_table_invalid.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_tablename = 'INVALID'.

        cl_abap_unit_assert=>fail( msg = 'Table is invalid so exception should have happened' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD get_type.
    CREATE OBJECT f_cut
      EXPORTING
        i_tablename = 'ZABAK_DEFAULT'.

    cl_abap_unit_assert=>assert_equals(
      exp                  = zif_abak_consts=>source_type-database
      act                  = f_cut->zif_abak_source~get_type( ) ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
