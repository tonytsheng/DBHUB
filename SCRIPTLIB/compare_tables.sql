select ... from (
 select 1 OLD#, 0 NEW#, ... from old_t
 union all
 select 0 OLD#, 1 NEW#, ... from new_t
)
group by ...
having sum(OLD#) != sum(NEW#)

