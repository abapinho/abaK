*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_source_inline.

    METHODS: setup RAISING zcx_abak.
    METHODS: read FOR TESTING RAISING zcx_abak.
    METHODS: get_type FOR TESTING RAISING zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut
      EXPORTING
        i_content = 'Something'.
  ENDMETHOD.

  METHOD read.
    cl_abap_unit_assert=>assert_equals( exp = 'Something'
                                        act = f_cut->zif_abak_source~get( ) ).
  ENDMETHOD.

  METHOD get_type.
    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>source_type-inline
                                        act = f_cut->zif_abak_source~get_type( ) ).
  ENDMETHOD.

ENDCLASS.
