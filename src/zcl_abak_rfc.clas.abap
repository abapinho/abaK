class ZCL_ABAK_RFC definition
  public
  final
  create public .

public section.
  interface ZIF_ABAK_CONSTS load .

  methods GET_DATA
    importing
      !I_ID type ZABAK_ID
    returning
      value(R_SERIALIZED) type STRING
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS ZCL_ABAK_RFC IMPLEMENTATION.


METHOD get_data.

  DATA: s_zabak TYPE zabak,
        content TYPE string,
        o_data  TYPE REF TO zif_abak_data,
        s_data  TYPE zabak_data.

  SELECT SINGLE * FROM zabak INTO s_zabak WHERE id = i_id.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak. " TODO
  ENDIF.

  IF s_zabak-format_type IS INITIAL OR s_zabak-content_type IS INITIAL OR s_zabak-content IS INITIAL.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        textid = zcx_abak=>invalid_parameters.
  ENDIF.

  content = s_zabak-content.

  o_data = zcl_abak_data_factory=>get_standard_instance( i_format_type  = s_zabak-format_type
                                                         i_content_type = s_zabak-content_type
                                                         i_content      = content ).

  s_data-t_k = o_data->get_data( ).
  s_data-name = o_data->get_name( ).

  CALL TRANSFORMATION zabak_content_rfc
  SOURCE root = s_data
  RESULT XML r_serialized.

*  EXPORT s_data FROM s_data TO DATA BUFFER r_rfc_data_serialized.

ENDMETHOD.
ENDCLASS.
