class ZCL_ABAK_DATA definition
  public
  abstract
  create public

  global friends ZCL_ABAK_FACTORY .

public section.

  interfaces ZIF_ABAK_DATA .
protected section.

  methods LOAD_DATA_AUX
  abstract
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK .
  methods INVALIDATE_AUX
  abstract
    raising
      ZCX_ABAK .
private section.

  constants:
    BEGIN OF gc_option,
          equal                    TYPE bapioption VALUE 'EQ',
          not_equal                TYPE bapioption VALUE 'NE',
          between                  TYPE bapioption VALUE 'BT',
          not_between              TYPE bapioption VALUE 'NB',
          contains_pattern         TYPE bapioption VALUE 'CP',
          does_not_contain_pattern TYPE bapioption VALUE 'NP',
          less_than                TYPE bapioption VALUE 'LT',
          less_or_equal            TYPE bapioption VALUE 'LE',
          greater_than             TYPE bapioption VALUE 'GT',
          greater_or_equal         TYPE bapioption VALUE 'GE',
        END OF gc_option .
  constants:
    BEGIN OF gc_sign,
      include TYPE bapisign VALUE 'I',
      exclude TYPE bapisign VALUE 'E',
    END OF gc_sign .
  data GT_K type ZABAK_K_T .
  data G_LOADED type FLAG .

  methods CHECK_DATA
    importing
      !IT_K type ZABAK_K_T
    raising
      ZCX_ABAK .
  methods CHECK_LINE
    importing
      !IS_K type ZABAK_K
    raising
      ZCX_ABAK .
  methods CHECK_LINE_MULTI
    importing
      !IS_K type ZABAK_K
    raising
      ZCX_ABAK .
  methods LOAD_DATA
    raising
      ZCX_ABAK .
  methods FILL_DEFAULTS
    changing
      !CT_K type ZABAK_K_T
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_DATA IMPLEMENTATION.


  METHOD check_data.

    FIELD-SYMBOLS: <s_k> LIKE LINE OF it_k.

    LOOP AT it_k ASSIGNING <s_k>.
      check_line( <s_k> ).
    ENDLOOP.

  ENDMETHOD.


  METHOD check_line.

    FIELD-SYMBOLS: <s_kv> LIKE LINE OF is_k-t_kv.

    IF is_k-fieldname IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    LOOP AT is_k-t_kv ASSIGNING <s_kv>.

*     Validate sign
      IF <s_kv>-sign CN 'IE'.
        RAISE EXCEPTION TYPE zcx_abak_data
          EXPORTING
            textid = zcx_abak_data=>invalid_sign
            sign   = <s_kv>-sign.
      ENDIF.

      CASE <s_kv>-option.
        WHEN gc_option-equal OR
             gc_option-not_equal OR
             gc_option-contains_pattern OR
             gc_option-does_not_contain_pattern OR
             gc_option-greater_or_equal OR
             gc_option-greater_than OR
             gc_option-less_or_equal OR
             gc_option-less_than.

*         For single value operators HIGH must be empty
          IF <s_kv>-high IS NOT INITIAL.
            RAISE EXCEPTION TYPE zcx_abak_data
              EXPORTING
                textid = zcx_abak_data=>high_must_be_empty
                option = <s_kv>-option.
          ENDIF.

        WHEN gc_option-between OR
             gc_option-not_between.

*         Two value operator must have high defined
          IF <s_kv>-low IS INITIAL OR <s_kv>-high IS INITIAL.
            RAISE EXCEPTION TYPE zcx_abak_data
              EXPORTING
                textid = zcx_abak_data=>low_high_must_be_filled
                option = <s_kv>-option.
          ENDIF.

          IF <s_kv>-high < <s_kv>-low.
            RAISE EXCEPTION TYPE zcx_abak_data
              EXPORTING
                textid = zcx_abak_data=>high_must_be_gt_low
                option = <s_kv>-option
                low    = <s_kv>-low
                high   = <s_kv>-high.
          ENDIF.

        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_abak_data
            EXPORTING
              textid = zcx_abak_data=>invalid_option
              option = <s_kv>-option.

      ENDCASE.

