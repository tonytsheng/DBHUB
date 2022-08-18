## Business Context - store and query flight info

## What data do you need to store:
  FLIGHTNUMBER
  SCHEDULED_DEP_TIME
  DEP_IATA
  ARR_IATA
  ACTUAL_DEP_TIME
  ACTUAL_ARR_TIME
  PASSENGER FNAME 
    LNAME 
    PHONE 
    EMAIL 
    BAGID1 
    BAGID2

## Model - what elements go in this single table
single flight identified by a flight number
  FLIGHTNUMBER - PK
  TIME_SCHEDULED - SK
    IATA - DEP ARR
    TIMEACTUAL - DEP ARR
    PASS - FNAME LNAME PHONE EMAIL
    BAG - ID1 ID2
what makes the row unique - FLIGHTNUMBER and TIME_SCHEDULED

## Access patterns - how do you search this data
  FLIGHTNUMBER
scheduled time
arrived time
  DEP_IATA
  ARR_IATA
  Depart or Arrival window of time
  PASS LNAME PHONE EMAIL
  BAGID

## Summary
Table Name
PK
SK
LSIs
GSIs

 
