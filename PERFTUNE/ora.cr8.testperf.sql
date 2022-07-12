create user testperf identified by testperf default tablespace users temporary tablespace temp;
alter user testperf quota unlimited on users;
grant create session to testperf;

CREATE TABLE testperf.bigtab (
  id            NUMBER(10),
  created_date  DATE,
  lookup_id     NUMBER(10),
  comments      VARCHAR2(100)
);


