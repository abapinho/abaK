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
  methods GET_DEMO_XML
    returning
      value(R_XML) type STRING
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


METHOD get_demo_xml.
* Even though storing constants in a separate file is better than hard coding them
* directly in the code, it would still be difficult for a functional person to maintain it.
* This demo uses a XSLT to store the XML file just for simplicity sake. If you want to store
* your constants in XML format make sure they are in a place which is both safe and yet easy
* to maintain according to the project needs and your company standards.

* Please bear in mind that with this example we are not advocating that constants should be
* hard coded in the program. On the contrary. That defeats the whole purpose of this tool.
* This is just a simpler way to package the demo data.

  r_xml = |<abak/>|.

  CALL TRANSFORMATION zabak_demo_xml
    SOURCE XML r_xml
    RESULT XML r_xml.

ENDMETHOD.
ENDCLASS.
