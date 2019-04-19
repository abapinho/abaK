CLASS zcx_abak_engine DEFINITION
  PUBLIC
  INHERITING FROM zcx_abak
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

  CONSTANTS:
    BEGIN OF value_not_found,
      msgid TYPE symsgid VALUE 'ZABAK',
      msgno TYPE symsgno VALUE '009',
      attr1 TYPE scx_attrname VALUE 'SCOPE',
      attr2 TYPE scx_attrname VALUE 'FIELDNAME',
      attr3 TYPE scx_attrname VALUE 'CONTEXT',
      attr4 TYPE scx_attrname VALUE '',
    END OF value_not_found .
  DATA scope TYPE zabak_scope .
  DATA fieldname TYPE fieldname .
  DATA context TYPE zabak_context .

  METHODS constructor
    IMPORTING
      !textid LIKE if_t100_message=>t100key OPTIONAL
      !previous LIKE previous OPTIONAL
      !previous_from_syst TYPE flag OPTIONAL
      !scope TYPE zabak_scope OPTIONAL
      !fieldname TYPE fieldname OPTIONAL
      !context TYPE zabak_context OPTIONAL .
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcx_abak_engine IMPLEMENTATION.


METHOD constructor ##ADT_SUPPRESS_GENERATION.
CALL METHOD super->constructor
EXPORTING
previous = previous
previous_from_syst = previous_from_syst
.
me->scope = scope .
me->fieldname = fieldname .
me->context = context .
CLEAR me->textid.
IF textid IS INITIAL.
  if_t100_message~t100key = if_t100_message=>default_textid.
ELSE.
  if_t100_message~t100key = textid.
ENDIF.
ENDMETHOD.
ENDCLASS.
