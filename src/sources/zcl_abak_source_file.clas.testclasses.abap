*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO ZCL_ABAK_SOURCE_FILE.

    methods: get_type for testing raising zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD get_type.
    CREATE OBJECT f_cut
      EXPORTING
        i_filepath = '/tmp/some_constants.txt'.

    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>source_type-file
                                        act = f_cut->zif_abak_source~get_type( ) ).
  ENDMETHOD.

ENDCLASS.
