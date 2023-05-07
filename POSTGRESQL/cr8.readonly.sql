create user readonly with password 'readonly';
grant connect on database pg102 to readonly;
grant usage on schema fly to readonly;
grant select on all tables in schema fly to readonly;

