CREATE DATABASE LINK dblink_passport
CONNECT TO admin IDENTIFIED BY Pass
USING
'(DESCRIPTION=
(ADDRESS=
(PROTOCOL=TCP)
(HOST=ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com)
(PORT=1521))
(CONNECT_DATA=
(SID=ttsora10)))';

