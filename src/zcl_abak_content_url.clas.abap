class ZCL_ABAK_CONTENT_URL definition
  public
  inheriting from ZCL_ABAK_CONTENT
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_URL type STRING
      !I_PROXY_HOST type STRING optional
      !I_PROXY_SERVICE type STRING optional
    raising
      ZCX_ABAK .

  methods ZIF_ABAK_CONTENT~GET_TYPE
    redefinition .
protected section.

  methods LOAD
    redefinition .
private section.

  data G_URL type STRING .
  data G_PROXY_HOST type STRING .
  data G_PROXY_SERVICE type STRING .
ENDCLASS.



CLASS ZCL_ABAK_CONTENT_URL IMPLEMENTATION.


  METHOD constructor.

    IF i_url IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    super->constructor( ).

    g_url = i_url.
    g_proxy_host = i_proxy_host.
    g_proxy_service = i_proxy_service.

  ENDMETHOD.


METHOD load.

  DATA: o_http_client TYPE REF TO if_http_client,
        code          TYPE i,
        reason        TYPE string.

  LOG-POINT ID zabak SUBKEY 'content_url.load' FIELDS g_url g_proxy_host g_proxy_service.

  cl_http_client=>create_by_url(
    EXPORTING
      url                = g_url
      ssl_id             = 'ANONYM'
      proxy_host         = g_proxy_host
      proxy_service      = g_proxy_service
    IMPORTING
      client             = o_http_client
    EXCEPTIONS
      argument_not_found = 1
      plugin_not_active  = 2
      internal_error     = 3
      OTHERS             = 4 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  o_http_client->send(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      http_invalid_timeout       = 4
      OTHERS                     = 5 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  o_http_client->receive(
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 4 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  o_http_client->response->get_status( IMPORTING code   = code
                                                 reason = reason ).
  IF code <> 200.
    RAISE EXCEPTION TYPE zcx_abak_content_url
      EXPORTING
        textid = zcx_abak_content_url=>http_error
        code   = code
        reason = reason
        url    = g_url.
  ENDIF.

  r_content = o_http_client->response->get_cdata( ).

  o_http_client->close(
    EXCEPTIONS
      http_invalid_state = 1
      OTHERS             = 2 ).
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

ENDMETHOD.


METHOD zif_abak_content~get_type.
  r_type = zif_abak_consts=>content_type-url.
ENDMETHOD.
ENDCLASS.
