class ZCL_ABAK_FORMAT_CSV definition
  public
  final
  create public .

public section.

  interfaces ZIF_ABAK_FORMAT .

  methods CONSTRUCTOR
    importing
      !I_DELIMITER type CHAR1 default '"'
      !I_SEPARATOR type CHAR1 default ',' .
protected section.
private section.

  types:
    ty_t_csv TYPE STANDARD TABLE OF string WITH KEY table_line .

  data GO_CONVERTER type ref to CL_RSDA_CSV_CONVERTER .

  methods SPLIT_INTO_LINES
    importing
      !I_CSV type STRING
    returning
      value(RT_CSV) type TY_T_CSV .
  methods CONVERT_CSV_2_DB
    importing
      !IT_CSV type TY_T_CSV
    returning
      value(RT_DB) type ZABAK_DB_T
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_CSV IMPLEMENTATION.


METHOD constructor.
  super->constructor( ).
  go_converter = cl_rsda_csv_converter=>create( i_delimiter = i_delimiter
                                                i_separator = i_separator ).
ENDMETHOD.


METHOD CONVERT_CSV_2_DB.

  DATA: s_db  LIKE LINE OF rt_db,
        s_csv like line of it_csv.

* It didn't have to be, but we'll use ZABAK_DB structure since it already exists
  LOOP AT it_csv into s_csv.
    s_csv = |000,{ s_csv }|. " Add MANDT to comply with the ZABAK_DB structure
    go_converter->csv_to_structure( EXPORTING i_data   = s_csv
                                    IMPORTING e_s_data = s_db ).
    INSERT s_db INTO TABLE rt_db.
  ENDLOOP.

ENDMETHOD.                                               "#EC CI_VALPAR


METHOD split_into_lines.
  SPLIT i_csv AT cl_abap_char_utilities=>cr_lf INTO TABLE rt_csv IN CHARACTER MODE.
ENDMETHOD.


METHOD zif_abak_format~convert.

  DATA: t_db TYPE zabak_db_t,
        o_k_table TYPE REF TO zcl_abak_k_table.

  LOG-POINT ID zabak SUBKEY 'format_csv.convert' FIELDS i_data.

  t_db = convert_csv_2_db( split_into_lines( i_data ) ).
  CREATE OBJECT o_k_table.
  o_k_table->add_db_t( t_db ).
  rt_k = o_k_table->get_k_t( ).

ENDMETHOD.


  METHOD ZIF_ABAK_FORMAT~GET_TYPE.
    r_format_type = zif_abak_consts=>format_type-csv.
  ENDMETHOD.
ENDCLASS.
