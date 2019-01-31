class ZCL_ABAK_CONTENT_FACTORY definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    importing
      !I_CONTENT_TYPE type ZABAK_CONTENT_TYPE
      !I_CONTENT type STRING
    returning
      value(RO_CONTENT) type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_s_param,
      name TYPE string,
      value TYPE string,
    END OF ty_s_param .
  types:
    ty_t_param TYPE SORTED TABLE OF ty_s_param WITH UNIQUE KEY name .

  constants:
    begin of gc_regex,
      so10_param TYPE string VALUE '^([a-z]\w*)(?: ([a-z]\w*)(?: ([a-z]*))*)*$', "#EC NOTEXT
      rfc_params type string value '^([a-z]\w*)(?: ([a-z]\w*))*$', "#EC NOTEXT
    end of gc_regex .
  constants GC_SO10_ID_DEFAULT type TDID value 'ST'. "#EC NOTEXT

  class-methods GET_SO10_PARAMS
    importing
      !I_PARAM type STRING
    exporting
      !E_NAME type TDOBNAME
      !E_ID type TDID
      !E_SPRAS type SPRAS
    raising
      ZCX_ABAK .
  class-methods GET_RFC_PARAMS
    importing
      !I_PARAM type STRING
    exporting
      !E_ID type ZABAK_ID
      !E_RFCDEST type RFCDEST
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_FACTORY IMPLEMENTATION.


  METHOD get_instance.
    DATA: so10_name   TYPE tdobname,
          so10_id     TYPE tdid,
          so10_spras  TYPE spras,
          rfc_id      TYPE zabak_id,
          rfc_rfcdest TYPE rfcdest.

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

      WHEN zif_abak_consts=>content_type-standard_text.
        get_so10_params( EXPORTING
                           i_param = i_content
                         IMPORTING
                           e_name  = so10_name
                           e_id    = so10_id
                           e_spras = so10_spras ).
        CREATE OBJECT ro_content TYPE zcl_abak_content_so10
          EXPORTING
            i_id    = so10_id
            i_name  = so10_name
            i_spras = so10_spras.

      WHEN zif_abak_consts=>content_type-rfc.
        get_rfc_params( EXPORTING
                          i_param = i_content
                        IMPORTING
                          e_id      = rfc_id
                          e_rfcdest = rfc_rfcdest ).
        CREATE OBJECT ro_content TYPE zcl_abak_content_rfc
          EXPORTING
            i_id      = rfc_id
            i_rfcdest = rfc_rfcdest.

      WHEN OTHERS.
        RAISE EXCEPTION TYPE zcx_abak
          EXPORTING
            textid = zcx_abak=>invalid_parameters.
    ENDCASE.

  ENDMETHOD.


METHOD get_rfc_params.

  DATA: o_regex   TYPE REF TO cl_abap_regex,
        o_exp     TYPE REF TO cx_root,
        o_matcher TYPE REF TO cl_abap_matcher,
        t_result  TYPE match_result_tab,
        str       TYPE string.

  FIELD-SYMBOLS: <s_result> LIKE LINE OF t_result.

  CLEAR: e_id, e_rfcdest.

  TRY.
      CREATE OBJECT o_regex
        EXPORTING
          pattern     = gc_regex-rfc_params
          ignore_case = abap_true.

      o_matcher = o_regex->create_matcher( text = i_param ).

      t_result = o_matcher->find_all( ).

*     ID name
      READ TABLE t_result ASSIGNING <s_result> INDEX 1.
      IF sy-subrc = 0.
        str = i_param+<s_result>-offset(<s_result>-length).
        IF strlen( str ) > 30.
          RAISE EXCEPTION TYPE zcx_abak
            EXPORTING
              textid = zcx_abak=>invalid_parameters.
        ELSE.
          e_id = str.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE zcx_abak. "TODO
      ENDIF.

*     RFC Destination
      READ TABLE t_result ASSIGNING <s_result> INDEX 2.
      IF sy-subrc = 0.
        str = i_param+<s_result>-offset(<s_result>-length).
        IF strlen( str ) > 32.
          RAISE EXCEPTION TYPE zcx_abak
            EXPORTING
              textid = zcx_abak=>invalid_parameters.
        ELSE.
          e_rfcdest = str.
        ENDIF.
      ENDIF.

    CATCH cx_sy_regex cx_sy_matcher INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.


METHOD get_so10_params.

  DATA: o_regex   TYPE REF TO cl_abap_regex,
        o_exp     TYPE REF TO cx_root,
        o_matcher TYPE REF TO cl_abap_matcher,
        t_result  TYPE match_result_tab,
        str       TYPE string.

  FIELD-SYMBOLS: <s_result> LIKE LINE OF t_result.

  TRY.
      CREATE OBJECT o_regex
        EXPORTING
          pattern     = gc_regex-so10_param
          ignore_case = abap_true.

      o_matcher = o_regex->create_matcher( text = i_param ).

      t_result = o_matcher->find_all( ).

*     Text name
      READ TABLE t_result ASSIGNING <s_result> INDEX 1.
      IF sy-subrc = 0.
        str = i_param+<s_result>-offset(<s_result>-length).
        IF strlen( str ) > 70.
          RAISE EXCEPTION TYPE zcx_abak
            EXPORTING
              textid = zcx_abak=>invalid_parameters.
        ELSE.
          e_name = str.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE zcx_abak. "TODO
      ENDIF.

*     Text id
      READ TABLE t_result ASSIGNING <s_result> INDEX 2.
      IF sy-subrc = 0.
        str = i_param+<s_result>-offset(<s_result>-length).
        IF strlen( str ) > 4.
          RAISE EXCEPTION TYPE zcx_abak
            EXPORTING
              textid = zcx_abak=>invalid_parameters.
        ELSE.
          e_id = str.
        ENDIF.
      ELSE.
        e_id = gc_so10_id_default.
      ENDIF.

*     Language
      READ TABLE t_result ASSIGNING <s_result> INDEX 3.
      IF sy-subrc = 0.
        str = i_param+<s_result>-offset(<s_result>-length).
        CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
          EXPORTING
            input            = str
          IMPORTING
            output           = e_spras
          EXCEPTIONS
            unknown_language = 1
            OTHERS           = 2.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_abak
            EXPORTING
              previous_from_syst = abap_true.
        ENDIF.
      ELSE.
        e_spras = sy-langu.
      ENDIF.

    CATCH cx_sy_regex cx_sy_matcher INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.
ENDCLASS.
