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
    flight_resp = put_flight("2021-11-15", "3O377", "BCN", "TNG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "MH3552", "MYY", "MKM", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AY5051", "HIJ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "HA5109", "HIJ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "MZ202", "AXJ", "KMJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "6J18", "HND", "KMJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "NH2418", "HND", "KMJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "JH326", "NKM", "KMJ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "JL630", "HND", "KMJ", "cancelled"  ) 
    flight_resp = put_flight("2021-11-15", "HA5319", "HND", "KMJ", "cancelled"  ) 
    flight_resp = put_flight("2021-11-15", "SK1202", "CPH", "AAL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "LH6091", "CPH", "AAL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "LG1890", "CPH", "AAL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AY432", "HEL", "OUL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "3U8217", "TNA", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC9973", "TNA", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "KY9073", "TNA", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "CA3899", "TNA", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "ZH3006", "TNA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "G58450", "TNA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC1182", "WEH", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC4805", "WNZ", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "HU7306", "SYX", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC8411", "SHE", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC2219", "NNG", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "PN6328", "CKG", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "8L9868", "KMG", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC4933", "WUH", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC8881", "XIY", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC4799", "CKG", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "HU7044", "ZHA", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "GK636", "NRT", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "JL6094", "NRT", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "6J60", "HND", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "NH2460", "HND", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "JL694", "HND", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "HA5911", "HND", "KMI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR8415", "CRL", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR197", "BER", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR8354", "STN", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W62403", "NYO", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "KL1972", "AMS", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "MF9630", "AMS", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "DL9694", "AMS", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W62473", "IEV", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "LH1683", "MUC", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "UA9143", "MUC", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "TP7977", "MUC", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SK3575", "MUC", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W62201", "LTN", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "LH1343", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "TG7667", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "UA9023", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "TP7967", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SQ2141", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SN7148", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SK3561", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "NH5466", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AC9023", "FRA", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W62441", "ATH", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FL131", "OSL", "RRS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "X14421", "OSL", "RRS", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W22322", "XMY", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "Q6361", "XMY", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W22348", "GIC", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "Q6321", "GIC", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "QF2497", "CNS", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "Q640", "CNS", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W22358", "CNS", "HID", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "QF2007", "SYD", "TMW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "NZ7007", "SYD", "TMW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "EK5148", "SYD", "TMW", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "MF4259", "HIA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AT1401", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "IB1823", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "QR4543", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AA7988", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "AQ1539", "TYN", "HIA", "cancelled"  ) 
    flight_resp = put_flight("2021-11-15", "QF2407", "BNE", "EMD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "NZ7209", "BNE", "EMD", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "V71124", "LIN", "CAG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR9932", "PSA", "CAG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR4707", "BGY", "CAG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR3701", "FUE", "EMA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "FR1624", "LCJ", "EMA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "W63501", "LTN", "TSR", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SV1255", "JED", "ELQ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "ZH1530", "TSN", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "SC5070", "TSN", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "9C8814", "PVG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "GS7929", "XIY", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "G56318", "KMG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "ZH8890", "WNZ", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "KY9590", "WNZ", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "MU5748", "KMG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "GX8803", "UYN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-15", "HU1803", "UYN", "TSN", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
