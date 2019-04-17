* Build exception instance from SYST message fields
* Inspiration: http://help.sap.com/abapdocu_740/en/abenmessage_interface_abexa.htm

class lcx_t100_syst definition inheriting from cx_dynamic_check final.
  public section.
    interfaces if_t100_message.
    methods constructor.
    data msgv1 type symsgv.
    data msgv2 type symsgv.
    data msgv3 type symsgv.
    data msgv4 type symsgv.
endclass.                    "cx_t100 DEFINITION

*----------------------------------------------------------------------*
*       CLASS cx_t100 IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class lcx_t100_syst implementation.
  method constructor.
    super->constructor( ).
    me->msgv1 = sy-msgv1.
    me->msgv2 = sy-msgv2.
    me->msgv3 = sy-msgv3.
    me->msgv4 = sy-msgv4.
    if_t100_message~t100key-msgid = sy-msgid.
    if_t100_message~t100key-msgno = sy-msgno.
    if_t100_message~t100key-attr1 = 'MSGV1'.
    if_t100_message~t100key-attr2 = 'MSGV2'.
    if_t100_message~t100key-attr3 = 'MSGV3'.
    if_t100_message~t100key-attr4 = 'MSGV4'.
  endmethod.                    "constructor
endclass.                    "cx_t100 IMPLEMENTATION
