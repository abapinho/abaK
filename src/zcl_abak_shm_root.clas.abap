class ZCL_ABAK_SHM_ROOT definition
  public
  final
  create public
  shared memory enabled .

public section.

  methods CONSTRUCTOR
    importing
      !I_FORMAT_TYPE type ZABAK_FORMAT_TYPE
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE
      !I_CONTENT type STRING
    raising
      ZCX_ABAK .
  methods GET_DATA
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
PRIVATE SECTION.

  DATA g_format_type TYPE zabak_format_type .
  DATA g_content_type TYPE zabak_content_type .
  DATA g_content TYPE string .
  DATA gt_k TYPE zabak_k_t .
  DATA g_loaded TYPE flag .

  METHODS load_data
    RAISING
      zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK_SHM_ROOT IMPLEMENTATION.


  METHOD constructor.

    g_format_type = i_format_type.
    g_content_type = i_content_type.
    g_content = i_content.

    load_data( ).

  ENDMETHOD.


  METHOD get_data.

    LOG-POINT ID zabak SUBKEY 'shm_root.get_data' FIELDS g_format_type g_content_type g_content.

    load_data( ).

    rt_k = gt_k.

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD load_data.
    DATA o_data TYPE REF TO zif_abak_data.
    IF g_loaded IS INITIAL.
      o_data = zcl_abak_data_factory=>get_standard_instance( i_format_type  = g_format_type
                                                             i_content_type = g_content_type
                                                             i_content      = g_content ).

      gt_k = o_data->get_data( ).
      g_loaded = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
