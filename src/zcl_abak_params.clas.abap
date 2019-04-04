CLASS zcl_abak_params DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    INTERFACES zif_abak_params .

    METHODS constructor
      IMPORTING
        !i_params TYPE string
        !i_paramsdef TYPE string
      RAISING
        zcx_abak .
    CLASS-METHODS create_instance
      IMPORTING
        !i_params TYPE string
        !i_paramsdef TYPE string
      RETURNING
        value(ro_params) TYPE REF TO zif_abak_params
      RAISING
        zcx_abak .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gt_namevalue TYPE zabak_namevalue_t .
    CONSTANTS:
      BEGIN OF gc_regex,
        namevalue  TYPE string VALUE '([a-z]\w*)=(\S*)',     ##no_text
        namevalues TYPE string VALUE '^([a-z]\w*=\S*\s*)*$', ##no_text
      END OF gc_regex .

    METHODS check_against_definition
      IMPORTING
        !i_paramsdef TYPE string
      RAISING
        zcx_abak .
    METHODS parse
      IMPORTING
        !i_namevalues TYPE string
      RAISING
        zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK_PARAMS IMPLEMENTATION.


  METHOD check_against_definition.
    DATA: o_params_definition TYPE REF TO zcl_abak_params_definition.

    CREATE OBJECT o_params_definition
      EXPORTING
        i_definition = i_paramsdef.

    o_params_definition->check_parameters( gt_namevalue ).

  ENDMETHOD.


  METHOD constructor.
    DATA: o_tools TYPE REF TO zcl_abak_tools.

    CREATE OBJECT o_tools.
    o_tools->check_against_regex( i_regex = gc_regex-namevalues
                                  i_value = i_params ).
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
            RAISE EXCEPTION TYPE zcx_abak_params
              EXPORTING
                textid = zcx_abak_params=>duplicate
                name   = s_namevalue-name.
          ENDIF.
        ENDLOOP.

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
    ENDIF.

  ENDMETHOD.
ENDCLASS.
