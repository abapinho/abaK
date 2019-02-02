class ZCL_ABAK_FORMAT_JSON definition
  public
  inheriting from ZCL_ABAK_FORMAT
  final
  create public .

public section.

  methods ZIF_ABAK_FORMAT~CONVERT
    redefinition .
  methods ZIF_ABAK_FORMAT~GET_TYPE
    redefinition .
protected section.
private section.

  methods CONVERT_XML_K_2_K
    importing
      !IT_XML_K type ZABAK_XML_K_T
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK .
  methods LOAD_JSON
    importing
      !I_JSON type STRING
    exporting
      !ET_XML_K type ZABAK_XML_K_T
      !E_NAME type STRING
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_JSON IMPLEMENTATION.


  METHOD CONVERT_XML_K_2_K.

    FIELD-SYMBOLS: <s_xml_k> LIKE LINE OF it_xml_k,
                   <s_kv>    LIKE LINE OF <s_xml_k>-t_kv.

    LOOP AT it_xml_k ASSIGNING <s_xml_k>.

      IF <s_xml_k>-value IS NOT INITIAL.
        add_kv(
          EXPORTING
            i_scope     = <s_xml_k>-scope
            i_fieldname = <s_xml_k>-fieldname
            i_context   = <s_xml_k>-context
            i_low       = <s_xml_k>-value
          CHANGING
            ct_k        = rt_k ).
      ENDIF.

      LOOP AT <s_xml_k>-t_kv ASSIGNING <s_kv>.
        add_kv(
          EXPORTING
            i_scope     = <s_xml_k>-scope
            i_fieldname = <s_xml_k>-fieldname
            i_context   = <s_xml_k>-context
            i_sign      = <s_kv>-sign
            i_option    = <s_kv>-option
            i_low       = <s_kv>-low
            i_high      = <s_kv>-high
          CHANGING
            ct_k        = rt_k ).
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD load_json.
    DATA: o_exp       TYPE REF TO cx_st_error.

    TRY.
        CALL TRANSFORMATION zabak_format_json
         SOURCE XML i_json
         RESULT constants = et_xml_k
                name = e_name.

      CATCH cx_st_error INTO o_exp.
        RAISE EXCEPTION TYPE zcx_abak
          EXPORTING
            previous = o_exp.
    ENDTRY.

  ENDMETHOD.


METHOD zif_abak_format~convert.
  DATA: t_xml_k TYPE zabak_xml_k_t.

  CLEAR: et_k, e_name.

  LOG-POINT ID zabak SUBKEY 'format_json.convert' FIELDS i_data.

  load_json( EXPORTING
              i_json    = i_data
             IMPORTING
               et_xml_k = t_xml_k
               e_name   = e_name ).

  IF et_k IS SUPPLIED.
    et_k = convert_xml_k_2_k( t_xml_k ).
  ENDIF.

  IF e_name IS INITIAL.
    e_name = zif_abak_consts=>format_type-json.
  ENDIF.

ENDMETHOD.


METHOD ZIF_ABAK_FORMAT~GET_TYPE.
  r_format_type = zif_abak_consts=>format_type-json.
ENDMETHOD.
ENDCLASS.
