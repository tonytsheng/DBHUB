For some customers running workloads with commercial off the shelf (COTS) applications, changing database endpoints is not trivial. Although preferrably database endpoints are stored in a config file, a data store or a managed service like AWS Parameter Store, some customers hard code these endpoints. These situations make modifying endpoints difficult.

Database endpoints can change - see https://aws.amazon.com/premiumsupport/knowledge-center/rds-ip-address-issues for examples. Other uses cases include a multi-AZ RDS instance that has failed over or the desire to restore a database to a new instance for a round of testing. In any of these cases, it may be worth exploring using a Network Load Balancer. Using an NLB between your applications and your databases allow you to specify database endpoint IP addresses if and when these database endpoints change. Your application only needs to know and connect to the endpoint for the NLB.

Here are steps that will help you implement this solution.

## Go to the EC2 console and Create Target Group under Load Balancing
-  Click IP addreses
-  Give your target group a name 
-  Protocol - TCP and Database Port Number
-  Click the appropriate VPC in the drop down
-  Dont worry about health checks 
-  Next
-  Register Targets
-    VPC in drop down
-    Add ip for your database - may need to do an nslookup on the endpoint
-    Make sure port is right
-    Create target group

Click Load Balancers - Create
  Create Network Load Balancer
  Give it a load balancer name
  Internal
  IPv4
  Click the appropriate VPC in the drop down
  Listener - TCP and database port and select a target group
  Click Creae

Go to VPC Security Groups
You will need to open the database port for the subnet(s) that your database is running in.
So add an inbound rule for port 5432, subnet 10.0.2.0/24 for example.

Wait for the status of the load balancer to become available

Then call your database client cli program with the NLB endpoint instead of the database endpoint.

If/when your endpoints change:
Get the IP of the endpoint after your database becomes available.
Update the IP address in the Target Group. Add the new IP and remove the old IP.
This can also be done via a cronjob or a Lambda function that checks database endpoints and calls an AWS CLI command to update the Target Group.

  

