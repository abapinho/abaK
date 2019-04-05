CLASS zcl_abak_source_url DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_url TYPE string
        !i_proxy_host TYPE string OPTIONAL
        !i_proxy_service TYPE string OPTIONAL
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    DATA g_url TYPE string .
    DATA g_proxy_host TYPE string .
    DATA g_proxy_service TYPE string .
    CONSTANTS gc_regex_url TYPE string VALUE '^(?:https?|ftp):\/\/[\w\-\.]+\.[\w]{2,4}[\w\/+=%&_\.~?\-]*$'. "#EC NOTEXT

    METHODS check_url
      IMPORTING
        !i_url TYPE string
      RAISING
        zcx_abak .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_URL IMPLEMENTATION.


  METHOD check_url.
    DATA: o_tools TYPE REF TO zcl_abak_tools.

    CREATE OBJECT o_tools.
    o_tools->check_against_regex( i_regex = gc_regex_url
                                  i_value = i_url ).
  ENDMETHOD.


  METHOD constructor.

    IF i_url IS INITIAL.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          textid = zcx_abak=>invalid_parameters.
    ENDIF.

    super->constructor( ).

    check_url( i_url ).

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
      RAISE EXCEPTION TYPE zcx_abak_source_url
        EXPORTING
          textid = zcx_abak_source_url=>http_error
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


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-url.
  ENDMETHOD.
ENDCLASS.
