
select count(*)
, (dbms_lob.getlength(ident))/1024/1024 as SizeMB 
from jeffdm.esrifeatureclass 
group by (dbms_lob.getlength(ident))/1024/1024;

select count(*)
, (dbms_lob.getlength(type))/1024/1024 as SizeMB 
from jeffdm.esrifeatureclass 
group by (dbms_lob.getlength(type))/1024/1024;

select count(*)
, (dbms_lob.getlength(info))/1024/1024 as SizeMB 
from jeffdm.mdrt_22b4d$ 
group by (dbms_lob.getlength(info))/1024/1024;

select count(*)
, (dbms_lob.getlength(info))/1024/1024 as SizeMB 
from jeffdm.mdrt_22b36$ 
group by (dbms_lob.getlength(info))/1024/1024;




exit;

