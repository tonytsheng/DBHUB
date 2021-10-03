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
    flight_resp = put_flight("2021-10-03", "VA5010", "HTI", "HIS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "VA5018", "HTI", "HIS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "T6127", "MNL", "ENI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "5J900", "MNL", "MPH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "Z2222", "MNL", "MPH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "UA9541", "FRA", "GRZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "QR4830", "GRU", "BEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "F34625", "RUH", "JED", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "LX1412", "BEG", "ZRH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "KQ3807", "CDG", "FLR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "KL2125", "CDG", "FLR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "LH6358", "VIE", "BER", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "EY430", "HKT", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CA3791", "TNA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "3U2681", "TNA", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "G8365", "AMD", "BOM", "active"  ) 
    flight_resp = put_flight("2021-10-03", "UK873", "HYD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "UA7783", "HYD", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "IX243", "DOH", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AI657", "TIR", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "6E5391", "MAA", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "G81507", "SHJ", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CI5686", "TPE", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SG7615", "DEL", "BOM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SG7402", "DEL", "BOM", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "SG7662", "HYD", "BOM", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "SG7445", "BLR", "BOM", "active"  ) 
    flight_resp = put_flight("2021-10-03", "SG7441", "BLR", "BOM", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "MS835", "EBB", "KGL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "GJ8795", "XNN", "ZYI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MF5407", "XNN", "ZYI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "G59419", "XNN", "ZYI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SA7150", "JNB", "DXB", "active"  ) 
    flight_resp = put_flight("2021-10-03", "SA7155", "CPT", "DXB", "active"  ) 
    flight_resp = put_flight("2021-10-03", "KE5952", "ICN", "DXB", "active"  ) 
    flight_resp = put_flight("2021-10-03", "SG7401", "BOM", "DEL", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "CA3945", "GOQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SC6011", "GOQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "ZH2019", "GOQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "GJ5011", "GOQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU2427", "PKX", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "G56245", "GMQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU9921", "GMQ", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU6701", "KMG", "XNN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "QF1601", "PER", "LEA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "NZ7398", "PER", "LEA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "EY6384", "HBA", "MEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CA9005", "ACX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SC3637", "ACX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "KY5021", "ACX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU4126", "ACX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "3U4205", "ACX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CZ8845", "PKX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MF1985", "PKX", "KWE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "ZH8913", "WNZ", "HUZ", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "KY9343", "WNZ", "HUZ", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "HO5087", "WNZ", "HUZ", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "5X218", "SDF", "PHL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "DV702", "CIT", "NQZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SV1480", "RUH", "AQI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "B78636", "RMQ", "MZG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AE368", "TSA", "MZG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "HU7682", "HAK", "AQG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SG7466", "DEL", "PNQ", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "6E988", "MAA", "PNQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "6E721", "IDR", "PNQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "6E835", "COK", "PNQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AI852", "DEL", "PNQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MF7078", "SJW", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CZ9778", "SJW", "KMG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "EU2803", "SJW", "ZHY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "3U4095", "SJW", "ZHY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "CZ9383", "SJW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU4009", "SJW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MF5205", "SJW", "CTU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "9C6399", "KHN", "SJW", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "KN2367", "ZUH", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU8701", "ZUH", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "9C6271", "JGS", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "GY7116", "LZO", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "JD5279", "URC", "SJW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "UA7273", "MUC", "ZAG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "QF8604", "BHE", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "QF8109", "LCA", "DXB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "MU5608", "WUH", "HIA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AA7988", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "IB1807", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AZ6139", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "AT1401", "CMN", "OUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "HU7089", "KMG", "HAK", "cancelled"  ) 
    flight_resp = put_flight("2021-10-03", "FR6754", "TLV", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "FR3165", "BGY", "BUD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "KY8245", "HRB", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "PK854", "PEK", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "PK855", "PEK", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "EU1823", "HLD", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "HU7044", "ZHA", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SC8821", "HNY", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "3U3769", "JZH", "TNA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-03", "SC8039", "WXN", "TNA", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
