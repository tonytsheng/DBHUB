-- get how many slices in the cluster
-- split your file you are going to COPY into cluser by multiples of slices
select count(slice) from stv_slices;

-- row skew
-- distribution of rows 
select disstyle, skew_rows
from svv_table_info where ''table'' = 'mytable';


