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

def put_flight(flight_date, flight_number, arrival_airport, arrival_delay, departure_airport, departure_delay, flight_status, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

    table = dynamodb.Table('flight')
    response = table.put_item(
       Item={
            'flight_date': flight_date,
            'flight_number': flight_number,
            'arrival_airport': arrival_airport,
            'arrival_delay': arrival_delay,
            'departure_airport': departure_airport,
            'departure_delay': departure_delay,
            'flight_status': flight_status,
        }
    )
    return response

if __name__ == '__main__':
    flight_resp = put_flight("2020-12-07", "EP3914", "BUZ", "", "THR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O36900", "SZX", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "OZ970", "ICN", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "FZ8914", "DXB", "", "COK", 35, "active" ) 
    flight_resp = put_flight("2020-12-07", "CV641", "AKL", "", "PPQ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CF9136", "CAN", "", "NKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "MF1795", "HFE", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "GJ8710", "SZX", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "GJ8713", "SJW", "", "HRB", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "QF7527", "HKG", "", "DRW", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "PO750", "SYD", "", "GUM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "UA2793", "LAX", "", "GUM", 17, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "FX81", "PVG", "", "GUM", 22, "landed" ) 
    flight_resp = put_flight("2020-12-07", "SQ7285", "SIN", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "JL7906", "HKG", "", "BNE", 595, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "AY5850", "HKG", "", "BNE", 595, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "BA4146", "HKG", "", "BNE", 595, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "OM5631", "HKG", "", "BNE", 595, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CX156", "HKG", "", "BNE", 595, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CA1051", "LAX", "", "PVG", 10, "active" ) 
    flight_resp = put_flight("2020-12-07", "SC2405", "ICN", "", "TAO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "R3492", "YKS", "", "VVO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "ZL4353", "ADL", "", "PLO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "OZ909", "WUH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "O37054", "CTU", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "DZ6259", "HAK", "", "SZX", 9, "landed" ) 
    flight_resp = put_flight("2020-12-07", "CF9087", "PEK", "", "NKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "J91404", "KWI", "", "HYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "GJ8148", "NKG", "", "KIX", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "HT3811", "WEH", "", "TSN", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "HT3813", "WEH", "", "TSN", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "BA4567", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "QR5830", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "AY5095", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "LH7013", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "LX9513", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "OM5613", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX105", "MEL", 1, "HKG", 19, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX261", "CDG", "", "HKG", 33, "active" ) 
    flight_resp = put_flight("2020-12-07", "CF9033", "NKG", "", "XIY", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "GI4032", "XNN", "", "XIY", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "GI4021", "CAN", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "Y87421", "CRK", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O37069", "MAA", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O37131", "DEL", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O36877", "PEK", 171, "PVG", 145, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O36882", "SZX", "", "PVG", 76, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CZ441", "LAX", "", "PVG", 34, "active" ) 
    flight_resp = put_flight("2020-12-07", "O37156", "SGN", "", "NNG", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "GI4113", "HFE", "", "CGO", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "O36921", "HGH", "", "CGO", 24, "landed" ) 
    flight_resp = put_flight("2020-12-07", "GJ8149", "CGO", "", "CGQ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "G9414", "SHJ", "", "CJB", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-07", "CF9015", "NKG", "", "WUH", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "ZL4614", "ADL", "", "MGB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "FJ430", "SUV", "", "AKL", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-07", "NH5341", "ADD", "", "ICN", 23, "active" ) 
    flight_resp = put_flight("2020-12-07", "OZ9760", "ADD", "", "ICN", 23, "active" ) 
    flight_resp = put_flight("2020-12-07", "KJ221", "TAO", "", "ICN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "ET673", "ADD", "", "ICN", 23, "active" ) 
    flight_resp = put_flight("2020-12-07", "AT9735", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "OZ6889", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "S74042", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "QR859", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "KL856", "AMS", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "OZ987", "PVG", "", "ICN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "GJ8137", "WUH", "", "HRB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "EK5734", "BNE", "", "MKY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "GJ8143", "CAN", "", "SHE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "7L874", "GYD", "", "KUL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "SB340", "WLS", "", "NOU", 11, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "HT3809", "KHN", "", "CGO", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "CA1087", "NKG", "", "SHE", "", "landed" ) 
    flight_resp = put_flight("2020-12-07", "CA1062", "PVG", "", "KIX", "", "landed" ) 
    flight_resp = put_flight("2020-12-07", "Y87458", "PVG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "YG9025", "CAN", "", "TSN", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "GI4023", "SZX", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CF9101", "NKG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "Y87474", "HGH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "HT3819", "WEH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O36935", "SZX", "", "HGH", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "Y87933", "PEK", 36, "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "YG9067", "KHI", "", "KMG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "CF9017", "NKG", "", "KMG", "", "unknown" ) 
    flight_resp = put_flight("2020-12-07", "AA8933", "LAX", "", "HKG", 18, "active" ) 
    flight_resp = put_flight("2020-12-07", "MH9190", "LAX", "", "HKG", 18, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX880", "LAX", "", "HKG", 18, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX2090", "ANC", "", "HKG", 10, "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "LD3754", "CTU", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-07", "LH7015", "FRA", "", "HKG", 40, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX289", "FRA", "", "HKG", 40, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX271", "AMS", "", "HKG", 37, "active" ) 
    flight_resp = put_flight("2020-12-07", "AA8930", "SFO", "", "HKG", 11, "active" ) 
    flight_resp = put_flight("2020-12-07", "MH9198", "SFO", "", "HKG", 11, "active" ) 
    flight_resp = put_flight("2020-12-07", "CX872", "SFO", "", "HKG", 11, "active" ) 
    flight_resp = put_flight("2020-12-07", "RH9235", "PVG", 6, "HKG", 21, "landed" ) 
    flight_resp = put_flight("2020-12-07", "CX888", "YVR", "", "HKG", 15, "active" ) 
    flight_resp = put_flight("2020-12-07", "7C3105", "ICN", "", "GUM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "", "ZAM", "", "MFM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-07", "O36965", "SZX", "", "KHN", "", "active" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws dynamodb scan --table-name flight --select "COUNT"')
