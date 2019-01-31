interface ZIF_ABAK_FORMAT
  public .


  methods CONVERT
    importing
      !I_DATA type STRING
    exporting
      !ET_K type ZABAK_K_T
      !E_NAME type STRING
    raising
      ZCX_ABAK .
  methods GET_TYPE
    returning
      value(R_FORMAT_TYPE) type ZABAK_FORMAT_TYPE .
endinterface.
