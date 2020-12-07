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
    flight_resp = put_flight("2020-12-08", "LH8455", "FRA", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "GX8843", "AEB", "", "NNG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "LH9753", "SIN", 24, "AKL", 16, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O37169", "HGH", "", "TAO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "NH203", "FRA", "", "HND", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "S76206", "VVO", "", "YKS", 15, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "BZ201", "BOM", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O37023", "HGH", "", "TYN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7349", "PER", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "BA32", "LHR", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CK221", "LAX", 526, "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "LX9003", "SIN", 24, "AKL", 16, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "NZ3282", "SIN", 24, "AKL", 16, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "SQ282", "SIN", 24, "AKL", 16, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O37051", "HGH", "", "CSX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "PO211", "PVG", "", "NGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CA1087", "NKG", "", "SHE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7338", "MEL", "", "LST", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CF9068", "WUH", "", "NKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "JT3794", "MKQ", "", "CGK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "AY5095", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "BA4567", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "LH7013", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "LX9513", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "QR5830", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "OM5613", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "CX105", "MEL", "", "HKG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "SG174", "BOM", "", "DXB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7404", "SYD", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7305", "MEL", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7438", "ADL", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7432", "MEL", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7424", "SYD", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7311", "MEL", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7410", "ROK", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CF9065", "NKG", "", "XMN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "ZH2404", "CTU", "", "XNN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GJ5072", "CTU", "", "XNN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "SC3618", "CTU", "", "XNN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "G54446", "CTU", "", "XNN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "EY1004", "AKL", "", "PVG", 18, "active" ) 
    flight_resp = put_flight("2020-12-08", "GJ8148", "NKG", "", "KIX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "Y87430", "NGB", "", "KIX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QG341", "CGK", "", "UPG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "YG9005", "CTU", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "HT3811", "WEH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "HT3813", "WEH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O36972", "HGH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7342", "BNE", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7422", "SYD", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7394", "PER", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7494", "SYD", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7423", "ADL", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7356", "LST", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7353", "BNE", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7454", "SYD", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7452", "ADL", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "VA9571", "ADL", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7458", "ADL", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CF9033", "NKG", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GJ6013", "TSN", "", "DLC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GJ8135", "SZX", "", "DLC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GI4105", "SJW", "", "LYG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GI4027", "TSN", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O37156", "SGN", "", "NNG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "DZ6259", "HAK", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7412", "BNE", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "VA9583", "BNE", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "VA9561", "MEL", "", "LST", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O37131", "DEL", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CZ441", "LAX", "", "PVG", 10, "active" ) 
    flight_resp = put_flight("2020-12-08", "O36877", "PEK", "", "PVG", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "O36882", "SZX", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "AI7965", "ADD", "", "BLR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GI4113", "HFE", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O36921", "HGH", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GJ8149", "CGO", "", "CGQ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "CZ473", "ANC", "", "CAN", 10, "active" ) 
    flight_resp = put_flight("2020-12-08", "JT794", "DJJ", "", "CGK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GJ8137", "WUH", "", "HRB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "AF3118", "AMS", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "KL832", "AMS", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "AT9735", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "OZ6889", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "S74042", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "QR859", "DOH", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "KL2345", "CDG", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "AF267", "CDG", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "KL856", "AMS", "", "ICN", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "OZ987", "PVG", "", "ICN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7524", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "QF7523", "CHC", "", "AKL", "", "active" ) 
    flight_resp = put_flight("2020-12-08", "GJ8143", "CAN", "", "SHE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "O36943", "HGH", "", "KMG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "YG9061", "CTU", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "KE363", "PEN", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GI4013", "NTG", "", "JJN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "5X67", "ANC", "", "KIX", 10, "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "Y87492", "PVG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-08", "GI4023", "SZX", "", "TSN", "", "scheduled" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws dynamodb scan --table-name flight --select "COUNT"')
