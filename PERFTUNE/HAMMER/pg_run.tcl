Script started on 2021-05-07 13:23:25+0000
[?1034h[01;32m[00m:[01;34m~/rpms/HammerDB-4.1[00m $ cd /tmp
[01;32m[00m:[01;34m/tmp[00m $ ls -latr
total 64
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .XIM-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .X11-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .Test-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .ICE-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .font-unix
-rw-r--r--  1 root     root       598 Apr 28 12:56 init-yum-update-security
drwxrwxr-x  2 ec2-user ec2-user    21 Apr 28 15:43 certs
drwxr-xr-x  2 root     root         6 Apr 28 15:44 hsperfdata_root
drwx------  3 root     root        17 Apr 29 12:16 systemd-private-35ec88e01a7f49f899a5ddae07c6a231-chronyd.service-1VmREy
drwx------  2 ec2-user ec2-user    23 Apr 29 12:16 tmux-1000
drwxr-xr-x  2 ec2-user ec2-user     6 May  2 20:22 aws-toolkit-vscode
drwxr-xr-x  2 ec2-user ec2-user    18 May  3 15:04 hsperfdata_ec2-user
-rwxr-xr-x  1 ec2-user ec2-user 54754 May  3 15:04 libjansi-64-8324421203854128842.so
dr-xr-xr-x 19 root     root       266 May  6 01:25 ..
drwx------  3 root     root        17 May  6 15:53 systemd-private-d8ff54f7351a450a9145e3056f90f674-chronyd.service-DXNS1H
drwx------  3 root     root        17 May  6 16:52 systemd-private-b634dcb79052476ba4ac38814372a83f-chronyd.service-4aO6r2
drwxrwxrwt 15 root     root      4096 May  7 13:23 .
[01;32m[00m:[01;34m/tmp[00m $ ls -latr
total 64
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .XIM-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .X11-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .Test-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .ICE-unix
drwxrwxrwt  2 root     root         6 Apr 21 17:35 .font-unix
-rw-r--r--  1 root     root       598 Apr 28 12:56 init-yum-update-security
drwxrwxr-x  2 ec2-user ec2-user    21 Apr 28 15:43 certs
drwxr-xr-x  2 root     root         6 Apr 28 15:44 hsperfdata_root
drwx------  3 root     root        17 Apr 29 12:16 systemd-private-35ec88e01a7f49f899a5ddae07c6a231-chronyd.service-1VmREy
drwx------  2 ec2-user ec2-user    23 Apr 29 12:16 tmux-1000
drwxr-xr-x  2 ec2-user ec2-user     6 May  2 20:22 aws-toolkit-vscode
drwxr-xr-x  2 ec2-user ec2-user    18 May  3 15:04 hsperfdata_ec2-user
-rwxr-xr-x  1 ec2-user ec2-user 54754 May  3 15:04 libjansi-64-8324421203854128842.so
dr-xr-xr-x 19 root     root       266 May  6 01:25 ..
drwx------  3 root     root        17 May  6 15:53 systemd-private-d8ff54f7351a450a9145e3056f90f674-chronyd.service-DXNS1H
drwx------  3 root     root        17 May  6 16:52 systemd-private-b634dcb79052476ba4ac38814372a83f-chronyd.service-4aO6r2
drwxrwxrwt 15 root     root      4096 May  7 13:23 .
[01;32m[00m:[01;34m/tmp[00m $ 
[01;32m[00m:[01;34m/tmp[00m $ cd
[01;32m[00m:[01;34m~[00m $ cd
[01;32m[00m:[01;34m~[00m $ cd DBHUB/
[01;32m[00m:[01;34m~/DBHUB[00m (master) $ ls
20210405.PG_RLS  BASEDAT  CFT  DYN  LOG   MYSQL  ORA	   PG	      setup_ec2.readme	Z.ARC
20210501.PG_GIS  BIN	  CLI  IAM  meta  NEP	 PERFTUNE  SCRIPTLIB  SQLSERV
[01;32m[00m:[01;34m~/DBHUB[00m (master) $ cd Z.ARC/
[01;32m[00m:[01;34m~/DBHUB/Z.ARC[00m (master) $ ls
20210125.PGPERF  20210211.PAVCON  20210213.DMSPERF  20210320.UAC  AB3
[01;32m[00m:[01;34m~/DBHUB/Z.ARC[00m (master) $ cd ..
[01;32m[00m:[01;34m~/DBHUB[00m (master) $ ls
20210405.PG_RLS  BASEDAT  CFT  DYN  LOG   MYSQL  ORA	   PG	      setup_ec2.readme	Z.ARC
20210501.PG_GIS  BIN	  CLI  IAM  meta  NEP	 PERFTUNE  SCRIPTLIB  SQLSERV
[01;32m[00m:[01;34m~/DBHUB[00m (master) $ cd PERFTUNE/
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ ls
awr-hist-ORA1001-3649484020-15-169.out	HAMMER				  ora.getawr.bsh	 qr_oraperftune
awr-hist-TTSORA10-3534888171-0-30.out	metric_queries.perfinsights.json  ora.sqlforpid.bsh	 rds.ora.getawr.bsh
awrrpt_181_185.txt			ora.aws_awr_miner.sql		  ora.topsql.bsh	 rds.perfinsights.bsh
awrrpt_78_79.txt			ora.functionbasedidx.txt	  pg.explain		 sqlserv.perf.sql
awrrpt_79_80.txt			ora.gatherstats.sql		  pg.pgstatactivity.bsh
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ more pg.pgstatactivity.bsh 
## To be able to have statements saved in pg_stat_statements table for RDS/Aurora postgreSQL, do the following
## 1 - set parameters:
## pg_stat_staements.track ALL
## shared_preload_libraries pg_stat_statements
## track_activity_query_size 2048
## reboot
## login and create the extention:
## 2 - CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;

export PGPASSWORD=Pass1234
psql --host=pg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ
\x
\echo #----#----#----# 
\echo #----#----#----# pg_stat_activity ordered by query_start, xact_start
\echo #----#----#----# 
SELECT (clock_timestamp() - xact_start) AS xact_age,
       (clock_timestamp() - query_start) AS query_age,
       (clock_timestamp() - state_change) AS change_age,
       pid, state, datname, usename,
       coalesce(wait_event_type = 'Lock', 'f') AS waiting,
       wait_event_type ||'.'|| wait_event as wait_details,
       client_addr ||'.'|| client_port AS client,
       query
FROM pg_stat_activity
WHERE clock_timestamp() - coalesce(xact_start, query_start) > '00:00:00.1'::interval
AND pid <> pg_backend_pid() AND state <> 'idle'
ORDER BY coalesce(xact_start, query_start);
\echo #----#----#----# 
\echo #----#----#----# pg_stat_activity and pg_locks
[7m--More--(40%)[27m[Kvi -c 1 pg.pgstatactivity.bsh[?1049h[?1h=[?2004h[1;30r[?12h[?12l[27m[23m[29m[m[H[2J[?25l[30;1H"pg.pgstatactivity.bsh" 63L, 3185C[1;1H## To be able to have statements saved in pg_stat_statements table for RDS/Aurora postgreSQL, do the following
## 1 - set parameters:
## pg_stat_staements.track ALL
## shared_preload_libraries pg_stat_statements
## track_activity_query_size 2048
## reboot
## login and create the extention:
## 2 - CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;

export PGPASSWORD=Pass1234
psql --host=pg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ
\x
\echo #----#----#----#
\echo #----#----#----# pg_stat_activity ordered by query_start, xact_start
\echo #----#----#----#
SELECT (clock_timestamp() - xact_start) AS xact_age,[17;8H(clock_timestamp() - query_start) AS query_age,[18;8H(clock_timestamp() - state_change) AS change_age,[19;8Hpid, state, datname, usename,[20;8Hcoalesce(wait_event_type = 'Lock', 'f') AS waiting,[21;8Hwait_event_type ||'.'|| wait_event as wait_details,[22;8Hclient_addr ||'.'|| client_port AS client,[23;8Hquery
FROM pg_stat_activity
WHERE clock_timestamp() - coalesce(xact_start, query_start) > '00:00:00.1'::interval
AND pid <> pg_backend_pid() AND state <> 'idle'
ORDER BY coalesce(xact_start, query_start);
\echo #----#----#----#
\echo #----#----#----# pg_stat_activity and pg_locks[1;1H[?25h









psql --host=[?25l[30;1H[1m-- INSERT --[m[30;13H[K[30;1H[K[12;29r[12;1H[L[1;30r[11;14Hpg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.comg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernaa[12;1Hme=postgres --dbname=pg100 <<EQ[11;59H[?25hom[?25l[30;1H1 change; before #1  4 seconds ago[11;29r[29;1H
[1;30r[11;1Hpsql --host=pg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[29;1H\echo #----#----#----# pg_stat_activity and pg_locks[30;1H[K[30;1H1 change; before #1  4 seconds ago[11;14H[?25h[?25l[30;1H[1m-- INSERT --[m[30;13H[K[11;13H[?25h[?25l[12;29r[12;1H[L[1;30r[11;17H2.cyt4dgtj55oy[28Cpg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernaa[12;1Hme=postgres --dbname=pg100 <<EQ[11;59H[?25h[?25l pg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernn[12;1Hame=postgres --dbname=pg100 <<EQ[11;60H[?25h[30;1H[K[11;59H[?25l[?25h [?25lg100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernaa[12;1Hme=postgres --dbname=pg100 <<EQ[12;32H[K[11;60H[?25h[?25l100.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernamm[12;1He=postgres --dbname=pg100 <<EQ[12;31H[K[11;60H[?25h[?25l00.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --usernamee[12;1H=postgres --dbname=pg100 <<EQ[12;30H[K[11;60H[?25h[?25l0.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username==[12;1Hpostgres --dbname=pg100 <<EQ[12;29H[K[11;60H[?25h[?25l.czzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=pp[12;1Hostgres --dbname=pg100 <<EQ[12;28H[K[11;60H[?25h[?25lczzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=poo[12;1Hstgres --dbname=pg100 <<EQ[12;27H[K[11;60H[?25h[?25lzzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=poss[12;1Htgres --dbname=pg100 <<EQ[12;26H[K[11;60H[?25h[?25lzdit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postt[12;1Hgres --dbname=pg100 <<EQ[12;25H[K[11;60H[?25h[?25ldit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgg[12;1Hres --dbname=pg100 <<EQ[12;24H[K[11;60H[?25h[?25lit7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgrr[12;1Hes --dbname=pg100 <<EQ[12;23H[K[11;60H[?25h[?25lt7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgree[12;1Hs --dbname=pg100 <<EQ[12;22H[K[11;60H[?25h[?25l7hfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgress[12;1H --dbname=pg100 <<EQ[12;21H[K[11;60H[?25h[?25lhfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres  [12;1H--dbname=pg100 <<EQ[12;20H[K[11;60H[?25h[?25lfndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --[12;1H-dbname=pg100 <<EQ[12;19H[K[11;60H[?25h[?25lndz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres ---[12;1Hdbname=pg100 <<EQ[12;18H[K[11;60H[?25h[?25ldz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dd[12;1Hbname=pg100 <<EQ[12;17H[K[11;60H[?25h[?25lz.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbb[12;1Hname=pg100 <<EQ[12;16H[K[11;60H[?25h[?25l.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbnn[12;1Hame=pg100 <<EQ[12;15H[K[11;60H[?25h[?25lus-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbnaa[12;1Hme=pg100 <<EQ[12;14H[K[11;60H[?25h[?25ls-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbnamm[12;1He=pg100 <<EQ[12;13H[K[11;60H[?25h[?25l-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbnamee[12;1H=pg100 <<EQ[12;12H[K[11;60H[?25h[?25least-2.rds.amazonaws.com --port=5432 --username=postgres --dbname==[12;1Hpg100 <<EQ[12;11H[K[11;60H[?25h[?25last-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pp[12;1Hg100 <<EQ[12;10H[K[11;60H[?25h[?25lst-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pgg[12;1H100 <<EQ[12;9H[K[11;60H[?25h[?25lt-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg11[12;1H00 <<EQ[12;8H[K[11;60H[?25h[?25l-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg100[12;1H0 <<EQ[12;7H[K[11;60H[?25h[?25l2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg1000[12;1H <<EQ[12;6H[K[11;60H[?25h[?25l.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg100  [12;1H<<EQ[12;5H[K[11;60H[?25h[?25lrds.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<[12;1H<EQ[12;4H[K[11;60H[?25h[?25lds.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<<[12;1HEQ[12;3H[K[11;60H[?25h[?25ls.amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EE[12;1HQ[12;2H[K[11;60H[?25h[?25l[11;29r[29;1H
[1;30r[11;1Hpsql --host=pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com .amazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[29;1H\echo #----#----#----# pg_stat_activity and pg_locks[11;60H[?25h[?25lamazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;125H[K[11;60H[?25h[?25lmazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;124H[K[11;60H[?25h[?25lazonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;123H[K[11;60H[?25h[?25lzonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;122H[K[11;60H[?25h[?25lonaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;121H[K[11;60H[?25h[?25lnaws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;120H[K[11;60H[?25h[?25laws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;119H[K[11;60H[?25h[?25lws.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;118H[K[11;60H[?25h[?25ls.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;117H[K[11;60H[?25h[?25l.com --port=5432 --username=postgres --dbname=pg100 <<EQ[11;116H[K[11;60H[?25h[?25lcom --port=5432 --username=postgres --dbname=pg100 <<EQ[11;115H[K[11;60H[?25h[?25lom --port=5432 --username=postgres --dbname=pg100 <<EQ[11;114H[K[11;60H[?25h[?25lm --port=5432 --username=postgres --dbname=pg100 <<EQ[11;113H[K[11;60H[?25h[?25l --port=5432 --username=postgres --dbname=pg100 <<EQ[11;112H[K[11;60H[?25h[?25l--port=5432 --username=postgres --dbname=pg100 <<EQ[11;111H[K[11;60H[?25h--port=5432 --username=postgres --dbname=pg10[?25l2[?25h
[?25l[27m[23m[29m[m[H[2J[1;1H\echo #----#----#----#
\echo #----#----#----# pg_stat_activity and pg_locks
\echo #----#----#----#
SELECT
  COALESCE(l1.relation::regclass::text,l1.locktype) as locked_item,
  w.wait_event_type as waiting_ev_type, w.wait_event as waiting_ev, w.query as waiting_query,
  l1.mode as waiting_mode,
  (select now() - xact_start as waiting_xact_duration from pg_stat_activity where pid = w.pid),
  (select now() - query_start as waiting_query_duration from pg_stat_activity where pid = w.pid),
  w.pid as waiting_pid, w.usename as waiting_user, w.state as waiting_state,
  l.wait_event_type as locking_ev_type, l.wait_event_type as locking_ev, l.query as locking_query,
  l2.mode as locking_mode,
  (select now() - xact_start as locking_xact_duration from pg_stat_activity where pid = l.pid),
  (select now() - query_start as locking_query_duration from pg_stat_activity where pid = l.pid),
  l.pid as locking_pid, l.usename as locking_user, l.state as locking_state
FROM pg_stat_activity w
JOIN pg_locks l1 ON w.pid = l1.pid AND NOT l1.granted
JOIN pg_locks l2 ON (l1.transactionid = l2.transactionid AND l1.pid != l2.pid)
    OR (l1.database = l2.database AND l1.relation = l2.relation and l1.pid != l2.pid)
JOIN pg_stat_activity l ON l2.pid = l.pid
WHERE w.wait_event is not null and w.wait_event_type is not null
ORDER BY l.query_start,w.query_start;
\echo #----#----#----#
\echo #----#----#----# worst 5 pg_stat_activity that is not idle, orderd by runtime
\echo #----#----#----#
select current_timestamp - query_start as runtime, datname, usename, query
    from pg_stat_activity
    where state != 'idle'
    order by 1 desc limit 5;[6;3H[?25h[?25l[27m[23m[29m[m[H[2J[1;5Hwhere state != 'idle'
    order by 1 desc limit 5;
\echo #----#----#----#
\echo #----#----#----# worst 5 pg_stat_activity ordered by total_time
\echo #----#----#----#
SELECT query, calls, total_time, rows, 100.0 * shared_blks_hit /[7;16Hnullif(shared_blks_hit + shared_blks_read, 0) AS hit_percent[8;11HFROM pg_stat_statements ORDER BY total_time DESC LIMIT 5;
EQ
[1m[34m~                                                                                                                            [11;1H~                                                                                                                            [12;1H~                                                                                                                            [13;1H~                                                                                                                            [14;1H~                                                                                                                            [15;1H~                                                                                                                            [16;1H~                                                                                                                            [17;1H~                                                                                                                            [18;1H~                                                                                                                            [19;1H~                                                                                                                            [20;1H~                                                                                                                            [21;1H~                                                                                                                            [22;1H~                                                                                                                            [23;1H~                                                                                                                            [24;1H~                                                                                                                            [25;1H~                                                                                                                            [26;1H~                                                                                                                            [27;1H~                                                                                                                            [28;1H~                                                                                                                            [29;1H~                                                                                                                            [6;1H[?25h[?25l[30;1H[m:[?2004h[?25hwq[?25l[?2004l"pg.pgstatactivity.bsh" 63L, 3185C written
[?2004l[?1l>[?25h[?1049l------------------------
[7m--More--(40%)[27m\echo #----#----#----# 
[7m--More--(41%)[27mSELECT[K
[7m--More--(41%)[27m  COALESCE(l1.relation::regclass::text,l1.locktype) as locked_item,
[7m--More--(43%)[27m[K[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ 
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ 
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ 
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ ls
awr-hist-ORA1001-3649484020-15-169.out	HAMMER				  ora.getawr.bsh	 qr_oraperftune
awr-hist-TTSORA10-3534888171-0-30.out	metric_queries.perfinsights.json  ora.sqlforpid.bsh	 rds.ora.getawr.bsh
awrrpt_181_185.txt			ora.aws_awr_miner.sql		  ora.topsql.bsh	 rds.perfinsights.bsh
awrrpt_78_79.txt			ora.functionbasedidx.txt	  pg.explain		 sqlserv.perf.sql
awrrpt_79_80.txt			ora.gatherstats.sql		  pg.pgstatactivity.bsh
[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ ./pg.pgstatactivity.bsh 
Expanded display is on.
#----#----#----#
#----#----#----# pg_stat_activity ordered by query_start, xact_start
#----#----#----#
(0 rows)

#----#----#----#
#----#----#----# pg_stat_activity and pg_locks
#----#----#----#
(0 rows)

#----#----#----#
#----#----#----# worst 5 pg_stat_activity that is not idle, orderd by runtime
#----#----#----#
-[ RECORD 1 ]-----------------------------------------------------------------------
runtime | 00:00:00
datname | pg102
usename | postgres
query   | select current_timestamp - query_start as runtime, datname, usename, query+
        |     from pg_stat_activity                                                 +
        |     where state != 'idle'                                                 +
        |     order by 1 desc limit 5;

#----#----#----#
#----#----#----# worst 5 pg_stat_activity ordered by total_time
#----#----#----#
-[ RECORD 1 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select sum(numbackends) numbackends, sum(xact_commit) xact_commit, sum(xact_rollback) xact_rollback, sum(blks_read) blks_read, sum(blks_hit) blks_hit, sum(tup_returned) tup_returned, sum(tup_fetched) tup_fetched, sum(tup_inserted) tup_inserted, sum(tup_updated) tup_updated, sum(tup_deleted) tup_deleted, sum(conflicts) conflicts, sum(temp_files) temp_files, sum(temp_bytes) temp_bytes, sum(deadlocks) deadlocks, sum(blk_read_time) blk_read_time, sum(blk_write_time) blk_write_time from pg_stat_database
calls       | 1450
total_time  | 14568.51219600001
rows        | 1450
hit_percent | 100.0000000000000000
-[ RECORD 2 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select pid, usename, client_addr, client_hostname, wait_event_type, wait_event, query, datname, application_name, backend_type from pg_stat_activity where state = $1
calls       | 86973
total_time  | 8499.810577000091
rows        | 86993
hit_percent | 100.0000000000000000
-[ RECORD 3 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | MOVE ALL IN "query-cursor_1"
calls       | 1450
total_time  | 1611.3266890000016
rows        | 0
hit_percent | 100.0000000000000000
-[ RECORD 4 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | ANALYZE
calls       | 1
total_time  | 1488.4483129999999
rows        | 0
hit_percent | 98.2901759240956711
-[ RECORD 5 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select count(distinct transactionid::varchar) active_transactions from pg_locks where locktype = $1
calls       | 1450
total_time  | 583.9112070000006
rows        | 1450
hit_percent | 100.0000000000000000

[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ ./pg.pgstatactivity.bsh 
Expanded display is on.
#----#----#----#
#----#----#----# pg_stat_activity ordered by query_start, xact_start
#----#----#----#
(0 rows)

#----#----#----#
#----#----#----# pg_stat_activity and pg_locks
#----#----#----#
(0 rows)

#----#----#----#
#----#----#----# worst 5 pg_stat_activity that is not idle, orderd by runtime
#----#----#----#
-[ RECORD 1 ]-----------------------------------------------------------------------
runtime | 00:00:00
datname | pg102
usename | postgres
query   | select current_timestamp - query_start as runtime, datname, usename, query+
        |     from pg_stat_activity                                                 +
        |     where state != 'idle'                                                 +
        |     order by 1 desc limit 5;

#----#----#----#
#----#----#----# worst 5 pg_stat_activity ordered by total_time
#----#----#----#
-[ RECORD 1 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select sum(numbackends) numbackends, sum(xact_commit) xact_commit, sum(xact_rollback) xact_rollback, sum(blks_read) blks_read, sum(blks_hit) blks_hit, sum(tup_returned) tup_returned, sum(tup_fetched) tup_fetched, sum(tup_inserted) tup_inserted, sum(tup_updated) tup_updated, sum(tup_deleted) tup_deleted, sum(conflicts) conflicts, sum(temp_files) temp_files, sum(temp_bytes) temp_bytes, sum(deadlocks) deadlocks, sum(blk_read_time) blk_read_time, sum(blk_write_time) blk_write_time from pg_stat_database
calls       | 1451
total_time  | 14578.75649000001
rows        | 1451
hit_percent | 100.0000000000000000
-[ RECORD 2 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select pid, usename, client_addr, client_hostname, wait_event_type, wait_event, query, datname, application_name, backend_type from pg_stat_activity where state = $1
calls       | 87004
total_time  | 8502.726322000091
rows        | 87024
hit_percent | 100.0000000000000000
-[ RECORD 3 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | MOVE ALL IN "query-cursor_1"
calls       | 1451
total_time  | 1747.0523890000015
rows        | 0
hit_percent | 100.0000000000000000
-[ RECORD 4 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | ANALYZE
calls       | 1
total_time  | 1488.4483129999999
rows        | 0
hit_percent | 98.2901759240956711
-[ RECORD 5 ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
query       | select count(distinct transactionid::varchar) active_transactions from pg_locks where locktype = $1
calls       | 1451
total_time  | 584.2770700000005
rows        | 1451
hit_percent | 100.0000000000000000

[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ [K[01;32m[00m:[01;34m~/DBHUB/PERFTUNE[00m (master) $ sudo yum install postgresql-contrib
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                            | 3.7 kB  00:00:00     
244 packages excluded due to repository priority protections
Resolving Dependencies
--> Running transaction check
---> Package postgresql-contrib.x86_64 0:9.2.24-1.amzn2.0.1 will be installed
--> Processing Dependency: postgresql-libs(x86-64) = 9.2.24-1.amzn2.0.1 for package: postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64
--> Processing Dependency: postgresql(x86-64) = 9.2.24-1.amzn2.0.1 for package: postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64
--> Processing Dependency: libossp-uuid.so.16()(64bit) for package: postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64
--> Running transaction check
---> Package postgresql.x86_64 0:9.2.24-1.amzn2.0.1 will be installed
---> Package postgresql-libs.x86_64 0:9.2.24-1.amzn2.0.1 will be installed
---> Package uuid.x86_64 0:1.6.2-26.amzn2.0.1 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================
 Package                           Arch                  Version                             Repository                 Size
=============================================================================================================================
Installing:
 postgresql-contrib                x86_64                9.2.24-1.amzn2.0.1                  amzn2-core                555 k
Installing for dependencies:
 postgresql                        x86_64                9.2.24-1.amzn2.0.1                  amzn2-core                3.0 M
 postgresql-libs                   x86_64                9.2.24-1.amzn2.0.1                  amzn2-core                235 k
 uuid                              x86_64                1.6.2-26.amzn2.0.1                  amzn2-core                 56 k

Transaction Summary
=============================================================================================================================
Install  1 Package (+3 Dependent packages)

Total download size: 3.9 M
Installed size: 18 M
Is this ok [y/d/N]: y
Downloading packages:
(1/4): postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64.rpm                                               | 555 kB  00:00:00     
(2/4): postgresql-9.2.24-1.amzn2.0.1.x86_64.rpm                                                       | 3.0 MB  00:00:00     
(3/4): uuid-1.6.2-26.amzn2.0.1.x86_64.rpm                                                             |  56 kB  00:00:00     
(4/4): postgresql-libs-9.2.24-1.amzn2.0.1.x86_64.rpm                                                  | 235 kB  00:00:00     
-----------------------------------------------------------------------------------------------------------------------------
Total                                                                                         18 MB/s | 3.9 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [                                                             ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#####                                                        ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [######                                                       ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#########                                                    ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##############                                               ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [###############                                              ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#####################                                        ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##########################                                   ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [################################                             ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##################################                           ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [###################################                          ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#####################################                        ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#######################################                      ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [########################################                     ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##########################################                   ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [############################################                 ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#############################################                ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##############################################               ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [###############################################              ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#################################################            ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [##################################################           ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [###################################################          ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [####################################################         ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [######################################################       ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [########################################################     ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [#########################################################    ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [###########################################################  ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64 [############################################################ ] 1/4  Installing : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64                                                                 1/4 
  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [                                                                  ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#                                                                 ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##                                                                ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###                                                               ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [####                                                              ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#####                                                             ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [######                                                            ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#######                                                           ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [########                                                          ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#########                                                         ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##########                                                        ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###########                                                       ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [############                                                      ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#############                                                     ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##############                                                    ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###############                                                   ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [################                                                  ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#################                                                 ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##################                                                ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###################                                               ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [####################                                              ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#####################                                             ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [######################                                            ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#######################                                           ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [########################                                          ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#########################                                         ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##########################                                        ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###########################                                       ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [############################                                      ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#############################                                     ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##############################                                    ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###############################                                   ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [################################                                  ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#################################                                 ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##################################                                ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###################################                               ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [####################################                              ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#####################################                             ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [######################################                            ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#######################################                           ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [########################################                          ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#########################################                         ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##########################################                        ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###########################################                       ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [############################################                      ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#############################################                     ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##############################################                    ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###############################################                   ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [################################################                  ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#################################################                 ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##################################################                ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###################################################               ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [####################################################              ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#####################################################             ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [######################################################            ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#######################################################           ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [########################################################          ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#########################################################         ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##########################################################        ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###########################################################       ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [############################################################      ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [#############################################################     ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [##############################################################    ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [###############################################################   ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [################################################################  ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64 [################################################################# ] 2/4  Installing : postgresql-9.2.24-1.amzn2.0.1.x86_64                                                                      2/4 
  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [                                                                        ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [########                                                                ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [#########                                                               ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [######################################                                  ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [####################################################                    ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [#############################################################           ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [###############################################################         ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [################################################################        ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [#################################################################       ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [##################################################################      ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [###################################################################     ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [#####################################################################   ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64 [####################################################################### ] 3/4  Installing : uuid-1.6.2-26.amzn2.0.1.x86_64                                                                            3/4 
  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [                                                          ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#                                                         ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##                                                        ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [####                                                      ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#####                                                     ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [######                                                    ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#######                                                   ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [########                                                  ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#########                                                 ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###########                                               ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [############                                              ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#############                                             ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###############                                           ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [################                                          ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#################                                         ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###################                                       ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [####################                                      ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [######################                                    ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#######################                                   ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#########################                                 ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##########################                                ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###########################                               ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [############################                              ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#############################                             ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###############################                           ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#################################                         ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##################################                        ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###################################                       ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [####################################                      ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [######################################                    ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#######################################                   ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [########################################                  ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#########################################                 ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##########################################                ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###########################################               ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [############################################              ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#############################################             ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##############################################            ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###############################################           ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [################################################          ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#################################################         ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [##################################################        ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [###################################################       ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#####################################################     ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [######################################################    ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [#######################################################   ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [########################################################  ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64 [######################################################### ] 4/4  Installing : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64                                                              4/4 
  Verifying  : postgresql-contrib-9.2.24-1.amzn2.0.1.x86_64                                                              1/4 
  Verifying  : uuid-1.6.2-26.amzn2.0.1.x86_64                                                                            2/4 
  Verifying  : postgresql-libs-9.2.24-1.amzn2.0.1.x86_64                                                                 3/4 
  Verifying  : postgresql-9.2.24-1.amzn2.0.1.x86_64                                                                      4/4 

Installed:
  postgresql-contrib.x86_64 0:9.2.24-1.amzn2.0.1                                                                             

Dependency Installed:
  postgresql.x86_64 0:9.2.24-1.amzn2.0.1   postgresql-libs.x86_64 0:9.2.24-1.amzn2.0.1   uuid.x86_64 0:1.6.2-26.amzn2.0.1  

Complete!
[01;32m[00m:[01;34m~/DBH