*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO zcl_abak_source_rfc.

    METHODS: empty_id FOR TESTING.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

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

ENDCLASS.       "lcl_Unittest
