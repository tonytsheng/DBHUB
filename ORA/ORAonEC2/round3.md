+ Data
/u02 
/u03

+Flash Cache - 40G
/fast01

+ TEMP tablespace
/fast01

only 1 instance store volume available so bump up flash cache size to 40G

put the temp tablespace on an instance store volume

recreate 3 log groups to be 3 members of 2G each
