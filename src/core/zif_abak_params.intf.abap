interface ZIF_ABAK_PARAMS
  public .


  methods GET
    importing
      !I_NAME type STRING
    returning
      value(R_VALUE) type STRING
    raising
      ZCX_ABAK .
endinterface.
