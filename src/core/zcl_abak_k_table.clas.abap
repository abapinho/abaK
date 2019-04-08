class ZCL_ABAK_K_TABLE definition
  public
  final
  create public .

public section.

  methods ADD_KV
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type FELDNAM
      !I_CONTEXT type ZABAK_CONTEXT optional
      !I_SIGN type BAPISIGN default 'I'
      !I_OPTION type BAPIOPTION default 'EQ'
      !I_LOW type ANY
      !I_HIGH type ANY optional
    raising
      ZCX_ABAK .
  methods GET_K_T
    returning
      value(RT_K) type ZABAK_K_T .
  methods ADD_DB_T
    importing
      !IT_DB type ZABAK_DB_T
    raising
      ZCX_ABAK .
  methods ADD_XML_K_T
    importing
      !IT_XML_K type ZABAK_XML_K_T
    raising
      ZCX_ABAK .
protected section.
private section.

  data GT_K type ZABAK_K_T .

  methods CREATE_K_LINE
    importing
      !I_SCOPE type ZABAK_SCOPE
      !I_FIELDNAME type FELDNAM
      !I_CONTEXT type ZABAK_CONTEXT .
ENDCLASS.



CLASS ZCL_ABAK_K_TABLE IMPLEMENTATION.


METHOD add_db_t.
  FIELD-SYMBOLS: <s_db> LIKE LINE OF it_db.

  LOOP AT it_db ASSIGNING <s_db>.
    add_kv(
      i_scope     = <s_db>-scope
      i_fieldname = <s_db>-fieldname
      i_context   = <s_db>-context
      i_sign      = <s_db>-ue_sign
      i_option    = <s_db>-ue_option
      i_low       = <s_db>-ue_low
      i_high      = <s_db>-ue_high ).
  ENDLOOP.

ENDMETHOD.


METHOD ADD_KV.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF gt_k.

  DATA: s_kv LIKE LINE OF  <s_k>-t_kv.

  create_k_line( i_scope     = i_scope
                 i_fieldname = i_fieldname
                 i_context   = i_context ).

  READ TABLE gt_k ASSIGNING <s_k>
    WITH KEY scope = i_scope
             fieldname = i_fieldname
             context = i_context.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        textid = zcx_abak=>unexpected_error.
  ENDIF.

  READ TABLE <s_k>-t_kv TRANSPORTING NO FIELDS
    WITH KEY sign = i_sign
             option = i_option
             low = i_low
             high = i_high.
  IF sy-subrc <> 0.
    s_kv-sign = i_sign.
    s_kv-option = i_option.
    s_kv-low = i_low.
    s_kv-high = i_high.
    INSERT s_kv INTO TABLE <s_k>-t_kv.
  ENDIF.

ENDMETHOD.


method ADD_XML_K_T.
  FIELD-SYMBOLS: <s_xml_k> LIKE LINE OF it_xml_k,
                 <s_kv>    LIKE LINE OF <s_xml_k>-t_kv.

  LOOP AT it_xml_k ASSIGNING <s_xml_k>.

    IF <s_xml_k>-value IS NOT INITIAL.
      add_kv(
        i_scope     = <s_xml_k>-scope
        i_fieldname = <s_xml_k>-fieldname
        i_context   = <s_xml_k>-context
        i_low       = <s_xml_k>-value ).
    ENDIF.

    LOOP AT <s_xml_k>-t_kv ASSIGNING <s_kv>. "#EC CI_NESTED
      add_kv(
        i_scope     = <s_xml_k>-scope
        i_fieldname = <s_xml_k>-fieldname
        i_context   = <s_xml_k>-context
        i_sign      = <s_kv>-sign
        i_option    = <s_kv>-option
        i_low       = <s_kv>-low
        i_high      = <s_kv>-high ).
    ENDLOOP.

  ENDLOOP.

endmethod.


METHOD CREATE_K_LINE.
  DATA: s_k LIKE LINE OF gt_k.

  READ TABLE gt_k TRANSPORTING NO FIELDS
    WITH KEY scope = i_scope
             fieldname = i_fieldname
             context = i_context.
  IF sy-subrc <> 0.
    s_k-scope = i_scope.
    s_k-fieldname = i_fieldname.
    s_k-context = i_context.
    INSERT s_k INTO TABLE gt_k.
  ENDIF.
ENDMETHOD.


METHOD get_k_t.
  rt_k = gt_k.
ENDMETHOD.
ENDCLASS.
