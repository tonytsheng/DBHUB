- For each aurora db cluster, you can create only one auto scaling policy for each target metric

- The scaling policy adds or removes Aurora Replicas as required to keep the metric at, or close to, the specified target value. 
In addition to keeping the metric close to the target value, a target-tracking scaling policy also adjusts to 
fluctuations in the metric due to a changing workload. Such a policy also minimizes rapid fluctuations in the number of 
available Aurora Replicas for your DB cluster.

keep the metric at or close to the target value
- Example: 200 connections average across the cluster

- The target value of the metric defines the maximum limit of the Auto Scale, that is, the one that once 
exceeded causes a scale-out. The minimum value is auto calculated by AWS and is always 
10% less than the maximum value. When the metric is below this 
minimum value a scale-in occurs.
200 connections - this is the max
180 connections - the min value

- The time period for the metric has to be above or below the max or min value is fixed
maximum value is 5 mins - over 200 connections for 5 mins
minimum value is 15 mins - under 200 connections for 15 mins

