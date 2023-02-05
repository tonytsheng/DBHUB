## Cloud Formation Templates
- 0.basevpc.yaml 
  - A simple VPC containing all the basic VPC components [route table, IGW, security groups, etc.] as well as 2 database subnets, 1 RDS for PostgreSQL instance and 1 EC2 bastion host that has postgresql, mysql and oracle connectivity libraries loaded.
    - Modify MyPcIpAddress and the SSHKeyName to yours.
    - Once the stack is created, ssh to the EC2 instance and use it as a database 'hub.'
    - Connect to your RDS for PostgreSQL instance like so:
      ```
      psql --host=<your db endpoint> --port=5432 --username=postgres --dbname=pg500
      ```
- 1.DMSWorkshop.yaml 
  - Taken from a DMS Workshop in AWS Workshop studio
    - Base VPC
    - A source database, depending on the lab chosen in CFN drop downs
    - All the components for DMS
      - DMS Replication Instance and Endpoints are not created.
