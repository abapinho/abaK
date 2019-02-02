REPORT zabak_usage.

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

DATA: go_usage TYPE REF TO zcl_abak_usage.

START-OF-SELECTION.

  CREATE OBJECT go_usage.

  PERFORM list_subclasses.
  SKIP.
  PERFORM list_zabak.
  SKIP.
  PERFORM list_where_used.

FORM list_subclasses.
  DATA: t_class TYPE seo_class_names,
        class   LIKE LINE OF t_class.

  WRITE / 'Content classes (implementing ZIF_ABAK_CONTENT):'.
  t_class = go_usage->get_subclasses( 'ZIF_ABAK_CONTENT' ).
  LOOP AT t_class INTO class.
    WRITE: / class INTENSIFIED OFF.
  ENDLOOP.

  SKIP.

  WRITE / 'Format classes (implementing ZIF_ABAK_FORMAT):'.
  t_class = go_usage->get_subclasses( 'ZIF_ABAK_FORMAT' ).
  LOOP AT t_class INTO class.
    WRITE: / class INTENSIFIED OFF.
  ENDLOOP.

ENDFORM.

FORM list_where_used.
  DATA: t_tadir TYPE tt_tadir.
  FIELD-SYMBOLS: <s_tadir> LIKE LINE OF t_tadir.

  WRITE : / 'abaK usage (objects using class ZCL_ABAK_FACTORY outside the abaK package):'.
  FORMAT INTENSIFIED OFF.
  t_tadir = go_usage->get_where_used( ).
  LOOP AT t_tadir ASSIGNING <s_tadir>.
    WRITE: / <s_tadir>-object, <s_tadir>-obj_name, <s_tadir>-devclass.
  ENDLOOP.
  IF sy-subrc <> 0.
    WRITE: / 'No objects found'.
  ENDIF.
  FORMAT INTENSIFIED ON.
ENDFORM.

FORM list_zabak.
  DATA: t_zabak TYPE zcl_abak_usage=>ty_zabak_t.
  FIELD-SYMBOLS: <s_zabak> LIKE LINE OF t_zabak.

  WRITE : / 'ZABAK records:'.
  FORMAT INTENSIFIED OFF.
  t_zabak = go_usage->get_zabak( ).
  LOOP AT t_zabak ASSIGNING <s_zabak>.
    WRITE / <s_zabak>.
  ENDLOOP.
  IF sy-subrc <> 0.
    WRITE / 'Empty'.
  ENDIF.
  FORMAT INTENSIFIED ON.
ENDFORM.
