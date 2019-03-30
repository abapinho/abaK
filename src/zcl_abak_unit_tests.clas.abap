class ZCL_ABAK_UNIT_TESTS definition
  public
  abstract
  create public
  for testing
  risk level harmless .

public section.
  PROTECTED SECTION.
    CONSTANTS:
      BEGIN OF gc_tablename,
                   valid TYPE string VALUE 'ZABAK_UNITTESTS',
                   invalid TYPE string VALUE 'USR01',
                 END OF gc_tablename .

    CONSTANTS:
      BEGIN OF gc_scope,
        utest TYPE zabak_scope VALUE space,
      END OF gc_scope.                                      "#EC NOTEXT
    CONSTANTS:
      BEGIN OF gc_context,
        c1             TYPE zabak_context VALUE 'C1',
        does_not_exist TYPE zabak_context VALUE 'DOES_NOT_EXIST',
      END OF gc_context.

    METHODS generate_test_data .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAK_UNIT_TESTS IMPLEMENTATION.


  METHOD generate_test_data.

    DATA: t_data TYPE zabak_db_t,
          s_data LIKE LINE OF t_data.

    CLEAR s_data.
    s_data-scope = gc_scope-utest.
    s_data-fieldname = 'BUKRS'.
    s_data-ue_option = 'EQ'.
    s_data-ue_sign = 'I'.
    s_data-ue_low = '0231'.
    INSERT s_data INTO TABLE t_data.

    CLEAR s_data.
    s_data-scope = gc_scope-utest.
    s_data-fieldname = 'KOART'.
    s_data-ue_option = 'EQ'.
    s_data-ue_sign = 'I'.
    s_data-ue_low = 'D'.
    s_data-idx = 1.
    INSERT s_data INTO TABLE t_data.
    s_data-ue_low = 'K'.
    s_data-idx = 2.
    INSERT s_data INTO TABLE t_data.

    CLEAR s_data.
    s_data-scope = gc_scope-utest.
    s_data-fieldname = 'KUNNR'.
    s_data-context = gc_context-c1.
    s_data-ue_option = 'EQ'.
    s_data-ue_sign = 'I'.
    s_data-ue_low = '1234567890'.
    INSERT s_data INTO TABLE t_data.

    CLEAR s_data.
    s_data-scope = gc_scope-utest.
    s_data-fieldname = 'WAERS'.
    s_data-idx = 1.
    s_data-ue_option = 'EQ'.
    s_data-ue_sign = 'I'.
    s_data-ue_low = 'EUR'.
    INSERT s_data INTO TABLE t_data.

    CLEAR s_data.
    s_data-scope = gc_scope-utest.
    s_data-fieldname = 'WAERS'.
    s_data-idx = 2.
    s_data-ue_option = 'EQ'.
    s_data-ue_sign = 'I'.
    s_data-ue_low = 'USD'.
    INSERT s_data INTO TABLE t_data.

*   Delete table content
    DELETE FROM zabak_unittests WHERE scope = gc_scope-utest.   "#EC CI_NOFIELD

    INSERT zabak_unittests FROM TABLE t_data.

  ENDMETHOD.
ENDCLASS.
