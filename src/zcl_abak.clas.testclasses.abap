*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION DEFERRED.
CLASS zcl_abak DEFINITION LOCAL FRIENDS lcl_unittest.

CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO zcl_abak,
      f_iut TYPE REF TO zif_abak.

    METHODS: setup RAISING zcx_abak.

    METHODS: get_value_ok FOR TESTING RAISING zcx_abak.
    METHODS: get_value_numeric_context FOR TESTING RAISING zcx_abak.
    METHODS: get_value_nok FOR TESTING.
    METHODS: get_value_if_exists FOR TESTING.
    METHODS: get_value_default_scope FOR TESTING RAISING zcx_abak.

    METHODS: check_value_ok FOR TESTING RAISING zcx_abak.
    METHODS: check_value_range_ok FOR TESTING RAISING zcx_abak.
    METHODS: check_value_range_nok FOR TESTING RAISING zcx_abak.
    METHODS: check_value_nok FOR TESTING.
    METHODS: check_value_if_exists FOR TESTING.

    METHODS: get_range_ok FOR TESTING RAISING zcx_abak.
    METHODS: get_range_nok FOR TESTING.
    METHODS: get_range_if_exists FOR TESTING.

ENDCLASS.       "lcl_Unit_Test


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    generate_test_data( ).

    CREATE OBJECT f_cut
      EXPORTING
        io_data = zcl_abak_data_factory=>get_standard_instance( i_format_type  = zif_abak_consts=>format_type-internal
                                                                i_content_type = zif_abak_consts=>content_type-database
                                                                i_content      = gc_tablename-valid ).

    f_iut = f_cut.

  ENDMETHOD.       "setup

  METHOD get_value_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = '0231'
      act = f_iut->get_value( i_scope     = gc_scope-utest
                              i_fieldname = 'BUKRS' )
                              msg         = 'Value should be 0231' ).

  ENDMETHOD.       "get_Value

  METHOD get_value_numeric_context.

    cl_abap_unit_assert=>assert_equals(
      exp = '1234567890'
      act = f_iut->get_value( i_scope     = gc_scope-utest
                              i_context   = gc_context-c1
                              i_fieldname = 'KUNNR' )
                              msg         = 'Value should be 1234567890' ).

  ENDMETHOD.       "get_Value

  METHOD get_value_nok.

    TRY.
        f_iut->get_value( i_scope     = gc_scope-utest
                          i_context   = gc_context-does_not_exist
                          i_fieldname = 'BUKRS' ).

        cl_abap_unit_assert=>fail( msg = 'Value does not exist and is not ignorable' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.       "get_Value

  METHOD get_value_if_exists.

    cl_abap_unit_assert=>assert_equals(
      exp = '0231'
      act = f_iut->get_value_if_exists( i_scope     = gc_scope-utest
                                        i_fieldname = 'BUKRS' )
      msg                  = 'Value exists and should be 0231' ).

    cl_abap_unit_assert=>assert_equals(
      exp = space
      act = f_iut->get_value_if_exists( i_scope     = gc_scope-utest
                                        i_context   = gc_context-does_not_exist
                                        i_fieldname = 'BUKRS' )
      msg                  = 'Not found value should return empty' ).

  ENDMETHOD.       "get_Value

  METHOD get_value_default_scope.

    cl_abap_unit_assert=>assert_equals(
      exp = '0231'
      act = f_iut->get_value( i_fieldname = 'BUKRS' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = f_iut->check_value( i_scope     = gc_scope-utest
                                i_fieldname = 'BUKRS'
                                i_value     = '0231' )
      msg                  = 'Value is 0231 so result should be true' ).

  ENDMETHOD.       "get_Value

  METHOD check_value_range_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = f_iut->check_value( i_scope     = gc_scope-utest
                                i_fieldname = 'WAERS'
                                i_value     = 'EUR' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_range_nok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = f_iut->check_value( i_scope     = gc_scope-utest
                                i_fieldname = 'WAERS'
                                i_value     = 'CAD' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_nok.

    TRY.
        f_iut->check_value( i_scope     = gc_scope-utest
                            i_context   = gc_context-does_not_exist
                            i_fieldname = 'BUKRS'
                                                 i_value     = '0231' ).

        cl_abap_unit_assert=>fail( msg = 'Value does not exist and is not ignorable' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.       "get_Value

  METHOD check_value_if_exists.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = f_iut->check_value_if_exists( i_scope     = gc_scope-utest
                                          i_fieldname = 'BUKRS'
                                          i_value     = '0231' )
      msg                  = 'Value exists and should be 0231' ).

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = f_iut->check_value_if_exists( i_scope     = gc_scope-utest
                                          i_context   = gc_context-does_not_exist
                                          i_fieldname = 'BUKRS'
                                          i_value     = '0231' )
      msg                  = 'No value defined so it should be false' ).

  ENDMETHOD.       "get_Value

  METHOD get_range_ok.

    DATA: r_koart TYPE RANGE OF koart.

    r_koart = f_iut->get_range( i_scope     = gc_scope-utest
                                i_fieldname = 'KOART' ).

    IF NOT ( 'D' IN r_koart AND 'K' IN r_koart ).
      cl_abap_unit_assert=>fail( msg = 'Range should have D and K' ).
    ENDIF.

  ENDMETHOD.       "get_Value

  METHOD get_range_nok.

    TRY.
        f_iut->get_range( i_scope     = gc_scope-utest
                          i_context   = gc_context-does_not_exist
                          i_fieldname = 'KOART' ).

        cl_abap_unit_assert=>fail( msg = 'Range does not exist and is not ignorable' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

  METHOD get_range_if_exists.

    IF 'D' NOT IN f_iut->get_range_if_exists( i_scope     = gc_scope-utest
                                              i_context   = gc_context-does_not_exist
                                              i_fieldname = 'KOART' ).
      cl_abap_unit_assert=>fail( msg = 'Defined range should include D' ).
    ENDIF.

    IF 'D' NOT IN f_iut->get_range_if_exists( i_scope     = gc_scope-utest
                                              i_fieldname = 'KOART' ).
      cl_abap_unit_assert=>fail( msg = 'Undefined range should be empty and ok because it is ignorable' ).
    ENDIF.

  ENDMETHOD.       "get_Value

ENDCLASS.       "lcl_Unit_Test
