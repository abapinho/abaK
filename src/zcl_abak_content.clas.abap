class ZCL_ABAK_CONTENT definition
  public
  abstract
  create public .

public section.

  interfaces ZIF_ABAK_CONTENT
      abstract methods GET_TYPE .
protected section.

  methods LOAD
  abstract
    returning
      value(R_CONTENT) type STRING
    raising
      ZCX_ABAK .
private section.

  data G_CONTENT type STRING .
  data G_LOADED type FLAG .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT IMPLEMENTATION.


  METHOD zif_abak_content~get.

    IF g_loaded IS INITIAL.
      g_content = load( ).
      g_loaded = abap_true.
    ENDIF.

    r_content = g_content.

  ENDMETHOD.


  METHOD zif_abak_content~invalidate.
    CLEAR g_loaded.
  ENDMETHOD.
ENDCLASS.
