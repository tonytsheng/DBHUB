insert into
fly.reservation (lname, fname, seatno, flightno, dep, arr, reservedate)
values 
( (    select last_name from fly.employee offset random() * (select count(*) from fly.employee) limit 1 ), 
  (    select first_name from fly.employee offset random() * (select count(*) from fly.employee) limit 1 ), 
--  '${seatnumber}${seatletter}',
  ( (select floor(random()* (50-10 + 10) + 10)) || (SELECT upper(array_to_string(ARRAY(SELECT chr((97 + round(random() * 8)) :: integer) FROM generate_series(1,1)), '')))),

      
--	'9C',
--    'AA120', 
   (SELECT upper(array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer) FROM generate_series(1,3)), '')) || (select floor(random()* (99-10 + 10) + 10))), 


--  '${flightno}',
  (    select iata_code from fly.airport offset random() * (select count(*) from fly.airport) limit 1 ), 
  (    select iata_code from fly.airport offset random() * (select count(*) from fly.airport) limit 1 ), 
  now());
select count(*) from fly.reservation;
\q
EQ
