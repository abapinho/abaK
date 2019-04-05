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
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    DATA: o_source_factory TYPE REF TO zcl_abak_source_factory,
          o_format_factory  TYPE REF TO zcl_abak_format_factory.

    generate_test_data( ).

    CREATE OBJECT o_source_factory.
    CREATE OBJECT o_format_factory.
    CREATE OBJECT f_cut
      EXPORTING
        io_format = o_format_factory->get_instance( zif_abak_consts=>format_type-internal )
        io_source = o_source_factory->get_instance( i_source_type  = zif_abak_consts=>source_type-database
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

ENDCLASS.       "lcl_Unittest
