interface ZIF_ABAK
  public .


  methods GET_VALUE
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY default ' '
    returning
      value(R_VALUE) type ZABAK_LOW
    raising
      ZCX_ABAK .
  methods GET_VALUE_IF_EXISTS
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY default ' '
    returning
      value(R_VALUE) type ZABAK_LOW .
  methods GET_RANGE
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY default ' '
    returning
      value(RR_RANGE) type ZABAK_RANGE_T
    raising
      ZCX_ABAK .
  methods GET_RANGE_IF_EXISTS
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY default ' '
    returning
      value(RR_RANGE) type ZABAK_RANGE_T .
  methods CHECK_VALUE
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY optional
      !I_VALUE type ANY
    returning
      value(R_RESULT) type FLAG
    raising
      ZCX_ABAK .
  methods CHECK_VALUE_IF_EXISTS
    importing
      !I_SCOPE type ZABAK_SCOPE optional
      !I_FIELDNAME type ZABAK_FIELDNAME
      !I_CONTEXT type ANY default ' '
      !I_VALUE type ANY
    returning
      value(R_RESULT) type FLAG .
  methods INVALIDATE
    raising
      ZCX_ABAK .
endinterface.
