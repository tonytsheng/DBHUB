set serveroutput on
--delete from esrifeatureclass;
--commit;

begin
--for r in (select objectid from esritestcopy order by objectid )
for r in (select objectid from ESRIFEATURECLASS_BASE where objectid >= 91 and objectid<=120)
	loop
		dbms_output.put_line (r.objectid);
		insert into esrifeatureclass select * from ESRIFEATURECLASS_BASE where objectid=r.objectid;
		commit;
	end loop;
end;
/
exit
