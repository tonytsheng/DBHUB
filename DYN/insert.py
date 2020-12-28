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
    flight_resp = put_flight("2020-12-29", "SQ231", "SYD", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "YG9035", "KIX", "", "YNT", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "R4801", "VAV", "", "TBU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "BA160", "LHR", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "JT1798", "DJJ", "", "UPG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "BR3239", "DUD", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "JQ251", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9101", "NKG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "Y87458", "PVG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF4971", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF8540", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "NZ519", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "AT9705", "DOH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "NZ8807", "CHC", "", "TRG", 15, "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "SQ4541", "CHC", "", "TRG", 15, "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "EY4621", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "EY4753", "DUD", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7432", "MEL", "", "BNE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF8477", "AKL", "", "NSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "OZ9662", "ICN", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "LH4921", "FRA", "", "HND", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CA1077", "ANC", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7524", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CX271", "AMS", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CX6", "NRT", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "GJ8148", "NKG", "", "KIX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36955", "HGH", "", "WUH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7337", "LST", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "U61706", "SVX", "", "OVB", 180, "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "GJ8150", "CGQ", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36866", "PEK", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "4H1617", "CJU", "", "GMP", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "TK9320", "SYD", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9041", "NKG", "", "FOC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "HT3810", "CGO", "", "KHN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QR5019", "KUL", "", "PER", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-29", "O36999", "PKX", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "7C3153", "PUS", "", "GUM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "VA9561", "MEL", "", "LST", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9069", "NKG", "", "TYN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "LA5274", "DOH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O37169", "HGH", "", "TAO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "RU139", "HKG", "", "ICN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF4962", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "GJ8137", "WUH", "", "HRB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36945", "WUX", "", "PEK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CI73", "AMS", "", "TPE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "Y87492", "PVG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "GI4023", "SZX", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "YG9025", "CAN", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "HT3819", "WEH", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36890", "NGB", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "RU138", "SVO", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "RS502", "ICN", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CX888", "YVR", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36965", "SZX", "", "KHN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9068", "WUH", "", "NKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9015", "NKG", "", "WUH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "KE316", "ICN", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "NH8518", "NRT", "", "PVG", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-29", "ID6170", "AMQ", "", "CGK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9023", "NKG", "", "KHN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7333", "PER", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7472", "HBA", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "VA9563", "PER", "", "MEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "7C3105", "ICN", "", "GUM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "RS102", "ICN", "", "GUM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "NH8506", "NRT", "", "TAO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36884", "SZX", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "8L9946", "KMG", "", "CTU", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-29", "O36976", "HGH", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "Y87433", "HKG", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "Y87915", "HKG", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CA1085", "NKG", "", "CTU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "GJ8710", "SZX", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CF9005", "NKG", "", "SJW", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "YG9085", "SZX", "", "SJW", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "YG9019", "HGH", "", "SJW", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "YG9083", "FRU", "", "SJW", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "U63710", "OVB", "", "HRB", 1455, "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "CA1087", "NKG", "", "SHE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "Y87430", "NGB", "", "KIX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "PK281", "MCT", "", "SKT", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "ET1303", "MEL", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "TK9324", "MEL", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "UK8237", "MEL", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "SQ237", "MEL", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "NZ3352", "CPH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "OU5807", "CPH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "SK8000", "CPH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "SQ352", "CPH", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "SQ7374", "BLR", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "TK9330", "BNE", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "UK8255", "BNE", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "S8321", "NSN", "", "WLG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7454", "ADL", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "QF7442", "BNE", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "O36936", "SZX", "", "PKX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "EY1004", "AKL", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-29", "LA8736", "AKL", "", "PVG", "", "scheduled" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws dynamodb scan --table-name flight --select "COUNT"')
