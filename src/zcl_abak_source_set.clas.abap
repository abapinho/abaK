CLASS zcl_abak_source_set DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_setid TYPE setid
        !i_setclass TYPE setclass
        !i_scope TYPE zabak_scope
        !i_context TYPE zabak_context
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    TYPES:
      ty_t_rgsb4 TYPE STANDARD TABLE OF rgsb4 WITH KEY setnr .

    DATA g_setid TYPE setid .
    DATA g_setclass TYPE setclass .
    DATA g_scope TYPE zabak_scope .
    DATA g_context TYPE zabak_context .

    METHODS read_set
      RETURNING
        value(rt_rgsb4) TYPE ty_t_rgsb4
      RAISING
        zcx_abak .
    METHODS set_2_k_t
      IMPORTING
        !it_rgsb4 TYPE ty_t_rgsb4
      RETURNING
        value(rt_k) TYPE zabak_k_t                       "#EC CI_VALPAR
      RAISING
        zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_SET IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

* TODO Validate parameters

    g_setid = i_setid.
    g_setclass = i_setclass.
    g_scope = i_scope.
    g_context = i_scope.

  ENDMETHOD.


  METHOD load.
    DATA: t_k     TYPE zabak_k_t.

    t_k = set_2_k_t( read_set( ) ).

    CALL TRANSFORMATION zabak_copy
    SOURCE root = t_k
    RESULT XML r_content.
  ENDMETHOD.


  METHOD read_set.
    CALL FUNCTION 'G_SET_GET_ALL_VALUES'
      EXPORTING
        setnr         = g_setid
        class         = g_setclass
      TABLES
        set_values    = rt_rgsb4
      EXCEPTIONS
        set_not_found = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak. " TODO
    ENDIF.
  ENDMETHOD.


  METHOD set_2_k_t.

    DATA: fieldname TYPE feldname,
          o_k_table TYPE REF TO zcl_abak_k_table.

    FIELD-SYMBOLS: <s_rgsb4> LIKE LINE OF it_rgsb4.

    CREATE OBJECT o_k_table.

    LOOP AT it_rgsb4 ASSIGNING <s_rgsb4>.

*   Make sure there is only one fieldname (the first one)
      IF sy-tabix = 1.
        fieldname = <s_rgsb4>-field.
      ELSE.
        CHECK <s_rgsb4>-field = fieldname.
      ENDIF.

      IF <s_rgsb4>-from = <s_rgsb4>-to.
        o_k_table->add_kv(
            i_scope     = g_scope
            i_fieldname = fieldname
            i_context   = g_context
            i_low       = <s_rgsb4>-from ).

      ELSE.
        o_k_table->add_kv(
            i_scope     = g_scope
            i_fieldname = fieldname
            i_context   = g_context
            i_option    = 'BT'
            i_low       = <s_rgsb4>-from
            i_high      = <s_rgsb4>-to ).
      ENDIF.
    ENDLOOP.

    rt_k = o_k_table->get_k_t( ).

  ENDMETHOD.


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-set.
  ENDMETHOD.
ENDCLASS.
