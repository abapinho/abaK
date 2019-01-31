*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak_format_rfc.

      METHODS: setup.
      METHODS: invalid FOR TESTING.
      METHODS: valid FOR TESTING RAISING zcx_abak.
  ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).
  ENDMETHOD.

  METHOD invalid.
    TRY.
        CREATE OBJECT f_cut.

        f_cut->zif_abak_format~convert( space ).

        cl_abap_unit_assert=>fail( msg = 'Invalid XML should have failed' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD valid.
    DATA: o_content TYPE REF TO zcl_abak_content_rfc,
          t_k       TYPE zabak_k_t,
          name      TYPE string.

    CREATE OBJECT f_cut.

    CREATE OBJECT o_content
      EXPORTING
        i_id      = 'UNITTESTS'
        i_rfcdest = space.

    f_cut->zif_abak_format~convert( EXPORTING i_data = o_content->zif_abak_content~get( )
                                    IMPORTING et_k   = t_k
                                              e_name = name ).

    cl_abap_unit_assert=>assert_equals( exp = 'ZABAK_UNITTESTS'
                                        act = name ).

    cl_abap_unit_assert=>assert_differs( exp = 0
                                        act = lines( t_k ) ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
