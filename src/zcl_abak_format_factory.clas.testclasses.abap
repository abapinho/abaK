*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut    TYPE REF TO zcl_abak_format_factory,
      o_format TYPE REF TO zif_abak_format.

    METHODS: setup.
    METHODS: check_class
      IMPORTING
        i_classname TYPE string.
    METHODS: csv FOR TESTING RAISING zcx_abak.
    METHODS: internal FOR TESTING RAISING zcx_abak.
    METHODS: json FOR TESTING RAISING zcx_abak.
    METHODS: xml FOR TESTING RAISING zcx_abak.
    METHODS: invalid FOR TESTING.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD check_class.
    cl_abap_unit_assert=>assert_equals( exp = i_classname
                                        act = cl_abap_objectdescr=>describe_by_object_ref( o_format )->get_relative_name( ) ).
  endmethod.

  method csv.
    o_format = f_cut->get_instance( zif_abak_consts=>format_type-csv ).
    check_class( 'ZCL_ABAK_FORMAT_CSV' ).
  endmethod.

  method internal.
    o_format = f_cut->get_instance( zif_abak_consts=>format_type-internal ).
    check_class( 'ZCL_ABAK_FORMAT_INTERNAL' ).
  endmethod.

  method json.
    o_format = f_cut->get_instance( zif_abak_consts=>format_type-json ).
    check_class( 'ZCL_ABAK_FORMAT_JSON' ).
  endmethod.

  method xml.
    o_format = f_cut->get_instance( zif_abak_consts=>format_type-xml ).
    check_class( 'ZCL_ABAK_FORMAT_XML' ).
  endmethod.

  METHOD invalid.
    TRY.
        o_format = f_cut->get_instance( i_format_type = 'INVALID' ).
        cl_abap_unit_assert=>fail( msg = 'Invalid content type' ).
      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
