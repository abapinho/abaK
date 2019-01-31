class ZCL_ABAK_FORMAT_DB definition
  public
  inheriting from ZCL_ABAK_FORMAT
  final
  create public .

public section.

  methods ZIF_ABAK_FORMAT~CONVERT
    redefinition .
  methods ZIF_ABAK_FORMAT~GET_TYPE
    redefinition .
protected section.
private section.

  methods CHECK_TABLE
    importing
      !I_TABLENAME type TABNAME
    raising
      ZCX_ABAK .
  methods SELECT
    importing
      !I_TABLENAME type TABNAME
    returning
      value(RT_DATA) type ZABAK_DB_T .
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_DB IMPLEMENTATION.


  METHOD check_table.
    DATA: o_structdescr TYPE REF TO cl_abap_structdescr,
          t_component TYPE cl_abap_structdescr=>component_table.

    FIELD-SYMBOLS: <s_component> LIKE LINE OF t_component.

    o_structdescr ?= cl_abap_structdescr=>describe_by_name( i_tablename ).
    t_component = o_structdescr->get_components( ).

* Two components expected
    IF lines( t_component ) <> 2.
      RAISE EXCEPTION TYPE zcx_abak_format_db
        EXPORTING
          textid    = zcx_abak_format_db=>invalid_table_format
          tablename = i_tablename.
    ENDIF.

* Both components are includes
    LOOP AT t_component TRANSPORTING NO FIELDS WHERE as_include <> 'X'.
      RAISE EXCEPTION TYPE zcx_abak_format_db
        EXPORTING
          textid    = zcx_abak_format_db=>invalid_table_format
          tablename = i_tablename.
    ENDLOOP.

* 1st include is ZABAK_DB_KEYS
    READ TABLE t_component ASSIGNING <s_component> INDEX 1.
    IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_KEY'.
      RAISE EXCEPTION TYPE zcx_abak_format_db
        EXPORTING
          textid    = zcx_abak_format_db=>invalid_table_format
          tablename = i_tablename.
    ENDIF.

* 2nd include is ZABAK_DB_FIELDS
    READ TABLE t_component ASSIGNING <s_component> INDEX 2.
    IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_FIELDS'.
      RAISE EXCEPTION TYPE zcx_abak_format_db
        EXPORTING
          textid    = zcx_abak_format_db=>invalid_table_format
          tablename = i_tablename.
    ENDIF.

  ENDMETHOD.


  METHOD select.

    SELECT *
      FROM (i_tablename)
      INTO TABLE rt_data.

  ENDMETHOD.


  METHOD zif_abak_format~convert.
    DATA: tablename TYPE tabname,
          t_db TYPE zabak_db_t.

    FIELD-SYMBOLS: <s_db> LIKE LINE OF t_db.

    LOG-POINT ID zabak SUBKEY 'format_db.convert' FIELDS tablename.

    tablename = i_data.
    check_table( tablename ).

    IF et_k IS SUPPLIED.
      t_db = select( tablename ).
      LOOP AT t_db ASSIGNING <s_db>.
        add_kv(
          EXPORTING
            i_scope     = <s_db>-scope
            i_fieldname = <s_db>-fieldname
            i_context   = <s_db>-context
            i_sign      = <s_db>-ue_sign
            i_option    = <s_db>-ue_option
            i_low       = <s_db>-ue_low
            i_high      = <s_db>-ue_high
          CHANGING
            ct_k        = et_k ).
      ENDLOOP.
    ENDIF.

    IF e_name IS SUPPLIED.
      e_name = tablename.
    ENDIF.

  ENDMETHOD.


  METHOD zif_abak_format~get_type.
    r_format_type = zif_abak_consts=>format_type-database.
  ENDMETHOD.
ENDCLASS.
