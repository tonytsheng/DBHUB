alter role admin with login;
alter user admin with password '***';

alter user alice with password '***';
alter role alice with login;

create role readwrite;
grant connect on database pg102 to readwrite;
grant all on database pg102 to readwrite;
create user ttsheng with password 'ttsheng';
grant readwrite to ttsheng;

