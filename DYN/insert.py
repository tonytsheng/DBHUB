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
    flight_resp = put_flight("2021-11-09", "CA8438", "PVG", "KIX", "cancelled"  ) 
    flight_resp = put_flight("2021-11-09", "CZ491", "STN", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87911", "TPE", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA1089", "NKG", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CZ449", "AMS", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87423", "MNL", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DL7918", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TK8020", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OS8639", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LY8401", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9057", "NKG", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LH9777", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TK9311", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "UK8218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7357", "HBA", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7303", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7359", "PER", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA1087", "NKG", "SHE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GJ8513", "TSN", "HET", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O37212", "CGO", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O37072", "SZX", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36882", "SZX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA1023", "CTU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36957", "PEK", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O37215", "HIA", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "HT3809", "KHN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4213", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "I99889", "CSX", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF221", "ICN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4039", "MNL", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4101", "TNA", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4205", "ICN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4119", "ICN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4203", "HFE", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "UK8237", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ237", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "A31207", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ3328", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OU5813", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ328", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ2929", "ZRH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "Y87993", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9055", "BKK", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9055", "NKG", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36919", "SZX", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9121", "ICN", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9091", "KIX", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9083", "FRU", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9019", "CTU", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9005", "NKG", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "S76345", "OSS", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SU5653", "KHV", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TR898", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ8524", "TPE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ231", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "UK8231", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TK9320", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NH9178", "NRT", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TR722", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ8560", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SQ352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "SK8000", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OU5807", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "NZ3352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LX177", "ZRH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GJ8715", "CAN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7404", "SYD", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7305", "MEL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7338", "ADL", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7405", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7445", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TH382", "SIN", "SZB", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4105", "SJW", "LYG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O37309", "PEK", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O37169", "HGH", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LH9726", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GI4027", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF9033", "NKG", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA601", "LAX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "LY2878", "NQZ", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "S74517", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OS8051", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "AC6997", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ET1299", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "TG6726", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "OZ742", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CF241", "KIX", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "CA5720", "KMG", "TCZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "ZH5510", "KMG", "TCZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "G58960", "KMG", "TCZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "KY8310", "KMG", "TCZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36873", "SZX", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "O36955", "HGH", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "YG9007", "KIX", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "GJ8941", "TSN", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7448", "ADL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "QF7349", "PER", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-09", "DZ6259", "HAK", "SZX", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
