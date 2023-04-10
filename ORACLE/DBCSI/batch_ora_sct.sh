#!/bin/bash

# 05/16/2019
# AWS Database Freedom Homework Data Gathering tool
# created by Craig Silveira
#
# 06/01/2019
# Modified by dbayard for DB CSI
#
# 11/19/2021
# Added some Diagnostic Pack confirmation
# create a version that can use similar CSV format as SCT multiserver assessor
#
# 01/07/2022
# Added some sanity checks

# You can download the latest version of this script from https://dbcsi.d29q8g3b9hzyur.amplifyapp.com/batch_ora.zip


echo ""
echo ""
echo "AWS DB CSI Batch Data Gathering tool - SCT multiserver assessor version"
echo ""
echo "This script will perform the following steps:"
echo ""
echo "1. Gather Oracle connection information"
echo "2. Scan the Oracle databases gathering the required data"
echo "3. Generate a zipped output file with an entry for each database"
echo ""

echo "Checking for Diagnostics Pack licensing needed..."
echo ""

main ()
{


scriptversion="sct 10.2"

diagpackcounter=0

for ENTRY in `cat batch_ora_sct.properties|grep -v '#'|grep -v '^[ \t]*\#'|sed 's/ //g'`
do
	dbuser=`echo $ENTRY|awk -F, '{print $8}'`
	pw=`echo $ENTRY|awk -F, '{print $9}'`
	hostname=`echo $ENTRY|awk -F, '{print $3}'`
	port=`echo $ENTRY|awk -F, '{print $4}'`
	servicename=`echo $ENTRY|awk -F, '{print $5}'`
	diagnosticspack=`echo $ENTRY|awk -F, '{print $11}'`
	
	if [ ! -z "$diagnosticspack" -a "$diagnosticspack" = "Y" ]
	then
		diagpackcounter=$[diagpackcounter + 1]
		echo "$diagpackcounter. Will need Diagnostics Pack license for $hostname:$port/$servicename"
    fi

done
  
if [ $diagpackcounter -gt 0 ]
then
	echo ""
	echo "This script assumes that you have a valid license for Diagnostics Pack for the above databases.  Do not run this script if you do not."
	echo "If you do not have a Diagnostic Pack license, change the batch_ora.properties file's diagnosticspack? parameter to N to use STATSPACK instead."
	
	
	echo ""
	echo "IN ORDER TO CONTINUE, We need your authorization to use Diagnostic Pack features for the above databases to continue." 
	echo ""
	echo "##################### INPUT NEEDED BELOW"
	echo ""
	echo "To provide authorization, please type in the following exact phrase: "
	echo "dba_hist"
	
	echo " "
	read -p "> " diagpackprefix
	echo ""
	
	if [ "${diagpackprefix,,}" != "dba_hist" ]
	then
	  echo "WARNING: This script is expecting to be able to use the DBA_HIST tables which require the Diagnostics Pack."
	  echo "To authorize the script to use the DBA_HIST tables, we needed you to enter the phrase: dba_hist"
	  echo "However, it seems that you did not."
	  echo "Consider changing the batch_ora.properties file's diagnosticspack? parameters to N if you do not wish to use the Diagnostics Pack."
	  echo "The script will now exit."
	  echo ""
	  exit;
	fi
fi

# create a temp directory
filedate="$(date +"%Y_%m_%d_%I_%M_%p")"
mkdir dbcsi_batch_$filedate
cd dbcsi_batch_$filedate

echo "Script version: $scriptversion" >>zzsqlplus.log

counter=1

for ENTRY in `cat ../batch_ora_sct.properties|grep -v '#'|grep -v '^[ \t]*\#'|sed 's/ //g'`
do
	dbuser=`echo $ENTRY|awk -F, '{print $8}'`
	pw=`echo $ENTRY|awk -F, '{print $9}'`
	hostname=`echo $ENTRY|awk -F, '{print $3}'`
	port=`echo $ENTRY|awk -F, '{print $4}'`
	servicename=`echo $ENTRY|awk -F, '{print $5}'`
	diagnosticspack=`echo $ENTRY|awk -F, '{print $11}'`
	
	if [ ! -z "$diagnosticspack" -a "$diagnosticspack" = "Y" ]
	then
		echo "$counter. Using AWR for $dbuser@$hostname:$port/$servicename"
		echo "$counter. Using AWR for $dbuser@$hostname:$port/$servicename" >>zzsqlplus.log 2>&1
		echo "$diagpackprefix" | sqlplus -S $dbuser/$pw@//$hostname:$port/$servicename @../aws_awr_miner.sql >>zzsqlplus.log 2>&1
	else
		echo "$counter. Using statspack for $dbuser@$hostname:$port/$servicename"
		echo "$coutner. Using statspack for $dbuser@$hostname:$port/$servicename" >>zzsqlplus.log 2>&1
		sqlplus -S $dbuser/$pw@//$hostname:$port/$servicename @../aws_statspack_miner.sql >>zzsqlplus.log 2>&1
	fi
	
	counter=$[counter + 1]
done
echo ""
echo ""

echo "Sanity check for proper output files."

echo ""
if ! grep -L "BEGIN-MAIN-METRICS" *-hist-*
then
    echo "These files appear to have errors (if any, please review the file for error messages and reach out to your AWS contact for help):"
    grep -L "BEGIN-MAIN-METRICS" *-hist-*
	echo " "
	read -p "Do you want to continue despite the errors? " -n 1 -r
	echo ""
	
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	  echo "The script will now exit."
	  echo ""
	  exit;
	fi
fi

echo ""


echo "Now zipping the .output files"
cd ..
zip -r dbcsi_batch_${filedate}_out.zip dbcsi_batch_$filedate/

echo "Now cleaning up temporary directory"

rm -r dbcsi_batch_$filedate/

echo ""
echo "Finished!"
echo ""
echo "Please upload the dbcsi_batch_${filedate}_out.zip file via the DB CSI web application."
echo ""

}

#BEGIN FUNCTIONS




main


