*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION DEFERRED.
CLASS zcl_abak DEFINITION LOCAL FRIENDS lcl_unittest.

CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
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

    METHODS: null_data FOR TESTING.

ENDCLASS.       "lcl_Unit_Test


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    DATA: o_tools TYPE REF TO zcl_abak_tools,
          o_data_factory TYPE REF TO zcl_abak_data_factory.

    CREATE OBJECT o_tools.
    CREATE OBJECT o_data_factory.

    CREATE OBJECT f_iut type zcl_abak
      EXPORTING
        io_data = o_data_factory->get_standard_instance(
          i_format_type  = zif_abak_consts=>format_type-xml
          i_source_type  = zif_abak_consts=>source_type-inline
          i_content      = o_tools->get_demo_xml( ) ).

  ENDMETHOD.       "setup

  METHOD get_value_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = '4321'
      act = f_iut->get_value( i_scope     = 'GLOBAL'
                              i_fieldname = 'BUKRS' ) ).

  ENDMETHOD.       "get_Value

  METHOD get_value_numeric_context.

    cl_abap_unit_assert=>assert_equals(
      exp = '1111111111'
      act = f_iut->get_value( i_scope     = 'SD'
                              i_context   = 'SCENARIO1'
                              i_fieldname = 'KUNNR' ) ).

  ENDMETHOD.       "get_Value

  METHOD get_value_nok.

    TRY.
        f_iut->get_value( i_scope     = 'DOES_NOT_EXIST'
                          i_fieldname = 'BUKRS' ).

        cl_abap_unit_assert=>fail( msg = 'Value does not exist and is not ignorable' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.       "get_Value

  METHOD get_value_if_exists.

    cl_abap_unit_assert=>assert_equals(
      exp = '4321'
      act = f_iut->get_value_if_exists( i_scope     = 'GLOBAL'
                                        i_fieldname = 'BUKRS' ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = space
      act = f_iut->get_value_if_exists( i_scope     = 'GLOBAL'
                                        i_context   = 'DOES_NOT_EXIST'
                                        i_fieldname = 'BUKRS' ) ).

  ENDMETHOD.       "get_Value

  METHOD get_value_default_scope.

    cl_abap_unit_assert=>assert_equals(
      exp = '5555'
      act = f_iut->get_value( i_fieldname = 'BUKRS' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = f_iut->check_value( i_scope     = 'GLOBAL'
                                i_fieldname = 'BUKRS'
                                i_value     = '4321' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_range_ok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_true
      act = f_iut->check_value( i_scope     = 'ZABAK_DEMO'
                                i_context   = 'PT'
                                i_fieldname = 'WAERS'
                                i_value     = 'EUR' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_range_nok.

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = f_iut->check_value( i_scope     = 'ZABAK_DEMO'
                                i_context   = 'PT'
                                i_fieldname = 'WAERS'
                                i_value     = 'CAD' ) ).

  ENDMETHOD.       "get_Value

  METHOD check_value_nok.

    TRY.
        f_iut->check_value( i_scope     = 'DOES_NOT_EXIST'
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
      act = f_iut->check_value_if_exists( i_scope     = 'GLOBAL'
                                          i_fieldname = 'BUKRS'
                                          i_value     = '4321' ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = abap_false
      act = f_iut->check_value_if_exists( i_scope     = 'DOES_NOT_EXIST'
                                          i_fieldname = 'BUKRS'
                                          i_value     = '4321' ) ).

  ENDMETHOD.       "get_Value

  METHOD get_range_ok.

    DATA: r_koart TYPE RANGE OF koart.

    r_koart = f_iut->get_range( i_scope     = 'PROJ1'
                                i_fieldname = 'KOART' ).

    IF NOT ( 'D' IN r_koart AND 'K' IN r_koart ).
      cl_abap_unit_assert=>fail( msg = 'Range should have D and K' ).
    ENDIF.

  ENDMETHOD.       "get_Value

  METHOD get_range_nok.

    TRY.
        f_iut->get_range( i_scope     = 'DOES_NOT_EXIST'
                          i_fieldname = 'KOART' ).

        cl_abap_unit_assert=>fail( msg = 'Range does not exist and is not ignorable' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

  METHOD get_range_if_exists.

    IF 'D' NOT IN f_iut->get_range_if_exists( i_scope     = 'PROJ1'
                                              i_fieldname = 'KOART' ).
      cl_abap_unit_assert=>fail( msg = 'Defined range should include D' ).
    ENDIF.

    IF 'D' NOT IN f_iut->get_range_if_exists( i_scope     = 'DOES_NOT_EXIST'
                                              i_fieldname = 'KOART' ).
      cl_abap_unit_assert=>fail( msg = 'Undefined range should be empty and ok because it is ignorable' ).
    ENDIF.

  ENDMETHOD.       "get_Value

  METHOD null_data.
    DATA: o_cut type ref to zcl_abak,
          o_data TYPE REF TO zif_abak_data.
    TRY.
        CREATE OBJECT o_cut
          EXPORTING
            io_data = o_data.
        cl_abap_unit_assert=>fail( msg = 'Null O_DATA should have been detected').
      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.       "lcl_Unit_Test
