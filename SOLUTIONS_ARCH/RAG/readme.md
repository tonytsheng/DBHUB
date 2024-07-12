+ everything runs in us-west-2

+ bedrock access to models

+ create rds postgresql in us-west-2
  - aws rds create-db-instance  --db-name pgrag --db-instance-identifier pgrag  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass --db-subnet-group-name default-vpc-02ae294a0559bfea0  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-west-2
  - open up 5432 security group in default vpc security group

+ create a cloud9 env us-west-2
  - public subnet must have enabled assign auto ip
  - create cloud9 env with ssh connection type
  - this env is al3 so some commands are different - python3/dnf
  - sudo dnf install postgresql15.x86_64 postgresql15-server -y
  - export PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE
    - psql should log right in to the database
  - clone repo
    cd ~/environment
    git clone https://github.com/aws-samples/aurora-postgresql-pgvector
  - python3 -m pip install -r requirements.txt

+ run the app
  - cd ~/environment/aurora-postgresql-pgvector/02_RetrievalAugmentedGeneration/02_QuestionAnswering_Bedrock_LLMs
  - run the app.py with streamlit
+ from cloud9, use the Show App menu drop down, but use firefox for this
  - upload an Aurora FAQ pdf
  - ask the app questions in natural language


! [alt text](https://static.us-east-1.prod.workshops.aws/public/baa20ca5-b5e4-434d-9590-9a692e7127ba/static/Retrieval_Augmented_Generation/RAG_APG.png)


