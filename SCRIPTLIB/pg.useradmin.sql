alter role admin with login;
alter user admin with password 'Pass1234';

alter user alice with password 'Pass1234';
alter role alice with login;

create role readwrite;
grant connect on database pg102 to readwrite;
create user ttsheng with password 'ttsheng';
grant readwrite to ttsheng;

