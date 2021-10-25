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
    flight_resp = put_flight("2021-10-26", "HO1055", "YKH", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CZ3807", "JIQ", "CSX", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "HU7897", "XIY", "SYX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "P47662", "LOS", "BJL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "TY107", "MEE", "GEA", "active"  ) 
    flight_resp = put_flight("2021-10-26", "O37061", "KIX", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CZ9039", "DCY", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "MU3377", "DCY", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "MF5023", "DCY", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "JR1529", "TSN", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "GJ8103", "NBS", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "TV6921", "NBS", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "AK6062", "KCH", "BTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "Y87422", "SZX", "CRK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "Y87492", "PVG", "TSN", "active"  ) 
    flight_resp = put_flight("2021-10-26", "GI4023", "SZX", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "QF410", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NZ1810", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "PG4587", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "EK5410", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NH4800", "SDJ", "CTS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NH1764", "OKA", "ISG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "JL277", "IZO", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "QR6049", "IZO", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "HA5117", "IZO", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "JL221", "KIX", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "MH9167", "KIX", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "QR6045", "KIX", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "HA5085", "KIX", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "AY5816", "KIX", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NH203", "FRA", "HND", "active"  ) 
    flight_resp = put_flight("2021-10-26", "GI4116", "ICN", "LYI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "TK6175", "IST", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CA551", "LHR", "PEK", "active"  ) 
    flight_resp = put_flight("2021-10-26", "O37212", "PVG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "O36952", "PVG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "Y87938", "PVG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "YG9006", "HGH", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "O36999", "PKX", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "QG7915", "CGK", "KNO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CX6", "NRT", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "O36890", "NGB", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CX3123", "SYD", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "RU738", "SVO", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "CX105", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "OM5611", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "AY5095", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "QR5830", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "LH7013", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "BA4567", "MEL", "HKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "CF9007", "NKG", "CSX", "landed"  ) 
    flight_resp = put_flight("2021-10-26", "JQ251", "WLG", "AKL", "unknown"  ) 
    flight_resp = put_flight("2021-10-26", "EK7488", "WLG", "AKL", "unknown"  ) 
    flight_resp = put_flight("2021-10-26", "QF4962", "WLG", "AKL", "unknown"  ) 
    flight_resp = put_flight("2021-10-26", "LA5699", "AKL", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "JQ292", "AKL", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "GJ5379", "INC", "CSX", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "MU8177", "INC", "CSX", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "KE624", "ICN", "MNL", "active"  ) 
    flight_resp = put_flight("2021-10-26", "SQ913", "SIN", "MNL", "active"  ) 
    flight_resp = put_flight("2021-10-26", "NZ3439", "SIN", "MNL", "active"  ) 
    flight_resp = put_flight("2021-10-26", "QR929", "DOH", "MNL", "active"  ) 
    flight_resp = put_flight("2021-10-26", "CF9065", "NKG", "XMN", "unknown"  ) 
    flight_resp = put_flight("2021-10-26", "YG9071", "KIX", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "YG9035", "KIX", "YNT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "QR8353", "DOH", "CKG", "active"  ) 
    flight_resp = put_flight("2021-10-26", "PX200", "LAE", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "PX120", "WWK", "POM", "active"  ) 
    flight_resp = put_flight("2021-10-26", "MF5328", "KWE", "INC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "GI4106", "LYG", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "3U2110", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "CZ4034", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "MU8024", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "NS6058", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "MF8058", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "MF8930", "HGH", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-26", "G58568", "PVG", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "DL6442", "PVG", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "MU5674", "PVG", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "AC6657", "PEK", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NZ3943", "PEK", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SC8903", "PEK", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "ZH4805", "PEK", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CA8903", "PEK", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "ZH2576", "TNA", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "CA4648", "TNA", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "TV6786", "TNA", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SC4648", "TNA", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "KL2914", "SVO", "KGD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SU1009", "SVO", "KGD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "AC6298", "LHR", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "NZ3308", "LHR", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "VS7973", "LHR", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SQ8502", "PEN", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SQ308", "LHR", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-26", "SQ8546", "BKK", "SIN", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
