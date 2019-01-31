class ZCL_ABAK_FACTORY definition
  public
  final
  create private .

public section.
  interface ZIF_ABAK_CONSTS load .

  class-methods GET_STANDARD_INSTANCE
    importing
      !I_FORMAT_TYPE type ZABAK_FORMAT_TYPE
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE default ZIF_ABAK_CONSTS=>CONTENT_TYPE-INLINE
      !I_CONTENT type STRING
      !I_BYPASS_CACHE type FLAG optional
      !I_USE_SHM type ZABAK_USE_SHM
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  class-methods GET_CUSTOM_INSTANCE
    importing
      !IO_FORMAT type ref to ZIF_ABAK_FORMAT
      value(IO_CONTENT) type ref to ZIF_ABAK_CONTENT optional
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  class-methods GET_ZABAK_INSTANCE
    importing
      !I_ID type ZABAK_ID default 'DEFAULT'
      !I_RFCDEST type RFCDEST optional
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
private section.

  class-methods GET_ZABAK_INSTANCE_LOCAL
    importing
      !I_ID type ZABAK_ID
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  class-methods GET_ZABAK_INSTANCE_RFC
    importing
      !I_ID type ZABAK_ID default 'DEFAULT'
      !I_RFCDEST type RFCDEST optional
    returning
      value(RO_INSTANCE) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_FACTORY IMPLEMENTATION.


  METHOD get_custom_instance.
    LOG-POINT ID zabak SUBKEY 'factory.get_custom_instance'.

    IF io_format IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    if io_content is not bound.
*     If no content is provided we assume the format class doesn't need it so we'll create an empty one
      io_content = zcl_abak_content_factory=>get_instance( i_content_type = zif_abak_consts=>content_type-inline
                                                           i_content      = space ).
    endif.

    CREATE OBJECT ro_instance TYPE zcl_abak
      EXPORTING
        io_data = zcl_abak_data_factory=>get_custom_instance( io_format = io_format
                                                              io_content = io_content ).

  ENDMETHOD.


  METHOD GET_STANDARD_INSTANCE.
    LOG-POINT ID zabak SUBKEY 'factory.get_instance' FIELDS i_format_type i_content_type i_content.

    IF i_format_type IS INITIAL OR i_content_type IS INITIAL OR i_content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    CREATE OBJECT ro_instance TYPE zcl_abak
      EXPORTING
        io_data = zcl_abak_data_factory=>get_standard_instance( i_format_type  = i_format_type
                                                                i_content_type = i_content_type
                                                                i_content      = i_content
                                                                i_use_shm      = i_use_shm
                                                                i_bypass_cache = i_bypass_cache ).
  ENDMETHOD.


  METHOD get_zabak_instance.

    IF i_rfcdest IS INITIAL.
      ro_instance = get_zabak_instance_local( i_id ).
    ELSE.
      ro_instance = get_zabak_instance_rfc( i_id      = i_id
                                            i_rfcdest = i_rfcdest ).
    ENDIF.

  ENDMETHOD.


METHOD get_zabak_instance_local.

  DATA: s_zabak TYPE zabak,
        content TYPE string.

  SELECT SINGLE * FROM zabak INTO s_zabak WHERE id = i_id.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak. " TODO
  ENDIF.

  content = s_zabak-content.

  ro_instance = get_standard_instance( i_format_type  = s_zabak-format_type
                                       i_content_type = s_zabak-content_type
                                       i_content      = content
                                       i_use_shm      = s_zabak-use_shm ).

ENDMETHOD.


METHOD get_zabak_instance_rfc.
*  CREATE OBJECT ro_instance TYPE zcl_abak
*    EXPORTING
*      io_data = zcl_abak_data_factory=>get_instance( i_id           = i_id
*                                                     i_rfcdest      = i_rfcdest
*                                                     i_bypass_cache = i_bypass_cache ).
ENDMETHOD.
ENDCLASS.
