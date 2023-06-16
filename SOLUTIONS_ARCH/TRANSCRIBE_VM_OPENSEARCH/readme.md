## Transcribe and OpenSearch
### Transcribe
Send a set of voicemail mp3 files to Transcribe. For each file, you will have to start a transcription job with a unique job name. Once the transcribe job is complete, it will save a json file to a bucket you specify. You can then retrieve and process the json.
```
aws transcribe start-transcription-job --transcription-job-name job11 --media MediaFileUri=s3://ttsheng-voicemail/20170222T011326Z.mp3 --language-code en-US --output-bucket-name ttsheng-voicemail
aws transcribe get-transcription-job --transcription-job-name job11
aws s3 cp s3://ttsheng-voicemail/job11.json  .
```

### OpenSearch
Construct an input file for all the json and then load that into your OpenSearch cluster. See the process bash shell script for more details.
```
curl -POST -u 'admin:Pass' 'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/_bulk' -H 'Content-Type: application/json' --data-binary "@small.json"
```
