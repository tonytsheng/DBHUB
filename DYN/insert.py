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
    flight_resp = put_flight("2021-10-28", "QF7443", "OOL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "FX12", "IND", "KIX", "active"  ) 
    flight_resp = put_flight("2021-10-28", "JQ286", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "FJ5552", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF4995", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NZ5840", "NSN", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NZ5741", "DUD", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "EY4491", "DUD", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NZ5711", "IVC", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7524", "SYD", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9019", "PKX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36969", "HGH", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "GJ8711", "HGH", "HRB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "R3475", "VKO", "YKS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "KC910", "ALA", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "OZ6961", "ALA", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "RU392", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NH203", "FRA", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O37053", "HGH", "HET", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "GJ8716", "SZX", "HET", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36976", "HGH", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87433", "HKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36884", "SZX", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CA1085", "NKG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "GI4105", "SJW", "LYG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9127", "KIX", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9065", "NKG", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "R3271", "VKO", "YKS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9068", "WUH", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O37156", "SGN", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9035", "KIX", "YNT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CZ443", "LAX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "AQ1507", "SYX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "HT3805", "WUX", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O37253", "WEH", "WNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87417", "CGO", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O37061", "KIX", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9089", "SZX", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87962", "SYX", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "FU6746", "YIH", "MXZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7357", "HBA", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "VN780", "SGN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "KE5782", "ICN", "CEB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "LJ22", "ICN", "CEB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "I99805", "MNL", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9071", "KIX", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9049", "MNL", "YIW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QG7915", "CGK", "KNO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9041", "NKG", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87403", "TSN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87417", "HKG", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87911", "XMN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QR8351", "DOH", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CZ495", "AMS", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "LX189", "ZRH", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CK257", "ICN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "KE249", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "AT9735", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "LA6037", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "OZ6889", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QR859", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "HT3817", "SIN", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "MH6191", "KUL", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "TR898", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "SQ8524", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "TR722", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "SQ8560", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "KL840", "AMS", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "DL8189", "AMS", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "SQ255", "BNE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "UK8255", "BNE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "TK9330", "BNE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NH9178", "NRT", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "SQ336", "CDG", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "Y87432", "PVG", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36868", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "GI4033", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9052", "HGH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "CF9017", "NKG", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9009", "KIX", "HIA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QR929", "DOH", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NZ3439", "SIN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "SQ913", "SIN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "KE624", "ICN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "OZ987", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "PO211", "PVG", "NGO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9041", "MNL", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7405", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36929", "JJN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "YG9077", "KIX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "GI4027", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "AF5476", "AMS", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36951", "CTU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36841", "HGH", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7458", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7454", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7356", "LST", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "QF7353", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "O36955", "HGH", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-28", "NZ8283", "WLG", "GIS", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
