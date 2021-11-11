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
    flight_resp = put_flight("2021-11-12", "EY1004", "AKL", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37169", "HGH", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "GI4027", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "Y87985", "PEK", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37112", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "Y87969", "CGO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36957", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36859", "JJN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CF9085", "PKX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36927", "CTU", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9101", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9033", "SIN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9046", "SGN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7332", "TSV", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36881", "SZX", "WNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37069", "MAA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36875", "PEK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36947", "JJN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36861", "NGB", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37303", "HGH", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "EK385", "DXB", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TP6375", "DXB", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TG4503", "DXB", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "8K804", "SIN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "Y87952", "PVG", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "KE654", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "DL7918", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "JL718", "NRT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "UL3339", "NRT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "AA8472", "NRT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "KL844", "AMS", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9022", "XIY", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TG972", "ZRH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "KL804", "AMS", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "GJ8522", "LYI", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TG910", "LHR", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "AC6123", "LHR", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "NH5958", "NGO", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TG6726", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "ET1299", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "AC6997", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "OS8051", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "S74517", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7445", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7405", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "OZ6961", "ALA", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "HT3811", "WEH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7404", "SYD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7305", "MEL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7338", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CX178", "HKG", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QR3488", "HKG", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "BA4140", "HKG", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "AY5844", "HKG", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "SQ218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "UK8218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "TK9311", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "LH9777", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "QF7412", "BNE", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "NH871", "CGK", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36888", "HGH", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CF9033", "NKG", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36877", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36995", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9005", "CTU", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9043", "HAN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CV6595", "MIA", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9071", "KIX", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "GI4113", "HFE", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36921", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37213", "FOC", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CX261", "CDG", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37309", "PEK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CZ441", "LAX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36882", "SZX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36957", "PEK", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37212", "CGO", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37072", "SZX", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36969", "HGH", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37095", "HGH", "SWA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "SB800", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "JL5370", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "AF4020", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9134", "HGH", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "R3401", "CYX", "YKS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "DZ6259", "HAK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CF9019", "PKX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37156", "SGN", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "PO717", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "PO276", "CVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "RU492", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "KE335", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "CK257", "ICN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "GA656", "DJJ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "YG9160", "KMG", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O37215", "HIA", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "HT3809", "KHN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "O36927", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "RU388", "SVO", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-12", "GI4213", "HGH", "CGO", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
