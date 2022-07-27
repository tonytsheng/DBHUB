exec rdsadmin.rdsadmin_master_util.create_archivelog_dir;
exec rdsadmin.rdsadmin_master_util.create_onlinelog_dir;
GRANT READ ON DIRECTORY ONLINELOG_DIR TO db_user;
GRANT READ ON DIRECTORY ARCHIVELOG_DIR TO db_user;

These two get created from above:
ONLINELOG_DIR                  /rdsdbdata/db/TTSORA4S_A/onlinelog
ARCHIVELOG_DIR                 /rdsdbdata/db/TTSORA4S_A/arch

