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
    flight_resp = put_flight("2021-11-03", "O36951", "CTU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EK379", "DXB", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG4505", "DXB", "HKT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ8300", "WLG", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TP6745", "DXB", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "JQ251", "WLG", "AKL", "cancelled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9160", "KMG", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "GA656", "DJJ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CK257", "ICN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9073", "ICN", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9035", "KIX", "YNT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36871", "CAN", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "QF7412", "BNE", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "QF7360", "MEL", "LST", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CF230", "NKG", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37160", "XIY", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CF208", "PVG", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CF228", "CGO", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "S8284", "WLG", "BHE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ5327", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EY4505", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ406", "AKL", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "QF8535", "AKL", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EY4502", "AKL", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "BR3302", "AKL", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ5331", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EY4555", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ5810", "HLZ", "WLG", "cancelled"  ) 
    flight_resp = put_flight("2021-11-03", "JQ286", "WLG", "CHC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37251", "WUH", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CF9007", "NKG", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37255", "KIX", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "QF7416", "ROK", "BNE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9001", "CTU", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "GI4014", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36868", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ515", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ4360", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EY4689", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "BR3215", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "Y87951", "KIX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36884", "SZX", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36873", "SZX", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36955", "HGH", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "OZ742", "ICN", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG644", "NGO", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "AA8472", "NRT", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG950", "CPH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "WE5950", "CPH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SK8629", "CPH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9022", "XIY", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG475", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TK8020", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "OS8639", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "LY8401", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "LH9726", "SYD", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EK393", "DXB", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG970", "ZRH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "LX4301", "ZRH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "AC6132", "ZRH", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "KL804", "AMS", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "GJ8522", "LYI", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TG910", "LHR", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "AC6123", "LHR", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "KL820", "AMS", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NH5958", "NGO", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "FJ5543", "WLG", "AKL", "cancelled"  ) 
    flight_resp = put_flight("2021-11-03", "EK7488", "WLG", "AKL", "cancelled"  ) 
    flight_resp = put_flight("2021-11-03", "QF4962", "WLG", "AKL", "cancelled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ7297", "MEL", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37229", "SZX", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EK449", "DXB", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9119", "BKK", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "YG9143", "MNL", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ255", "BNE", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NH9894", "NRT", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ332", "MUC", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ231", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "UK8231", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TK9320", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "GI4364", "SZX", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SQ352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "SK8000", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "OU5807", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ3352", "CPH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "EK353", "DXB", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "TP6356", "DXB", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "QF8353", "DXB", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O36881", "SZX", "WNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CX96", "ANC", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CX6", "NRT", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CX219", "MAN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "PO97", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "RH829", "PVG", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "CX2090", "ANC", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37157", "NNG", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "GJ8972", "XUZ", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "OZ736", "ICN", "SGN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "O37095", "HGH", "SWA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-03", "NZ680", "WLG", "DUD", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
