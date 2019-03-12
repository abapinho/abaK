interface ZIF_ABAK_FORMAT
  public .


  methods CONVERT
    importing
      !I_DATA type STRING
    returning
      value(RT_K) type ZABAK_K_T
    raising
      ZCX_ABAK .
  methods GET_TYPE
    returning
      value(R_FORMAT_TYPE) type ZABAK_FORMAT_TYPE .
endinterface.
