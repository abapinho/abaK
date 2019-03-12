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

  methods K_TO_XML_K
    importing
      !IT_K type ZABAK_K_T
    returning
      value(RT_XML_K_T) type ZABAK_XML_K_T .
ENDCLASS.



CLASS ZCL_ABAK_RFC IMPLEMENTATION.


METHOD get_data.

  DATA: s_zabak TYPE zabak,
        content TYPE string,
        o_data  TYPE REF TO zif_abak_data,
        t_xml_k TYPE zabak_xml_k_t.

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

  t_xml_k = k_to_xml_k( o_data->get_data( ) ).
  CALL TRANSFORMATION zabak_content_rfc
    SOURCE constants = t_xml_k
    RESULT XML r_serialized.

ENDMETHOD.


METHOD k_to_xml_k.

  DATA: s_xml_k LIKE LINE OF rt_xml_k_t.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF it_k.

  LOOP AT it_k ASSIGNING <s_k>.
    MOVE-CORRESPONDING <s_k> TO s_xml_k.
    INSERT s_xml_k INTO TABLE rt_xml_k_t.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
