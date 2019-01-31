class ZCX_ABAK_FORMAT_DB definition
  public
  inheriting from ZCX_ABAK
  final
  create public .

public section.

  constants:
    begin of INVALID_TABLE_FORMAT,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '007',
      attr1 type scx_attrname value 'TABLENAME',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_TABLE_FORMAT .
  data TABLENAME type TABNAME .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !TABLENAME type TABNAME optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_FORMAT_DB IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->TABLENAME = TABLENAME .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
