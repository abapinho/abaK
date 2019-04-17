CLASS zcl_abak_source_inline DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_content TYPE string
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    DATA g_content TYPE string .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_INLINE IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    g_content = i_content.

  ENDMETHOD.


  METHOD load.

    LOG-POINT ID zabak SUBKEY 'content_inline.load' FIELDS g_content.

    r_content = g_content.

  ENDMETHOD.


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-inline.
  ENDMETHOD.
ENDCLASS.
