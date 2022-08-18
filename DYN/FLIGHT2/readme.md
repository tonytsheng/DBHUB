## Business Context 
Store and query flight info

## What data do you need to store:
- FLIGHTNUMBER
- SCHEDULED_DEP_TIME
- DEP_IATA
- ARR_IATA
- ACTUAL_DEP_TIME
- ACTUAL_ARR_TIME
- PASSENGER FNAME 
- LNAME 
- PHONE 
- EMAIL 
- BAGID1 
- BAGID2

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

FLIGHTNUMBER - PK
SCHEDULED_DEPARTURE_TIME - SK
  IATA - DEP ARR
  TIMES - ACTUALDEP ACTUALARR
  PASSENGER - FNAME LNAME PHONE EMAIL
  BAGGAGE - ID1 ID2 ID3

GSI:
1 - FLIGHTNUMBER, PASSLNAME
INCLUDE ALL COLS

2 - FLIGHTNUMBER, PASSLNAME
INCLUDE ALL COLS

LSI:

 
