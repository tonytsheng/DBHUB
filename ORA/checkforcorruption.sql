SET SERVEROUT ON
SET TIMING ON
EXEC DBMS_OUTPUT.PUT_LINE('OK');

EXEC rdsadmin.rdsadmin_rman_util.validate_database(p_rman_to_dbms_output=>TRUE, p_validation_type=>'PHYSICAL+LOGICAL');

BEGIN
  for ts in (select name from v$tablespace where name <> 'TEMP') loop
    rdsadmin.rdsadmin_rman_util.validate_tablespace(p_tablespace_name=>ts.name, p_rman_to_dbms_output=>TRUE, p_validation_type=>'PHYSICAL+LOGICAL');
  end loop;
END;
/


EXEC rdsadmin.rdsadmin_rman_util.validate_current_controlfile(p_rman_to_dbms_output=>TRUE, p_validation_type=>'PHYSICAL+LOGICAL');

EXEC rdsadmin.rdsadmin_rman_util.validate_spfile(p_rman_to_dbms_output=>TRUE, p_validation_type=>'PHYSICAL+LOGICAL');

BEGIN
  for df in (select name from v$datafile) loop
    rdsadmin.rdsadmin_rman_util.validate_datafile( p_datafile=>df.name, p_rman_to_dbms_output=>TRUE, p_validation_type=>'PHYSICAL+LOGICAL');
  end loop;
end;
/

col name for a20
select ts#, file#, round(bytes/1024/1024/1024,2) as GB, status, name from v$datafile;

select round(sum(bytes)/power(1024,3),2) as "Total GB" from v$datafile;

SELECT round(SUM(BLOCKS * BLOCK_SIZE)/power(1024,3),2) "GB needed over 40 hours" FROM V$ARCHIVED_LOG WHERE NEXT_TIME>=SYSDATE-40/24 AND DEST_ID=1
/

col grantee for a20
col table_name for a30
col privilege for a20
select grantee, table_name, privilege from dba_tab_privs where table_name = 'DBMS_QOPATCH' and owner = 'SYS' and
(grantee = user or grantee in (select granted_role from dba_role_privs where grantee = user)
)
/
-- if above does not return that current user has execute privilege on dbms_qopatch then run:
rdsadmin.rdsadmin_util.grant_sys_object( p_obj_name=>'DBMS_QOPATCH', p_grantee=>user, p_privilege=>'EXECUTE', p_grant_option=>FALSE);

with a as (select dbms_qopatch.get_opatch_lsinventory patch_output from dual) select
x.patch_id, x.patch_uid, x.description from a, xmltable( 'InventoryInstance/patches/*'
passing a.patch_output columns patch_id number path 'patchID', patch_uid number path
'uniquePatchID', description varchar2(80) path 'patchDescription') x
/

-- OUTPUT OPATCH DATA
SET long 200000
SET pages 0
SET lines 200
Spool opatchoutput.log
select xmltransform(DBMS_QOPATCH.GET_OPATCH_LSINVENTORY,
DBMS_QOPATCH.GET_OPATCH_XSLT).getclobval() from dual
/
Spool off
Host head opatchoutput.log
host grep -i "database release update" opatchoutput.log



