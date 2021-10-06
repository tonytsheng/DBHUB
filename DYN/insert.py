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
    flight_resp = put_flight("2021-10-08", "NZ5012", "AKL", "NPE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-08", "SQ4422", "AKL", "NPE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-08", "QF8468", "AKL", "NPE", "cancelled"  ) 
    flight_resp = put_flight("2021-10-07", "S72086", "DME", "KRR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "A4321", "UFA", "KRR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "PC1035", "HAJ", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3O438", "CMN", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "G9284", "SHJ", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "PC391", "MRV", "SAW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "QR1332", "DOH", "KRT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "U68655", "LBD", "AER", "cancelled"  ) 
    flight_resp = put_flight("2021-10-07", "Y87944", "NGB", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "O36955", "HGH", "WUH", "unknown"  ) 
    flight_resp = put_flight("2021-10-07", "CX178", "HKG", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "AY5844", "HKG", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "OM5612", "HKG", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "BA4140", "HKG", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "SQ218", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "UK8218", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "TK9311", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "LH9777", "SIN", "MEL", "active"  ) 
    flight_resp = put_flight("2021-10-07", "ZH2497", "XNN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA4147", "LZY", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "TV9829", "LHW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "ZH3733", "LHW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "EU7221", "LHW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ5051", "LHW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "TV9803", "LXA", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "ZH3711", "LXA", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "SC6031", "LXA", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF3187", "KMG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ3820", "CAN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF1474", "CAN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF8865", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ5455", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U2395", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU3337", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "NS8865", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4589", "JNG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA1795", "LFQ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA1771", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "ZH1771", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ8854", "PKX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA8683", "PKX", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "HU7467", "ZUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF8175", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "NS8175", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU8099", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ5331", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4135", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U2157", "TSN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ6990", "URC", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF8289", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "NS8289", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU8181", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ5381", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4229", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U2221", "XIY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ8117", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4725", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU8283", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U4511", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "TV6925", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF5325", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "G59311", "WNZ", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA8341", "ZHY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "ZH4611", "ZHY", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF8532", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "NS8532", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU3258", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "GJ5442", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4438", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U2366", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "KL3766", "XMN", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "JD5127", "KMG", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CA1773", "GYS", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "ZH1773", "GYS", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ4799", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU3857", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "3U4569", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MF5413", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "G59425", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "TV7007", "WUH", "HGH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU6409", "ZHA", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ5772", "NNG", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU5285", "KWL", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "CZ5600", "ZUH", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MU5483", "CKG", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "G56755", "CKG", "HFE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "EK2368", "DXB", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "FZ1628", "DXB", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "LH8291", "CAI", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "AR7853", "JFK", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "LH8290", "CAI", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "TK9305", "SIN", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "MK8211", "SIN", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "VA1528", "HBA", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "SQ6662", "HBA", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-07", "EY6401", "HBA", "SYD", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
