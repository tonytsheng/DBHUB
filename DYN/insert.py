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
    flight_resp = put_flight("2021-10-04", "SG7456", "HYD", "MAA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7451", "BOM", "MAA", "active"  ) 
    flight_resp = put_flight("2021-10-04", "NZ5931", "WLG", "GIS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "NZ5972", "GIS", "WLG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7445", "BLR", "BOM", "active"  ) 
    flight_resp = put_flight("2021-10-04", "SG7457", "BLR", "AMD", "active"  ) 
    flight_resp = put_flight("2021-10-04", "SG7083", "BLR", "DEL", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "UA7766", "RPR", "DEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG9888", "COK", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7446", "BOM", "BLR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7084", "DEL", "BLR", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "CZ3049", "HAN", "CAN", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "SG7455", "MAA", "HYD", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7404", "DEL", "HYD", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7009", "CCU", "HKG", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7792", "CCU", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7184", "CCU", "DEL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "SG7792", "BOM", "CCU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SG7009", "DEL", "CCU", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "M083", "HVD", "ULN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SU1633", "SVO", "SIP", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "ID6370", "SUB", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "QZ7680", "SUB", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "JU8197", "IST", "GZP", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "GS6525", "ZHA", "HAK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "IW1920", "TMC", "ENE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "XQ124", "ZRH", "AYT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Q6183", "UBB", "BDD", "active"  ) 
    flight_resp = put_flight("2021-10-04", "JT136", "TJQ", "CGK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "SJ54", "TJQ", "CGK", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "SJ54", "PGK", "TJQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "IN551", "PGK", "TJQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "QG977", "CGK", "TJQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "UL197", "DEL", "CMB", "active"  ) 
    flight_resp = put_flight("2021-10-04", "UL1185", "LHE", "CMB", "diverted"  ) 
    flight_resp = put_flight("2021-10-04", "EY4499", "ZQN", "CHC", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "TY505", "KNQ", "GEA", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "TY107", "MEE", "GEA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "TY201", "LIF", "GEA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "GG4854", "ANC", "CSX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "GI4240", "XIY", "HZG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "OZ988", "ICN", "PVG", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "Y87951", "KIX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87429", "KIX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "RU668", "KJA", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "GJ8718", "TAO", "PVG", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "KZ228", "NRT", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "O37060", "PKX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "CK223", "LAX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "3V802", "LGG", "PVG", "active"  ) 
    flight_resp = put_flight("2021-10-04", "TK6519T", "FRU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "NH8404", "NRT", "PVG", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "TK6519", "FRU", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87905", "MNL", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "CF9138", "SZX", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "NH8416", "NRT", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "O36950", "SZX", "WEF", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "O37076", "JJN", "NTG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "NZ5843", "CHC", "NSN", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "FJ7", "SUV", "NAN", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "SQ6147", "SUV", "NAN", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "FJ941", "SYD", "SUV", "cancelled"  ) 
    flight_resp = put_flight("2021-10-04", "Q6902", "TIS", "HID", "active"  ) 
    flight_resp = put_flight("2021-10-04", "QR853", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "MH9054", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "LA5270", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "IB7945", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "BA5817", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "B66521", "DOH", "KUL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "KC860", "ALA", "SCO", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "PK207", "RKT", "PEW", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87958", "PVG", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "YG9026", "TSN", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "QR8941", "DOH", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "O36850", "NGB", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87961", "SIN", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87991", "HGH", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "O36872", "PEK", "CAN", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "Y87932", "SZX", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87934", "HGH", "PEK", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "LH8430", "ICN", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "LH8433", "ICN", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "KC2242", "ALA", "OVB", "active"  ) 
    flight_resp = put_flight("2021-10-04", "VA362", "BNE", "TSV", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "SQ6535", "BNE", "TSV", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "EY6925", "BNE", "TSV", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "NZ3879", "LHW", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "Y87922", "HGH", "TSN", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "Y87976", "PVG", "TSN", "unknown"  ) 
    flight_resp = put_flight("2021-10-04", "Y87978", "PVG", "TSN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "VA1385", "BNE", "ADL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "SQ6923", "BNE", "ADL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "EY6603", "BNE", "ADL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "QF2071", "WYA", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "NZ7045", "WYA", "ADL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-04", "QQ3100", "OLP", "ADL", "active"  ) 
    flight_resp = put_flight("2021-10-04", "QF724", "CBR", "ADL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "NZ7072", "CBR", "ADL", "landed"  ) 
    flight_resp = put_flight("2021-10-04", "KU284", "KWI", "DAC", "active"  ) 
    flight_resp = put_flight("2021-10-04", "O37186", "CGO", "DAC", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
