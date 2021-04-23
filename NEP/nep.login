cd /home/ec2-user/rpms/apache-tinkerpop-gremlin-console-3.4.8
bin/gremlin.sh <<EQ
:remote connect tinkerpop.server conf/neptune-remote.yaml
## query here
EQ

