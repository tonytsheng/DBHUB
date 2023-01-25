For some customers running workloads with commercial off the shelf (COTS) applications, changing database endpoints is not trivial. Although preferrably database endpoints are stored in a config file, a data store or a managed service like AWS Parameter Store, some customers are forced to hard code these endpoints. These situations make modifying endpoints difficult.

Database endpoints can change - see https://aws.amazon.com/premiumsupport/knowledge-center/rds-ip-address-issues for examples. Other uses cases include a multi-AZ RDS instance that has failed over or the desire to restore a database to a new instance for a round of testing. In any of these cases, it may be worth exploring using a Network Load Balancer. Using an NLB between your applications and your databases allow you to specify database endpoint IP addresses if and when these database endpoints change. Your application only needs to know and connect to the endpoint of the NLB.

Here are steps that will help you implement this solution.

## Go to the EC2 console and Create Target Group under Load Balancing
-  Chooose IP addresses for Target Type.
-  Give your target group a name .
-  For Protocol - choose TCP and the Port Number that your database runs on.
-  Click the appropriate VPC in the drop down.
-  Click TCP in the Health Check drop down.
-  Leave defaults for Advanced health check settings.
-  Click Next.
-  Register Targets.
   -  Use your VPC in drop down.
   -  Add the ip address for your database (if you don't know, do an nslookup on the endpoint).
   -  Click Include as pending below.
-    Click Create Target Group.

## Create the Network Load Balancer
- In the EC2 console, click on Load Balancer under Load Balancing.
- Click Create Load Balancer.
- Choose Network Load Balancer.
- Give it a load balancer name.
- Under Scheme, choose Internal.
- Ensure IPv4.
- Click the appropriate VPC in the drop down.
- Under Mappings, choose your availability zones.
  - Ensure that the subnets are ones that your database is running in.
  - Leave the Private IPv4 address drop down default for all subnets.
  - Listener - enter TCP and the database port and select the name of the Target Group you just created.
- Click Create Load Balancer.
- Note the port that your Load Balancer is running on - the default is 80.
- You can add another target group to run on another port.

## Open the database port in your VPC Security Groups
- You will need to open the database port for the subnet(s) that your database is running in. So add an inbound rule for port that the load balancer is running on, 80 is the default, subnet 10.0.2.0/24 for example.

## Test connectivity through the NLB
- Wait for the status of the load balancer to become Active - this may take a few minutes.
- Then call your database client cli program with the NLB endpoint instead of the database endpoint.
- Calling psql with the database endpoint:
```
[ec2-user@ip-10-0-2-111 NLB_RDS]$ psql --host=pg102-old.cyt4dgtj55oy.us-east-2.rds.amazonaws.com --port=5432 --username=postgres --dbname=pg102
Password for user postgres:
psql (10.17, server 12.8)
WARNING: psql major version 10, server major version 12.
         Some psql features might not work.
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

pg102=>
```


- Calling psql with the NLB endpoint:
```
[ec2-user@ip-10-0-2-111 NLB_RDS]$ psql --host=ttshengnlb-95d4fe9fd1597692.elb.us-east-2.amazonaws.com --port=80 --username=postgres --dbname=pg102
Password for user postgres:
psql (10.17, server 12.8)
WARNING: psql major version 10, server major version 12.
         Some psql features might not work.
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

pg102=>
```
- You can now give your application owners the NLB endpoint instead of the database endpoint.

## If/when your endpoints change:
- Get the IP of the endpoint after your database becomes available.
- Update the IP address in the Target Group. Add the new IP and remove the old IP.
- This can also be done via a cronjob or a Lambda function that checks database endpoints and calls an AWS CLI command to update the Target Group.

  

