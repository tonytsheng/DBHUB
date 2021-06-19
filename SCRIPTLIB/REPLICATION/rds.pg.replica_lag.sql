SELECT extract(epoch from now() - pg_last_xact_replay_timestamp()) AS reader_lag;
