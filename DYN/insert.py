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
    flight_resp = put_flight("2021-12-16", "SQ218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF8457", "DUD", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9146", "HGH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GI4360", "SZX", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "I99808", "SZX", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9052", "HGH", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9112", "KHN", "KUL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "AC7235", "HKG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "PO276", "CVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "KE249", "PVG", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "RU392", "SVO", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CK257", "ICN", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "UK8218", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "TK9320", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36969", "HGH", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36919", "SZX", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ231", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "LH9754", "SYD", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CA601", "LAX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "MH6191", "KUL", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GI4021", "CAN", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36953", "HGH", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9053", "DAC", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ336", "CDG", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36974", "HGH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "ET1303", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "TK9324", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "UK8237", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ237", "MEL", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ8560", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "TR722", "ATH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "NZ5810", "HLZ", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O37145", "SZX", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9084", "TNA", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "I99867", "SZX", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "TK9301", "IST", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "NZ3392", "IST", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ2929", "ZRH", "SIN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7458", "ADL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7454", "SYD", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7356", "LST", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9057", "NKG", "CKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9009", "VVO", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7360", "MEL", "LST", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7405", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7445", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9068", "WUH", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9141", "SIN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "VA1456", "MEL", "DRW", "cancelled"  ) 
    flight_resp = put_flight("2021-12-16", "EY6332", "MEL", "DRW", "cancelled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ6573", "MEL", "DRW", "cancelled"  ) 
    flight_resp = put_flight("2021-12-16", "EY6378", "MEL", "DRW", "cancelled"  ) 
    flight_resp = put_flight("2021-12-16", "QF8631", "WLG", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "NZ8872", "WLG", "IVC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9007", "KIX", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GJ8941", "TSN", "DLC", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87453", "ANC", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9165", "KIX", "YIW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9049", "MNL", "YIW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CX261", "CDG", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GA656", "DJJ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9145", "KUL", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GI4035", "CGO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87947", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87977", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O37306", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36933", "TAO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9081", "CAN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87985", "PEK", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87969", "CGO", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O37112", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87993", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36859", "JJN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9085", "PKX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "O36927", "CTU", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9101", "SZX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9167", "KIX", "YNT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9035", "KIX", "YNT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "S76371", "GDX", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9001", "NKG", "LHW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GI4027", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "GJ6012", "PKX", "SWA", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9091", "KIX", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7353", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "QF7310", "BNE", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ7290", "AKL", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CI5637", "DEL", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CI73", "AMS", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CI59", "AKL", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "FX5016", "ANC", "TPE", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "NZ5740", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "EY4492", "CHC", "DUD", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "TK9311", "SIN", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "YG9122", "SJW", "ICN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "Y87474", "HGH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "CF9101", "NKG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SU5653", "KHV", "IKT", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "BA4491", "DOH", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "SQ4521", "CHC", "NPL", "scheduled"  ) 
    flight_resp = put_flight("2021-12-16", "NZ8767", "CHC", "NPL", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
