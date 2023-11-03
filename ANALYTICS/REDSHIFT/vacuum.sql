-- svv_table_info is not a postgresql thing, just a redshift thing

select "table", size, tbl_rows, estimated_visible_rows
from SVV_TABLE_INFO
where "table" = 'orders';


delete orders where o_orderdate between '1997-01-01' and '1998-01-01';
select "table", size, tbl_rows, estimated_visible_rows
from SVV_TABLE_INFO
where "table" = 'orders';
vacuum delete only orders;

