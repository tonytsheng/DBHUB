## Some Tools to Monitor DMS

1. CloudWatch dashboard
copy the dmswatch.json file to your own.
substitute values in this file for your own:
- region
- ReplicationInstanceIdentifier
- ReplicationInstanceExternalResourceId
- ReplicationTaskIdentifier
- DashboardName

deploy with the command:
```
aws cloudwatch put-dashboard  --cli-input-json file://<YOUR FILE>.json
## more helpful commands:
aws cloudwatch list-dashboards
aws cloudwatch delete-dashboards <YOUR DASHBOARD NAME>
```

2. code

