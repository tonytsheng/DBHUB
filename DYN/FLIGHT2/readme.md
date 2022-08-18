## Existing Relational Model
- FLIGHT
- flightno
- airline
- dep airport
- arr airport
- scheduled dep time
- scheduled arr time

PASSENGER
- pass id
- lname, fname, address
- phone
- email

BAGGAGE
- bag id
- description

- FLIGHT_PASS_BAG
flight no
passid
bagid


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
- SCHEDULED_DEPARTURE_TIME - SK
-  IATA - DEP ARR
-   TIMES - ACTUALDEP ACTUALARR
-   PASSENGER - FNAME LNAME PHONE EMAIL
-   BAGGAGE - ID1 ID2 ID3

GSI:
- 1 - SCHEDULED_DEPARTURE_TIME - PK, FLIGHTNUMBER - SK
INCLUDE ALL COLS

- 2 - PASS_LAST_NAME, DEP AIRPORT INCLUDE ALL COLS
- 3 - ARR AIRPORT

LSI:

 
