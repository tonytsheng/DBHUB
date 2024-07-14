## Generating Sample Data and Loading into DDB

## Create table in DDB

## Generate Flight Data
various scripts in here to do this
best one is : 0.gen_flight_data.bsh
which looks at some reference data in other directories but generates a csv

./0.gen_flight_data.bsh <year for sample data> <output file>

## Load Data
loading the flight table from a csv file using 1.csv_load_flight.py
python3 1. <DDB Table Name> <csv input file>
