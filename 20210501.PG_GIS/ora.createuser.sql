create tablespace tts_spatial;

grant create session,
      create table,
      create sequence,
      create view,
      create procedure
  to tts_spatial
  identified by "Pass1234";

alter user tts_spatial default tablespace tts_spatial
              quota unlimited on tts_spatial;

alter user tts_spatial temporary tablespace temp;

