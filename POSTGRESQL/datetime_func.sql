select count(*), extract('hour' from reservedate) from fly.reservation group by extract('hour' from reservedate);

