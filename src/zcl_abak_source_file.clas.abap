class ZCL_ABAK_SOURCE_FILE definition
  public
  inheriting from zcl_abak_source
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_FILEPATH type STRING
    raising
      ZCX_ABAK .

  methods zif_abak_source~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
private section.

  data G_FILEPATH type STRING .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_FILE IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    g_filepath = i_filepath.

  ENDMETHOD.


METHOD load.
  DATA: o_exp TYPE REF TO cx_root.

  TRY.
      LOG-POINT ID zabak SUBKEY 'content_file.load' FIELDS g_filepath.

      OPEN DATASET g_filepath FOR INPUT IN TEXT MODE ENCODING DEFAULT.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_abak_source_file
          EXPORTING
            textid   = zcx_abak_source_file=>error_opening_file
            filepath = g_filepath.
      ENDIF.

      READ DATASET g_filepath INTO r_content.

      CLOSE DATASET g_filepath.

    CATCH cx_sy_file_open
          cx_sy_codepage_converter_init
          cx_sy_conversion_codepage
          cx_sy_file_authority
          cx_sy_pipes_not_supported
          cx_sy_too_many_files INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.
ENDMETHOD.


METHOD zif_abak_source~get_type.
  r_type = zif_abak_consts=>source_type-file.
ENDMETHOD.
ENDCLASS.
