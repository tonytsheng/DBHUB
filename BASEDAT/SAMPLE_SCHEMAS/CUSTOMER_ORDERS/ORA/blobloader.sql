create or replace
function loader(p_filename varchar2) return blob is
bf bfile := bfilename('DATA_PUMP_DIR',p_filename);
b blob;
begin
  dbms_lob.createtemporary(b,true);
  dbms_lob.fileopen(bf, dbms_lob.file_readonly);
  dbms_lob.loadfromfile(b,bf,dbms_lob.getlength(bf));
  dbms_lob.fileclose(bf);
 return b;
 end;
/

exit

