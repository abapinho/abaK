CLASS zcl_abak_source_database DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_tablename TYPE string
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    DATA g_tablename TYPE tabname .

    METHODS check_table
      IMPORTING
        !i_tablename TYPE string
      RAISING
        zcx_abak .
    METHODS read_db
      IMPORTING
        !i_tablename TYPE tabname
      RETURNING
        value(rt_db) TYPE zabak_db_t .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_DATABASE IMPLEMENTATION.


  METHOD check_table.
    DATA: o_structdescr TYPE REF TO cl_abap_structdescr,
          o_typedescr   TYPE REF TO cl_abap_typedescr,
          t_component   TYPE cl_abap_structdescr=>component_table,
          tablename     TYPE tabname.

    FIELD-SYMBOLS: <s_component> LIKE LINE OF t_component.

    cl_abap_structdescr=>describe_by_name(
      EXPORTING
        p_name         = i_tablename
      RECEIVING
        p_descr_ref    = o_typedescr
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous_from_syst = abap_true.
    ENDIF.
    o_structdescr ?= o_typedescr.
    t_component = o_structdescr->get_components( ).

    tablename = i_tablename.

* Two components expected
    IF lines( t_component ) <> 2.
      RAISE EXCEPTION TYPE zcx_abak_source_database
        EXPORTING
          textid    = zcx_abak_source_database=>invalid_table_format
          tablename = tablename.
    ENDIF.

* Both components are includes
    LOOP AT t_component TRANSPORTING NO FIELDS WHERE as_include <> 'X'.
      RAISE EXCEPTION TYPE zcx_abak_source_database
        EXPORTING
          textid    = zcx_abak_source_database=>invalid_table_format
          tablename = tablename.
    ENDLOOP.

* 1st include is ZABAK_DB_KEYS
    READ TABLE t_component ASSIGNING <s_component> INDEX 1.
    IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_KEY'.
      RAISE EXCEPTION TYPE zcx_abak_source_database
        EXPORTING
          textid    = zcx_abak_source_database=>invalid_table_format
          tablename = tablename.
    ENDIF.

* 2nd include is ZABAK_DB_FIELDS
    READ TABLE t_component ASSIGNING <s_component> INDEX 2.
    IF sy-subrc <> 0 OR <s_component>-type->absolute_name <> '\TYPE=ZABAK_DB_FIELDS'.
      RAISE EXCEPTION TYPE zcx_abak_source_database
        EXPORTING
          textid    = zcx_abak_source_database=>invalid_table_format
          tablename = tablename.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

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


  METHOD read_db.
    SELECT *
      FROM (i_tablename)
      INTO TABLE rt_db.
  ENDMETHOD.


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-database.
  ENDMETHOD.
ENDCLASS.
