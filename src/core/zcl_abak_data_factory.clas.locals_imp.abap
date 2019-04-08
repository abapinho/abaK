*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_cache DEFINITION FINAL.
  PUBLIC SECTION.

    CLASS-METHODS get
      IMPORTING
        i_use_shm      TYPE flag
        i_format_type  TYPE zabak_format_type
        i_source_type TYPE zabak_source_type
        i_content      TYPE string
      RETURNING value(ro_instance) TYPE REF TO zif_abak_data.

    CLASS-METHODS add
      IMPORTING
        i_use_shm       TYPE flag
        i_format_type   TYPE zabak_format_type
        i_source_type  TYPE zabak_source_type
        i_content       TYPE string
        io_instance     TYPE REF TO zif_abak_data
      RAISING
        zcx_abak.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_s_instance,
        use_shm      TYPE flag,
        format_type  TYPE zabak_format_type,
        source_type TYPE zabak_source_type,
        content      TYPE string,
        o_instance TYPE REF TO zif_abak_data,
      END OF ty_s_instance .

    TYPES:
      ty_t_instance
        TYPE SORTED TABLE OF ty_s_instance
        WITH UNIQUE KEY use_shm format_type source_type content.

    CLASS-DATA gt_instance TYPE ty_t_instance .
ENDCLASS.

CLASS lcl_cache IMPLEMENTATION.
  METHOD get.
    FIELD-SYMBOLS: <s_instance> LIKE LINE OF gt_instance.

    READ TABLE gt_instance ASSIGNING <s_instance>
      WITH KEY use_shm = i_use_shm
               format_type = i_format_type
               source_type = i_source_type
               content = i_content.
    IF sy-subrc = 0.
      ro_instance = <s_instance>-o_instance.
    ENDIF.
  ENDMETHOD.

  METHOD add.
    DATA: s_instance LIKE LINE OF gt_instance.

    s_instance-use_shm = i_use_shm.
    s_instance-format_type = i_format_type.
    s_instance-source_type = i_source_type.
    s_instance-content = i_content.
    s_instance-o_instance = io_instance.
    INSERT s_instance INTO TABLE gt_instance.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>unexpected_error.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
