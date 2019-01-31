FUNCTION z_abak_zabak_rfc_get .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_ID) TYPE  ZABAK_ID
*"  EXPORTING
*"     VALUE(E_SERIALIZED_DATA) TYPE  STRING
*"  EXCEPTIONS
*"      ERROR
*"----------------------------------------------------------------------

  DATA: o_abak_rfc TYPE REF TO zcl_abak_rfc.

  TRY.
      CREATE OBJECT o_abak_rfc.
      e_serialized_data = o_abak_rfc->get_data( i_id ).

    CATCH zcx_abak.
      RAISE error.
  ENDTRY.

ENDFUNCTION.
