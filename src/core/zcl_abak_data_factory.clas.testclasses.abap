*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut    TYPE REF TO zcl_abak_data_factory,
      o_data TYPE REF TO zif_abak_data.

    METHODS: setup.
    METHODS: check_class
      IMPORTING
        i_classname TYPE string.
    METHODS: standard_normal FOR TESTING RAISING zcx_abak.
    METHODS: standard_sho FOR TESTING RAISING zcx_abak.
    METHODS: custom FOR TESTING RAISING zcx_abak.
    METHODS: cache FOR TESTING RAISING zcx_abak.
    METHODS: bypass_cache FOR TESTING RAISING zcx_abak.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD check_class.
    cl_abap_unit_assert=>assert_equals( exp = i_classname
                                        act = cl_abap_objectdescr=>describe_by_object_ref( o_data )->get_relative_name( ) ).
  ENDMETHOD.

  METHOD standard_normal.
    o_data = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy' ).
    check_class( 'ZCL_ABAK_DATA_NORMAL' ).
  ENDMETHOD.

  METHOD standard_sho.
    o_data = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy'
        i_use_shm      = abap_true ).
    check_class( 'ZCL_ABAK_DATA_SHM' ).
  ENDMETHOD.

  METHOD custom.
    DATA: o_format_factory TYPE REF TO zcl_abak_format_factory,
          o_source_factory TYPE REF TO zcl_abak_source_factory.

    CREATE OBJECT o_format_factory.
    CREATE OBJECT o_source_factory.
    o_data = f_cut->get_custom_instance(
        io_format = o_format_factory->get_instance( zif_abak_consts=>format_type-xml )
        io_source = o_source_factory->get_instance( i_source_type = zif_abak_consts=>source_type-inline
                                                    i_content      = 'dummy' ) ).
    check_class( 'ZCL_ABAK_DATA_NORMAL' ).
  ENDMETHOD.

  METHOD cache.
    DATA: o_data2 TYPE REF TO zif_abak_data.

    o_data = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy' ).

    o_data2 = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy'
        i_bypass_cache = abap_false ).

    cl_abap_unit_assert=>assert_equals( exp = o_data
                                        act = o_data2 ).
  ENDMETHOD.

  METHOD bypass_cache.
    DATA: o_data2 TYPE REF TO zif_abak_data.

    o_data = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy' ).

    o_data2 = f_cut->get_standard_instance(
        i_format_type  = zif_abak_consts=>format_type-xml
        i_source_type = zif_abak_consts=>source_type-inline
        i_content      = 'dummy'
        i_bypass_cache = abap_true ).

    IF o_data = o_data2.
      cl_abap_unit_assert=>fail( msg = 'Instances should be different' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
