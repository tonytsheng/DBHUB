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
    flight_resp = put_flight("2021-09-23", "3U8181", "KHN", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "GR651", "GCI", "SOU", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "P8126", "CLJ", "BRQ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "AF7773", "YIW", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MF5224", "CTU", "LXA", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CA8791", "DLC", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MM583", "CTS", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MU7051", "ORD", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "5X910", "LAX", "RFD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "FR3341", "PFO", "TLL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "JD5809", "KWL", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "FX1434", "IAD", "MEM", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "EY6338", "CNS", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "LA4772", "GRU", "GYN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "FX1409", "MCO", "MEM", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "ET1067", "LOS", "DLA", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "RO9536", "CDG", "TLS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "5X956", "MHR", "RFD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "AF1860", "LDE", "ORY", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "KZ133", "ANC", "ORD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CZ6535", "PVG", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CZ7661", "AMS", "LHR", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "BA578", "VCE", "LHR", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "UX4025", "PMI", "ALC", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CV7783", "MEX", "JFK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "AD4737", "REC", "VIX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "SV1700", "ABT", "JED", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "0B5904", "LIN", "MAD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "EY2683", "KUL", "KBR", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "WF970", "KKN", "VDS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "B78921", "KNH", "KHH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "G56481", "KWE", "ACX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MU8447", "CSX", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "OQ2339", "CAN", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "JD5439", "FNC", "LIS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "FX1421", "ATL", "MEM", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "OU5667", "FRA", "OSL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CXI386", "HER", "HAJ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CA3328", "SZX", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "BA500", "LIS", "LHR", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CZ3209", "WUX", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MU3745", "WNZ", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "JL2244", "ITM", "KIJ", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "JL2871", "CTS", "KIJ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CI9903", "CTS", "KIJ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "HA5936", "CTS", "KIJ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "LD3864", "HKG", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "VZ208", "UTH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "VZ102", "CNX", "BKK", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "VZ350", "URT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "RH332", "HKG", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MH3013", "BKI", "LDU", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MH2613", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "HZ530", "KVR", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "WY5624", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "HZ9236", "NGK", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "IK77", "AER", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "BA7905", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "N477", "AER", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "QR5442", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "U6174", "SVX", "KHV", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PR3539", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "FY7649", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "EK3435", "KUL", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "ZL3469", "MEL", "MIM", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "RY8885", "HET", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MF2095", "HET", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CZ3376", "CAN", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MF1168", "CAN", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "9C8923", "ZHA", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "ZH9393", "LYI", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "KY9393", "LYI", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "G56194", "CKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "G56440", "CKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "CA4562", "CKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "ZH4562", "CKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "SC4562", "CKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "ZH8906", "HUZ", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "KY9906", "HUZ", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MU9066", "PVG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "HU7091", "URC", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "MU5681", "HAK", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "NS3301", "SYX", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "RY2001", "SYX", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "MF7071", "SYX", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "CZ9771", "SYX", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "JD5324", "HAK", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PF141", "LHE", "KHI", "cancelled"  ) 
    flight_resp = put_flight("2021-09-23", "ER520", "LHE", "KHI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PK582", "RYK", "KHI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PK302", "LHE", "KHI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PK6401", "DAM", "KHI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "PA200", "ISB", "KHI", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "B79167", "MZG", "KHH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "B78915", "KNH", "KHH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "GS7562", "URC", "KHG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "7R493", "TBW", "AER", "scheduled"  ) 
    flight_resp = put_flight("2021-09-23", "TV6010", "XNN", "YUS", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
