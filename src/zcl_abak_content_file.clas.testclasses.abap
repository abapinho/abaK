*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO ZCL_ABAK_CONTENT_file.

    METHODS: setup RAISING zcx_abak.
    methods: get_type for testing raising zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut
      EXPORTING
        i_filepath = '/tmp/constants.txt'.
  ENDMETHOD.


  METHOD get_type.
    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>content_type-file
                                        act = f_cut->zif_abak_content~get_type( ) ).
  ENDMETHOD.

ENDCLASS.
