class ZCL_ABAK_SOURCE_RFC definition
  public
  inheriting from zcl_abak_source
  final
  create public .

public section.
  interface ZIF_ABAK_CONSTS load .

  methods CONSTRUCTOR
    importing
      !I_ID type ZABAK_ID
      !I_RFCDEST type RFCDEST
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_SOURCE~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
PRIVATE SECTION.

  DATA g_id TYPE zabak_id .
  DATA g_rfcdest TYPE rfcdest .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_RFC IMPLEMENTATION.


METHOD constructor.

  IF i_id IS INITIAL.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        textid = zcx_abak=>invalid_parameters.
  ENDIF.

  super->constructor( ).

  g_id = i_id.
  g_rfcdest = i_rfcdest.

ENDMETHOD.


METHOD load.

  CALL FUNCTION 'Z_ABAK_ZABAK_RFC_GET'
    DESTINATION g_rfcdest
    EXPORTING
      i_id              = g_id
    IMPORTING
      e_serialized_data = r_content
    EXCEPTIONS
      error             = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak. " TODO
  ENDIF.


ENDMETHOD.


METHOD zif_abak_source~get_type.
  r_type = zif_abak_consts=>source_type-rfc.
ENDMETHOD.
ENDCLASS.
