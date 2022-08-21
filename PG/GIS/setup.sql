# using 
https://aws.amazon.com/blogs/publicsector/how-to-deliver-performant-gis-desktop-applications-amazon-appstream-2-0/

# using postgresql with gis extensions
# loading gis speed test data from ookla
# using qgis opensource gis application

CREATE EXTENSION postgis;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;
ALTER SCHEMA tiger OWNER TO rds_superuser;
ALTER SCHEMA tiger_data OWNER TO rds_superuser; 
ALTER SCHEMA topology OWNER TO rds_superuser;
CREATE FUNCTION exec(text) returns text language plpgsql volatile AS $f$ BEGIN EXECUTE $1; RETURN $1; END; $f$;
SELECT exec('ALTER TABLE ' ^|^| quote_ident(s.nspname) ^|^| '.' ^|^| quote_ident(s.relname) ^|^| ' OWNER TO rds_superuser;')
FROM (
SELECT nspname, relname
FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid) 
WHERE nspname in ('tiger','topology') AND
relkind IN ('r','S','v') ORDER BY relkind = 'S')
echo s;

REVOKE CREATE ON SCHEMA public FROM public;
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE postgres TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;
CREATE USER ${READONLY_USERNAME} WITH PASSWORD '${READONLY_PASSWORD}';
GRANT readonly TO ${READONLY_USERNAME};

aws s3 cp s3://ookla-open-data/shapefiles/performance/type=fixed/year=2021/quarter=3/2021-07-01_performance_fixed_tiles.zip .  --no-sign-request
unzip 2021-07-01_performance_fixed_tiles.zip

REM add the downloaded Ookla dataset into RDS PostGIS
C:\OSGeo4W\bin\ogr2ogr.exe -f "PostgreSQL" "PG:host=${RDSPostGIS.Endpoint.Address} user=${DBMasterUsername} dbname=postgres password=%PGPASSWORD%" "C:\ookla\gps_fixed_tiles.shp"
            REM download the qgs file from GitHub
            curl https://raw.githubusercontent.com/aws-samples/appstream-qgis-blog/main/ookla-download-speed.qgs --output C:\ookla-example-project.qgs
            REM find and replace the placeholder RDS hostname with the real RDS hostname and add it to the OSGeo4W package
            powershell -Command "(gc C:\ookla-example-project.qgs) -replace 'placeholderhostname', '${RDSPostGIS.Endpoint.Address}' | Out-File -encoding ASCII C:\OSGeo4W\ookla-example-project.qgs"
