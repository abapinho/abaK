*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA:
      f_cut   TYPE REF TO zcl_abak_params_definition,
      t_param TYPE zabak_namevalue_t.

    METHODS add
      IMPORTING
        i_name  TYPE string
        i_value TYPE string.
    METHODS no_params FOR TESTING RAISING zcx_abak.
    METHODS single_param FOR TESTING RAISING zcx_abak.
    METHODS two_params FOR TESTING RAISING zcx_abak.
    METHODS obligatory_missing FOR TESTING.
    METHODS non_obligatory_missing FOR TESTING RAISING zcx_abak.
    METHODS invalid_param FOR TESTING.
    METHODS length_exceeded FOR TESTING.
    METHODS length_not_exceeded FOR TESTING RAISING zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD add.
    DATA: s_param LIKE LINE OF t_param.
    s_param-name = i_name.
    s_param-value = i_value.
    INSERT s_param INTO TABLE t_param.
  ENDMETHOD.

  METHOD no_params.
    CREATE OBJECT f_cut
      EXPORTING
        i_definition = space.
  ENDMETHOD.

  METHOD single_param.

    CREATE OBJECT f_cut
      EXPORTING
        i_definition = 'PARAM1'.

    add( i_name  = 'PARAM1' i_value = '123' ).

    f_cut->check_parameters( t_param ).

  ENDMETHOD.

  METHOD two_params.
    CREATE OBJECT f_cut
      EXPORTING
        i_definition = 'PARAM1 PARAM2'.

    add( i_name  = 'PARAM1' i_value = '123' ).
    add( i_name  = 'PARAM2' i_value = '456' ).

    f_cut->check_parameters( t_param ).

  ENDMETHOD.

  METHOD invalid_param.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_definition = 'VALID'.

        add( i_name  = 'INVALID' i_value = '123' ).

        f_cut->check_parameters( t_param ).

        cl_abap_unit_assert=>fail( 'Should have failed with INVALID parameter ').
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

  METHOD obligatory_missing.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_definition = '+OBLIGATORY VALID'.

        add( i_name  = 'VALID' i_value = '123' ).

        f_cut->check_parameters( t_param ).

        cl_abap_unit_assert=>fail( 'Obligatory parameter should have been detected').
      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

  METHOD non_obligatory_missing.
    CREATE OBJECT f_cut
      EXPORTING
        i_definition = 'NON_OBLIGATORY VALID'.

    add( i_name  = 'VALID' i_value = '123' ).

    f_cut->check_parameters( t_param ).

  ENDMETHOD.

  METHOD length_exceeded.
    TRY.
        CREATE OBJECT f_cut
          EXPORTING
            i_definition = 'PARAM1 PARAM2 PARAM3(5)'.

        add( i_name  = 'PARAM3' i_value = '123456' ).

        f_cut->check_parameters( t_param ).

        cl_abap_unit_assert=>fail( 'Max length of 5 should have been detected').

      CATCH zcx_abak.
        RETURN.
    ENDTRY.

  ENDMETHOD.

  METHOD length_not_exceeded.
    CREATE OBJECT f_cut
      EXPORTING
        i_definition = 'PARAM1 PARAM2 PARAM3(5)'.

    add( i_name  = 'PARAM3' i_value = '12345' ).

    f_cut->check_parameters( t_param ).

  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
