class ZCL_ABAK_FORMAT_XSLT definition
  public
  inheriting from ZCL_ABAK_FORMAT
  abstract
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_TRANSFORMATION_ID type CXSLTDESC
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_FORMAT~CONVERT
    redefinition .
protected section.
private section.

  data G_TRANSFORMATION_ID type CXSLTDESC .

  methods CONVERT_XML_K_2_K
    importing
      !IT_XML_K type ZABAK_XML_K_T
    returning
      value(RT_K) type ZABAK_K_T .
  methods LOAD
    importing
      !I_XML type STRING
    exporting
      !ET_XML_K type ZABAK_XML_K_T
      !E_NAME type STRING
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_FORMAT_XSLT IMPLEMENTATION.


METHOD CONSTRUCTOR.

  IF i_transformation_id IS INITIAL.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        textid = zcx_abak=>invalid_parameters.
  ENDIF.

  super->constructor( ).

  g_transformation_id = i_transformation_id.

ENDMETHOD.


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


  METHOD LOAD.
    DATA: o_exp       TYPE REF TO cx_st_error.

    TRY.
        CALL TRANSFORMATION (g_transformation_id)
         SOURCE XML i_xml
         RESULT constants = et_xml_k
                name = e_name.

      CATCH cx_st_error INTO o_exp.
        RAISE EXCEPTION TYPE zcx_abak
          EXPORTING
            previous = o_exp.
    ENDTRY.

  ENDMETHOD.


METHOD ZIF_ABAK_FORMAT~CONVERT.
  DATA: t_xml_k TYPE zabak_xml_k_t.

  CLEAR: et_k, e_name.

  LOG-POINT ID zabak SUBKEY 'format_xml.convert' FIELDS i_data.

  load( EXPORTING
          i_xml    = i_data
        IMPORTING
          et_xml_k = t_xml_k
          e_name   = e_name ).

  IF et_k IS SUPPLIED.
    et_k = convert_xml_k_2_k( t_xml_k ).
  ENDIF.

  IF e_name IS INITIAL.
    e_name = zif_abak_format~get_type( ).
  ENDIF.

ENDMETHOD.
ENDCLASS.
