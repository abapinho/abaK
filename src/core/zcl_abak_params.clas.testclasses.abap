*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA:
      f_cut   TYPE REF TO zif_abak_params.

    METHODS malformed FOR TESTING.
    METHODS no_params FOR TESTING RAISING zcx_abak.
    METHODS single_param FOR TESTING RAISING zcx_abak.
    METHODS two_params FOR TESTING RAISING zcx_abak.
    METHODS obligatory_missing FOR TESTING.
    METHODS duplicate FOR TESTING.
    METHODS non_obligatory_missing FOR TESTING RAISING zcx_abak.
    METHODS invalid_param FOR TESTING.
    METHODS length_exceeded FOR TESTING.
    METHODS length_not_exceeded FOR TESTING RAISING zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD malformed.
    TRY.
        zcl_abak_params=>create_instance( i_params    = 'This is not valid'
                                          i_paramsdef = space ).

        cl_abap_unit_assert=>fail( 'Invalid syntax should have been detected' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD no_params.
    f_cut = zcl_abak_params=>create_instance( i_params    = space
                                              i_paramsdef = space ).
  ENDMETHOD.

  METHOD single_param.
    f_cut = zcl_abak_params=>create_instance( i_params    = 'PARAM1=123'
                                              i_paramsdef = 'PARAM1' ).

    cl_abap_unit_assert=>assert_equals( exp = '123'
                                        act = f_cut->get( 'PARAM1' ) ).
  ENDMETHOD.

  METHOD two_params.
    f_cut = zcl_abak_params=>create_instance( i_params    = 'PARAM1=123 PARAM2=456'
                                              i_paramsdef = 'PARAM1 PARAM2' ).

    cl_abap_unit_assert=>assert_equals( exp = '123'
                                        act = f_cut->get( 'PARAM1' ) ).
    cl_abap_unit_assert=>assert_equals( exp = '456'
                                        act = f_cut->get( 'PARAM2' ) ).
  ENDMETHOD.

  METHOD invalid_param.
    TRY.
        f_cut = zcl_abak_params=>create_instance( i_params    = 'INVALID=123'
                                                  i_paramsdef = 'VALID' ).

        cl_abap_unit_assert=>fail( 'Should have failed with INVALID parameter ').
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD obligatory_missing.
    TRY.
        f_cut = zcl_abak_params=>create_instance( i_params    ='VALID=123'
                                                  i_paramsdef = '+OBLIGATORY VALID' ).

        cl_abap_unit_assert=>fail( 'Obligatory parameter should have been detected').
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD duplicate.
    TRY.
        f_cut = zcl_abak_params=>create_instance( i_params    ='PARAM1=A PARAM1=B'
                                                  i_paramsdef = 'PARAM1' ).

        cl_abap_unit_assert=>fail( 'Duplicate parameter should have been detected').
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD non_obligatory_missing.
    f_cut = zcl_abak_params=>create_instance( i_params    = 'VALID=123'
                                              i_paramsdef = 'NON_OBLIGATORY VALID' ).
  ENDMETHOD.

  METHOD length_exceeded.
    TRY.
         f_cut = zcl_abak_params=>create_instance( i_params    = 'PARAM3=123456'
                                                   i_paramsdef = 'PARAM1 PARAM2 PARAM3(5)' ).

        cl_abap_unit_assert=>fail( 'Max length of 5 should have been detected').

      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD length_not_exceeded.
    f_cut = zcl_abak_params=>create_instance( i_params    = 'PARAM3=12345'
                                              i_paramsdef = 'PARAM1 PARAM2 PARAM3(5)' ).

    cl_abap_unit_assert=>assert_equals( exp = '12345'
                                        act = f_cut->get( 'PARAM3' ) ).
  ENDMETHOD.

ENDCLASS.       "lcl_Unittest
