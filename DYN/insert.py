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
    flight_resp = put_flight("2021-10-22", "LH4921", "FRA", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ680", "WLG", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "EY4762", "WLG", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4035", "CGO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36886", "TAO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87985", "PEK", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87933", "PEK", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87969", "CGO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36957", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36859", "JJN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF9085", "PKX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O37112", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "YG9071", "KIX", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36862", "SZX", "NGB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36849", "CAN", "NGB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "MU779", "AKL", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CZ451", "AMS", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87911", "XMN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87417", "HKG", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87403", "TSN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "YG9049", "MNL", "YIW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7458", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7454", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7353", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7356", "LST", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF9065", "NKG", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ8807", "CHC", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "SQ4541", "CHC", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "JL41", "LHR", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CI73", "AMS", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "UX3000", "AMS", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ5825", "WLG", "HLZ", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "XY3873", "AUH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7349", "PER", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF7448", "ADL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ8251", "WLG", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF8493", "AKL", "GIS", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ8160", "AKL", "GIS", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ8283", "WLG", "GIS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4040", "CGO", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87481", "CGO", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O37077", "TSN", "NTG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O37197", "SZX", "NTG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX6", "NRT", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "KE608", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "DL7916", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX888", "YVR", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36890", "NGB", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX289", "FRA", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "LH7015", "FRA", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX2090", "ANC", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX3165", "DWC", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX105", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QR5830", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "OM5611", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "LH7013", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "BA4567", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "AY5095", "MEL", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "LY2876", "KGF", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX2050", "CGO", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CX271", "AMS", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF219", "BKK", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QF8631", "WLG", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF9069", "NKG", "TYN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "FX60", "MEM", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "Y87433", "HKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "OZ324", "ICN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "R3600", "KHV", "UUS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4105", "SJW", "LYG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ8208", "AKL", "BHE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "SQ4365", "AKL", "BHE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "QF8508", "AKL", "BHE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-22", "CF9001", "NKG", "LHW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "EK379", "DXB", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O37158", "HGH", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CA1085", "NKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36955", "HGH", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "EY4492", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ5740", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CV821", "AKL", "WHK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "U6365", "VVO", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "NZ516", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "EY4530", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "BR3276", "AKL", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "I99871", "HIA", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "I99865", "SZX", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4101", "TNA", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4039", "MNL", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF9091", "NKG", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "GI4213", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "O36927", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "HT3809", "KHN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "EY873", "AUH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "PO276", "CVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "KE335", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "AT9735", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "LA6037", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "OZ6889", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "QR859", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-22", "CF202", "XIY", "ICN", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
