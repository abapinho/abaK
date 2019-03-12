class ZCL_ABAK_CONTENT_SET definition
  public
  inheriting from ZCL_ABAK_CONTENT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_SETID type SETID
      !I_SETCLASS type SETCLASS
      !I_SCOPE type ZABAK_SCOPE
      !I_CONTEXT type ZABAK_CONTEXT
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
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
      value(rt_k) TYPE zabak_k_t "#EC CI_VALPAR
    RAISING
      zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_SET IMPLEMENTATION.


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


METHOD SET_2_K_T.

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
          i_scope     = G_scope
          i_fieldname = fieldname
          i_context   = G_context
          i_low       = <s_rgsb4>-from ).

    ELSE.
      o_k_table->add_kv(
          i_scope     = G_scope
          i_fieldname = fieldname
          i_context   = G_context
          i_option    = 'BT'
          i_low       = <s_rgsb4>-from
          i_high      = <s_rgsb4>-to ).
    ENDIF.
  ENDLOOP.

  rt_k = o_k_table->get_k_t( ).

ENDMETHOD.


METHOD zif_abak_content~get_type.
  r_type = zif_abak_consts=>content_type-set.
ENDMETHOD.
ENDCLASS.
