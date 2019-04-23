interface ZIF_ABAK_CONSTS
  public .


  constants VERSION type STRING value '0.23b'. "#EC NOTEXT
  constants:
    BEGIN OF source_type,
      database      TYPE zabak_source_type VALUE 'DB',
      inline        TYPE zabak_source_type VALUE 'INLINE',
      file          TYPE zabak_source_type VALUE 'FILE',
      mime          type zabak_source_type value 'MIME',
      rfc           TYPE zabak_source_type VALUE 'RFC',
      standard_text TYPE zabak_source_type VALUE 'SO10',
      url           TYPE zabak_source_type VALUE 'URL',
    END OF source_type .
  constants:
    BEGIN OF format_type,
      internal TYPE zabak_format_type VALUE 'INTERNAL',
      xml      TYPE zabak_format_type VALUE 'XML',
      json     TYPE zabak_format_type VALUE 'JSON',
      csv      TYPE zabak_format_type VALUE 'CSV',
    END OF format_type .
endinterface.
