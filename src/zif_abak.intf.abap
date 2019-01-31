interface ZIF_ABAK
  public .


  methods GET_VALUE
    importing
      value(I_SCOPE) type ZABAK_SCOPE optional
      value(I_FIELDNAME) type NAME_FELD
      value(I_CONTEXT) type ANY default ' '
    returning
      value(R_VALUE) type ZABAK_LOW
    raising
      ZCX_ABAK .
  methods GET_VALUE_IF_EXISTS
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type NAME_FELD
      value(I_CONTEXT) type ANY default ' '
    returning
      value(R_VALUE) type ZABAK_LOW .
  methods GET_RANGE
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type NAME_FELD
      value(I_CONTEXT) type ANY default ' '
    returning
      value(RR_RANGE) type ZABAK_RANGE_T
    raising
      ZCX_ABAK .
  methods GET_RANGE_IF_EXISTS
    importing
      value(I_SCOPE) type ZABAK_SCOPE
      value(I_FIELDNAME) type NAME_FELD
      value(I_CONTEXT) type ANY default ' '
    returning
      value(RR_RANGE) type ZABAK_RANGE_T .
  methods CHECK_VALUE
    importing
      !I_SCOPE type ZABAK_SCOPE
      !I_FIELDNAME type NAME_FELD
      !I_CONTEXT type ANY default ' '
      !I_VALUE type ANY
    returning
      value(R_RESULT) type FLAG
    raising
      ZCX_ABAK .
  methods CHECK_VALUE_IF_EXISTS
    importing
      !I_SCOPE type ZABAK_SCOPE
      !I_FIELDNAME type NAME_FELD
      !I_CONTEXT type ANY default ' '
      !I_VALUE type ANY
    returning
      value(R_RESULT) type FLAG .
  methods INVALIDATE
    raising
      ZCX_ABAK .
endinterface.
