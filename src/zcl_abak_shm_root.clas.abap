CLASS zcl_abak_shm_root DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  SHARED MEMORY ENABLED .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_format_type TYPE zabak_format_type
        !i_source_type TYPE zabak_source_type
        !i_content TYPE string
      RAISING
        zcx_abak .
    METHODS get_data
      RETURNING
        value(rt_k) TYPE zabak_k_t
      RAISING
        zcx_abak .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA g_format_type TYPE zabak_format_type .
    DATA g_source_type TYPE zabak_source_type .
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
    g_source_type = i_source_type.
    g_content = i_content.

    load_data( ).

  ENDMETHOD.


  METHOD get_data.

    LOG-POINT ID zabak SUBKEY 'shm_root.get_data' FIELDS g_format_type g_source_type g_content.

    load_data( ).

    rt_k = gt_k.

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD load_data.
    DATA: o_data         TYPE REF TO zif_abak_data,
          o_data_factory TYPE REF TO zcl_abak_data_factory.

    IF g_loaded IS INITIAL.
      CREATE OBJECT o_data_factory.
      o_data = o_data_factory->get_standard_instance( i_format_type  = g_format_type
                                                      i_source_type = g_source_type
                                                      i_content      = g_content ).

      gt_k = o_data->get_data( ).
      g_loaded = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
