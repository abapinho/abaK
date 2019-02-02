REPORT zabak_demo.

* See https://github.com/abapinho/abaK

********************************************************************************
* MIT License
*
* Copyright (c) 2018 Nuno Godinho
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
********************************************************************************

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-sou.
PARAMETERS p_db RADIOBUTTON GROUP g.
PARAMETERS p_zabak RADIOBUTTON GROUP g.
PARAMETERS p_xml RADIOBUTTON GROUP g.
SELECTION-SCREEN END OF BLOCK b1.

DATA: go_exp     TYPE REF TO zcx_abak,
      go_demo    TYPE REF TO zcl_abak_demo,
      which_demo TYPE string,
      txt        TYPE string.

START-OF-SELECTION.

  sy-title = |{ sy-title } (version { zif_abak_consts=>version })|.

  CASE abap_true.
    WHEN p_db.
      which_demo = 'DB'.
    WHEN p_zabak.
      which_demo = 'ZABAK'.
    WHEN p_xml.
      which_demo = 'XML'.
  ENDCASE.

  TRY.
      CREATE OBJECT go_demo
        EXPORTING
          i_which_demo = which_demo.

      go_demo->get_our_company( ).
      SKIP.
      go_demo->is_account_type_valid( ).
      SKIP.
      go_demo->get_customer_for_context( ).
      SKIP.
      go_demo->is_currency_valid( ).
      SKIP.
      go_demo->validate_amount( ).

    CATCH zcx_abak INTO go_exp.
      txt = go_exp->get_text( ).
      WRITE: / 'Error:', txt.
  ENDTRY.
