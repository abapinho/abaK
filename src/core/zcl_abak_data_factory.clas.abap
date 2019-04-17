CLASS zcl_abak_data_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_standard_instance
      IMPORTING
        !i_format_type TYPE zabak_format_type
        !i_source_type TYPE zabak_source_type
        !i_content TYPE string
        !i_use_shm TYPE zabak_use_shm OPTIONAL
        !i_bypass_cache TYPE flag OPTIONAL
      RETURNING
        value(ro_instance) TYPE REF TO zif_abak_data
      RAISING
        zcx_abak .
    METHODS get_custom_instance
      IMPORTING
        !io_format TYPE REF TO zif_abak_format
        !io_source TYPE REF TO zif_abak_source
      RETURNING
        value(ro_instance) TYPE REF TO zif_abak_data
      RAISING
        zcx_abak .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAK_DATA_FACTORY IMPLEMENTATION.


  METHOD get_custom_instance.
    CREATE OBJECT ro_instance TYPE zcl_abak_data_normal
      EXPORTING
        io_format  = io_format
        io_source = io_source.
  ENDMETHOD.


  METHOD get_standard_instance.
    DATA: o_source_factory TYPE REF TO zcl_abak_source_factory,
          o_format_factory  TYPE REF TO zcl_abak_format_factory.

    IF i_format_type IS INITIAL OR i_source_type IS INITIAL OR i_content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    IF i_bypass_cache IS INITIAL.
      ro_instance = lcl_cache=>get( i_use_shm      = i_use_shm
                                    i_format_type  = i_format_type
                                    i_source_type = i_source_type
                                    i_content      = i_content ).
      IF ro_instance IS BOUND.
        RETURN.
      ENDIF.
    ENDIF.


    IF i_use_shm = abap_true.
      CREATE OBJECT ro_instance TYPE zcl_abak_data_shm
        EXPORTING
          i_format_type = i_format_type
          i_source_type = i_source_type
          i_content     = i_content.
    ELSE.
      CREATE OBJECT o_source_factory.
      CREATE OBJECT o_format_factory.
      CREATE OBJECT ro_instance TYPE zcl_abak_data_normal
        EXPORTING
          io_format = o_format_factory->get_instance( i_format_type )
          io_source = o_source_factory->get_instance( i_source_type = i_source_type
                                                        i_content      = i_content ).
    ENDIF.

    IF i_bypass_cache IS INITIAL.
      lcl_cache=>add( i_use_shm      = i_use_shm
                      i_format_type  = i_format_type
                      i_source_type = i_source_type
                      i_content      = i_content
                      io_instance    = ro_instance ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
