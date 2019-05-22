"* use this source file for your ABAP unit test classes

CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut TYPE REF TO lcl_data_for_utests,
      t_k  TYPE zabak_k_t,
      s_k  LIKE LINE OF t_k,
      s_kv LIKE LINE OF s_k-t_kv.

    METHODS: valid FOR TESTING RAISING zcx_abak.
    METHODS: empty_fieldname FOR TESTING.
    METHODS: invalid_sign FOR TESTING.
    METHODS: invalid_option FOR TESTING.
    METHODS: unary_operator_with_high FOR TESTING.
    METHODS: binary_operator_without_low FOR TESTING.
    METHODS: binary_operator_without_high FOR TESTING.
    METHODS: multi_fields_valid FOR TESTING RAISING zcx_abak.
    METHODS: multi_fields_option_not_eq FOR TESTING.
    METHODS: multi_fields_sign_not_i FOR TESTING.
    METHODS: multi_fields_with_high FOR TESTING.
    METHODS: multi_fields_value_count FOR TESTING.
    METHODS: single_field_many_values_ok FOR TESTING RAISING zcx_abak.

ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD valid.
    s_k-fieldname = 'FIELD1'.
    s_kv-low = 'A'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    f_cut->zif_abak_data~get_data( ).

  ENDMETHOD.

  METHOD empty_fieldname.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'Empty fieldname should have been detected' ).
      CATCH zcx_abak.
    ENDTRY.

  ENDMETHOD.

  METHOD invalid_sign.
    s_kv-sign = '?'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    s_k-fieldname = 'DUMMY'.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'Invalid sign should have been detected' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD invalid_option.
    s_kv-option = '?'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    s_k-fieldname = 'DUMMY'.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'Invalid option should have been detected' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD unary_operator_with_high.
    s_kv-option = 'EQ'.
    s_kv-high = 'something'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    s_k-fieldname = 'DUMMY'.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For unary operators HIGH must be empty' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD binary_operator_without_low.
    s_kv-option = 'BT'.
    s_kv-high = 10.
    INSERT s_kv INTO TABLE s_k-t_kv.
    s_k-fieldname = 'DUMMY'.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For binary operators LOW must be filled' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD binary_operator_without_high.
    s_kv-option = 'BT'.
    s_kv-low = 10.
    INSERT s_kv INTO TABLE s_k-t_kv.
    s_k-fieldname = 'DUMMY'.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For binary operators HIGH must be filled' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD multi_fields_valid.
    s_k-fieldname = 'FIELD1 FIELD2'.
    s_kv-option = 'EQ'.
    s_kv-low = 'A B'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    f_cut->zif_abak_data~get_data( ).
  ENDMETHOD.

  METHOD multi_fields_option_not_eq.
    s_k-fieldname = 'FIELD1 FIELD2'.
    s_kv-option = 'BT'.
    s_kv-low = 'A B'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For multiple fields OPTION must be EQ' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD multi_fields_sign_not_i.
    s_k-fieldname = 'FIELD1 FIELD2'.
    s_kv-sign = 'E'.
    s_kv-low = 'A B'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For multiple fields SIGN must be I' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD multi_fields_with_high.
    s_k-fieldname = 'FIELD1 FIELD2'.
    s_kv-low = 'A B'.
    s_kv-high = 'C D'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For multiple fields HIGH must be empty' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD multi_fields_value_count.
    s_k-fieldname = 'FIELD1 FIELD2'.
    s_kv-low = 'A B C'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    TRY.
        f_cut->zif_abak_data~get_data( ).
        cl_abap_unit_assert=>fail( 'For multiple fields exactly value one value per field required' ).
      CATCH zcx_abak.
    ENDTRY.
  ENDMETHOD.

  METHOD single_field_many_values_ok.
    s_k-fieldname = 'FIELD1'.
    s_kv-low = 'A B C'.
    INSERT s_kv INTO TABLE s_k-t_kv.
    INSERT s_k INTO TABLE t_k.
    CREATE OBJECT f_cut
      EXPORTING
        it_k = t_k.

    f_cut->zif_abak_data~get_data( ).
  ENDMETHOD.

ENDCLASS.
