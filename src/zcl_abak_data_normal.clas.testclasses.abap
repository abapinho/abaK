*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_data_normal.

    METHODS: setup RAISING zcx_abak.
    METHODS: read_valid FOR TESTING RAISING zcx_abak.
    METHODS: get_name FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).

    CREATE OBJECT f_cut
      EXPORTING
        io_format = zcl_abak_format_factory=>get_instance( zif_abak_consts=>format_type-database )
        io_content = zcl_abak_content_factory=>get_instance( i_content_type = zif_abak_consts=>content_type-inline
                                                             i_content      = gc_tablename-valid ).
  ENDMETHOD.

  METHOD read_valid.

    cl_abap_unit_assert=>assert_differs(
      exp = 0
      act = lines( f_cut->zif_abak_data~read( i_scope     = gc_scope-utest
                                              i_fieldname = 'BUKRS'
                                              i_context   = space ) )
      msg = 'Resulting table should not be empty' ).

  ENDMETHOD.

  METHOD get_name.

    cl_abap_unit_assert=>assert_equals(
      exp = gc_tablename-valid
      act = f_cut->zif_abak_data~get_name( )
      msg = 'Name different from what was expected' ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
