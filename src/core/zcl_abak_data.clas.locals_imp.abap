* Mock class to be able to instantiate _DATA in unit tests (since it is abstract)
CLASS lcl_data_for_utests DEFINITION
  FINAL
  INHERITING FROM zcl_abak_data.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING it_k TYPE zabak_k_t.

  PROTECTED SECTION.
    METHODS load_data_aux REDEFINITION.
    METHODS invalidate_aux REDEFINITION.

  PRIVATE SECTION.
    DATA: gt_k TYPE zabak_k_t.
ENDCLASS.

CLASS lcl_data_for_utests IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    gt_k = it_k.
  ENDMETHOD.

  METHOD load_data_aux.
    rt_k[] = gt_k[].
  ENDMETHOD.

  METHOD invalidate_aux.
    RETURN.
  ENDMETHOD.

ENDCLASS.
