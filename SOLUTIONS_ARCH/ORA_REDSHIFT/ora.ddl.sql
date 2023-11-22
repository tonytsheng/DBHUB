create table trip 
  (vendorid varchar(40)
  , pickup_datetime timestamp
  , dropoff_datetime timestamp
  , ratecode int
  , passenger_count int
  , trip_distance numeric(4,2)
  , fare_amount	numeric(4,2)
  , total_amount numeric(4,2)
  , payment_type int
);

create table vendor
(vendorid varchar(40)
  , vendorname varchar(40)
  , vendorzip varchar(5)
);

create table payment
(payment_type int
  , payment_desc varchar(40)
);

