class ZCX_ABAK_ENGINE definition
  public
  inheriting from ZCX_ABAK
  final
  create public .

public section.

  constants:
    begin of VALUE_NOT_FOUND,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '009',
      attr1 type scx_attrname value 'SCOPE',
      attr2 type scx_attrname value 'FIELDNAME',
      attr3 type scx_attrname value 'CONTEXT',
      attr4 type scx_attrname value '',
    end of VALUE_NOT_FOUND .
  data SCOPE type ZABAK_SCOPE .
  data FIELDNAME type FELDNAME .
  data CONTEXT type ZABAK_CONTEXT .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !SCOPE type ZABAK_SCOPE optional
      !FIELDNAME type FELDNAME optional
      !CONTEXT type ZABAK_CONTEXT optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_ENGINE IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->SCOPE = SCOPE .
me->FIELDNAME = FIELDNAME .
me->CONTEXT = CONTEXT .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
