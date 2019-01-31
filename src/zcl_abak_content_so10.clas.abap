class ZCL_ABAK_CONTENT_SO10 definition
  public
  inheriting from ZCL_ABAK_CONTENT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_NAME type TDOBNAME
      !I_ID type TDID
      !I_SPRAS type SPRAS
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
private section.

  data G_NAME type TDOBNAME .
  data G_ID type TDID .
  data G_SPRAS type SPRAS .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_SO10 IMPLEMENTATION.


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


METHOD zif_abak_content~get_type.
  r_type = zif_abak_consts=>content_type-standard_text.
ENDMETHOD.
ENDCLASS.
