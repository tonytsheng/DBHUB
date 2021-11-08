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
    flight_resp = put_flight("2021-11-09", "NZ5625", "CHC", "HLZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "PX251", "POM", "BUA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MF8315", "HAK", "HGH", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "MF5294", "SZX", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "MU4055", "SZX", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9469", "SZX", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "3U8667", "KMG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MF5292", "KMG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MU4043", "KMG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9449", "KMG", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "EU2235", "CAN", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "TV7229", "CAN", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "G56144", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "3U8861", "TSN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "G58679", "TSN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "MU4099", "TSN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9571", "TSN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "3U8729", "CAN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "MF5302", "CAN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9481", "CAN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "EU2743", "LXA", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "TV7249", "LXA", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CA4193", "PEK", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "TV9883", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "ZH3923", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CA3927", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "EU7251", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "SC6101", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "GJ5121", "RKZ", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CA4519", "HGH", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "CA4511", "TAO", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "SC5273", "TAO", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "CA4187", "TSN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "CA4151", "URC", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "UA7535", "URC", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "SC5203", "URC", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "TV9894", "BPX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "ZH3930", "BPX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "SC6106", "BPX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "GJ5128", "BPX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "TV9879", "SHE", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "ZH3919", "SHE", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "SC6097", "SHE", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "GJ5117", "SHE", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CA4529", "NGB", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "3U8607", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "G58639", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "MU4031", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9435", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "TV9889", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "ZH3925", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "GJ5123", "JHG", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "G56588", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "G56344", "XNN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "G56098", "XNN", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "3U8881", "PEK", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9585", "PEK", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "3U8755", "SYX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "MU4067", "SYX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "CZ9501", "SYX", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "TV9829", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "GJ5077", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "ZH3729", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "SC6069", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "G54941", "XNN", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "3U4619", "XNN", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "ZH2497", "XNN", "CTU", "active"  ) 
    flight_resp = put_flight("2021-11-08", "CA4403", "LXA", "CTU", "cancelled"  ) 
    flight_resp = put_flight("2021-11-08", "W63661", "CRL", "IAS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "HU7321", "PVG", "SYX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MF1278", "CAN", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "HD14", "HND", "CTS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MU8865", "UYN", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "QF8001", "LHR", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "QF2323", "BNE", "BDB", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "O37197", "SZX", "NTG", "unknown"  ) 
    flight_resp = put_flight("2021-11-08", "VQ941", "JSR", "DAC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "G58600", "HGH", "UYN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "GJ8526", "HGH", "UYN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MU3690", "NKG", "UYN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "ZH5136", "NKG", "UYN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "HO1684", "NKG", "UYN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "GA9128", "MAN", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "N42126", "LED", "LCA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CY486", "DME", "LCA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "AA6501", "LHR", "LCA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "BA661", "LHR", "LCA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "MF1000", "CAN", "AOG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ6564", "CAN", "AOG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ3629", "URC", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CA3535", "XNN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "KY9235", "XNN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "IN135", "TKG", "SOC", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "CZ4920", "DYG", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "DL40", "LAX", "SYD", "active"  ) 
    flight_resp = put_flight("2021-11-08", "U62885", "TJU", "GOJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "NZ5359", "CHC", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-08", "QF8572", "CHC", "WLG", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
