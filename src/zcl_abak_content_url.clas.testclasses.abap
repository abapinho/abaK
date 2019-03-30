*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_content_url.

    METHODS: invalid_url FOR TESTING.
    METHODS: get_type FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD get_type.
    CREATE OBJECT f_cut
      EXPORTING
        i_url = 'https://somewhere.com/constants.txt'.
    cl_abap_unit_assert=>assert_equals( exp = zif_abak_consts=>content_type-url
                                        act = f_cut->zif_abak_content~get_type( ) ).
  ENDMETHOD.

  METHOD invalid_url.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_url = 'xxx://somewhere.com/constants.txt'.
        cl_abap_unit_assert=>fail( msg = 'Invalid url not detected' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_url = 'http://'.
        cl_abap_unit_assert=>fail( msg = 'Invalid url not detected' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_url = 'http://.com/test.txt'.
        cl_abap_unit_assert=>fail( msg = 'Invalid url not detected' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_url = 'http://domain.thisistoolong/test.txt'.
        cl_abap_unit_assert=>fail( msg = 'Invalid url not detected' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_url = 'http://domain.com/folder\file.txt'.
        cl_abap_unit_assert=>fail( msg = 'Invalid url not detected' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
