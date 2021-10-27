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
    flight_resp = put_flight("2021-10-28", "FX12", "IND", "KIX", "active"  ) 
    flight_resp = put_flight("2021-10-27", "BA5847", "BOM", "DEL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "TK692", "CAI", "IST", "active"  ) 
    flight_resp = put_flight("2021-10-27", "KY9928", "SZX", "JUH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CA1623", "HRB", "PEK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MU8051", "PKX", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "HU7004", "HAK", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "UT356", "VKO", "GRV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "GS2513", "MIG", "URC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "KC7325", "CIT", "NQZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PX184", "HGU", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PE531", "BNE", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PX240", "HKN", "POM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PX865", "POM", "TIZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "IW1925", "LBJ", "KOE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "LK261", "VTE", "LXG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "QR5257", "GRU", "JPA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "LA3134", "GRU", "JPA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "6E5329", "BOM", "SXR", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PR3505", "KUL", "JHB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MH1052", "KUL", "JHB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MH5336", "SZB", "JHB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FY1339", "SZB", "JHB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "AZ1626", "LIN", "BDS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FR8808", "BVA", "BDS", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "AZ5133", "JED", "GIZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "SV1769", "JED", "GIZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "XY106", "RUH", "GIZ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CA5762", "CSX", "JHG", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "ZH5352", "CSX", "JHG", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ4034", "FOC", "NKG", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "MM541", "ASJ", "NRT", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "AY1012", "HEL", "TLL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "6H173", "TIV", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "AM7885", "CDG", "TLV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CF9044", "HGH", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MU2491", "WNZ", "CAN", "active"  ) 
    flight_resp = put_flight("2021-10-27", "BK6533", "SHE", "YTY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "TEZ127", "OSS", "FRU", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PK605", "GIL", "ISB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "PF122", "KHI", "ISB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "S75216", "OVB", "BTK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "8V21", "NBO", "JNB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "NS8397", "WUH", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "VJ501", "DAD", "HAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "G56448", "HET", "HLH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "6J13", "KMJ", "HND", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FR6324", "SOF", "BGY", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "M9201", "IEV", "OZH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "GJ8019", "HRB", "HLH", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "U69126", "DME", "ZIA", "landed"  ) 
    flight_resp = put_flight("2021-10-27", "NH5314", "KIX", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FZ1716", "DXB", "MSQ", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ6657", "HEK", "HRB", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ6209", "PVG", "HRB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ3743", "SZX", "HRB", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FE201", "MBA", "NBO", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "SU3314", "AMS", "GLA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MF8395", "CAN", "PKX", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CF206", "PVG", "KIX", "active"  ) 
    flight_resp = put_flight("2021-10-27", "IW1531", "AMQ", "LUV", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "IW1507", "AMQ", "LUV", "landed"  ) 
    flight_resp = put_flight("2021-10-27", "EU2723", "DLC", "JNG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "KN2280", "PKX", "YIE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "KL3645", "SVO", "TOF", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "IW2921", "TMC", "KOE", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MF2117", "LFQ", "KHN", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "SM8034", "ASW", "CAI", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "HU1881", "NNY", "NNG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "NZ3709", "PEK", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "J91542", "KWI", "KTM", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CA1207", "LHW", "PEK", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "ZH1207", "LHW", "PEK", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "G58563", "INC", "SHA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "G52859", "NZL", "HET", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "FZ442", "DXB", "COK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "6E5323", "BOM", "COK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "AD4901", "REC", "JPA", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "SL510", "CNX", "DMK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "KL4611", "SHA", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MF1001", "PKX", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "HZ4600", "KHV", "NGK", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "QF2596", "CNS", "MOV", "active"  ) 
    flight_resp = put_flight("2021-10-27", "ZH2865", "KMG", "NKG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "ZH2019", "GOQ", "XNN", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "GJ5011", "GOQ", "XNN", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "G56103", "HTN", "TWC", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "MF8930", "HGH", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "MF8058", "NKG", "DLC", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "MH4298", "AYT", "IST", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "NH1207", "OKA", "FUK", "cancelled"  ) 
    flight_resp = put_flight("2021-10-27", "CA1330", "PEK", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ6776", "HAK", "CAN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "QG310", "GTO", "UPG", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "KC7972", "NQZ", "OMS", "active"  ) 
    flight_resp = put_flight("2021-10-27", "YG9117", "HGH", "KMG", "landed"  ) 
    flight_resp = put_flight("2021-10-27", "CA8019", "XUZ", "XMN", "scheduled"  ) 
    flight_resp = put_flight("2021-10-27", "CZ4101", "HET", "XMN", "cancelled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
