## Cloud Formation Templates
- 0.basevpc.yaml 
  - Simplest vpc including 2 database subnets, 1 RDS for PostgreSQL instance and 1 EC2 bastion host that has postgresql, mysql and oracle connectivity libraries loaded.
    - Make sure to modify MyPcIpAddress and the SSHKeyName to yours.
    - Connect with your ssh client to the public IPv4 hostname
