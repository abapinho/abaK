class ZCL_ABAK_TOOLS definition
  public
  final
  create public .

public section.

  methods CHECK_AGAINST_REGEX
    importing
      !I_REGEX type STRING
      !I_VALUE type STRING
    raising
      ZCX_ABAK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_TOOLS IMPLEMENTATION.


METHOD check_against_regex.
  DATA: o_matcher TYPE REF TO cl_abap_matcher,
        o_exp     TYPE REF TO cx_root.

  TRY.
      o_matcher = cl_abap_matcher=>create( pattern       = i_regex
                                           text          = i_value
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
