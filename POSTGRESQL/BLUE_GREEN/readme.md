green env is callled -green-randomcharacters

test green env
  recommended to keep this in read only
  don't want to have replication conflicts
  robust framework for read testing 
  set the default_transaction_read_only parameter to off at the session level.

  switchover does result in downtime
    usually under one minute
    previous blue env now named -oldn

  When you add a read replica to a DB instance in the green environment of a blue/green deployment, 
  the new read replica won't replace a read replica in the blue environment when you switch over. 
  However, the new read replica is retained in the new production environment after switchover.

  When you delete a DB instance in the green environment of a blue/green deployment, you can't 
  create a new DB instance to replace it in the blue/green deployment.

- make sure customer understands replication compatible changes
- do not add/remove read replicas to blue green envs. better to turn it off and 
  then modify versus modify when blue/green configured.
- tuning database is always recommended but for blue/green, ideally you want your database 
  already tuned because there is complication of replication in the mix too. long running txs 
  will contribute to replica lag and complicate things.
