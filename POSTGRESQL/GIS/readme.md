## Postgresql and PostGIS
This is a slimmed down version of the code from this link: https://aws.amazon.com/blogs/publicsector/how-to-deliver-performant-gis-desktop-applications-amazon-appstream-2-0/. This code was run from an EC2 bastion host.

## Create PostGIS extensions
```
CREATE EXTENSION postgis;
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis_tiger_geocoder;
CREATE EXTENSION postgis_topology;
ALTER SCHEMA tiger OWNER TO rds_superuser;
ALTER SCHEMA tiger_data OWNER TO rds_superuser;
ALTER SCHEMA topology OWNER TO rds_superuser;
```
## Get the sample data
```
mkdir /home/ec2-user/data/GIS
aws s3 cp s3://ookla-open-data/shapefiles/performance/type=fixed/year=2021/quarter=3/2021-07-01_performance_fixed_tiles.zip /home/ec2-user/data/GIS  --no-sign-request
cd /home/ec2-user/data/GIS
unzip 2021-07-01_performance_fixed_tiles.zip
```
## Install osgeo on your EC2 instance 
(see https://gist.github.com/abelcallejo/e75eb93d73db6f163b076d0232fc7d7e)
```
cd /tmp
wget https://download.osgeo.org/proj/proj-6.1.1.tar.gz
tar -xvf proj-6.1.1.tar.gz
cd proj-6.1.1
./configure
sudo make
sudo make install

cd /tmp
wget https://github.com/OSGeo/gdal/releases/download/v3.2.1/gdal-3.2.1.tar.gz
tar -xvf gdal-3.2.1.tar.gz
cd gdal-3.2.1
./configure --with-proj=/usr/local --with-python
sudo make
sudo make install
```
## Load the shapefile into your PostgreSQL database
```
ogr2ogr -f "PostgreSQL" "PG:host=<database endpoint> user=<username> dbname=<dbname> password=<password>" "/home/ec2-user/data/GIS/gps_fixed_tiles.shp"
```

## Run your GIS application and connect to your PostgreSQL database. Add the appropriate layer.
