class ZCL_ABAK definition
  public
  final
  create private

  global friends ZCL_ABAK_FACTORY .

public section.

  interfaces ZIF_ABAK .

  methods CONSTRUCTOR
    importing
      !IO_DATA type ref to ZIF_ABAK_DATA
    raising
      ZCX_ABAK .
  PROTECTED SECTION.
private section.

  data GO_DATA type ref to ZIF_ABAK_DATA .

  methods GET_VALUE_AUX
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type ZABAK_FIELDNAME
      value(I_CONTEXT) type ANY
    returning
      value(R_VALUE) type ZABAK_LOW
    raising
      ZCX_ABAK .
  methods CONVERT_CONTEXT
    importing
      !I_CONTEXT type ANY
    returning
      value(R_CONTEXT) type ZABAK_CONTEXT .
  methods CHECK_VALUE_AUX
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type ZABAK_FIELDNAME
      value(I_CONTEXT) type ANY
      value(I_VALUE) type ANY
    returning
      value(R_RESULT) type FLAG
    raising
      ZCX_ABAK .
  methods GET_RANGE_AUX
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type ZABAK_FIELDNAME
      value(I_CONTEXT) type ANY
    returning
      value(RR_RANGE) type ZABAK_RANGE_T
    raising
      ZCX_ABAK .
  methods CHECK_RANGE_FIELDNAME
    importing
      !I_FIELDNAME type ZABAK_FIELDNAME
    raising
      ZCX_ABAK .
ENDCLASS.



CLASS ZCL_ABAK IMPLEMENTATION.


METHOD check_range_fieldname.
  DATA: t_field TYPE STANDARD TABLE OF string.

*   Get range not possible for multiple fields
  SPLIT i_fieldname AT space INTO TABLE t_field.
  IF lines( t_field ) <> 1.
    RAISE EXCEPTION TYPE zcx_abak_engine. " TODO
  ENDIF.
ENDMETHOD.


  METHOD check_value_aux.

    DATA: r_range TYPE zabak_range_t.

    r_range = get_range_aux( i_scope     = i_scope
                             i_fieldname = i_fieldname
                            i_context   = i_context ).
    IF r_range[] IS INITIAL.
      RETURN.
    ELSEIF i_value IN r_range.
      r_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    IF io_data IS NOT BOUND.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    go_data = io_data.

  ENDMETHOD.


  METHOD convert_context.
    WRITE i_context TO r_context LEFT-JUSTIFIED.
  ENDMETHOD.


  METHOD get_range_aux.
    DATA: t_kv    TYPE zabak_kv_t,
          context TYPE zabak_context.

    DATA: s_range LIKE LINE OF rr_range.

    FIELD-SYMBOLS: <s_kv> LIKE LINE OF t_kv.

    context = convert_context( i_context ).

    t_kv = go_data->read( i_scope     = i_scope
                         i_fieldname = i_fieldname
                         i_context   = context ).

    LOOP AT t_kv ASSIGNING <s_kv>.
      CLEAR s_range.
      s_range-sign = <s_kv>-sign.
      s_range-option = <s_kv>-option.
      s_range-low = <s_kv>-low.
      s_range-high = <s_kv>-high.
      INSERT s_range INTO TABLE rr_range.
    ENDLOOP.

    IF rr_range[] IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak_engine
        EXPORTING
          textid    = zcx_abak_engine=>value_not_found
          scope     = i_scope
          fieldname = i_fieldname
          context   = context.
    ENDIF.

  ENDMETHOD.


  METHOD get_value_aux.

    DATA: t_kv TYPE zabak_kv_t,
          context type zabak_context.

    FIELD-SYMBOLS: <s_kv> LIKE LINE OF t_kv.

    context = convert_context( i_context ).

    t_kv = go_data->read( i_scope     = i_scope
                          i_fieldname = i_fieldname
                          i_context   = context ).

    READ TABLE t_kv ASSIGNING <s_kv> INDEX 1.

    IF sy-subrc = 0.
      r_value = <s_kv>-low.

    ELSE.
      RAISE EXCEPTION TYPE zcx_abak_engine
        EXPORTING
          textid    = zcx_abak_engine=>value_not_found
          scope     = i_scope
          fieldname = i_fieldname
          context   = context.
    ENDIF.

  ENDMETHOD.


  METHOD zif_abak~check_value.

    LOG-POINT ID zabak SUBKEY 'abak.check_value' FIELDS i_scope i_fieldname i_context i_value.

    r_result = check_value_aux( i_scope     = i_scope
                                i_fieldname = i_fieldname
                                i_context   = i_context
                                i_value     = i_value ).
  ENDMETHOD.


  METHOD zif_abak~check_value_if_exists.

    TRY.
        LOG-POINT ID zabak SUBKEY 'abak.check_value_if_exists' FIELDS i_scope i_fieldname i_context i_value.

        r_result = check_value_aux( i_scope     = i_scope
                                    i_fieldname = i_fieldname
                                    i_context   = i_context
                                    i_value     = i_value ).

      CATCH zcx_abak.
        CLEAR r_result. " No problem if it does not exist
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abak~get_range.

    LOG-POINT ID zabak SUBKEY 'abak.get_range' FIELDS i_scope i_fieldname i_context.

    check_range_fieldname( i_fieldname ).

    rr_range = get_range_aux( i_scope     = i_scope
                              i_fieldname = i_fieldname
                              i_context   = i_context ).

  ENDMETHOD.


  METHOD zif_abak~get_range_if_exists.
    TRY.
        LOG-POINT ID zabak SUBKEY 'abak.get_range_if_exists' FIELDS i_scope i_fieldname i_context.

        rr_range = get_range_aux( i_scope     = i_scope
                                  i_fieldname = i_fieldname
                                  i_context   = i_context ).

      CATCH zcx_abak.
        CLEAR rr_range. " No problem if it does not exist
    ENDTRY.
  ENDMETHOD.


  METHOD zif_abak~get_value.

    LOG-POINT ID zabak SUBKEY 'abak.get_value' FIELDS i_scope i_fieldname i_context.

    r_value = get_value_aux( i_scope     = i_scope
                             i_fieldname = i_fieldname
                             i_context   = i_context ).

  ENDMETHOD.


  METHOD zif_abak~get_value_if_exists.

    TRY.
        LOG-POINT ID zabak SUBKEY 'abak.get_value_if_exists' FIELDS i_scope i_fieldname i_context.

        r_value = get_value_aux( i_scope     = i_scope
                                 i_fieldname = i_fieldname
                                 i_context   = i_context ).

      CATCH zcx_abak.
        CLEAR r_value. " No problem if it does not exist
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abak~invalidate.

    LOG-POINT ID zabak SUBKEY 'abak.invalidate'.

    go_data->invalidate( ).

  ENDMETHOD.
ENDCLASS.
