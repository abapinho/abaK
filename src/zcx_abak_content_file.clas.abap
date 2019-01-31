class ZCX_ABAK_CONTENT_FILE definition
  public
  inheriting from ZCX_ABAK
  create public .

public section.

  constants:
    begin of ERROR_OPENING_FILE,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'FILEPATH',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ERROR_OPENING_FILE .
  data FILEPATH type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !FILEPATH type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_CONTENT_FILE IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->FILEPATH = FILEPATH .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
