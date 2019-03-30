class ZCL_ABAK_DATA_FACTORY definition
  public
  final
  create public .

public section.

  methods GET_STANDARD_INSTANCE
    importing
      !I_FORMAT_TYPE type ZABAK_FORMAT_TYPE
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE
      !I_CONTENT type STRING
      !I_USE_SHM type ZABAK_USE_SHM optional
      !I_BYPASS_CACHE type FLAG optional
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK_DATA
    raising
      ZCX_ABAK .
  methods GET_CUSTOM_INSTANCE
    importing
      !IO_FORMAT type ref to ZIF_ABAK_FORMAT
      !IO_CONTENT type ref to ZIF_ABAK_CONTENT
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK_DATA
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAK_DATA_FACTORY IMPLEMENTATION.


  METHOD get_custom_instance.
    CREATE OBJECT ro_instance TYPE zcl_abak_data_normal
      EXPORTING
        io_format  = io_format
        io_content = io_content.
  ENDMETHOD.


  METHOD get_standard_instance.
    DATA: o_content_factory TYPE REF TO zcl_abak_content_factory,
          o_format_factory  type ref to zcl_abak_format_factory.

    IF i_format_type IS INITIAL OR i_content_type IS INITIAL OR i_content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    IF i_bypass_cache IS INITIAL.
      ro_instance = lcl_cache=>get( i_use_shm      = i_use_shm
                                    i_format_type  = i_format_type
                                    i_content_type = i_content_type
                                    i_content      = i_content ).
      IF ro_instance IS BOUND.
        RETURN.
      ENDIF.
    ENDIF.


    IF i_use_shm = abap_true.
      CREATE OBJECT ro_instance TYPE zcl_abak_data_shm
        EXPORTING
          i_format_type  = i_format_type
          i_content_type = i_content_type
          i_content      = i_content.
    ELSE.
      CREATE OBJECT o_content_factory.
      create object o_format_factory.
      CREATE OBJECT ro_instance TYPE zcl_abak_data_normal
        EXPORTING
          io_format = o_format_factory->get_instance( i_format_type )
          io_content = o_content_factory->get_instance( i_content_type = i_content_type
                                                        i_content      = i_content ).
    ENDIF.

    IF i_bypass_cache IS INITIAL.
      lcl_cache=>add( i_use_shm      = i_use_shm
                      i_format_type  = i_format_type
                      i_content_type = i_content_type
                      i_content      = i_content
                      io_instance    = ro_instance ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
