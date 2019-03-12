class ZCL_ABAK_DATA_NORMAL definition
  public
  inheriting from ZCL_ABAK_DATA
  final
  create public

  global friends ZCL_ABAK_FACTORY .

public section.

  methods CONSTRUCTOR
    importing
      !IO_FORMAT type ref to ZIF_ABAK_FORMAT
      !IO_CONTENT type ref to ZIF_ABAK_CONTENT
    raising
      ZCX_ABAK .
protected section.

  methods INVALIDATE_AUX
    redefinition .
  methods LOAD_DATA_AUX
    redefinition .
  PRIVATE SECTION.

    DATA go_format TYPE REF TO zif_abak_format .
    DATA go_content TYPE REF TO zif_abak_content .
ENDCLASS.



CLASS ZCL_ABAK_DATA_NORMAL IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    IF io_format IS NOT BOUND OR io_content IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    go_format = io_format.
    go_content = io_content.

  ENDMETHOD.


  METHOD invalidate_aux.
    go_content->invalidate( ).
  ENDMETHOD.


METHOD load_data_aux.
  rt_k = go_format->convert( go_content->get( ) ).
ENDMETHOD.
ENDCLASS.
