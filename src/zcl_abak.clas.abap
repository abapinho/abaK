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
  PRIVATE SECTION.

    DATA go_data TYPE REF TO zif_abak_data .

    METHODS get_value_aux
      IMPORTING
        value(i_scope) TYPE zabak_scope
        value(i_fieldname) TYPE name_feld
        value(i_context) TYPE any
      RETURNING
        value(r_value) TYPE zabak_low
      RAISING
        zcx_abak .
    METHODS convert_context
      IMPORTING
        !i_context TYPE any
      RETURNING
        value(r_context) TYPE zabak_context .
    METHODS check_value_aux
      IMPORTING
        value(i_scope) TYPE zabak_scope
        value(i_fieldname) TYPE name_feld
        value(i_context) TYPE any
        value(i_value) TYPE any
      RETURNING
        value(r_result) TYPE flag
      RAISING
        zcx_abak .
    METHODS get_range_aux
      IMPORTING
        value(i_scope) TYPE zabak_scope
        value(i_fieldname) TYPE name_feld
        value(i_context) TYPE any
      RETURNING
        value(rr_range) TYPE zabak_range_t
      RAISING
        zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK IMPLEMENTATION.


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


    DATA: t_kv TYPE zabak_kv_t,
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

    LOG-POINT ID zabak SUBKEY 'abak.check_value' FIELDS go_data->get_name( ) i_scope i_fieldname i_context i_value.

    r_result = check_value_aux( i_scope     = i_scope
                                i_fieldname = i_fieldname
                                i_context   = i_context
                                i_value     = i_value ).
  ENDMETHOD.


  METHOD zif_abak~check_value_if_exists.

    TRY.
        LOG-POINT ID zabak SUBKEY 'abak.check_value_if_exists' FIELDS go_data->get_name( ) i_scope i_fieldname i_context i_value.

        r_result = check_value_aux( i_scope     = i_scope
                                    i_fieldname = i_fieldname
                                    i_context   = i_context
                                    i_value     = i_value ).

      CATCH zcx_abak.
        RETURN. " No problem if it does not exist
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abak~get_range.

    LOG-POINT ID zabak SUBKEY 'abak.get_range' FIELDS go_data->get_name( ) i_scope i_fieldname i_context.

    rr_range = get_range_aux( i_scope     = i_scope
                              i_fieldname = i_fieldname
                              i_context   = i_context ).

  ENDMETHOD.


  METHOD zif_abak~get_range_if_exists.

    TRY.

        LOG-POINT ID zabak SUBKEY 'abak.get_range_if_exists' FIELDS go_data->get_name( ) i_scope i_fieldname i_context.

        rr_range = get_range_aux( i_scope     = i_scope
                                  i_fieldname = i_fieldname
                                  i_context   = i_context ).

      CATCH zcx_abak.
        RETURN. " No problem if it does not exist
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abak~get_value.

    LOG-POINT ID zabak SUBKEY 'abak.get_value' FIELDS go_data->get_name( ) i_scope i_fieldname i_context.

    r_value = get_value_aux( i_scope     = i_scope
                             i_fieldname = i_fieldname
                             i_context   = i_context ).

  ENDMETHOD.


  METHOD zif_abak~get_value_if_exists.

    TRY.
        LOG-POINT ID zabak SUBKEY 'abak.get_value_if_exists' FIELDS go_data->get_name( ) i_scope i_fieldname i_context.

        r_value = get_value_aux( i_scope     = i_scope
                                 i_fieldname = i_fieldname
                                 i_context   = i_context ).

      CATCH zcx_abak.
        RETURN. " No problem if it does not exist
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abak~invalidate.

    LOG-POINT ID zabak SUBKEY 'abak.invalidate' FIELDS go_data->get_name( ).

    go_data->invalidate( ).

  ENDMETHOD.
ENDCLASS.
