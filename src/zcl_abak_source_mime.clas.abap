CLASS zcl_abak_source_mime DEFINITION
  PUBLIC
  INHERITING FROM zcl_abak_source
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !i_url TYPE string
      RAISING
        zcx_abak .

    METHODS zif_abak_source~get_type
      REDEFINITION .
  PROTECTED SECTION.

    METHODS load
      REDEFINITION .
  PRIVATE SECTION.

    DATA g_url TYPE string .
ENDCLASS.



CLASS ZCL_ABAK_SOURCE_MIME IMPLEMENTATION.


  METHOD constructor.

    super->constructor( ).

    g_url = i_url.

  ENDMETHOD.


  METHOD load.
    DATA:
        o_mime_repository TYPE REF TO if_mr_api,
        xcontent TYPE xstring.

    LOG-POINT ID zabak SUBKEY 'content_mime.load' FIELDS g_url.

    o_mime_repository = cl_mime_repository_api=>get_api( ).

    o_mime_repository->get(
      EXPORTING
        i_url                  = g_url
      IMPORTING
        e_content              = xcontent
      EXCEPTIONS
        parameter_missing      = 1
        error_occured          = 2
        not_found              = 3
        permission_failure     = 4
        OTHERS                 = 5 ).
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_abak
        EXPORTING
          previous_from_syst = abap_true.
    ENDIF.

    r_content = cl_bcs_convert=>xstring_to_string( iv_xstr   = xcontent
                                                   iv_cp     = '4210' ). " TODO fixed UTF-8 for PCL Printers

  ENDMETHOD.


  METHOD zif_abak_source~get_type.
    r_type = zif_abak_consts=>source_type-mime.
  ENDMETHOD.
ENDCLASS.
