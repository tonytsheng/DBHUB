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
    flight_resp = put_flight("2021-09-05", "NZ8204", "AKL", "", "BHE", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "SQ4371", "AKL", "", "BHE", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "QF8509", "AKL", "", "BHE", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "QF8594", "GIS", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "NZ5004", "AKL", "", "NPE", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "NZ5069", "NSN", "", "AKL", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-05", "NZ8282", "GIS", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "EY4608", "AKL", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "BR3262", "AKL", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "NZ8884", "NPE", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "QF8596", "NPE", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "JQ279", "ZQN", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "QF4964", "ZQN", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "NZ8792", "NPL", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "QF8599", "NPL", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "S8111", "PCN", "", "WLG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NZ337", "CHC", "", "WLG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SQ4397", "CHC", "", "WLG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "BC300", "HND", "", "KOJ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "G52813", "HET", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "JQ772", "ADL", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SQ4533", "CHC", "", "NPL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SQ6542", "ROK", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "3U8457", "XIC", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "G8330", "CNN", "", "BOM", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "U6512", "LED", "", "SIP", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "TK885", "IST", "", "SYZ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "GK381", "OKA", "", "NGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "DP389", "PEE", "", "AAQ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "DP304", "SVX", "", "AAQ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "S75303", "NSK", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "S75267", "YKS", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NZ603", "ZQN", "", "WLG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "Y87921", "TSN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "GI4033", "SZX", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "UA899", "ORD", "", "DEL", 27, "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "BZ482", "AMD", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "G81506", "SHJ", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "AF225", "CDG", "", "DEL", 50, "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SU233", "SVO", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "BZ481", "AMD", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "G873", "HKT", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SG705", "DXB", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "", "KWA", "", "MAJ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "DD88", "UTH", "", "DMK", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CF9065", "NKG", "", "XMN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "KM2388", "MCT", "", "DOH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "QH101", "DAD", "", "HAN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "QR1369", "CPT", "", "DOH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "AI276", "BOM", "", "CMB", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "FX12", "MEM", "", "KIX", 33, "active" ) 
    flight_resp = put_flight("2021-09-04", "O37256", "CSX", "", "KIX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CA1062", "PVG", "", "KIX", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "OZ6792", "JNB", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "QF7557", "ICN", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SC1781", "YCU", "", "HGH", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "G56451", "TSN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "G56079", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MF8465", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NS8465", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MU3221", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "GJ5429", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CZ4379", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "3U2335", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "JD5843", "URC", "", "HGH", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "3U8815", "TSN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CZ9483", "TSN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MU4035", "TSN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MF3423", "SHE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CA1765", "LHW", "", "HGH", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "ZH1765", "LHW", "", "HGH", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "G56991", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "QF5730", "MEL", "", "LST", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MF8229", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NS8229", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MU8133", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "GJ5351", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CZ4175", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "3U2175", "CSX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CA1701", "PEK", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "ZH1701", "PEK", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "UA7577", "PEK", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MF8383", "SZX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "GJ8779", "HZG", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CA3841", "CTU", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MF5313", "LYI", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "U68904", "SVX", "", "OSS", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "JT11", "CGK", "", "DPS", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NZ516", "AKL", "", "CHC", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "PX120", "WWK", "", "POM", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "MU2673", "ENH", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "SJ604", "SOQ", "", "UPG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "Y87991", "HGH", "", "CAN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CX3252", "PVG", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "TW118", "ICN", "", "HKG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-04", "4V502", "YNY", "", "CJU", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CZ6433", "YIH", "", "CAN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "KL2223", "CDG", "", "PEK", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "CF215", "KIX", "", "YIW", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-04", "NZ8765", "CHC", "", "NPL", "", "cancelled" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws dynamodb scan --table-name flight --select "COUNT"')
