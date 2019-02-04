class ZCL_ABAK_TOOLS definition
  public
  final
  create public .

public section.

  methods CREATE_TABLE
    importing
      value(I_TABLENAME) type TABNAME
      !I_DEVCLASS type DEVCLASS
    raising
      ZCX_ABAK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ABAK_TOOLS IMPLEMENTATION.


METHOD create_table.

  DATA: name        TYPE  ddobjname,
        s_dd02v_wa  TYPE  dd02v,
        s_dd09l_wa  TYPE  dd09v,
        t_dd03p_tab TYPE STANDARD TABLE OF dd03p,
        s_dd03p_tab LIKE LINE OF t_dd03p_tab,
        rc          TYPE sysubrc,
        obj_name    TYPE sobj_name.

  CALL FUNCTION 'DDIF_TABL_GET'
    EXPORTING
      name          = 'ZABAK_DEFAULT'
    IMPORTING
      dd02v_wa      = s_dd02v_wa
      dd09l_wa      = s_dd09l_wa
    TABLES
      dd03p_tab     = t_dd03p_tab
    EXCEPTIONS
      illegal_input = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  i_tablename = 'ZABAK123'.
  s_dd02v_wa-tabname = i_tablename.
  s_dd02v_wa-ddtext = i_tablename.
  s_dd02v_wa-ddlanguage = sy-langu.
  s_dd09l_wa-tabname = i_tablename.

  s_dd03p_tab-tabname = i_tablename.
  MODIFY t_dd03p_tab FROM s_dd03p_tab TRANSPORTING tabname WHERE tabname <> i_tablename.
  DELETE t_dd03p_tab WHERE fieldname <> '.INCLUDE'.

  CALL FUNCTION 'DDIF_TABL_PUT'
    EXPORTING
      name              = i_tablename
      dd02v_wa          = s_dd02v_wa
      dd09l_wa          = s_dd09l_wa
    TABLES
      dd03p_tab         = t_dd03p_tab
    EXCEPTIONS
      tabl_not_found    = 1
      name_inconsistent = 2
      tabl_inconsistent = 3
      put_failure       = 4
      put_refused       = 5
      OTHERS            = 6.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  obj_name = i_tablename.
  CALL FUNCTION 'TR_TADIR_INTERFACE'
    EXPORTING
      wi_test_modus                  = space
      wi_tadir_pgmid                 = 'R3TR'
      wi_tadir_object                = 'TABL'
      wi_tadir_obj_name              = obj_name
      wi_tadir_devclass              = i_devclass
      wi_set_genflag                 = abap_true
    EXCEPTIONS
      tadir_entry_not_existing       = 1
      tadir_entry_ill_type           = 2
      no_systemname                  = 3
      no_systemtype                  = 4
      original_system_conflict       = 5
      object_reserved_for_devclass   = 6
      object_exists_global           = 7
      object_exists_local            = 8
      object_is_distributed          = 9
      obj_specification_not_unique   = 10
      no_authorization_to_delete     = 11
      devclass_not_existing          = 12
      simultanious_set_remove_repair = 13
      order_missing                  = 14
      no_modification_of_head_syst   = 15
      pgmid_object_not_allowed       = 16
      masterlanguage_not_specified   = 17
      devclass_not_specified         = 18
      specify_owner_unique           = 19
      loc_priv_objs_no_repair        = 20
      gtadir_not_reached             = 21
      object_locked_for_order        = 22
      change_of_class_not_allowed    = 23
      no_change_from_sap_to_tmp      = 24
      OTHERS                         = 25.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  CALL FUNCTION 'DDIF_TABL_ACTIVATE'
    EXPORTING
      name        = i_tablename
      auth_chk    = abap_false
    IMPORTING
      rc          = rc
    EXCEPTIONS
      not_found   = 1
      put_failure = 2
      OTHERS      = 3.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  IF rc = 0.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
    RAISE EXCEPTION TYPE zcx_abak.
  ENDIF.

ENDMETHOD.
ENDCLASS.
