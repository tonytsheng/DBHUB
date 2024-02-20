## Various experimental sample code for ingesting data into OpenSearch

- airbnb.py
  - python bulk reader from csv file to opensearch
- taylor_ingest.py
  - load taylor swift lyrics
- c1.*
  - c1.mapping - creates the c1 index to explicitly create a date field
  - c1.gendata - create a series of test data
  - c1.json - output file from c1.gendata to use with the bulk loader
  - curl  -H "Content-Type: application/json" -XPOST "<ENDPOINT>/_bulk" --data-binary @c1.json
