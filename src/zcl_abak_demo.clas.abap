class ZCL_ABAK_DEMO definition
  public
  final
  create public .

public section.

  methods IS_CURRENCY_VALID
    raising
      ZCX_ABAK .
  methods CONSTRUCTOR
    importing
      !I_WHICH_DEMO type STRING
    raising
      ZCX_ABAK .
  methods GET_CUSTOMER_FOR_CONTEXT
    raising
      ZCX_ABAK .
  methods GET_OUR_COMPANY
    raising
      ZCX_ABAK .
  methods IS_ACCOUNT_TYPE_VALID
    raising
      ZCX_ABAK .
  methods VALIDATE_AMOUNT
    raising
      ZCX_ABAK .
protected section.
private section.

  constants GC_DEMO_TABLENAME type STRING value 'ZABAK_DEMO'. "#EC NOTEXT
  data GO_ABAK type ref to ZIF_ABAK .

  methods CREATE_INSTANCE
    importing
      !I_WHICH_DEMO type STRING
    raising
      ZCX_ABAK .
  methods GENERATE_DB_DATA
    raising
      ZCX_ABAK .
  methods GET_DEMO_XML
    returning
      value(R_XML) type STRING
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_STANDARD_DB
    returning
      value(RO_ABAK) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_STANDARD_XML
    returning
      value(RO_ABAK) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
  methods GET_INSTANCE_ZABAK_DB
    returning
      value(RO_ABAK) type ref to ZIF_ABAK
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK_DEMO IMPLEMENTATION.


method CONSTRUCTOR.
  create_instance( i_which_demo ).
endmethod.


METHOD create_instance.

  CASE i_which_demo.

    WHEN 'DB'.
      generate_db_data( ).
      go_abak = get_instance_standard_db( ).

    WHEN 'ZABAK'.
      go_abak = get_instance_zabak_db( ).

    WHEN 'XML'.
      go_abak = get_instance_standard_xml( ).

    WHEN OTHERS.
      RAISE EXCEPTION TYPE zcx_abak. " TODO

  ENDCASE.

ENDMETHOD.


METHOD generate_db_data.
* We take the XML data stored in the XSLT transformation ZABAK_DEMO_XML,
* convert it to the database format and insert it into table ZABAK_DEMO.
* Besides being a convenient way to generate the demo's database data records,
* this way we're sure that both database and XML examples will be using
* the same data.

  DATA: t_data TYPE zabak_db_t,
        s_data LIKE LINE OF t_data,
        o_format_xml TYPE REF TO zcl_abak_format_xml,
        t_k          TYPE zabak_k_t.

  FIELD-SYMBOLS: <s_k> LIKE LINE OF t_k,
                 <s_kv> LIKE LINE OF <s_k>-t_kv.

  CREATE OBJECT o_format_xml.
  t_k = o_format_xml->zif_abak_format~convert( get_demo_xml( ) ).

  LOOP AT t_k ASSIGNING <s_k>.
    MOVE-CORRESPONDING <s_k> TO s_data.
    CLEAR s_data-idx.
    LOOP AT <s_k>-t_kv ASSIGNING <s_kv>. "#EC CI_NESTED
      ADD 1 TO s_data-idx.
      s_data-ue_sign = <s_kv>-sign.
      s_data-ue_option = <s_kv>-option.
      s_data-ue_low = <s_kv>-low.
      s_data-ue_high = <s_kv>-high.
      INSERT s_data INTO TABLE t_data.
    ENDLOOP.
  ENDLOOP.

* Delete table contents
  DELETE FROM zabak_demo WHERE scope <> '1MPR0BABL3SC0P3'. "#EC CI_NOFIELD

  INSERT zabak_demo FROM TABLE t_data.

ENDMETHOD.


METHOD get_customer_for_context.
  DATA: kunnr TYPE kunnr,
        context TYPE string.

  WRITE / 'Demo: get customer for scenario'. ##NO_TEXT

  FORMAT INTENSIFIED OFF.

  DO 2 TIMES.
    CASE sy-index.
      WHEN 1.
        context = 'SCENARIO1'.
      WHEN 2.
        context = 'SCENARIO2'.
    ENDCASE.

    kunnr = go_abak->get_value( i_scope     = 'SD'
                                i_fieldname = 'KUNNR'
                                i_context   = context ).

    WRITE: / 'The customer for context', context, 'is', kunnr. ##NO_TEXT

  ENDDO.

  FORMAT INTENSIFIED ON.

