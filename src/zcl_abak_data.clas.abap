CLASS zcl_abak_data DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC

  GLOBAL FRIENDS zcl_abak_factory .

  PUBLIC SECTION.

    INTERFACES zif_abak_data .
  PROTECTED SECTION.

    METHODS load_data_aux
    ABSTRACT
      EXPORTING
        !et_k TYPE zabak_k_t
        !e_name TYPE string
      RAISING
        zcx_abak .
    METHODS invalidate_aux
    ABSTRACT
      RAISING
        zcx_abak .
private section.

  CONSTANTS:
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

  CONSTANTS:
    BEGIN OF gc_sign,
      include TYPE bapisign VALUE 'I',
      exclude TYPE bapisign VALUE 'E',
    END OF gc_sign.

  data GT_K type ZABAK_K_T .
  data G_NAME type STRING .
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
  methods LOAD_DATA
    exporting
      !ET_K type ZABAK_K_T
      !E_NAME type STRING
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

    ENDLOOP.

  ENDMETHOD.


METHOD fill_defaults.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF ct_k,
                 <s_kv> LIKE LINE OF <s_k>-t_kv.

  LOOP AT ct_k ASSIGNING <s_k>.
    LOOP AT <s_k>-t_kv ASSIGNING <s_kv>.
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

    CLEAR: et_k, e_name.

    IF g_loaded = abap_true.
      RETURN.
    ENDIF.

    load_data_aux( IMPORTING et_k   = gt_k
                             e_name = g_name ).

    fill_defaults( CHANGING ct_k = gt_k ).

    check_data( gt_k ).

    g_loaded = abap_true.

  ENDMETHOD.


  METHOD zif_abak_data~get_data.
    load_data( ).
    rt_k = gt_k.
  ENDMETHOD.


  METHOD zif_abak_data~get_name.
    load_data( ).
    r_name = g_name.
  ENDMETHOD.


  METHOD zif_abak_data~invalidate.
    CLEAR gt_k[].
    CLEAR g_name.
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
