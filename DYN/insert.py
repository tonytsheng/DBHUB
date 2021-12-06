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
    flight_resp = put_flight("2021-12-06", "VJ504", "HAN", "DAD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "RJ3841", "DOH", "AMM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IN239", "PNK", "JOG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "G56318", "KMG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KL4730", "CAN", "WNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "O37156", "SGN", "NNG", "unknown"  ) 
    flight_resp = put_flight("2021-12-06", "AQ1539", "HIA", "CAN", "active"  ) 
    flight_resp = put_flight("2021-12-06", "AQ1435", "YKH", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "ZH9821", "WUX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SC9821", "WUX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KY9821", "WUX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MH3722", "BBN", "MUR", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TV9852", "CTU", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AE784", "RMQ", "MZG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "TR898", "NRT", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MU4415", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "NH6374", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "OZ6997", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "SV6247", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "VN3237", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "XY3315", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "EY2315", "RUH", "AUH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "JT3941", "UPG", "SOQ", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ5707", "IVC", "CHC", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "EY4556", "WLG", "CHC", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "NZ348", "WLG", "CHC", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "S8654", "BHE", "CHC", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "SQ4505", "CHC", "HKK", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8831", "CHC", "HKK", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "QF8555", "CHC", "NSN", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "NZ8845", "CHC", "NSN", "landed"  ) 
    flight_resp = put_flight("2021-12-06", "SC9401", "CTU", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "ZH9401", "CTU", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MU9733", "DLU", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CA1461", "KWE", "PEK", "active"  ) 
    flight_resp = put_flight("2021-12-06", "HU7302", "SYX", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "3U3415", "NNG", "XIC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "BS307", "SIN", "DAC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CA4189", "CGQ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "3U8905", "FOC", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QF778", "MEL", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MF1899", "CAN", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CZ6199", "CAN", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "DL8627", "CDG", "DXB", "active"  ) 
    flight_resp = put_flight("2021-12-06", "MU5901", "JHG", "KMG", "active"  ) 
    flight_resp = put_flight("2021-12-06", "8L9904", "JHG", "KMG", "active"  ) 
    flight_resp = put_flight("2021-12-06", "GK411", "TAK", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SQ4412", "PMR", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ5105", "PMR", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CV649", "AKL", "PPQ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "X14779", "PRI", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "HM3084", "PRI", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "BG87", "DAC", "KUL", "active"  ) 
    flight_resp = put_flight("2021-12-06", "G9447", "SHJ", "TRV", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "KU332", "KWI", "TRV", "active"  ) 
    flight_resp = put_flight("2021-12-06", "AY6019", "SEZ", "DOH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "JL102", "HND", "ITM", "active"  ) 
    flight_resp = put_flight("2021-12-06", "HD83", "AKJ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "BC9", "FUK", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "SQ6926", "PER", "BNE", "active"  ) 
    flight_resp = put_flight("2021-12-06", "EY6950", "PER", "BNE", "active"  ) 
    flight_resp = put_flight("2021-12-06", "VA464", "PER", "BNE", "active"  ) 
    flight_resp = put_flight("2021-12-06", "EY6550", "ROK", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NH4716", "HND", "CTS", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "G56941", "CKG", "LXA", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "CZ8683", "NGB", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QG988", "PLM", "BTH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MH3743", "SBW", "BTU", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "OZ968", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CA6614", "PEK", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CX334", "PEK", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CX366", "PVG", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CX907", "MNL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "DB2010", "ANC", "HKG", "active"  ) 
    flight_resp = put_flight("2021-12-06", "CX98", "ANC", "HKG", "active"  ) 
    flight_resp = put_flight("2021-12-06", "CX982", "CAN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AM7772", "KMQ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "AF4926", "SVO", "SVX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MF4141", "YNJ", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "PC2033", "SAW", "AYT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "XC1407", "DUS", "AYT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "XC1313", "BRE", "AYT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MU5527", "YNT", "PVG", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "SC4602", "TAO", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "FM9173", "JNG", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QH101", "DAD", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "QR8012", "BOM", "DOH", "active"  ) 
    flight_resp = put_flight("2021-12-06", "EY4388", "BCN", "PMI", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "GX8807", "JNG", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "MU8376", "SHA", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CZ9731", "SJW", "CKG", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "G56955", "CKG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "G56172", "TSN", "NDG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CZ6739", "CAN", "SYX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "J9650", "KWI", "TAS", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "IN196", "PKN", "SRG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "F327", "AHB", "RUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "NZ3844", "PEK", "YNT", "cancelled"  ) 
    flight_resp = put_flight("2021-12-06", "CZ8656", "SWA", "LYI", "scheduled"  ) 
    flight_resp = put_flight("2021-12-06", "CA1914", "HGH", "CTU", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
