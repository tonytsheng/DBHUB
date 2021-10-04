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
    flight_resp = put_flight("2021-10-05", "OU5807", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ3352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SK8000", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "A31207", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "LH9791", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "EK9824", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CK217", "AMS", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "GJ8755", "XUZ", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37059", "PVG", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36936", "SZX", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CX53", "HKG", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36900", "SZX", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CV821", "AKL", "WHK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "Y87492", "PVG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7416", "ROK", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36868", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "GI4033", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ5740", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ4369", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "EY4492", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36935", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "YG9079", "MNL", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "YG9101", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "YG9061", "CTU", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "YG9005", "CTU", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF827", "BNE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ7349", "BNE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "AA7318", "BNE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "JQ673", "BNE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF5673", "BNE", "DRW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "FX9012", "IND", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37256", "CSX", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CA8438", "PVG", "KIX", "cancelled"  ) 
    flight_resp = put_flight("2021-10-05", "O37238", "SZX", "KIX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37057", "HGH", "TYN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37023", "HGH", "TYN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36877", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36995", "HGH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "OZ987", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KL856", "AMS", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "AF267", "CDG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KL2345", "CDG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KL832", "AMS", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "AF5474", "AMS", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "RU139", "HKG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "UA858", "SFO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ282", "SIN", "AKL", "active"  ) 
    flight_resp = put_flight("2021-10-05", "NZ3282", "SIN", "AKL", "active"  ) 
    flight_resp = put_flight("2021-10-05", "LX9003", "SIN", "AKL", "active"  ) 
    flight_resp = put_flight("2021-10-05", "LH9753", "SIN", "AKL", "active"  ) 
    flight_resp = put_flight("2021-10-05", "QF7412", "BNE", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "GI4027", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CF9065", "NKG", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7338", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7438", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7305", "MEL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7404", "SYD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7340", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF7356", "LST", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SU5653", "KHV", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KC910", "ALA", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "OZ6961", "ALA", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QR859", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "OZ6889", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "AT9735", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "LA6037", "DOH", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KE335", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "PO276", "CVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ8807", "CHC", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ4541", "CHC", "TRG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "KE624", "ICN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ913", "SIN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ3439", "SIN", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QR929", "DOH", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CA1089", "NKG", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ8872", "WLG", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "QF8631", "WLG", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NZ5700", "CHC", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "NH203", "FRA", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O36909", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "MU5904", "KMG", "JHG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "LH9777", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "TK9311", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "UK8218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37255", "KIX", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37209", "HKG", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37055", "WUH", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "YG9025", "MNL", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "O37077", "TSN", "NTG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "AF4020", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "JL5370", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SB800", "NRT", "NOU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "CF9023", "NKG", "KHN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "TR898", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ8524", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "TR722", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-05", "SQ8560", "ATH", "SIN", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
