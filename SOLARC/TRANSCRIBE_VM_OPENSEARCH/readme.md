aws transcribe start-transcription-job --transcription-job-name job11 --media MediaFileUri=s3://ttsheng-voicemail/20170222T011326Z.mp3 --language-code en-US --output-bucket-name ttsheng-voicemail

aws transcribe get-transcription-job --transcription-job-name job11

aws s3 cp s3://ttsheng-voicemail/job11.json  .

https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/

curl -XPUT -u 'admin:Pass1234!234' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/_doc/1' \
  -d '{"transcript":"Tony. Can you call me back tonight? I need to talk to you. Ok. Bye bye."}' \
  -H 'Content-Type: application/json'

curl -POST -u 'admin:Pass1234!234' 'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/_bulk' -H 'Content-Type: application/json' --data-binary "@small.json"

curl -XPUT -u 'admin:Pass1234!234' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail'

curl -XGET -u 'admin:Pass1234!234' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail'

curl -XGET -u 'admin:Pass1234!234' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/_search?q-get'

curl -X DELETE -u 'admin:Pass1234!234' \
'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/'

jq ' .results | .transcripts' job11.json

