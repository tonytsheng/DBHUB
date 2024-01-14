import os
import subprocess
import shlex
from subprocess import check_output, CalledProcessError, STDOUT

WDIR='/home/ec2-user/DBHUB/APPS/FLY1/'
INFILE=WDIR+'airport-codes_csv.csv'

cmd='/bin/grep large_airport ' + INFILE + ' | /usr/bin/shuf -n1 | /usr/bin/awk -F\',\' \'{print $10}\' '
DEP = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
ARR = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
print (DEP)
print (ARR)


 g.addE('knows').from(vMarko).to(vPeter) ////


