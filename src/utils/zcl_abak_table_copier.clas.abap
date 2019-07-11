class ZCL_ABAK_TABLE_COPIER definition
  public
  final
  create public .

public section.

  methods COPY
    importing
      !I_TABLENAME type TABNAME
      !I_DEVCLASS type DEVCLASS
    raising
      ZCX_ABAK .
protected section.
private section.

  methods CREATE_TABLE
    importing
      value(I_TABLENAME) type TABNAME
    raising
      ZCX_ABAK .
  methods INSERT_IN_TADIR
    importing
      value(I_TABLENAME) type TABNAME
      !I_DEVCLASS type DEVCLASS
    raising
      ZCX_ABAK .
  methods ACTIVATE
    importing
      !I_TABLENAME type TABNAME
    raising
      ZCX_ABAK .
  methods ACTIVATE2
    importing
      !I_TABLENAME type TABNAME
    raising
      ZCX_ABAK .
  methods SHOW_ACTIVATION_ERRORS
    importing
      !I_LOGNAME type DDMASS-LOGNAME .
ENDCLASS.



CLASS ZCL_ABAK_TABLE_COPIER IMPLEMENTATION.


METHOD activate.
  DATA: rc TYPE sysubrc.

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

  IF rc <> 0.
    RAISE EXCEPTION TYPE zcx_abak.
  ENDIF.

ENDMETHOD.


METHOD activate2.
  DATA: t_gentab     TYPE STANDARD TABLE OF dcgentb,
        t_deltab     TYPE STANDARD TABLE OF dcdeltb,
        t_action_tab TYPE STANDARD TABLE OF dctablres,
        s_gentab     LIKE LINE OF t_gentab,
        logname      TYPE ddmass-logname,
        rc           type sy-subrc.

  s_gentab-tabix = 1.
  s_gentab-type = 'TABL'.
  s_gentab-name = i_tablename.
  INSERT s_gentab INTO TABLE t_gentab.

  logname = |ABAK_{ sy-datum }_{ sy-uzeit }|.

  CALL FUNCTION 'DD_MASS_ACT_C3'
    EXPORTING
      ddmode         = 'O'
      medium         = 'T' " transport order
      device         = 'T' " saves to table DDRPH?
      version        = 'M' " activate newest
      logname        = logname
      write_log      = abap_true
      log_head_tail  = abap_true
      t_on           = space
      prid           = 1
    IMPORTING
      act_rc         = rc
    TABLES
      gentab         = t_gentab
      deltab         = t_deltab
      cnvtab         = t_action_tab
    EXCEPTIONS
      access_failure = 1
      no_objects     = 2
      locked         = 3
      internal_error = 4
      OTHERS         = 5.

  IF sy-subrc <> 0.
    raise EXCEPTION type ZCX_ABAK
      EXPORTING
        previous_from_syst = abap_true.
  ENDIF.

  IF rc > 0.
    raise EXCEPTION type zcx_abak.
*    show_activation_errors( logname ).
  ENDIF.

ENDMETHOD.


METHOD copy.
  DATA: o_exp TYPE REF TO zcx_abak.

  TRY.
      create_table( i_tablename ).

*      insert_in_tadir( i_tablename = i_tablename
*                       i_devclass  = i_devclass ).

      activate2( i_tablename ).

      COMMIT WORK AND WAIT.

    CATCH zcx_abak INTO o_exp.
      ROLLBACK WORK.
      RAISE EXCEPTION o_exp.
  ENDTRY.

ENDMETHOD.


METHOD CREATE_TABLE.

  DATA: s_dd02v_wa  TYPE  dd02v,
        s_dd09l_wa  TYPE  dd09v,
        t_dd03p_tab TYPE STANDARD TABLE OF dd03p,
        s_dd03p_tab LIKE LINE OF t_dd03p_tab.

* We take table ZABAK_DEFAULT as template
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

* ...and replace its name with the name of the new table
  s_dd03p_tab-tabname = i_tablename.
  MODIFY t_dd03p_tab FROM s_dd03p_tab TRANSPORTING tabname WHERE tabname <> i_tablename.
  DELETE t_dd03p_tab WHERE fieldname <> '.INCLUDE'.

* And some more structures needed...
  s_dd02v_wa-tabname = i_tablename.
  s_dd02v_wa-ddtext = i_tablename.
  s_dd02v_wa-ddlanguage = sy-langu.
  s_dd09l_wa-tabname = i_tablename.

* ...and finally create the table in the DDIC
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
ENDMETHOD.


METHOD INSERT_IN_TADIR.
  DATA: obj_name TYPE sobj_name.

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

ENDMETHOD.


method SHOW_ACTIVATION_ERRORS.
endmethod.
ENDCLASS.
