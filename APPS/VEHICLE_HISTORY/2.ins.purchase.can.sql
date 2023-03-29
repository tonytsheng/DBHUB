use tyler;
insert into purchase
(year, make_name, model_name, color_name, status, purchase_date)
values 
( (SELECT year(CURRENT_DATE - INTERVAL FLOOR(RAND() * 2900) day))
	, (select make_name from make order by rand() limit 1)
	, (select model_name from make order by rand() limit 1)
	, (select color_name from color order by rand() limit 1)
	, 'CANCELLED'
	, (SELECT CURRENT_DATE - INTERVAL FLOOR(RAND() * 780) DAY) 
);

