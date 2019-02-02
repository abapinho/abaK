INTERFACE zif_abak_consts
  PUBLIC .

  CONSTANTS version TYPE string VALUE '0.1-alpha'.          "#EC NOTEXT

  CONSTANTS:
    BEGIN OF content_type,
      inline        TYPE zabak_content_type VALUE 'INLINE',
      url           TYPE zabak_content_type VALUE 'URL',
      standard_text TYPE zabak_content_type VALUE 'SO10',
      file          TYPE zabak_content_type VALUE 'FILE',
      rfc           TYPE zabak_content_type VALUE 'RFC',
      custom        TYPE zabak_content_type VALUE 'CUSTOM',
    END OF content_type .

  CONSTANTS:
    BEGIN OF format_type,
      database TYPE zabak_format_type VALUE 'DB',
      xml      TYPE zabak_format_type VALUE 'XML',
      json     TYPE zabak_format_type VALUE 'JSON',
      csv      TYPE zabak_format_type VALUE 'CSV',
      custom   TYPE zabak_format_type VALUE 'CUSTOM',
    END OF format_type .

ENDINTERFACE.
