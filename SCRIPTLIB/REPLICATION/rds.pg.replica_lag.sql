# get lag for a RR
# note that if you run this on the primary, the query will not return any data

SELECT extract(epoch from now() - pg_last_xact_replay_timestamp()) AS reader_lag;
exit

