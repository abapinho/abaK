class ZCL_ABAK_CONTENT_INLINE definition
  public
  inheriting from ZCL_ABAK_CONTENT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_CONTENT type STRING
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
private section.

  data G_CONTENT type STRING .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_INLINE IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    g_content = i_content.

  ENDMETHOD.


METHOD load.

  LOG-POINT ID zabak SUBKEY 'content_inline.load' FIELDS g_content.

  r_content = g_content.

ENDMETHOD.


METHOD zif_abak_content~get_type.
  r_type = zif_abak_consts=>content_type-inline.
ENDMETHOD.
ENDCLASS.
