DECLARE
  l_bfile  BFILE;
  l_blob   BLOB;
BEGIN
  -- this depends on your table definition, col1 being the BLOB column
  INSERT INTO customer_orders.stores 
    (store_id, store_name, physical_address, logo) VALUES ('9267409','TTSHENG','1',empty_blob())
  RETURN logo INTO l_blob;

  l_bfile := BFILENAME('DATA_PUMP_DIR', 'aws-logo-blog-header.png');
  DBMS_LOB.fileopen(l_bfile, Dbms_Lob.File_Readonly);
  DBMS_LOB.loadfromfile(l_blob, l_bfile, DBMS_LOB.getlength(l_bfile));
  DBMS_LOB.fileclose(l_bfile);

  COMMIT;
END;
/
exit

