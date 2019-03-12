class ZCL_ABAK_DATA_SHM definition
  public
  inheriting from ZCL_ABAK_DATA
  final
  create public

  global friends ZCL_ABAK_FACTORY .

public section.

  methods CONSTRUCTOR
    importing
      !I_FORMAT_TYPE type ZABAK_FORMAT_TYPE optional
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE optional
      !I_CONTENT type STRING optional
    raising
      ZCX_ABAK .
  PROTECTED SECTION.

    METHODS invalidate_aux
      REDEFINITION .
    METHODS load_data_aux
      REDEFINITION .
private section.

  constants GC_MAX_INSTANCE_NAME type I value 80. "#EC NOTEXT
  data G_FORMAT_TYPE type ZABAK_FORMAT_TYPE .
  data G_CONTENT_TYPE type ZABAK_CONTENT_TYPE .
  data G_CONTENT type STRING .

  methods READ_SHM
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK
      CX_SHM_NO_ACTIVE_VERSION
      CX_SHM_INCONSISTENT .
  methods WRITE_SHM
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_NAME
    returning
      value(R_INSTANCE_NAME) type SHM_INST_NAME .
  methods HASH
    importing
      !I_DATA type STRING
    returning
      value(R_HASHED) type STRING .
ENDCLASS.



CLASS ZCL_ABAK_DATA_SHM IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    IF i_format_type IS INITIAL OR i_content_type IS INITIAL OR i_content IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    g_format_type = i_format_type.
    g_content_type = i_content_type.
    g_content = i_content.

  ENDMETHOD.


  METHOD get_instance_name.
    DATA: instance_name TYPE string.

    instance_name = |{ g_format_type }.{ g_content_type }.{ g_content }|.

    IF strlen( instance_name ) <= gc_max_instance_name.
      r_instance_name = instance_name.
    ELSE.
*   If the instance name size is too big just hash it
      r_instance_name = hash( instance_name ).
    ENDIF.

  ENDMETHOD.


  METHOD hash.

    DATA: hashed TYPE hash160.

    CALL FUNCTION 'CALCULATE_HASH_FOR_CHAR'
      EXPORTING
        data           = i_data
      IMPORTING
        hash           = hashed
      EXCEPTIONS
        unknown_alg    = 1
        param_error    = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
*   This will probably never happen so we'll just call it HASH_ERROR
      hashed = 'HASH_ERROR'.
    ENDIF.

    r_hashed = hashed.

  ENDMETHOD.


  METHOD invalidate_aux.
    DATA: o_broker TYPE REF TO zcl_abak_shm_area.

    LOG-POINT ID zabak SUBKEY 'data_shm.invalidate' FIELDS get_instance_name( ). " TODO

    TRY.
        o_broker = zcl_abak_shm_area=>attach_for_read( get_instance_name( ) ).

        o_broker->invalidate_area( ).

        o_broker->detach( ).

      CATCH cx_shm_attach_error
            cx_shm_parameter_error
            cx_sy_ref_is_initial
            cx_dynamic_check.
        "If the area does not exist, no need to invalidate it
        RETURN.

    ENDTRY.
  ENDMETHOD.


  METHOD load_data_aux.

    DATA: o_exp TYPE REF TO cx_shm_parameter_error.

    TRY.
        rt_k = read_shm( ).

      CATCH cx_shm_no_active_version.
        rt_k = write_shm( ).

      CATCH cx_shm_inconsistent.
        TRY.
            zcl_abak_shm_area=>free_instance( get_instance_name( ) ).
            rt_k = write_shm( ).

          CATCH cx_shm_parameter_error INTO o_exp.
            LOG-POINT ID zabak SUBKEY 'data_shm.load_data_aux' FIELDS get_instance_name( ) o_exp->get_text( ).
        ENDTRY.

    ENDTRY.

  ENDMETHOD.


  METHOD read_shm.

    DATA: o_broker      TYPE REF TO zcl_abak_shm_area,
          o_exp         TYPE REF TO cx_root.

    LOG-POINT ID zabak SUBKEY 'data_shm.read_shm' FIELDS get_instance_name( ).

    TRY.
        o_broker = zcl_abak_shm_area=>attach_for_read( get_instance_name( ) ).
        rt_k = o_broker->root->get_data( ).
        o_broker->detach( ).

      CATCH cx_shm_exclusive_lock_active
            cx_shm_change_lock_active
            cx_shm_read_lock_active INTO o_exp.

        RAISE EXCEPTION TYPE zcx_abak
          EXPORTING
            previous = o_exp.

    ENDTRY.

  ENDMETHOD.


  METHOD write_shm.

    DATA: o_broker      TYPE REF TO zcl_abak_shm_area,
          o_root        TYPE REF TO zcl_abak_shm_root,
          o_exp         TYPE REF TO cx_root,
          o_abak_exp  TYPE REF TO zcx_abak.

    LOG-POINT ID zabak SUBKEY 'data_shm.write_shm' FIELDS get_instance_name( ).

    TRY.
        o_broker = zcl_abak_shm_area=>attach_for_write( get_instance_name( ) ).

        TRY.
            CREATE OBJECT o_root AREA HANDLE o_broker
              EXPORTING
                i_format_type  = g_format_type
                i_content_type = g_content_type
                i_content      = g_content.

            o_broker->set_root( o_root ).
            rt_k = o_root->get_data( ).

            o_broker->detach_commit( ).

          CATCH zcx_abak INTO o_abak_exp.
            o_broker->detach_rollback( ).
            RAISE EXCEPTION o_abak_exp.

        ENDTRY.

      CATCH cx_shm_error INTO o_exp.
        RAISE EXCEPTION TYPE zcx_abak
          EXPORTING
            previous = o_exp.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
