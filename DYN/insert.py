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
    flight_resp = put_flight("2021-11-13", "TY108", "GEA", "MEE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "FX12", "IND", "KIX", "landed"  ) 
    flight_resp = put_flight("2021-11-13", "AI588", "BLR", "COK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "Y87945", "WUH", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O37211", "CTU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CK263", "HKG", "PVG", "landed"  ) 
    flight_resp = put_flight("2021-11-13", "KE316", "ICN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CF205", "KIX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CZ431", "ANC", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36851", "PEK", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "TK6479", "ISL", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CA8425", "HKG", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CA597", "MXP", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "RH569", "HKG", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CA1092", "PVG", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CK262", "PVG", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NZ8302", "WLG", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "EY972", "AUH", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "I99898", "SZX", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NZ5742", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "SQ4502", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "EY4494", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "Y87994", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "6E681", "BLR", "PAT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GI4116", "ICN", "LYI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "6E146", "CCU", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "G9497", "SHJ", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "JL754", "NRT", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "UK2754", "NRT", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GI4222", "YNT", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "UK8656", "FUK", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NH6270", "FUK", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NH987", "CTS", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GI4108", "CAN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CK258", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NH461", "OKA", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "NZ8231", "WLG", "ROT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36884", "SZX", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CA1085", "NKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "Y87433", "HKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36976", "HGH", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "TH6821", "HKG", "SZB", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "AF193", "CDG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "KL2347", "CDG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "KE249", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "PO276", "CVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "QR8981", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O37303", "HGH", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36888", "HGH", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36861", "NGB", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36947", "JJN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36875", "PEK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CZ409", "FRA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O37069", "MAA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "MS8074", "HKT", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "KJ2123", "ICN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "I99879", "SZX", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CF9020", "CAN", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "VN780", "SGN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "YG9007", "KIX", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GJ8941", "TSN", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GJ8707", "HAN", "XUZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GJ8971", "SGN", "XUZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GA9033", "AUH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "MH5261", "AUH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "XY3411", "AUH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "EY411", "AUH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "BG87", "DAC", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "BA5817", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "IB7945", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "LA5270", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "B66521", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "MH9054", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "QR853", "DOH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O37111", "HGH", "URC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36958", "HGH", "URC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36930", "JJN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "O36961", "CAN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GJ8710", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "GJ8507", "BAV", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CF9001", "NKG", "LHW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "R3495", "KHV", "YKS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "HZ2102", "KHV", "YKS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "BX792", "TAE", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "CG8490", "WBM", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "BZ102", "BOM", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "BZ304", "DEL", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "I5722", "DEL", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "1I522", "AUS", "BKS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "RI101", "UPG", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "ID6540", "KOE", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "ID6274", "MDC", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "ID6170", "AMQ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "YG9060", "HAK", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "PC2100", "ADA", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "PC410", "MCX", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "PR1809", "DVO", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "TK4633", "DVO", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-13", "C85525", "ANC", "OVB", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
