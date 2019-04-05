CLASS zcl_abak_source_so10 DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_name TYPE tdobname
        !i_id TYPE tdid
        !i_spras TYPE spras
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    DATA g_name TYPE tdobname .
    DATA g_id TYPE tdid .
    DATA g_spras TYPE spras .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_SO10 IMPLEMENTATION.


  METHOD constructor.

    IF i_name IS INITIAL OR i_id IS INITIAL OR i_spras IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    super->constructor( ).

    g_name = i_name.
    g_id = i_id.
    g_spras = i_spras.

  ENDMETHOD.


  METHOD load.

    DATA: t_line   TYPE tline_t.

    FIELD-SYMBOLS: <s_line> LIKE LINE OF t_line.

    LOG-POINT ID zabak SUBKEY 'content_so10.load' FIELDS g_id g_spras g_name.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = g_id
        language                = g_spras
        name                    = g_name
        object                  = 'TEXT'
      TABLES
        lines                   = t_line
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous_from_syst = abap_true.
    ENDIF.

    LOOP AT t_line ASSIGNING <s_line>.
      IF sy-tabix = 1.
        r_content = <s_line>.
      ELSE.
        r_content = |{ r_content }\n{ <s_line>-tdline }|.
      ENDIF.
    ENDLOOP.

    SHIFT r_content LEFT DELETING LEADING space.

  ENDMETHOD.


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-standard_text.
  ENDMETHOD.
ENDCLASS.
