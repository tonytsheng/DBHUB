CREATE TABLE sde.gis_osm_buildings_wkt AS (SELECT mdsys.sdo_util.tO_WKTGEOMETRY(SHAPE) AS wktshape, OBJECTID, OSM_ID, CODE, FCLASS, NAME, TYPE, SE_ANNO_CAD_DATA FROM sde.gis_osm_buildings_a_free_1);

