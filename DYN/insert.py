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
    flight_resp = put_flight("2020-12-30", "QF1544", "BNE", "", "CBR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ9053", "ZUH", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "G54953", "KWE", "", "HET", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ4405", "LZO", "", "XMN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SC1181", "SZX", "", "TNA", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "TG2031", "BKK", "", "KOP", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SC1155", "PEK", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NZ5070", "AKL", "", "NSN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NH583", "MYJ", "", "HND", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZH4232", "CTU", "", "INC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JT825", "SUB", "", "LOP", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "UK8277", "ADL", "", "SIN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JL140", "HND", "", "AOJ", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "9C6653", "UYN", "", "SHE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "QR6045", "KIX", "", "HND", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "VA555", "PER", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CA3420", "SZX", "", "CGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "XY105", "GIZ", "", "RUH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZH2485", "THQ", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "MU5983", "BSD", "", "KMG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HU1893", "FUG", "", "HAK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "QR946", "SIN", "", "DOH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "TG6027", "HND", "", "TOY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZL165", "SYD", "", "OAG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NZ7169", "BNE", "", "GLT", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "EK420", "PER", "", "DXB", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HO5245", "WUX", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SC9936", "SZX", "", "KHN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SC4553", "HGH", "", "CKG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "VJ779", "CXR", "", "HAN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "LJ397", "KPO", "", "GMP", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CI9940", "FUK", "", "KMI", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "VN1641", "VCL", "", "HAN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JL6005", "KIX", "", "NRT", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ4057", "LYG", "", "FOC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "7C383", "KWJ", "", "GMP", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ6436", "SHE", "", "KWE", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "7G59", "FUK", "", "NGO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "VJ132", "HAN", "", "SGN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZO4077", "SYZ", "", "THR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HU7861", "HGH", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "KY9216", "SZX", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "7Y161", "HEH", "", "RGN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "TG6154", "CTS", "", "SDJ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "6E2757", "RPR", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SU1522", "NUX", "", "SVO", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ6195", "KWE", "", "SWA", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "EY4485", "ZQN", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "3U4388", "KWE", "", "KHN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "GS7493", "XIY", "", "URC", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NU871", "UEO", "", "OKA", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "SV1324", "HAS", "", "JED", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "9S7680", "ANC", "", "HKG", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "ZH9259", "NTG", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "3T114", "CAI", "", "PZU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CA1573", "KHN", "", "PKX", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "M8716", "MNL", "", "USU", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ8279", "CTU", "", "CSX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "G8173", "PNQ", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "Y5301", "TVY", "", "RGN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HA5494", "CTS", "", "ITM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JT991", "UPG", "", "KDI", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CV806", "WHK", "", "AKL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "QF2335", "BNE", "", "GLT", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZH1353", "SYX", "", "PEK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ6470", "CAN", "", "CZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "GJ8801", "HJJ", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "Y87519", "CGO", "", "PVG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "MF8465", "KWE", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "ZH4835", "LYG", "", "DLC", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "MU9653", "JJN", "", "HGH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NH242", "HND", "", "FUK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HO5789", "HET", "", "SHA", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ9812", "YIH", "", "PKX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "DZ6204", "YIH", "", "PKX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JD5809", "KWL", "", "HAK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "KY5039", "THQ", "", "XIY", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "GA9337", "HND", "", "FUK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "QR557", "DOH", "", "BOM", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "UK829", "HYD", "", "DEL", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HA4136", "MEL", "", "SYD", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "VA1853", "KGI", "", "PER", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CF9027", "NKG", "", "WEF", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "AY6021", "MLE", "", "DOH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "MU2153", "XIY", "", "XNN", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "9C8613", "CKG", "", "SZX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "HA5290", "HKD", "", "HND", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "RU238", "SVO", "", "KJA", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JL430", "HND", "", "MYJ", "", "cancelled" ) 
    flight_resp = put_flight("2020-12-30", "SV1469", "MED", "", "RUH", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NH1658", "ITM", "", "KIJ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "AS5103", "BNE", "", "CBR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "CZ9455", "WNZ", "", "SYX", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NH1201", "OKA", "", "FUK", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "QR6049", "IZO", "", "HND", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JL277", "IZO", "", "HND", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JL3761", "TNE", "", "KOJ", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "NZ7413", "MEL", "", "CBR", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "FJ5538", "AKL", "", "WLG", "", "scheduled" ) 
    flight_resp = put_flight("2020-12-30", "JQ256", "AKL", "", "WLG", "", "scheduled" ) 
    print("Put flight succeeded:")
    pprint(flight_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws dynamodb scan --table-name flight --select "COUNT"')
