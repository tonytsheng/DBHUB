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
    flight_resp = put_flight("2021-09-10", "GI4040", "CGO", "MNL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8217", "AKL", "WRE", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ1291", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ519", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF8540", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "EY4683", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "BR3335", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ405", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "EY4601", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "BR3243", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ5063", "NSN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF8471", "NSN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ611", "ZQN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF8448", "ZQN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "EY4739", "ZQN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "BR3273", "ZQN", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8139", "TRG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ5025", "NPE", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF8465", "NPE", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8031", "NPL", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF8498", "NPL", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ401", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "EY4599", "WLG", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "Y87970", "HGH", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "GI4209", "NRT", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "O36912", "SZX", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "PO214", "CVG", "NGO", "active"  ) 
    flight_resp = put_flight("2021-09-10", "Y87417", "BRU", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "7L74", "GYD", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "GI4108", "CAN", "CGO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "H15971", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZL5661", "BQL", "ISA", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "A3896", "TBS", "ATH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QS1240", "HRG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "OK4272", "HRG", "PRG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "PO212", "NRT", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "CA8411", "ANC", "PVG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "MS8074", "HKT", "AUH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "BC590", "UKB", "OKA", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QF7405", "MEL", "SYD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZH2725", "XIY", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "JD5287", "SHE", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "G56439", "XIY", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "MU9927", "HNY", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "SC4909", "KHN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "CA4909", "KHN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZH3075", "KHN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "3U2049", "KHN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "SC8749", "XMN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "CA8749", "XMN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZH3089", "XMN", "TAO", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "O36966", "KHN", "SZX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "YG9073", "ICN", "YNZ", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8843", "CHC", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "SQ4457", "CHC", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8300", "WLG", "NSN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ5062", "AKL", "NSN", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ8841", "CHC", "NSN", "cancelled"  ) 
    flight_resp = put_flight("2021-09-10", "HT3805", "JJN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "O37002", "TSN", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "GJ8710", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "GJ8703", "HDG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "O36969", "HGH", "FOC", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "KE314", "ICN", "HKG", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "S75277", "PYJ", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "S75255", "UUD", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "HY3670", "TAS", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "S75427", "IKT", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "S75223", "HTA", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "S75227", "IKT", "OVB", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "JT11", "CGK", "DPS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "JT746", "UPG", "DPS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "JT742", "UPG", "DPS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "IN640", "TMC", "DPS", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "NZ515", "CHC", "AKL", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "QR501", "DOH", "HYD", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "MF3079", "XIY", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "3U5103", "XIY", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "G58533", "XIY", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "G56026", "XIY", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "DR6551", "KMG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "BK6551", "KMG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZH8515", "CKG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "SC9269", "CKG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "KY9625", "CKG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "HO5031", "CKG", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "MU2701", "TAO", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "ZH9818", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "SC9818", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "KY9818", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "HO5214", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "CA3488", "SZX", "WUX", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "6E9650", "MAA", "BKK", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "8L9588", "KMG", "WUH", "scheduled"  ) 
    flight_resp = put_flight("2021-09-10", "MU6880", "CAN", "WUH", "cancelled"  ) 
    flight_resp = put_flight("2021-09-10", "CI5398", "ANC", "TPE", "active"  ) 
    flight_resp = put_flight("2021-09-10", "BX792", "TAE", "TPE", "scheduled"  ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
