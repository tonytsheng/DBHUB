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
    flight_resp = put_flight("2021-09-10", "GI4040", "CGO", "", "MNL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8217", "AKL", "", "WRE", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ1291", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ519", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8540", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY4683", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BR3335", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ405", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY4601", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BR3243", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ5063", "NSN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8471", "NSN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ611", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8448", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY4739", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BR3273", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8139", "TRG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ5025", "NPE", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8465", "NPE", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8031", "NPL", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8498", "NPL", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ401", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY4599", "WLG", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "Y87970", "HGH", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "GI4209", "NRT", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "O36912", "SZX", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "PO214", "CVG", "", "NGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "Y87417", "BRU", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "7L74", "GYD", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "GI4108", "CAN", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "H15971", "ICN", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "ZL5661", "BQL", "", "ISA", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "A3896", "TBS", "", "ATH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QS1240", "HRG", "", "PRG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "OK4272", "HRG", "", "PRG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "", "BWT", "", "LST", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "PO212", "NRT", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "CA8411", "ANC", "", "PVG", 10, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "MS8074", "HKT", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BC590", "UKB", "", "OKA", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF7405", "MEL", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "O36966", "KHN", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "YG9073", "ICN", "", "YNZ", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8843", "CHC", "", "NSN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "SQ4457", "CHC", "", "NSN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8300", "WLG", "", "NSN", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "NZ5062", "AKL", "", "NSN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ8841", "CHC", "", "NSN", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "HT3805", "JJN", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "O37002", "TSN", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "GJ8710", "SZX", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "GJ8703", "HDG", "", "WUX", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "O36969", "HGH", "", "FOC", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "KE314", "ICN", "", "HKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "S75277", "PYJ", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "", "LGG", "", "OVB", 65, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "S75255", "UUD", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "HY3670", "TAS", "", "OVB", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "S75427", "IKT", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "S75223", "HTA", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "S75227", "IKT", "", "OVB", 15, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "", "IST", "", "KUL", 10, "active" ) 
    flight_resp = put_flight("2021-09-10", "NZ515", "CHC", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QR501", "DOH", "", "HYD", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "CI5398", "ANC", "", "TPE", 10, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BX792", "TAE", "", "TPE", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NZ5740", "CHC", "", "DUD", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "EY4492", "CHC", "", "DUD", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "JT792", "UPG", "", "CGK", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "CF9019", "PKX", "", "CAN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "SQ4541", "CHC", "", "TRG", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "Y87458", "PVG", "", "TSN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "NH393", "SYO", "", "HND", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "CF9085", "PKX", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "", "SRY", "", "IFN", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "", "LIF", "", "GEA", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "PK218", "PEW", "", "AUH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "BK5324", "KMG", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF883", "PER", "", "ADL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "ZL4126", "CED", "", "ADL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF5960", "CNS", "", "ADL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EK7492", "CNS", "", "ADL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "JQ960", "CNS", "", "ADL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "KC7175", "SCO", "", "ALA", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "RH4569", "HKG", "", "TPE", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EK449", "DXB", "", "KUL", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY4965", "CAI", "", "AUH", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8616", "CHC", "", "IVC", "", "cancelled" ) 
    flight_resp = put_flight("2021-09-10", "EY460", "MEL", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF2355", "MKY", "", "TSV", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "QF8835", "BAH", "", "DXB", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "MP8122", "AMS", "", "NBO", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "DV818", "SCO", "", "NCU", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "AZ5688", "ICN", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY470", "SIN", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "CA3278", "SHA", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "EY424", "MNL", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "KL3940", "MEL", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "JU7558", "MEL", "", "AUH", 16, "scheduled" ) 
    flight_resp = put_flight("2021-09-10", "KM2157", "MEL", "", "AUH", 16, "scheduled" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name flight --select "COUNT"')
