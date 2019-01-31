*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO zcl_abak_content_rfc.

    METHODS: invalid_id FOR TESTING.
    METHODS: empty_id FOR TESTING.
    METHODS: valid FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD invalid_id.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_id      = 'INVALID'
            i_rfcdest = space.

        f_cut->zif_abak_content~get( ).

        cl_abap_unit_assert=>fail( msg = 'Invalid ID should have raised exception' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD empty_id.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_id      = space
            i_rfcdest = space.

        cl_abap_unit_assert=>fail( msg = 'Empty ID should have raised exception' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD valid.
    DATA: str TYPE string.

    CREATE OBJECT f_cut
      EXPORTING
        i_id      = 'UNITTESTS'
        i_rfcdest = space.

    str = f_cut->zif_abak_content~get( ).

    cl_abap_unit_assert=>assert_differs( exp = space
                                         act = str ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
