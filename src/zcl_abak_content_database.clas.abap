class ZCL_ABAK_CONTENT_DATABASE definition
  public
  inheriting from ZCL_ABAK_CONTENT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_TABLENAME type STRING
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
private section.

  data G_TABLENAME type TABNAME .

  methods CHECK_TABLE
    importing
      !I_TABLENAME type STRING
    raising
      ZCX_ABAK .
  methods READ_DB
    importing
      !I_TABLENAME type TABNAME
    returning
      value(RT_DB) type ZABAK_DB_T .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_DATABASE IMPLEMENTATION.


METHOD CHECK_TABLE.
  DATA: o_structdescr TYPE REF TO cl_abap_structdescr,
        t_component   TYPE cl_abap_structdescr=>component_table,
        tablename     TYPE tabname.

  FIELD-SYMBOLS: <s_component> LIKE LINE OF t_component.

  o_structdescr ?= cl_abap_structdescr=>describe_by_name( i_tablename ).
  t_component = o_structdescr->get_components( ).

  tablename = i_tablename.

* Two components expected
  IF lines( t_component ) <> 2.
    RAISE EXCEPTION TYPE zcx_abak_content_database
      EXPORTING
        textid    = zcx_abak_content_database=>invalid_table_format
        tablename = tablename.
  ENDIF.

* Both components are includes
  LOOP AT t_component TRANSPORTING NO FIELDS WHERE as_include <> 'X'.
    RAISE EXCEPTION TYPE zcx_abak_content_database
      EXPORTING
        textid    = zcx_abak_content_database=>invalid_table_format
        tablename = tablename.
  ENDLOOP.

* 1st include is ZABAK_DB_KEYS
  READ TABLE t_component ASSIGNING <s_component> INDEX 1.
  IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_KEY'.
    RAISE EXCEPTION TYPE zcx_abak_content_database
      EXPORTING
        textid    = zcx_abak_content_database=>invalid_table_format
        tablename = tablename.
  ENDIF.

* 2nd include is ZABAK_DB_FIELDS
  READ TABLE t_component ASSIGNING <s_component> INDEX 2.
  IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_FIELDS'.
    RAISE EXCEPTION TYPE zcx_abak_content_database
      EXPORTING
        textid    = zcx_abak_content_database=>invalid_table_format
        tablename = tablename.
  ENDIF.

ENDMETHOD.


METHOD CONSTRUCTOR.

  super->constructor( ).

  check_table( i_tablename ).

  g_tablename = i_tablename.

ENDMETHOD.


METHOD load.
  DATA: t_k       TYPE zabak_k_t,
        o_k_table TYPE REF TO zcl_abak_k_table.

  CREATE OBJECT o_k_table.
  o_k_table->add_db_t( read_db( g_tablename ) ).
  t_k = o_k_table->get_k_t( ).

  CALL TRANSFORMATION zabak_copy
  SOURCE root = t_k
  RESULT XML r_content.

ENDMETHOD.


METHOD READ_DB.
  SELECT *
    FROM (i_tablename)
    INTO TABLE rt_db.
ENDMETHOD.


method ZIF_ABAK_CONTENT~GET_TYPE.
  r_type = zif_abak_consts=>content_type-database.
endmethod.
ENDCLASS.
