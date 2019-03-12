class ZCL_ABAK_PARAMS definition
  public
  final
  create private .

public section.

  interfaces ZIF_ABAK_PARAMS .

  methods CONSTRUCTOR
    importing
      !I_PARAMS type STRING
      !I_PARAMSDEF type STRING
    raising
      ZCX_ABAK .
  class-methods CREATE_INSTANCE
    importing
      !I_PARAMS type STRING
      !I_PARAMSDEF type STRING
    returning
      value(RO_PARAMS) type ref to ZIF_ABAK_PARAMS
    raising
      ZCX_ABAK .
protected section.
private section.

  data GT_NAMEVALUE type ZABAK_NAMEVALUE_T .
  constants:
    BEGIN OF gc_regex,
      namevalue  TYPE string VALUE '([a-z]\w*)=(\S*)',     ##NO_TEXT
      namevalues TYPE string VALUE '^([a-z]\w*=\S*\s*)*$', ##NO_TEXT
    END OF gc_regex .

  methods CHECK_AGAINST_DEFINITION
    importing
      !I_PARAMSDEF type STRING
    raising
      ZCX_ABAK .
  methods PARSE
    importing
      !I_NAMEVALUES type STRING
    raising
      ZCX_ABAK .
  methods VALIDATE
    importing
      !I_NAMEVALUES type STRING
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_PARAMS IMPLEMENTATION.


METHOD CHECK_AGAINST_DEFINITION.
  DATA: o_params_definition TYPE REF TO zcl_abak_params_definition.

  CREATE OBJECT o_params_definition
    EXPORTING
      i_definition = i_paramsdef.

  o_params_definition->check_parameters( gt_namevalue ).

ENDMETHOD.


METHOD constructor.
  validate( i_params ).
  parse( i_namevalues = i_params ).
  check_against_definition( i_paramsdef ).
ENDMETHOD.


METHOD create_instance.
  CREATE OBJECT ro_params TYPE zcl_abak_params
    EXPORTING
      i_params    = i_params
      i_paramsdef = i_paramsdef.
ENDMETHOD.


METHOD parse.

  DATA: o_matcher   TYPE REF TO cl_abap_matcher,
        t_match     TYPE match_result_tab,
        o_exp       TYPE REF TO cx_root,
        s_namevalue LIKE LINE OF gt_namevalue,
        str         TYPE char100.

  FIELD-SYMBOLS: <s_match>    LIKE LINE OF t_match,
                 <s_submatch> LIKE LINE OF <s_match>-submatches.

  IF i_namevalues IS INITIAL.
    RETURN.
  ENDIF.

  TRY.
      o_matcher = cl_abap_matcher=>create( pattern       = gc_regex-namevalue
                                           text          = i_namevalues
                                           ignore_case   = abap_true ).

      t_match = o_matcher->find_all( ).

      LOOP AT t_match ASSIGNING <s_match>.
        CLEAR s_namevalue.

        LOOP AT <s_match>-submatches ASSIGNING <s_submatch>. "#EC CI_NESTED

          str = i_namevalues+<s_submatch>-offset(<s_submatch>-length).

          CASE sy-tabix.
            WHEN 1. " Name
              s_namevalue-name = str.

            WHEN 2. " Value
              s_namevalue-value = str.

            WHEN OTHERS.
              RAISE EXCEPTION TYPE zcx_abak
                EXPORTING
                  textid = zcx_abak=>unexpected_error.

          ENDCASE.

        ENDLOOP.

        INSERT s_namevalue INTO TABLE gt_namevalue.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcx_abak. " TODO (Duplicate)
        ENDIF.
      ENDLOOP.

    CATCH cx_sy_regex cx_sy_matcher INTO o_exp.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous = o_exp.
  ENDTRY.

ENDMETHOD.


METHOD VALIDATE.
  DATA: o_matcher TYPE REF TO cl_abap_matcher,
        o_exp     TYPE REF TO cx_root.

  IF i_namevalues IS INITIAL.
    RETURN.
  ENDIF.

  TRY.
      o_matcher = cl_abap_matcher=>create( pattern       = gc_regex-namevalues
                                           text          = i_namevalues
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


METHOD zif_abak_params~get.
  DATA: upper_name LIKE i_name.

  FIELD-SYMBOLS <s_namevalue> LIKE LINE OF gt_namevalue.

  upper_name = to_upper( i_name ).

  READ TABLE gt_namevalue ASSIGNING <s_namevalue> WITH KEY name = upper_name.
  IF sy-subrc = 0.
    r_value = <s_namevalue>-value.
  ELSE.
    RAISE EXCEPTION TYPE zcx_abak. " TODO
  ENDIF.

ENDMETHOD.
ENDCLASS.
