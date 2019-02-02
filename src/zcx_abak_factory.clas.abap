class ZCX_ABAK_FACTORY definition
  public
  inheriting from ZCX_ABAK
  final
  create public .

public section.

  constants:
    begin of ID_NOT_FOUND,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '012',
      attr1 type scx_attrname value 'ID',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ID_NOT_FOUND .
  data ID type ZABAK_ID .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !ID type ZABAK_ID optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_FACTORY IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->ID = ID .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
