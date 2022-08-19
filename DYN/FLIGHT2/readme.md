## Existing Relational Model
- FLIGHT
  - flightno
  - airline
  - dep airport
  - arr airport
  - scheduled dep time
  - scheduled arr time

- PASSENGER
  - pass id
  - lname, fname, address
  - phone
  - email

- BAGGAGE
  - bag id
  - description

- FLIGHT_PASS_BAG
  - flight no
  - passid
  - bagid

- Sample query
  - select flightno, departure_airport, scheduled_dep_time, pass_lname, pass_phone, bag_id, bag_description from flight_pass_bag fpb, passenger p, flight f where f.flight_id=fpb.flight_id and fpb.pass_id=p.pass_id and fpb.bagid=b.bag_id

## Business Context 
Store and query flight info

## What data do you need to store:
A flight that has the following attributes:
- FLIGHTNUMBER
- SCHEDULED_DEP_TIME
- DEP_IATA
- ARR_IATA
- ACTUAL_DEP_TIME
- ACTUAL_ARR_TIME
- PASS_FIRST_NAME 
- PASS_LAST_NAME 
- PASS_PHONE 
- PASS_EMAIL 
- PASS_BAGID1 
- PASS_BAGID2

## Access patterns - how do you search this data
- FLIGHTNUMBER
- scheduled time
- arrived time
- DEP_IATA
- ARR_IATA
- Depart or Arrival window of time
- PASS LNAME PHONE EMAIL
- BAGID

## What might the single table model look like
- FLIGHTNUMBER - PK
- SCHEDULEDTIME#DEP - SK
- SCHEDULEDTIME#ARR 
- AIRPORT#DEP 
- AIRPORT#ARR 
- ACTUALTIME#DEP 
- ACTUALTIME#ARR
- PASSENGER#FNAME 
- PASSENGER#LNAME 
- PASSENGER#PHONE 
- PASSENGER#EMAIL 
- BAGGAGE#ID1 
- BAGGAGE#ID2 
- BAGGAGE#ID3 

GSI:
# inherit rcu/wcu from the base table
# create after table gets created
# projections - KEYS_ONLY, INCLUDE, ALL
- 1 - SCHEDULED_DEPARTURE_TIME - PK, FLIGHTNUMBER - SK INCLUDE ALL COLS -- don't need this because this is already in the base table
- 2 - PASSENGER#LNAME, IATA#DEP
- 3 - PASSENGER#LNAME, BAGGAGE#ID1
- 4 - ACTUAL#DEP, IATA#DEP

LSI:
# contains a copy of all the data from the base table
# 5 per table
# projections - KEYS_ONLY, INCLUDE, ALL
# created when the table is created 
- 1 - FLIGHTNUMBER PK, AIRPORT#DEP, AIRPORT#ARR
- 2 - FLIGHTNUMBER PK, SCHEDULEDTIME#ARR, SCHEDULEDTIME#DEP
- 4 - FLIGHTNUMBER PK, PASSENGER#LNAME

 
