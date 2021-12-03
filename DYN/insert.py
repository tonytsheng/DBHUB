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
    flight_resp = put_flight("2021-12-04", "U62828", "CEK", "LBD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "8L9527", "KWE", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "9C6334", "SHE", "CGO", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "MU3813", "DLC", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "HO1933", "DLC", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "PN6249", "AKU", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "O37185", "DAC", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "RH9366", "HKG", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "8L9519", "KOW", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "8L9517", "WNZ", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IW1323", "BPN", "PLW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "JT641", "UPG", "PLW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "X16318", "UPG", "PLW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "JT781", "UPG", "PLW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "JL3052", "NRT", "FUK", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "BC591", "OKA", "UKB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "BC131", "KOJ", "UKB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "JH232", "MMJ", "UKB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "DZ6228", "SZX", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CZ9914", "SZX", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZH8837", "KMG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "O36918", "SZX", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "Y87936", "CAN", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CI5238", "KIX", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "GA9410", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "JU7729", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "KE5923", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "SU251", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZL2112", "PER", "ALH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "9C8821", "TAO", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "9C6733", "LJG", "SHA", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "9C8909", "JJN", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "9C8815", "XMN", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "FJ391", "HKG", "NAN", "active"  ) 
    flight_resp = put_flight("2021-12-04", "AI6171", "HKG", "NAN", "active"  ) 
    flight_resp = put_flight("2021-12-04", "Y87994", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "MU8321", "TAO", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IL7322", "DJJ", "WMX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IO205", "OVB", "NJC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZF839", "MLE", "VKO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "QR1332", "DOH", "KRT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "EY6509", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "6E106", "GOI", "CCU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "G58615", "TNA", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CA3401", "PEK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "PN6217", "XUZ", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "NH5314", "KIX", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "MF8502", "XMN", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "KM2389", "DOH", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IX136", "DEL", "SHJ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "BR678", "TPE", "CKG", "active"  ) 
    flight_resp = put_flight("2021-12-04", "GJ6011", "SWA", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "HU7745", "XUZ", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "HA5117", "IZO", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "6E244", "AMD", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "UC1505", "VCP", "SID", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ET3706", "LGG", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "A4234", "ROV", "TJM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZH2617", "TNA", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "GI4104", "CAN", "LYG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "NH8537", "TPE", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "QW9873", "KWL", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZH9824", "CAN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "LJ359", "PUS", "GMP", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZH3819", "INC", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "HA5455", "CTS", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "MH9175", "CTS", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "MF3722", "CZX", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "OZ8911", "CJU", "GMP", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "3K556", "SIN", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "VJ602", "CXR", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "VN244", "HAN", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "QH154", "DAD", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "QH1571", "VKG", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "DL7869", "DFW", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "KE73", "YYZ", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "KE31", "DFW", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "GA641", "UPG", "AMQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "TG6745", "JFK", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IW3520", "BXB", "AMQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CM8004", "JFK", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "UA7293", "JFK", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IL429", "JIO", "AMQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "OZ222", "JFK", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "IW1516", "SXK", "AMQ", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "SV1421", "JED", "MED", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "PR412", "KIX", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "Q6226", "GIC", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "W22309", "GIC", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CA1847", "NKG", "PEK", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "MF3104", "XIY", "NGB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "AM7736", "KMJ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CI5198", "LAX", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CA3486", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CZ9731", "SJW", "CKG", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "NS3241", "SJW", "CKG", "cancelled"  ) 
    flight_resp = put_flight("2021-12-04", "SC3675", "THQ", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "QF3450", "LPT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "ZH9303", "CGO", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-04", "CA605", "DXB", "PEK", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
