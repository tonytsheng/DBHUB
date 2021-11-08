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
    flight_resp = put_flight("2021-11-09", "O37110", "HFE", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "K4835", "ANC", "ICN", "active"  ) 
    flight_resp = put_flight("2021-11-09", "YG9074", "YNZ", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA8438", "PVG", "KIX", "cancelled"  ) 
    flight_resp = put_flight("2021-11-09", "S75227", "IKT", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9008", "CSX", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9058", "CKG", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9118", "KMG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9051", "KUL", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36866", "PEK", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36977", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36973", "SIN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87970", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4207", "KIX", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36912", "SZX", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ZM559", "DME", "FRU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y7910", "NSK", "TJM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CZ491", "STN", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87911", "TPE", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA1089", "NKG", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CZ449", "AMS", "CAN", "active"  ) 
    flight_resp = put_flight("2021-11-09", "Y87423", "MNL", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DL7918", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TK8020", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OS8639", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LY8401", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TV7122", "HGH", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TY401", "ILP", "GEA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TY307", "UVE", "GEA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TY108", "GEA", "MEE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9025", "MNL", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SB140", "SYD", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "5J551", "CEB", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DG6177", "MBT", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "5J649", "TAC", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NH5344", "BKK", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OZ9778", "BKK", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GJ8929", "HLD", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ8479", "WLG", "WRE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TG316", "BKK", "DEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF5456", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "EK7508", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "JQ456", "BNK", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "EY6421", "HBA", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ6662", "HBA", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "VA1528", "HBA", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF2121", "GFF", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "JQ505", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "BA7437", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "EK5409", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ1809", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF409", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "RI101", "UPG", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ID6540", "KOE", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ID6274", "MDC", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GA648", "TTE", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ID6170", "AMQ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9060", "HAK", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9057", "NKG", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF8548", "WLG", "GIS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TP8986", "BRU", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ET734", "CDG", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NH5352", "CDG", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "AC6025", "CDG", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ET644", "BKK", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TM7644", "BKK", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ6078", "BKK", "ADD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QQ4072", "MCY", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LH9777", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-11-09", "TK9311", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-11-09", "UK8218", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-11-09", "SQ218", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-11-09", "KE362", "ICN", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "KL422", "DMM", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "WY5442", "DMM", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DL9227", "DMM", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DL8192", "DMM", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "AF8372", "DMM", "MCT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "IW1957", "WGP", "KOE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QG10", "KNO", "HLP", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA1043", "AMS", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87972", "SZX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87465", "ANC", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF207", "NRT", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NH8518", "NRT", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CK225", "ORD", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NH9702", "NRT", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "PA8700", "JED", "MUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "PK9951", "KHI", "MUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "G9481", "AMD", "SHJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "G9516", "DAC", "SHJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "IE828", "MHM", "AKS", "cancelled"  ) 
    flight_resp = put_flight("2021-11-09", "EK5404", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "BA7438", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "PG4585", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ1804", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF404", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "EK5410", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "PG4587", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ1810", "SYD", "MEL", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
