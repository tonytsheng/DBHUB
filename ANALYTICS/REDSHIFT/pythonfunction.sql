create function f_sql_greater (float, float)
  returns float
stable
as $$
  select case when $1 > $2 then $1
    else $2
  end
$$ language sql;  

select f_sql_greater (l_extendedprice, l_discount) from lineitem limit 10

