interface ZIF_ABAK_CONSTS
  public .


  constants VERSION type STRING value '0.21b'. "#EC NOTEXT
  constants:
    BEGIN OF content_type,
      database      TYPE zabak_content_type VALUE 'DB',
      inline        TYPE zabak_content_type VALUE 'INLINE',
      url           TYPE zabak_content_type VALUE 'URL',
      standard_text TYPE zabak_content_type VALUE 'SO10',
      set           TYPE zabak_content_type VALUE 'SET',
      file          TYPE zabak_content_type VALUE 'FILE',
      rfc           TYPE zabak_content_type VALUE 'RFC',
      custom        TYPE zabak_content_type VALUE 'CUSTOM',
    END OF content_type .
  constants:
    BEGIN OF format_type,
      internal TYPE zabak_format_type VALUE 'INTERNAL',
      xml      TYPE zabak_format_type VALUE 'XML',
      json     TYPE zabak_format_type VALUE 'JSON',
      csv      TYPE zabak_format_type VALUE 'CSV',
      custom   TYPE zabak_format_type VALUE 'CUSTOM',
    END OF format_type .
endinterface.
