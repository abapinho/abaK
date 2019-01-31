interface ZIF_ABAK_CONSTS
  public .


  constants:
    BEGIN OF content_type,
      inline        TYPE zabak_content_type VALUE 'INLINE',
      url           TYPE zabak_content_type VALUE 'URL',
      standard_text TYPE zabak_content_type VALUE 'SO10',
      file          TYPE zabak_content_type VALUE 'FILE',
      rfc           type zabak_content_type value 'RFC',
      custom        TYPE zabak_content_type VALUE 'CUSTOM',
    END OF content_type .
  constants:
    BEGIN OF format_type,
      database TYPE zabak_format_type VALUE 'DB',
      xml      TYPE zabak_format_type VALUE 'XML',
      csv      TYPE zabak_format_type VALUE 'CSV',
      custom   TYPE zabak_format_type VALUE 'CUSTOM',
      rfc      type zabak_format_type value 'RFC',
    END OF format_type .
  constants VERSION type STRING value '0.1-alpha'. "#EC NOTEXT
endinterface.
