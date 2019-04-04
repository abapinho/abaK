interface ZIF_ABAK_CONSTS
  public .


  constants VERSION type STRING value '0.22b'. "#EC NOTEXT
  constants:
    BEGIN OF content_type,
      database      TYPE zabak_content_type VALUE 'DB',
      inline        TYPE zabak_content_type VALUE 'INLINE',
      file          TYPE zabak_content_type VALUE 'FILE',
      mime          type zabak_content_type value 'MIME',
      rfc           TYPE zabak_content_type VALUE 'RFC',
      set           TYPE zabak_content_type VALUE 'SET',
      standard_text TYPE zabak_content_type VALUE 'SO10',
      url           TYPE zabak_content_type VALUE 'URL',
    END OF content_type .
  constants:
    BEGIN OF format_type,
      internal TYPE zabak_format_type VALUE 'INTERNAL',
      xml      TYPE zabak_format_type VALUE 'XML',
      json     TYPE zabak_format_type VALUE 'JSON',
      csv      TYPE zabak_format_type VALUE 'CSV',
    END OF format_type .
endinterface.
