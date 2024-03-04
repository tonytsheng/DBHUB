## References
- https://docs.aws.amazon.com/opensearch-service/latest/developerguide/knn.html
- https://catalog.workshops.aws/semantic-search/en-US/module-3-semantic-search/lab

## From the Semantic Workshop
- Headset pqa
```
curl  -XPUT 'https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/headset_pqa/' -d @"headset_pqa.mapping" -H 'Content-Type: application/json'
python3 headset_pqa_load.py
python3 headset_pqa_search.py
```

- NLP pqa
```
curl  -XPUT 'https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/nlp_pqa/' -d @"knn_index.mapping" -H 'Content-Type: application/json'
python3 nlp_pqa_load.py
python3 nlp_pqa_search.py
```

