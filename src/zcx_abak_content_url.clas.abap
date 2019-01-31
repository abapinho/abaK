class ZCX_ABAK_CONTENT_URL definition
  public
  inheriting from ZCX_ABAK
  create public .

public section.

  constants:
    begin of HTTP_ERROR,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '010',
      attr1 type scx_attrname value 'CODE',
      attr2 type scx_attrname value 'REASON',
      attr3 type scx_attrname value 'URL',
      attr4 type scx_attrname value '',
    end of HTTP_ERROR .
  data CODE type I .
  data REASON type STRING .
  data URL type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !CODE type I optional
      !REASON type STRING optional
      !URL type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_CONTENT_URL IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->CODE = CODE .
me->REASON = REASON .
me->URL = URL .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
