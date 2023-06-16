## Bulk Process pdf forms

## Architecture
S3 bucket
Textract each pdf
Extract data into

Search Strings:
54 
Applicant:
Iventors:
Assignee:
Appl. No.:
Filed:
ABSTRACT



aws textract start-document-analysis    --document '{"S3Object":{"Bucket":"ttsheng-textract","Name":"11616624.pdf"}}'     --feature-types '["TABLES","FORMS","SIGNATURES"]'   --profile ec2

aws textract get-document-analysis --job-id "949aeca93e24fd5e0d30b8f2f9b91ef25aaa6b13dbd432b0487efae4f7e8ecfd" --profile ec2 > out1

