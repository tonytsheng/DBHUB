#!/usr/bin/python

import csv
import time
import socket
import array
import os
from collections import defaultdict

# PrintMsg
def PrintMsg (msg):
    print (time.strftime("%Y-%m-%d %H:%M:%S") + ": " + msg)

host = socket.gethostname().split('.',1)[0]
PrintMsg("HOST: " + host)
ssirep = "/home/user/dba_arch/scripts/install/ssi/rep." + host
PrintMsg("SSI_REP: " + ssirep)

# snippet-start:[dynamodb.python.codeexample.MoviesItemOps01]
from pprint import pprint
import boto3
boto3.setup_default_session(profile_name='ec2')

def put_flight(flight_date, flight_number, arrival_airport, departure_airport, flight_status, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

    table = dynamodb.Table('flight')
    response = table.put_item(
       Item={
            'flight_date': flight_date,
            'flight_number': flight_number,
            'arrival_airport': arrival_airport,
            'departure_airport': departure_airport,
            'flight_status': flight_status,
        }
    )
    return response

if __name__ == '__main__':
    flight_resp = put_flight("2021-11-05", "GA9346", "CTS", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "6E9001", "CCJ", "DEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "UA8653", "YYZ", "DEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FZ460", "DXB", "CCU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ5784", "ROT", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ5180", "PMR", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ5346", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY4612", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "S8711", "WKA", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ1294", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ4366", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "BR3216", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF2256", "LDH", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GI4023", "SZX", "WEF", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HT3811", "WEH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "O37302", "WUH", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "YG9166", "YIW", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "O37238", "SZX", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "YG9164", "HGH", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "XY3205", "AUH", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "6E1413", "SHJ", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "J9402", "KWI", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GI4018", "XIY", "XUZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "N4383", "EVN", "KUF", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HZ4704", "YKS", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AA8946", "HKG", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF8240", "HKG", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "JL7914", "HKG", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CX632", "HKG", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "PX852", "PNP", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CZ411", "ANC", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "I99807", "KUL", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY6337", "MKY", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HA4017", "MKY", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ6496", "MKY", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VA601", "MKY", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7915", "ISA", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF1076", "ISA", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY6304", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HA4008", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ6450", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VA771", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY6472", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ6472", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF5928", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VA1707", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7661", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "JQ928", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AS5056", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7750", "TSV", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF661", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK5596", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF750", "TSV", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7162", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF5759", "HBA", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF2332", "GLT", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "JQ759", "HBA", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7204", "EMD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF2402", "EMD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY6409", "PPP", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ6508", "PPP", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VA1113", "PPP", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK5640", "BNE", "ROK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF5457", "SYD", "BNK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK7511", "SYD", "BNK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "JQ457", "SYD", "BNK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY6423", "MCY", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ6672", "MCY", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VA475", "MCY", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK5265", "CFS", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7060", "CFS", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF2104", "CFS", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "BA7463", "ABX", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7018", "ARM", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK5169", "ARM", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF840", "DRW", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MU4302", "DRW", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7840", "DRW", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF2205", "ABX", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NZ7105", "ABX", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK5172", "ABX", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MU6606", "WNZ", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CA601", "LAX", "PEK", "active"  ) 
    flight_resp = put_flight("2021-11-05", "O36969", "HGH", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF7523", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FJ430", "SUV", "AKL", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "TG952", "CPH", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "TG4505", "DXB", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EK379", "DXB", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QF8606", "WLG", "ROT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LH755", "FRA", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SK3223", "FRA", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AI8755", "FRA", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AC9057", "FRA", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "6E146", "CCU", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G9497", "SHJ", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY2315", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY246", "COK", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY474", "CGK", "AUH", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
