## Some Tools to Monitor DMS

1. CloudWatch dashboard
Copy the dmswatch.json file to your own. Substitute values in this file for your own:
- Region
- ReplicationInstanceIdentifier
- ReplicationInstanceExternalResourceId
- ReplicationTaskIdentifier
- DashboardName

This dashboard watches the following metrics:
- SwapUsage
- FreeableMemory
- MemoryUsage
- CPUUtilization
- WriteThroughput
- CDCLatencyTarget
- CDCLatencySource
- CDCChangesDiskSource
- CDCChangesDiskTarget
- WriteIOPS
- ReadIOPS
- FullLoadThroughputRowsTarget
- FullLoadThroughputRowsSource

deploy with the command:
```
aws cloudwatch put-dashboard  --cli-input-json file://<YOUR FILE>.json
## more helpful commands:
aws cloudwatch list-dashboards
aws cloudwatch delete-dashboards <YOUR DASHBOARD NAME>
```

2. Some sample bash scripts to pull table statistics.
mon2.bsh
mon_rep_load.bsh



