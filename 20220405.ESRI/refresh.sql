-- drop index "JEFFDM"."SHAPE_142114_2_SIDX" ;
delete from esrifeatureclass;
commit;
insert into esrifeatureclass select * from esrifeatureclass_base;
commit;
-- CREATE INDEX "JEFFDM"."SHAPE_142114_2_SIDX" ON "JEFFDM"."ESRIFEATURECLASS" ("SHAPE")
-- INDEXTYPE IS "MDSYS"."SPATIAL_INDEX"  PARAMETERS ('SDO_COMMIT_INTERVAL = 1000 ');  
delete from gdelttest;
commit;
insert into gdelttest select * from gdelttest_base;
commit;
exit

