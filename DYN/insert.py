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
    flight_resp = put_flight("2021-12-06", "O37156", "SGN", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MU4415", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NH6374", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "OZ6997", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SV6247", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "VN3237", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "XY3315", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY2315", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "JT3941", "UPG", "SOQ", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ5707", "IVC", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY4556", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ348", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "S8654", "BHE", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SQ4505", "CHC", "HKK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8831", "CHC", "HKK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QF8555", "CHC", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8845", "CHC", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "G9447", "SHJ", "TRV", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KU332", "KWI", "TRV", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "J9650", "KWI", "TAS", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QF5456", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EK7508", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "JQ456", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IB7913", "DOH", "LHE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "OZ6976", "AUH", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MS8083", "AUH", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "LY9639", "AUH", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "S75215", "BTK", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "ZL6852", "BHQ", "DBO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NH1075", "FUK", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SV453", "KRT", "JED", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "RL8245", "SSH", "KZN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "BA6328", "DOH", "KRT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "7L41", "PVG", "GYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "DL8471", "CDG", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KL2289", "CDG", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AF191", "CDG", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "G841", "HKT", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SG9012", "BOM", "RKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "6E7973", "BLR", "CNN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TK349", "IST", "FRU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QR633", "DOH", "ISB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IB7917", "DOH", "ISB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "R39492", "YKS", "VVO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "YG9057", "KUL", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "XY3281", "AUH", "COK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "XY61", "JED", "RUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EK649", "DXB", "CMB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AI274", "MAA", "CMB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "6E1208", "MAA", "CMB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "S8112", "WLG", "PCN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ5345", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QF8569", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY4571", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8464", "KKE", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8250", "TRG", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ609", "ZQN", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY4587", "ZQN", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "HA4136", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EK5362", "BNE", "GLT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ7167", "BNE", "GLT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QF2333", "BNE", "GLT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "ZL3152", "ABX", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "JQ504", "SYD", "MEL", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "VA679", "PER", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SQ6958", "PER", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY6805", "PER", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "VA213", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SQ6936", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "EY6643", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "U6599", "GOJ", "DME", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MH5279", "RUH", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NH990", "HND", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TL404", "GTE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "HA5084", "HND", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CA1083", "NKG", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "7C711", "CJU", "TAE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "9T513", "CGN", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "J9638", "KWI", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KC909", "ICN", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "OZ6962", "ICN", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CX6231", "ICN", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TK6790", "HKG", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TK6782", "HKG", "ALA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KE362", "ICN", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "PQ7105", "SSH", "KBP", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "PQ7131", "SSH", "KBP", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AF4850", "SVO", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KL3238", "SVO", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SU1441", "SVO", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IO180", "ULK", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IE326", "ATD", "HIR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "GI4216", "CAN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QR929", "DOH", "MNL", "active"  ) 
    flight_resp = put_flight("2021-12-06", "KE624", "ICN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ3439", "SIN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "6E6876", "PNQ", "BLR", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
