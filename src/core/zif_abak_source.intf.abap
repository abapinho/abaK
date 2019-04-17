interface ZIF_ABAK_SOURCE
  public .


  methods GET
    returning
      value(R_CONTENT) type STRING
    raising
      ZCX_ABAK .
  methods GET_TYPE
    returning
      value(R_TYPE) type ZABAK_SOURCE_TYPE .
  methods INVALIDATE
    raising
      ZCX_ABAK .
endinterface.
