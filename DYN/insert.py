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
    flight_resp = put_flight("2021-12-17", "GJ8715", "CAN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CV701", "AKL", "WAG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NZ642", "CHC", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SQ4548", "CHC", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EY4486", "CHC", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EY4572", "CHC", "ZQN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36871", "CAN", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SQ801", "SIN", "PEK", "active"  ) 
    flight_resp = put_flight("2021-12-17", "O36865", "HGH", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36909", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CA681", "LAX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CA1083", "NKG", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36913", "HGH", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "N7221", "SIN", "PEN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "AY5846", "HKG", "PER", "active"  ) 
    flight_resp = put_flight("2021-12-17", "BA4144", "HKG", "PER", "active"  ) 
    flight_resp = put_flight("2021-12-17", "QF8237", "HKG", "PER", "active"  ) 
    flight_resp = put_flight("2021-12-17", "JL7904", "HKG", "PER", "active"  ) 
    flight_resp = put_flight("2021-12-17", "CX170", "HKG", "PER", "active"  ) 
    flight_resp = put_flight("2021-12-17", "GI4033", "CGO", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CA1089", "NKG", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Y87911", "TPE", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "KL4300", "AMS", "CAN", "active"  ) 
    flight_resp = put_flight("2021-12-17", "CZ307", "AMS", "CAN", "active"  ) 
    flight_resp = put_flight("2021-12-17", "CZ465", "FRA", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FJ911", "SYD", "NAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QF3868", "SYD", "NAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E241", "PNQ", "NAG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NF211", "VLI", "SON", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Q2116", "MLE", "GAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36915", "TPE", "NGB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EY6665", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NZ8251", "WLG", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "RM724", "TBS", "EVN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QR490", "IKA", "DOH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QR454", "EBL", "DOH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QR436", "ISU", "DOH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QR458", "BGW", "DOH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Y87968", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36876", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Q2256", "MLE", "HAQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E6129", "PNQ", "BBI", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CA567", "LHR", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EK7538", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "AA9029", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FJ5514", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VA917", "BNE", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EI8060", "MEL", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36945", "WUX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "LX9001", "ZRH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "AI952", "HYD", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "IX612", "TRZ", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FZ331", "KHI", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FZ8005", "BOM", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "AC57", "YYZ", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SG717", "AMD", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "XY214", "RUH", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FZ713", "TBS", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E64", "BOM", "DXB", "cancelled"  ) 
    flight_resp = put_flight("2021-12-17", "SQ4368", "BHE", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QF1616", "PBO", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NZ8193", "TIU", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SJ604", "SOQ", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "OZ976", "ICN", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Y87932", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "S75309", "KJA", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QF4954", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SU803", "KJA", "FEG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E768", "GOI", "JAI", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "N42373", "NQZ", "KGD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E361", "GOI", "PNQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "GI4036", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VN416", "ICN", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VN55", "LHR", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "YG9044", "HGH", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "JQ253", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "BR3243", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EY4601", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NZ405", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "PA430", "AUH", "LHE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "6E8513", "DEL", "SHJ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "W22332", "SYU", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "Q6162", "SYU", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "NZ1711", "SYD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VN5408", "ICN", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VN340", "NGO", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "KE395", "SIN", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "SJ574", "LUW", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "JT773", "CGK", "UPG", "cancelled"  ) 
    flight_resp = put_flight("2021-12-17", "X16325", "SUB", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "JT801", "SUB", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QG341", "CGK", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "QG7341", "CGK", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "FP311", "CBR", "NTL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "O36860", "HGH", "JJN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "EY6440", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "VA1137", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "RU449", "HKG", "KJA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "CF205", "KIX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-17", "YG9072", "YNZ", "KIX", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
