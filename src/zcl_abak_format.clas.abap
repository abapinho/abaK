class ZCL_ABAK_FORMAT definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_ABAK_FORMAT
      all methods abstract .
protected section.

  methods ADD_KV
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type FELDNAM
      !I_CONTEXT type ZABAK_CONTEXT optional
      !I_SIGN type BAPISIGN default 'I'
      !I_OPTION type BAPIOPTION default 'EQ'
      !I_LOW type ANY
      !I_HIGH type ANY optional
    changing
      !CT_K type ZABAK_K_T
    raising
      ZCX_ABAK .
private section.

  methods CREATE_K_LINE
    importing
      !I_SCOPE type ZABAK_SCOPE
      !I_FIELDNAME type FELDNAM
      !I_CONTEXT type ZABAK_CONTEXT
    changing
      !CT_K type ZABAK_K_T .
ENDCLASS.



CLASS ZCL_ABAK_FORMAT IMPLEMENTATION.


METHOD add_kv.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF ct_k.
  DATA: s_kv LIKE LINE OF  <s_k>-t_kv.

  create_k_line(
    EXPORTING
      i_scope     = i_scope
      i_fieldname = i_fieldname
      i_context   = i_context
    CHANGING
      ct_k        = ct_k ).

  READ TABLE ct_k ASSIGNING <s_k>
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


METHOD create_k_line.
  DATA: s_k LIKE LINE OF ct_k.

  READ TABLE ct_k TRANSPORTING NO FIELDS
    WITH KEY scope = i_scope
             fieldname = i_fieldname
             context = i_context.
  IF sy-subrc <> 0.
    s_k-scope = i_scope.
    s_k-fieldname = i_fieldname.
    s_k-context = i_context.
    INSERT s_k INTO TABLE ct_k.
  ENDIF.
ENDMETHOD.
ENDCLASS.
