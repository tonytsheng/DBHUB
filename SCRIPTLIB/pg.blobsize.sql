select count(*), concat(length(logo) / 1048576.0, ' MB') as the_size
from customer_orders.stores
group by (length(logo));
\quit
