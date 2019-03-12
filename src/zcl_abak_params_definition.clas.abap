class ZCL_ABAK_PARAMS_DEFINITION definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_DEFINITION type STRING
    raising
      ZCX_ABAK .
  methods CHECK_PARAMETERS
    importing
      !IT_PARAM type ZABAK_NAMEVALUE_T
    raising
      ZCX_ABAK .
protected section.
private section.

  types:
    BEGIN OF ty_s_paramdef,
      name       TYPE string,
      obligatory TYPE flag,
      max_length TYPE i,
    END OF ty_s_paramdef .
  types:
    ty_t_paramdef TYPE SORTED TABLE OF ty_s_paramdef WITH UNIQUE KEY name .

  constants:
    BEGIN OF gc_regex,
      paramdef  type string value '(\+?)([a-z]\w*)(\(\d{1,3}\))?', ##NO_TEXT
      paramdefs type string value '(?:\+?)(?:[a-z]\w*)(?:\(\d{1,3}\))?(?: (?:\+?)(?:[a-z]\w*)(?:\(\d{1,3}\))?)*', ##NO_TEXT
    END OF gc_regex .
  data GT_PARAMDEF type TY_T_PARAMDEF .

  methods PARSE
    importing
      !I_DEFINITION type STRING
    raising
      ZCX_ABAK .
  methods VALIDATE
    importing
      !I_DEFINITION type STRING
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_PARAMS_DEFINITION IMPLEMENTATION.


METHOD check_parameters.

  FIELD-SYMBOLS: <s_param> LIKE LINE OF it_param,
                 <s_paramdef>   LIKE LINE OF gt_paramdef.

* Check provided parameters
  LOOP AT it_param ASSIGNING <s_param>.
    READ TABLE gt_paramdef ASSIGNING <s_paramdef> WITH KEY name = <s_param>-name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak. " TODO
    ELSEIF <s_paramdef>-max_length > 0 AND strlen( <s_param>-value ) > <s_paramdef>-max_length.
      RAISE EXCEPTION TYPE zcx_abak. " TODO
    ENDIF.
  ENDLOOP.

* Look for missing obligatory parameters
  LOOP AT gt_paramdef ASSIGNING <s_paramdef> WHERE obligatory = abap_true. "#EC CI_SORTSEQ
    READ TABLE it_param TRANSPORTING NO FIELDS WITH KEY name = <s_paramdef>-name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak. " TODO
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD CONSTRUCTOR.
  validate( i_definition ).
  parse( i_definition ).
ENDMETHOD.


METHOD parse.

  DATA: o_matcher  TYPE REF TO cl_abap_matcher,
        t_match    TYPE match_result_tab,
        o_exp      TYPE REF TO cx_root,
        s_paramdef LIKE LINE OF gt_paramdef,
        str        TYPE char100,
        len        TYPE i.

  FIELD-SYMBOLS: <s_match>    LIKE LINE OF t_match,
                 <s_submatch> LIKE LINE OF <s_match>-submatches.

  IF i_definition IS INITIAL.
    RETURN.
  ENDIF.

  TRY.
      o_matcher = cl_abap_matcher=>create( pattern       = gc_regex-paramdef
                                           text          = i_definition
                                           ignore_case   = abap_true ).

      t_match = o_matcher->find_all( ).

      LOOP AT t_match ASSIGNING <s_match>.
        CLEAR s_paramdef.

        LOOP AT <s_match>-submatches ASSIGNING <s_submatch>. "#EC CI_NESTED

          IF <s_submatch>-offset < 0.
            CONTINUE.
          ENDIF.

          str = i_definition+<s_submatch>-offset(<s_submatch>-length).

          CASE sy-tabix.
            WHEN 1. " Obligatory
              IF str = '+'.
                s_paramdef-obligatory = abap_true.
              ENDIF.

            WHEN 2. " Name
              s_paramdef-name = str.

            WHEN 3. " Length
              IF str IS NOT INITIAL.
                len = strlen( str ) - 2.
                s_paramdef-max_length = str+1(len).
              ENDIF.

          ENDCASE.
        ENDLOOP.

        INSERT s_paramdef INTO TABLE gt_paramdef.
      ENDLOOP.

    CATCH cx_sy_regex cx_sy_matcher INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.


METHOD validate.

  DATA: o_matcher TYPE REF TO cl_abap_matcher,
        o_exp     TYPE REF TO cx_root.

  IF i_definition IS INITIAL.
    RETURN.
  ENDIF.

  TRY.
      o_matcher = cl_abap_matcher=>create( pattern       = gc_regex-paramdefs
                                           text          = i_definition
                                           ignore_case   = abap_true ).

      IF o_matcher->match( ) IS INITIAL.
        RAISE EXCEPTION TYPE zcx_abak. " TODO
      ENDIF.

    CATCH cx_sy_regex cx_sy_matcher INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.
ENDCLASS.
