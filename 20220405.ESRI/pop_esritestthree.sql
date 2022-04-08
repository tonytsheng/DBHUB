set serveroutput on
--delete from esrifeatureclass;
--commit;

begin
--for r in (select objectid from esritestcopy order by objectid )
for r in (select objectid from BASE_ESRI where objectid >= 81 and objectid<=90)
	loop
		dbms_output.put_line (r.objectid);
		insert into esritestthree select * from base_esri where objectid=r.objectid;
		commit;
	end loop;
end;
/
exit
