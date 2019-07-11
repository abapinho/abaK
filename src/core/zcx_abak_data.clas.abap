class ZCX_ABAK_DATA definition
  public
  inheriting from ZCX_ABAK
  final
  create public .

public section.

  constants:
    begin of INVALID_SIGN,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'SIGN',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_SIGN .
  constants:
    begin of INVALID_OPTION,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'OPTION',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_OPTION .
  constants:
    begin of HIGH_MUST_BE_EMPTY,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '004',
      attr1 type scx_attrname value 'OPTION',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of HIGH_MUST_BE_EMPTY .
  constants:
    begin of LOW_HIGH_MUST_BE_FILLED,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '005',
      attr1 type scx_attrname value 'OPTION',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of LOW_HIGH_MUST_BE_FILLED .
  constants:
    begin of HIGH_MUST_BE_GT_LOW,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '006',
      attr1 type scx_attrname value 'OPTION',
      attr2 type scx_attrname value 'HIGH',
      attr3 type scx_attrname value 'LOW',
      attr4 type scx_attrname value '',
    end of HIGH_MUST_BE_GT_LOW .
  constants:
    begin of MULTI_OPTION_NOT_EQ,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '014',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MULTI_OPTION_NOT_EQ .
  constants:
    begin of MULTI_SIGN_NOT_I,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '015',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MULTI_SIGN_NOT_I .
  constants:
    begin of MULTI_FIELDNAME_VALUE_MISMATCH,
      msgid type symsgid value 'ZABAK',
      msgno type symsgno value '018',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of MULTI_FIELDNAME_VALUE_MISMATCH .
  data SIGN type BAPISIGN .
  data OPTION type BAPIOPTION .
  data LOW type ZABAK_LOW .
  data HIGH type ZABAK_HIGH .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !PREVIOUS_FROM_SYST type FLAG optional
      !SIGN type BAPISIGN optional
      !OPTION type BAPIOPTION optional
      !LOW type ZABAK_LOW optional
      !HIGH type ZABAK_HIGH optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_ABAK_DATA IMPLEMENTATION.


method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
PREVIOUS_FROM_SYST = PREVIOUS_FROM_SYST
.
me->SIGN = SIGN .
me->OPTION = OPTION .
me->LOW = LOW .
me->HIGH = HIGH .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
endmethod.
ENDCLASS.
