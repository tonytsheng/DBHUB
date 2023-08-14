drop sequence my_number1;
drop sequence my_number2;
create sequence my_number1 start with 1 increment by 2;
create sequence my_number2 start with 2 increment by 2 ;
set linesize 200
set pagesize 0

select '
        {
            "rule-type": "selection",
            "rule-id": "'||my_number1.nextval||'",
            "rule-name": "'||my_number1.currval||'",
            "object-locator": {
                "schema-name": "'||username||'",
                "table-name": "%"
            },
            "rule-action": "include"
        },
        {
            "rule-type": "transformation",
            "rule-id": "'||my_number2.nextval||'",
            "rule-name": "'||my_number2.currval||'",
            "rule-action": "rename",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "'||username||'"
            },
            "value": "'||username||'"
        },' FROM DBA_USERS 
	where 
	-- default_tablespace = 'USERS' and 
	ORACLE_MAINTAINED ='N' ;

exit

