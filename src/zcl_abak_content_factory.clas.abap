class ZCL_ABAK_CONTENT_FACTORY definition
  public
  final
  create public .

public section.

  methods GET_INSTANCE
    importing
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE
      !I_CONTENT type STRING
    returning
      value(RO_CONTENT) type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
private section.

  constants GC_SO10_ID_DEFAULT type TDID value 'ST'. "#EC NOTEXT

  methods GET_INSTANCE_SO10
    importing
      !I_CONTENT type STRING
    returning
      value(RO_CONTENT) type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_SET
    importing
      !I_CONTENT type STRING
    returning
      value(RO_CONTENT) type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_RFC
    importing
      !I_CONTENT type STRING
    returning
      value(RO_CONTENT) type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_FACTORY IMPLEMENTATION.


METHOD get_instance.
  CASE i_content_type.
    WHEN zif_abak_consts=>content_type-inline.
      CREATE OBJECT ro_content TYPE zcl_abak_content_inline
        EXPORTING
          i_content = i_content.

    WHEN zif_abak_consts=>content_type-url.
      CREATE OBJECT ro_content TYPE zcl_abak_content_url
        EXPORTING
          i_url = i_content.

    WHEN zif_abak_consts=>content_type-file.
      CREATE OBJECT ro_content TYPE zcl_abak_content_file
        EXPORTING
          i_filepath = i_content.

    WHEN zif_abak_consts=>content_type-database.
      CREATE OBJECT ro_content TYPE zcl_abak_content_database
        EXPORTING
          i_tablename = i_content.

    WHEN zif_abak_consts=>content_type-set.
      ro_content = get_instance_set( i_content ).

    WHEN zif_abak_consts=>content_type-standard_text.
      ro_content = get_instance_so10( i_content ).

    WHEN zif_abak_consts=>content_type-rfc.
      ro_content = get_instance_rfc( i_content ).

    WHEN OTHERS.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
  ENDCASE.
ENDMETHOD.


METHOD get_instance_rfc.
  DATA: o_params TYPE REF TO zif_abak_params,
        rfcdest  TYPE rfcdest,
        id       TYPE zabak_id.

  o_params = zcl_abak_params=>create_instance( i_params    = i_content
                                               i_paramsdef = '+RFCDEST(32) +ID' ).

  id = o_params->get( 'ID' ).
  rfcdest = o_params->get( 'RFCDEST' ).

  CREATE OBJECT ro_content TYPE zcl_abak_content_rfc
    EXPORTING
      i_id      = id
      i_rfcdest = rfcdest.

ENDMETHOD.


METHOD get_instance_set.
  DATA: o_params TYPE REF TO zif_abak_params,
        context  TYPE zabak_context,
        scope    TYPE zabak_scope,
        setid    TYPE setid,
        setclass TYPE setclass.

  o_params = zcl_abak_params=>create_instance( i_params    = i_content
                                               i_paramsdef = '+ID(34) +CLASS(4) SCOPE(40) CONTEXT(40)' ).

  scope = o_params->get( 'SCOPE' ).
  context = o_params->get( 'CONTEXT' ).
  setid = o_params->get( 'ID' ).
  setclass = o_params->get( 'CLASS' ).

  CREATE OBJECT ro_content TYPE zcl_abak_content_set
    EXPORTING
      i_context  = context
      i_scope    = scope
      i_setclass = setclass
      i_setid    = setid.

ENDMETHOD.


METHOD get_instance_so10.
  DATA: o_params TYPE REF TO zif_abak_params,
        name     TYPE tdobname,
        id       TYPE tdid,
        language TYPE char2,
        spras    TYPE spras.

  o_params = zcl_abak_params=>create_instance( i_params    = i_content
                                               i_paramsdef = '+NAME(70) ID(4) LANGUAGE(2)' ).

  name = o_params->get( 'NAME' ).

  id = o_params->get( 'ID' ).
  IF id IS INITIAL.
    id = gc_so10_id_default.
  ENDIF.

  language = o_params->get( 'LANGUAGE' ).
  IF language IS NOT INITIAL.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input            = language
      IMPORTING
        output           = spras
      EXCEPTIONS
        unknown_language = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous_from_syst = abap_true.
    ENDIF.
  ELSE.
    spras = sy-langu.
  ENDIF.


  CREATE OBJECT ro_content TYPE zcl_abak_content_so10
    EXPORTING
      i_id    = id
      i_name  = name
      i_spras = spras.

ENDMETHOD.
ENDCLASS.
