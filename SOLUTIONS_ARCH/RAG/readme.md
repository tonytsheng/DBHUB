## GenAI Use Case with RDS for PostgreSQL and pgvector. 
Notes here for a slightly modified lab taken originally from https://catalog.workshops.aws/pgvector/en-US/4-retrieval-augmented-generation

## Region
Note that everything runs out of us-west-2.

## Bedrock Setup
Grant Amazon and Anthropic model access to Bedrock in your account. 

## RDS Setup
Create an RDS for PostgreSQL instance in the us-west-2 region. Note that we are using RDS for PostgreSQL instead of Aurora.
```
aws rds create-db-instance  --db-name pgrag --db-instance-identifier pgrag  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass --db-subnet-group-name default-vpc-02ae294a0559bfea0  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-west-2
```

## Cloud9 Set up
We are going to use an instance of Cloud9 to run the application code. Create a cloud9 environment in us-west-2. 
- Choose ssh as the connection type.
- Your public subnet must have enabled assign auto ip.
- Install postgresql libraries.
```
sudo dnf install postgresql15.x86_64 postgresql15-server -y
```
- Make sure you can access the RDS instance from the cloud9 instance.
- Export the set of PG environment variables using the RDS instance that you just created. Also create the .env file.
```
export PGUSER
export PGPASSWORD
export PGHOST
export PGPORT
export PGDATABASE

cd ~/environment/aurora-postgresql-pgvector/02_RetrievalAugmentedGeneration/02_QuestionAnswering_Bedrock_LLMs
cat > .env << EOF
PGVECTOR_USER='$PGUSER'
PGVECTOR_PASSWORD='$PGPASSWORD'
PGVECTOR_HOST='$PGHOST'
PGVECTOR_PORT=$PGPORT
PGVECTOR_DATABASE='$PGDATABASE'
EOF
cat .env
```
- Make sure you can access the RDS instance from the cloud9 instance.
- Clone the github repo. Install libraries from the requirements file.
```
cd ~/environment
git clone https://github.com/aws-samples/aurora-postgresql-pgvector
python3 -m pip install -r requirements.txt
```
## Clean up any existing langchain tables.
```
psql
drop table if exists langchain_pg_embedding cascade;
drop table if exists langchain_pg_collection cascade;
\q
```
## Run the app. Note that the app.py script is complete.
```
cd ~/environment/aurora-postgresql-pgvector/02_RetrievalAugmentedGeneration/02_QuestionAnswering_Bedrock_LLMs
run the app.py with streamlit
streamlit run app.py --server.port 8080
```
## from cloud9, use the Show App menu drop down, but use firefox for this
  - upload an Aurora FAQ pdf
  - ask the app questions in natural language


![alt text](https://static.us-east-1.prod.workshops.aws/public/baa20ca5-b5e4-434d-9590-9a692e7127ba/static/Retrieval_Augmented_Generation/RAG_APG.png)


