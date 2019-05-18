*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_data_shm.  "class under test

    METHODS: setup RAISING zcx_abak.
    METHODS: read_valid FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    DATA: o_tools TYPE REF TO zcl_abak_tools.

    CREATE OBJECT o_tools.

    CREATE OBJECT f_cut
      EXPORTING
        i_format_type = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content     = o_tools->get_demo_xml( ).
  ENDMETHOD.

  METHOD read_valid.

    cl_abap_unit_assert=>assert_differs(
      exp = 0
      act = lines( f_cut->zif_abak_data~read( i_scope     = space
                                              i_fieldname = 'BUKRS'
                                              i_context   = space ) )
      msg = 'Resulting table should not be empty' ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