*     Multiple fields: check if there are corresponding values and other checks
      check_line_multi( is_k ).

    ENDLOOP.

  ENDMETHOD.


METHOD check_line_multi.

  DATA: t_fieldname TYPE STANDARD TABLE OF string,
        t_value     TYPE STANDARD TABLE OF string.

  FIELD-SYMBOLS: <s_kv> LIKE LINE OF is_k-t_kv.

  SPLIT is_k-fieldname AT space INTO TABLE t_fieldname.

* Only relevant for multiple fieldnames
  IF lines( t_fieldname ) <= 1.
    RETURN.
  ENDIF.

* Only one value line allowed (no ranges)
  IF lines( is_k-t_kv ) <> 1.
    RAISE EXCEPTION TYPE zcx_abak_data
      EXPORTING
        textid = zcx_abak_data=>multi_many_values.
  ENDIF.

  READ TABLE is_k-t_kv ASSIGNING <s_kv> INDEX 1.

* Option must be EQ (no ranges)
  IF <s_kv>-option <> gc_option-equal.
    RAISE EXCEPTION TYPE zcx_abak_data
      EXPORTING
        textid = zcx_abak_data=>multi_option_not_eq.
  ENDIF.

* Sign must be I (no ranges)
  IF <s_kv>-sign <> gc_sign-include.
    RAISE EXCEPTION TYPE zcx_abak_data
      EXPORTING
        textid = zcx_abak_data=>multi_sign_not_i.
  ENDIF.

* High must be empty (no ranges)
  IF <s_kv>-high IS NOT INITIAL.
    RAISE EXCEPTION TYPE zcx_abak_data
      EXPORTING
        textid = zcx_abak_data=>high_must_be_empty.
  ENDIF.

* We need one value per field
  SPLIT <s_kv>-low AT space INTO TABLE t_value.
  IF lines( t_value ) <> lines( t_fieldname ).
    RAISE EXCEPTION TYPE zcx_abak_data
      EXPORTING
        textid = zcx_abak_data=>multi_fieldname_value_mismatch.
  ENDIF.

ENDMETHOD.


METHOD fill_defaults.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF ct_k,
                 <s_kv> LIKE LINE OF <s_k>-t_kv.

  LOOP AT ct_k ASSIGNING <s_k>.
    LOOP AT <s_k>-t_kv ASSIGNING <s_kv> WHERE sign IS INITIAL OR option IS INITIAL. "#EC CI_NESTED
      IF <s_kv>-sign IS INITIAL.
        <s_kv>-sign = gc_sign-include.
      ENDIF.
      IF <s_kv>-option IS INITIAL.
        <s_kv>-option = gc_option-equal.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDMETHOD.


  METHOD load_data.

    IF g_loaded = abap_true.
      RETURN.
    ENDIF.

    gt_k = load_data_aux( ).

    fill_defaults( CHANGING ct_k = gt_k ).

    check_data( gt_k ).

    g_loaded = abap_true.

  ENDMETHOD.


  METHOD zif_abak_data~get_data.
    load_data( ).
    rt_k = gt_k.
  ENDMETHOD.


  METHOD zif_abak_data~invalidate.
    CLEAR gt_k[].
    CLEAR g_loaded.
    invalidate_aux( ).
  ENDMETHOD.


  METHOD zif_abak_data~read.
    FIELD-SYMBOLS: <s_k> LIKE LINE OF gt_k.

    LOG-POINT ID zabak SUBKEY 'data.read' FIELDS i_scope i_fieldname i_context.

    load_data( ).

    READ TABLE gt_k ASSIGNING <s_k>
      WITH KEY scope = i_scope
               fieldname = i_fieldname
               context = i_context.
    IF sy-subrc = 0.
      rt_kv = <s_k>-t_kv.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
