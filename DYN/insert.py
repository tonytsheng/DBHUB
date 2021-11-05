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
    flight_resp = put_flight("2021-11-05", "5X284", "MMX", "CGN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GMA3", "ABZ", "LSI", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GMA3", "LSI", "ABZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "D02134", "EDI", "EMA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MF3083", "NKG", "XIY", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MU4970", "XMN", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CZ4532", "XMN", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SKQ34", "USA", "CAE", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "DR2852", "TSN", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MF1284", "TSN", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "ZH1530", "TSN", "XMN", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "SC5070", "TSN", "XMN", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "GS7929", "XIY", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56318", "KMG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "ZH8890", "WNZ", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KY9590", "WNZ", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MU5748", "KMG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GX8803", "UYN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HU1803", "UYN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GS7825", "KHN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CA2905", "URC", "TSN", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "BK3224", "LFQ", "TSN", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "DR3224", "LFQ", "TSN", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "G56280", "TYN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56245", "URC", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CA1441", "TYN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56588", "CHG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56408", "CHG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56441", "CHG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G52871", "CHG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GT1028", "LYA", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CZ6656", "YIW", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SC4843", "HET", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FM9116", "SHA", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56693", "CIH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56700", "CIH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G56205", "CIH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G52720", "CIH", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "GS7879", "IQN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FU6602", "HSN", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CA2955", "SHA", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "G8297", "GAU", "AJL", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KQ254", "DZA", "NBO", "cancelled"  ) 
    flight_resp = put_flight("2021-11-05", "JM8668", "EDL", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KQ420", "EBB", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "BA7736", "EBB", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KL4164", "EBB", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AF8055", "EBB", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FE201", "MBA", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "JM8712", "MBA", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "MS516", "CAI", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KQ520", "ABJ", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "2J2520", "ABJ", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EY4052", "ABJ", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FR8332", "CIA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LH1403", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "WY5503", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "UA8734", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "TP7929", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ2085", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NH6196", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LG1476", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AC9129", "FRA", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "3V4928", "TSR", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SN2816", "BRU", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "UA9939", "BRU", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "HU8602", "BRU", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AC6331", "BRU", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LH1689", "MUC", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "UA9244", "MUC", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "TP7941", "MUC", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "SQ2131", "MUC", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AC9193", "MUC", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "FR1014", "STN", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "3V4089", "BRQ", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "EW4212", "BRS", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AF1583", "CDG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VS6594", "CDG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KQ3799", "CDG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "DL8550", "CDG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CZ7024", "CDG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LA3307", "GRU", "SLZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "QR5260", "GRU", "SLZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AM8563", "GRU", "SLZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AD4475", "CNF", "SLZ", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LH1212", "GVA", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "UA9092", "GVA", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "TG7694", "GVA", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "NH6179", "GVA", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "LX3661", "GVA", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "BA901", "LHR", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AA6577", "LHR", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "AF1019", "CDG", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VS6519", "CDG", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "VN3131", "CDG", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "KQ3025", "CDG", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "DL8389", "CDG", "FRA", "scheduled"  ) 
    flight_resp = put_flight("2021-11-05", "CZ7078", "CDG", "FRA", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
