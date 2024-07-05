https://catalog.us-east-1.prod.workshops.aws/workshops/ee59d21b-4cb8-4b3d-a629-24537cf37bb5

1. run the cft, run the build env on the cloud9 instance
2. head a sample csv to see the schema
3. create glue catalog database.
4. create 2 crawlers - one with csv and one with json.
5. run both crawlers.
  A crawler connects to a data store, 
  progresses through a prioritized list of classifiers to 
  determine the schema for your data, 
  and then creates metadata tables in your data catalog.
6. note that the s3 bucket has been created with event notification to an sqs queue.
7. create crawler that looks at the bucket but is triggered from an event in the sqs.
2024-07-05T13:30:55.009Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] BENCHMARK : Crawler has finished running and is in state READY
8. trigger the crawler by coping something into the bucket and then running the crawler.
2024-07-05T13:29:39.674Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] BENCHMARK : Finished writing to Catalog
2024-07-05T13:29:39.715Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] INFO : Run Summary For PARTITION:
2024-07-05T13:29:39.716Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] INFO : ADD: 1
2024-07-05T13:29:39.716Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] INFO : Run Summary For TABLE:
2024-07-05T13:29:39.717Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] INFO : ADD: 1
2024-07-05T13:30:55.009Z	[3eeda126-0cf9-4128-b9f5-4d807bc10e9b] BENCHMARK : Crawler has finished running and is in state READY