ENDMETHOD.


METHOD get_demo_xml.
* Even though storing constants in a separate file better than hard coding them
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


METHOD GET_INSTANCE_STANDARD_DB.
  ro_abak = zcl_abak_factory=>get_standard_instance( i_format_type  = zif_abak_consts=>format_type-internal
                                                     i_source_type = zif_abak_consts=>source_type-database
                                                     i_content      = gc_demo_tablename ).
ENDMETHOD.


METHOD get_instance_standard_xml.
  DATA: xml TYPE string.

  xml = get_demo_xml( ).

  ro_abak = zcl_abak_factory=>get_standard_instance(
    i_format_type  = zif_abak_consts=>format_type-xml
    i_source_type = zif_abak_consts=>source_type-inline
    i_content      = xml ).
ENDMETHOD.


METHOD get_instance_zabak_db.
  ro_abak = zcl_abak_factory=>get_zabak_instance( 'ABAK_DEMO' ).
ENDMETHOD.


METHOD GET_OUR_COMPANY.
  data: bukrs type bukrs.

  WRITE / 'Demo: my own company'.

  bukrs = go_abak->get_value( i_scope     = 'GLOBAL'
                              i_fieldname = 'BUKRS' ).

  WRITE / bukrs INTENSIFIED OFF.

ENDMETHOD.


METHOD is_account_type_valid.
  DATA: koart TYPE koart.

  WRITE / 'Demo: is account type valid for PROJ1 scope?'. ##NO_TEXT

  FORMAT INTENSIFIED OFF.

  DO 2 TIMES.

    CASE sy-index.
      WHEN 1.
        koart = 'K'. " Valid
      WHEN 2.
        koart = '$'. " Invalid
    ENDCASE.

    IF go_abak->check_value( i_scope     = 'PROJ1'
                             i_fieldname = 'KOART'
                             i_value     = koart ) = abap_true.
      WRITE: / koart, 'Is a valid account type'. ##NO_TEXT
    ELSE.
      WRITE: / koart, 'Is NOT a valid account type'. ##NO_TEXT
    ENDIF.

  ENDDO.

  FORMAT INTENSIFIED ON.

ENDMETHOD.


METHOD IS_CURRENCY_VALID.

  DATA: waers   TYPE waers.

  WRITE / 'Demo: check if currency is valid for context PT'. ##NO_TEXT

  FORMAT INTENSIFIED OFF.

  DO 2 TIMES.
    CASE sy-index.
      WHEN 1.
        waers = 'EUR'.
      WHEN 2.
        waers = 'CAD'.
    ENDCASE.

    IF waers IN go_abak->get_range( i_scope = sy-cprog
                                    i_fieldname = 'WAERS'
                                    i_context   = 'PT' ).
      WRITE: / 'Currency', waers, 'is valid for PT'. ##NO_TEXT
    ELSE.
      WRITE: / 'Currency', waers, 'is NOT valid for PT'. ##NO_TEXT
    ENDIF.

  ENDDO.

  FORMAT INTENSIFIED ON.

ENDMETHOD.


METHOD validate_amount.

  DATA: wrbtr TYPE wrbtr.

  WRITE / 'Demo: validate amount'. ##NO_TEXT

  FORMAT INTENSIFIED OFF.

  DO 5 TIMES.
    CASE sy-index.
      WHEN 1.
        wrbtr = 500.
      WHEN 2.
        wrbtr = 1500.
      WHEN 3.
        wrbtr = 2500.
      WHEN 4.
        wrbtr = 3500.
      WHEN 5.
        wrbtr = 10500.
    ENDCASE.

    IF go_abak->check_value( i_scope = sy-cprog
                             i_fieldname = 'WRBTR'
                             i_value = wrbtr ) = abap_true.
      WRITE: / 'Value', wrbtr CURRENCY 'EUR', 'OK'. ##NO_TEXT
    ELSE.
      WRITE: / 'Value', wrbtr CURRENCY 'EUR', 'Not OK'. ##NO_TEXT
    ENDIF.

  ENDDO.

  FORMAT INTENSIFIED ON.

ENDMETHOD.
ENDCLASS.
