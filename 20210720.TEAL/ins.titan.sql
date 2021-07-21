Insert into TITAN
values ( titan_seq.nextval
  , (DBMS_RANDOM.string('a',40))
  , (select content from titan where id =1)
);
commit;
exit;

