AWS DB CSI Batch Data Collection Tool

The tool is comprised of 6 files:

	1) batch_ora.properties
		This file is to be completed by the customer with details about:
	
		ORACLE_HOME setting on the Linux server the tool will be run.  SQL*Plus is required to be accessible.

		The format of the first line of the file is:
		ORACLE_HOME=<oracle_home path>

 		Then one line for each Oracle database server to connect to:
		<username>:<password>:<hostname>:<port>:<dbname>:<diagnosticspack?>
		
		where <diagnsoticspack?> is set to Y if you are using Oracle AWR (instead of STATSPACK) for this particular database.  Otherwise, set it to N.  If left undefined, it is assumed you are wanting to use AWR.
		
	2) aws_awr_miner.sql and aws_statspack_miner.sql
	    [NOTE: You don't run these directly.  The shell script will run these scripts]
		This is the SQL and PL/SQL script that will be executed against the database to gather the required data.  The script needs to be run as a user with select_catalog_role (i.e. with SELECT privileges on the DBA_*, v$*, and gv$* tables/views).  

	3) batch_ora.sh
		This is the driving script for running the data gathering.  This script parses the batch_ora.properties file and pulls :

			i. out the ORACLE_HOME setting so SQL*Plus can be found
			ii. Connection details for each Oracle server to connect to.
			
	4) EXTRA: batch_ora_sct.sh and batch_ora_sct.properties
		These are variations that use a different properties file format.  These variations are designed to be able to leverage the same CSV format as used here: https://docs.aws.amazon.com/SchemaConversionTool/latest/userguide/CHAP_AssessmentReport.Multiserver.html
		There is one exception.. you should add an extra field at the end of each row set to N to indicate if you want to use STATSPACK (Oracle AWR/Diagnostics Pack is recommend if licensed for it).

The following steps illustrate how to use the tool:

	1. Edit the batch_ora.properties file and enter the correct path for ORACLE_HOME and add connection details for each server to be scanned
	2. chmod +x on batch_ora.sh
	3. Execute batch_ora.sh :
		$ ./batch_ora.sh

You will see output indicating which server is being connected to and when the script completes running.

The dbcsi_batch_<timestamp>_out.zip file will created in the same directory you ran the tool in.  

Upload the dbcsi_batch_<timestamp>_out.zip file via the DB CSI web application.
