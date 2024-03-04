https://docs.aws.amazon.com/opensearch-service/latest/developerguide/knn.html

https://catalog.workshops.aws/semantic-search/en-US/module-3-semantic-search/lab

curl  -XPUT 'https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/headset_pqa/' -d @"headset_pqa.mapping" -H 'Content-Type: application/json'

python3 headset_pqa_load.py
python3 headset_pqa_search.py
