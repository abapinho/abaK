INTERFACE zif_abak_source
  PUBLIC .


  METHODS get
    RETURNING
      value(r_content) TYPE string
    RAISING
      zcx_abak .
  METHODS get_type
    RETURNING
      value(r_type) TYPE zabak_source_type .
  METHODS invalidate
    RAISING
      zcx_abak .
ENDINTERFACE.
