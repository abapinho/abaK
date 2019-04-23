*"* use this source file for your ABAP unit test classes
CLASS lcl_unittest DEFINITION FOR TESTING
  INHERITING FROM zcl_abak_unit_tests
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.

    DATA:
      f_cut     TYPE REF TO ZCL_ABAK_SOURCE_FACTORY,
      o_content TYPE REF TO zif_abak_source.

    METHODS: setup.
    METHODS: check_class
      IMPORTING
        i_classname TYPE string.
    METHODS: inline FOR TESTING RAISING zcx_abak.
    METHODS: database FOR TESTING RAISING zcx_abak.
    METHODS: file FOR TESTING RAISING zcx_abak.
    METHODS: rfc FOR TESTING RAISING zcx_abak.
    METHODS: standard_text FOR TESTING RAISING zcx_abak.
    METHODS: url FOR TESTING RAISING zcx_abak.
    METHODS: invalid FOR TESTING.
ENDCLASS.       "lcl_Unittest


CLASS lcl_unittest IMPLEMENTATION.

  METHOD setup.
    CREATE OBJECT f_cut.
  ENDMETHOD.

  METHOD check_class.
    cl_abap_unit_assert=>assert_equals( exp = i_classname
                                        act = cl_abap_objectdescr=>describe_by_object_ref( o_content )->get_relative_name( ) ).
  endmethod.

  method inline.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-inline
                                     i_content      = 'dummy' ).
    check_class( 'ZCL_ABAK_SOURCE_INLINE' ).
  ENDMETHOD.

  METHOD database.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-database
                                     i_content      = gc_tablename-valid ).
    check_class( 'ZCL_ABAK_SOURCE_DATABASE' ).
  ENDMETHOD.

  METHOD file.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-file
                                     i_content      = 'dummy' ).
    check_class( 'ZCL_ABAK_SOURCE_FILE' ).
  ENDMETHOD.

  METHOD rfc.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-rfc
                                     i_content      = 'RFCDEST=dummy ID=dummy' ).
    check_class( 'ZCL_ABAK_SOURCE_RFC' ).
  ENDMETHOD.

  METHOD standard_text.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-standard_text
                                     i_content      = 'NAME=dummy' ).

    check_class( 'ZCL_ABAK_SOURCE_SO10' ).
  ENDMETHOD.

  METHOD url.
    o_content = f_cut->get_instance( i_source_type = zif_abak_consts=>source_type-url
                                     i_content      = 'http://abapinho.com/dummy.txt' ).
    check_class( 'ZCL_ABAK_SOURCE_URL' ).
 ENDMETHOD.

  METHOD invalid.
    TRY.
        o_content = f_cut->get_instance( i_source_type = 'INVALID'
                                         i_content      = 'dummy' ).

        cl_abap_unit_assert=>fail( msg = 'Invalid content type' ).

      CATCH zcx_abak.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
