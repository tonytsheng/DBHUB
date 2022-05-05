(\watch 60).
select *, pg_current_wal_lsn()
 from pg_stat_database
 where datname=current_database()
\gset
select blks_hit-:blks_hit "blk hit",
      blks_read-:blks_read "blk read",
         tup_inserted-:tup_inserted "ins",
         tup_updated-:tup_updated "upd",
         tup_deleted-:tup_deleted "del",
         tup_returned-:tup_returned "tup ret",
         tup_fetched-:tup_fetched "tup fch",
         xact_commit-:xact_commit "commit",
         xact_rollback-:xact_rollback "rbk",         pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(),:'pg_current_wal_lsn')) "WAL",
         pg_size_pretty(temp_bytes-:temp_bytes) "temp"
 from pg_stat_database
 where datname=current_database();
\watch 60
