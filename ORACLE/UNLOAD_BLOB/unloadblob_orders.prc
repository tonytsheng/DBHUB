CREATE OR REPLACE PROCEDURE unload_blob_orders
  (p_id_value int, 
   p_dir varchar2
  )
IS

  l_blob  BLOB;
  p_blob  BLOB;
  p_filename varchar2(2000); 
  l_file      UTL_FILE.FILE_TYPE;
  l_buffer    RAW(32767);
  l_amount    BINARY_INTEGER := 32767;
  l_pos       INTEGER := 1;
  l_blob_len  INTEGER;
BEGIN
-- Get LOB locator
  SELECT order_img
  INTO   l_blob
  FROM   orders
  WHERE  order_id=p_id_value;

p_filename := p_id_value || 'orders.gif';
l_blob_len := DBMS_LOB.getlength(l_blob);

-- Open the destination file.
  l_file := UTL_FILE.fopen(p_dir, p_filename,'wb', 32767);

-- Read chunks of the BLOB and write them to the file until complete.
  WHILE l_pos <= l_blob_len LOOP
    DBMS_LOB.read(l_blob, l_amount, l_pos, l_buffer);
    UTL_FILE.put_raw(l_file, l_buffer, TRUE);
    l_pos := l_pos + l_amount;
  END LOOP;
	  
-- Close the file.
  UTL_FILE.fclose(l_file);
  
	END;
/
show errors;
exit
