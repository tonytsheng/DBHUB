SELECT setting ~ 'pgactive' 
FROM pg_catalog.pg_settings
WHERE name = 'shared_preload_libraries';
exit;
