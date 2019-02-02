class ZCL_ABAK_USAGE definition
  public
  final
  create public .

public section.

  types:
    TY_ZABAK_T type SORTED TABLE OF zabak with UNIQUE key id .

  methods GET_SUBCLASSES
    importing
      !I_INTERFACE type SEOCLSNAME
    returning
      value(RT_CLASS) type SEO_CLASS_NAMES .
  methods GET_WHERE_USED
    returning
      value(RT_TADIR) type TT_TADIR
    raising
      ZCX_ABAK .
  methods GET_ZABAK
    returning
      value(RT_ZABAK) type TY_ZABAK_T .
protected section.
private section.

  constants GC_DEMO_TABLENAME type STRING value 'ZABAK_DEMO'. "#EC NOTEXT
  constants GC_DEMO_ID type ZABAK_ID value 'ABAK_DEMO'. "#EC NOTEXT

  methods GET_OWN_PACKAGE
    returning
      value(R_DEVCLASS) type DEVCLASS .
ENDCLASS.



CLASS ZCL_ABAK_USAGE IMPLEMENTATION.


METHOD get_own_package.
  SELECT SINGLE devclass INTO r_devclass
    FROM tadir
    WHERE pgmid = 'R3TR'
      AND object = 'PROG'
      AND obj_name = sy-cprog.
  IF sy-subrc <> 0.
*   Not relevant since we're just interested in finding packages for abaK objects
    RETURN.
  ENDIF.
ENDMETHOD.


METHOD GET_SUBCLASSES.
  DATA: o_interface TYPE REF TO cl_oo_interface,
        o_class     TYPE REF TO cl_oo_class,
        o_exp       TYPE REF TO cx_root,
        t_class     TYPE seo_relkeys,
        t_subclass  TYPE seo_relkeys.

  FIELD-SYMBOLS: <s_class>    LIKE LINE OF t_class,
                 <s_subclass> LIKE LINE OF t_subclass.

  TRY.
      CREATE OBJECT o_interface
        EXPORTING
          intfname = i_interface.

      t_class = o_interface->get_implementing_classes( ).
      LOOP AT t_class ASSIGNING <s_class>.

        CREATE OBJECT o_class
          EXPORTING
            clsname = <s_class>-clsname.
        t_subclass = o_class->get_subclasses( ).
        INSERT <s_class> INTO TABLE t_subclass.

        LOOP AT t_subclass ASSIGNING <s_subclass>.
          CREATE OBJECT o_class
            EXPORTING
              clsname = <s_subclass>-clsname.
          IF o_class->is_abstract( ) IS INITIAL.
            INSERT <s_subclass>-clsname INTO TABLE rt_class.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

    CATCH cx_class_not_existent INTO o_exp.
      MESSAGE o_exp TYPE 'E'.
  ENDTRY.

ENDMETHOD.


METHOD get_where_used.

  DATA: t_findstring TYPE STANDARD TABLE OF string,
        t_found       TYPE STANDARD TABLE OF rsfindlst ,
        my_devclass   TYPE devclass,
        name          TYPE sobj_name,
        devclass      TYPE devclass,
        s_tadir       LIKE LINE OF rt_tadir.

  FIELD-SYMBOLS: <s_found> LIKE LINE OF t_found.

  APPEND 'ZCL_ABAK_FACTORY' TO t_findstring.

  CALL FUNCTION 'RS_EU_CROSSREF'
    EXPORTING
      i_find_obj_cls           = 'CLAS'
      no_dialog                = abap_true
    TABLES
      i_findstrings            = t_findstring
      o_founds                 = t_found
    EXCEPTIONS
      not_executed             = 1
      not_found                = 2
      illegal_object           = 3
      no_cross_for_this_object = 4
      batch                    = 5
      batchjob_error           = 6
      wrong_type               = 7
      object_not_exist         = 8
      OTHERS                   = 9.
  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE zcx_abak.
  ENDIF.

  IF lines( t_found ) = 0.
    RETURN.
  ENDIF.

  LOOP AT t_found ASSIGNING <s_found>.
    IF <s_found>-encl_objec IS NOT INITIAL.
      s_tadir-obj_name = <s_found>-encl_objec.
    ELSE.
      s_tadir-obj_name = <s_found>-object.
    ENDIF.
    INSERT s_tadir INTO TABLE rt_tadir.
  ENDLOOP.

  my_devclass = get_own_package( ).

  SELECT * FROM tadir
    INTO CORRESPONDING FIELDS OF TABLE rt_tadir
    FOR ALL ENTRIES IN rt_tadir
    WHERE pgmid = 'R3TR'
      AND ( object = 'CLAS' OR object = 'PROG' )
      AND obj_name = rt_tadir-obj_name
      AND devclass <> my_devclass.

ENDMETHOD.


METHOD get_zabak.
  SELECT * FROM zabak INTO TABLE rt_zabak.
ENDMETHOD.
ENDCLASS.
