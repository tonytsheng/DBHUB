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
    flight_resp = put_flight("2021-12-10", "ZL4612", "ADL", "MGB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37062", "NKG", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37145", "SZX", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "I99805", "MNL", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "CF9084", "TNA", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "I99867", "SZX", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AZ5379", "RUH", "GIZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "CX796", "HKG", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SL913", "BKK", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SJ257", "CGK", "SUB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QG430", "BPN", "SUB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JT3946", "UPG", "SUB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JT852", "UPG", "SUB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JT786", "UPG", "SUB", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "TL160", "GOV", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "CX2754", "HKG", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "YG9044", "HGH", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VN55", "LHR", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VN416", "ICN", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "OZ932", "CAN", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EY621", "AUH", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "XY3621", "AUH", "SEZ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AK5110", "BKI", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "G9455", "SHJ", "CCJ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AI937", "DXB", "CCJ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QR537", "DOH", "CCJ", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ8767", "CHC", "NPL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JQ507", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QR6040", "AXT", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "LY9640", "SYD", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "UA174", "SPN", "GUM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "UA200", "HNL", "GUM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JT798", "DJJ", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "X16244", "DJJ", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SU5600", "KHV", "VVO", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NH631", "IWK", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "IX251", "SHJ", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "ET611", "ADD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "TM7611", "ADD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AI7551", "ADD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "BZ154", "AMD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "G9409", "SHJ", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "BA138", "LHR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AA6658", "LHR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "IB7364", "LHR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "LX155", "ZRH", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "I5331", "GOI", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AF217", "CDG", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "KL2165", "CDG", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "DL8706", "CDG", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "UK105", "SIN", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "N42145", "GYD", "UFA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "RU220", "SVO", "KJA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AK6351", "KCH", "BKI", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37255", "KIX", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "CF9007", "NKG", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37251", "WUH", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QF2077", "MEL", "MQL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "MU4259", "MEL", "MQL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7047", "MEL", "MQL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EK5105", "MEL", "MQL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NH985", "ITM", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "GA9968", "ITM", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "DL7300", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EY6511", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SQ6871", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VA401", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EK5670", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7670", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AS5063", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "MU4179", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QF670", "MEL", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7045", "WYA", "ADL", "cancelled"  ) 
    flight_resp = put_flight("2021-12-10", "QF2071", "WYA", "ADL", "cancelled"  ) 
    flight_resp = put_flight("2021-12-10", "EY6603", "BNE", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SQ6923", "BNE", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VA1385", "BNE", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JQ761", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7883", "PER", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QF883", "PER", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EK5732", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "JQ6732", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NF3051", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7732", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "LA4806", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QF732", "SYD", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VA9217", "OCM", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "VA1835", "PHE", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "SQ6742", "PHE", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EY6777", "PHE", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "QF1616", "PBO", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "NZ7272", "PBO", "PER", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "AI191", "EWR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "6E8271", "DXB", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "6E5316", "BLR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37138", "FOC", "HIA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "O37264", "CSX", "HIA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "I99872", "CGO", "HIA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "EK5103", "SYD", "TMW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-10", "MU4317", "SYD", "TMW", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
