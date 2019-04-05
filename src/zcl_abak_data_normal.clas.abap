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
      !IO_SOURCE type ref to zif_abak_source
    raising
      ZCX_ABAK .
protected section.

  methods INVALIDATE_AUX
    redefinition .
  methods LOAD_DATA_AUX
    redefinition .
  PRIVATE SECTION.

    DATA go_format TYPE REF TO zif_abak_format .
    DATA go_source TYPE REF TO zif_abak_source .
ENDCLASS.



CLASS ZCL_ABAK_DATA_NORMAL IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    IF io_format IS NOT BOUND OR IO_SOURCE IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    go_format = io_format.
    go_source = IO_SOURCE.

  ENDMETHOD.


  METHOD invalidate_aux.
    go_source->invalidate( ).
  ENDMETHOD.


METHOD load_data_aux.
  rt_k = go_format->convert( go_source->get( ) ).
ENDMETHOD.
ENDCLASS.
