INTERFACE zif_abak_data
  PUBLIC .


  METHODS read
    IMPORTING
      !i_scope TYPE zabak_scope
      !i_fieldname TYPE name_feld
      !i_context TYPE zabak_context
    RETURNING
      value(rt_kv) TYPE zabak_kv_t
    RAISING
      zcx_abak .
  METHODS invalidate
    RAISING
      zcx_abak .
  METHODS get_name
    RETURNING
      value(r_name) TYPE string
    RAISING
      zcx_abak .
  METHODS get_data
    RETURNING
      value(rt_k) TYPE zabak_k_t
    RAISING
      zcx_abak .
ENDINTERFACE.
